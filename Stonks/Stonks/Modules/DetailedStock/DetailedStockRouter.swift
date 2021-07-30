import UIKit
import SafariServices

final class DetailedStockRouter: BaseRouter {
}

extension DetailedStockRouter: DetailedStockRouterInput {
    func showNews(with url: String) {
        guard
            let url = URL(string: url),
            UIApplication.shared.canOpenURL(url)
        else {
            return
            
        }
        let newsViewController = SFSafariViewController(url: url)
        navigationController?.present(newsViewController, animated: true)
    }
}
