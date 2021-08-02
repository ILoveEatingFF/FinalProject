import UIKit

protocol ImageLoaderProtocol {
    func load(url: URL?, completion: @escaping (UIImage?) -> Void)
    func image(url: NSURL) -> UIImage?
}

class ImageLoader: ImageLoaderProtocol {
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses: [NSURL: [(UIImage?) -> Void]] = [:]
    private let session = URLSession(configuration: .ephemeral)
    
    private let queue = DispatchQueue(label: "com.image.loader.lizogub", attributes: .concurrent)
    
    private var safeLoadingResponsesGetter: [NSURL: [(UIImage?) -> Void]] {
        get {
            queue.sync {
                self.loadingResponses
            }
        }
    }
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    public func image(url: NSURL) -> UIImage? {
        cachedImages.object(forKey: url)
    }
    
    func load(url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url, let nsURL = NSURL(string: url.absoluteString) else {
            return
        }
        if let cachedImage = image(url: nsURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        let status = safeSetNewLoadingResponse(with: nsURL, completion: completion)
        
        switch status {
        case .wasSet:
            break
        case .wasAppended:
            return
        }
        
        let handler: Handler = { [weak self] rawData, response, error in
            guard let self = self else {
                return
            }
            guard
                let responseData = rawData,
                let image = UIImage(data: responseData),
                let blocks = self.safeLoadingResponsesGetter[nsURL],
                error == nil
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            self.cachedImages.setObject(image, forKey: nsURL, cost: responseData.count)
            
            for block in blocks {
                DispatchQueue.main.async {
                    block(image)
                }
            }
            
        }
        session.dataTask(with: URLRequest(url: url), completionHandler: handler).resume()
        
    }
    
    
    private func safeSetNewLoadingResponse(with url: NSURL, completion: @escaping (UIImage?) -> Void) -> BlockStatus {
        queue.sync(flags: .barrier) {
            if self.loadingResponses[url] != nil {
                self.loadingResponses[url]!.append(completion)
                return .wasAppended
            } else {
                self.loadingResponses[url] = [completion]
                return .wasSet
            }
        }
    }
}

// MARK: - Nested Types

private extension ImageLoader {
    enum BlockStatus {
        case wasSet
        case wasAppended
    }
}
