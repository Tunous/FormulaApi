import SwiftUI

/// Definition of a single results page.
///
/// A page consists of number of elements defined by `limit` property and offset from the first
/// element determined by `offset` property. You set them together to decide which page to fetch.
///
/// By default all API requests fetch first 30 elements when not provided with a page.
public struct Page {

    /// Maximum number of elements included in a single page.
    ///
    /// - Note: It should not be higher than 1000.
    public let limit: Int

    /// Offset from first element.
    public let offset: Int

    /// Total number of elements available in corresponding request.
    ///
    /// - Note: This property is only set on pages received from server. When page is created manually in code
    /// it will always be equal to 0.
    public let total: Int

    /// Creates a new page.
    ///
    /// For example to get second page where each page consists of ten elements set `limit` to 10 and `offset` to 20.
    ///
    /// - Parameters:
    ///   - limit: The number of results that are returned.
    ///   - offset: An offset into the result set.
    ///
    /// - Note: `limit` should be set to a maximum value of 1000.
    public init(limit: Int, offset: Int) {
        self.init(limit: limit, offset: offset, total: 0)
        if limit > 1000 {
            assertionFailure("[WARNING] Limit should be set up to a maximum value of 1000")
        }
    }

    init(limit: Int, offset: Int, total: Int) {
        self.limit = limit
        self.offset = offset
        self.total = total
    }

    /// Gets a next page.
    public func next() -> Page {
        return Page(limit: limit, offset: offset + limit, total: total)
    }

    /// Tells whether there is a previous page available.
    public var hasPreviousPage: Bool {
        offset > 0
    }

    /// Tells whether there is a next page available.
    ///
    /// - Note: This will always return false for pages created manually from code.
    public var hasNextPage: Bool {
        offset + limit < total
    }
}

extension Page: Decodable {

    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let limit = Int(try container.decode(String.self, forKey: .limit)) else {
            throw DecodingError.dataCorruptedError(forKey: .limit, in: container, debugDescription: "Type mismatch")
        }
        guard let offset = Int(try container.decode(String.self, forKey: .offset)) else {
            throw DecodingError.dataCorruptedError(forKey: .offset, in: container, debugDescription: "Type mismatch")
        }
        guard let total = Int(try container.decode(String.self, forKey: .total)) else {
            throw DecodingError.dataCorruptedError(forKey: .total, in: container, debugDescription: "Type mismatch")
        }

        self.limit = limit
        self.offset = offset
        self.total = total
    }
}
