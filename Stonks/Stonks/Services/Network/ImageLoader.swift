import UIKit

protocol ImageLoaderProtocol {
    func load(url: URL?, completion: @escaping (UIImage?) -> Void)
    func image(url: NSURL) -> UIImage?
}

class ImageLoader: ImageLoaderProtocol {
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses: [NSURL: [(UIImage?) -> Void]] = [:]
    private let session = URLSession(configuration: .default)
    
    
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
        
        let handler: Handler = { [weak self] rawData, response, error in
            guard let self = self else {
                return
            }
            guard
                let responseData = rawData,
                let image = UIImage(data: responseData),
                error == nil
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            self.cachedImages.setObject(image, forKey: nsURL, cost: responseData.count)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        session.dataTask(with: URLRequest(url: url), completionHandler: handler).resume()
        
    }
}
