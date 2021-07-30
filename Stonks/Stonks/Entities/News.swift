import Foundation

struct News: Codable {
    let datetime: TimeInterval?
    let headline: String?
    let source: String?
    let url: String?
    let summary: String?
    let image: String?
}
