import Foundation

/// Main type used to interact with the Formula 1 API.
public enum F1 {

    /// `URLSession` used to perform all of the networks calls.
    public static var urlSession = URLSession.shared
}

extension F1 {
    /// An error that can happen when making network requests.
    public enum Error: Swift.Error {

        /// Internal error that resulted in HTTP status code in range 400...499
        case `internal`(statusCode: Int)

        /// Extenral server error that resulted in HTTP status code in range >= 500
        case external(statusCode: Int)
    }
}

// MARK: - Private

extension F1 {
    static var decoder = JSONDecoder()
}

extension URL {
    static let base: URL = URL(string: "https://ergast.com/api/f1")!
}
