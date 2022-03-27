import SwiftUI

public struct Page {
    public let limit: Int
    public let offset: Int
    public let total: Int
    
    public init(limit: Int, offset: Int) {
        self.init(limit: limit, offset: offset, total: 0)
    }

    init(limit: Int, offset: Int, total: Int) {
        self.limit = limit
        self.offset = offset
        self.total = total
    }
    
    public func next() -> Page {
        return Page(limit: limit, offset: offset + limit, total: total)
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
