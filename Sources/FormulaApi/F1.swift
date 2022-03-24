import Foundation

public enum F1 {
    public static var urlSession = URLSession.shared
    public static var decoder = JSONDecoder()
}

extension F1 {
    public enum Error: Swift.Error {
        case `internal`(statusCode: Int)
        case external(statusCode: Int)
    }
}

// MARK: - Private

extension URL {
    static let base: URL = URL(string: "https://ergast.com/api/f1")!
}
