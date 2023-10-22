import Foundation

/// Information about a constructor.
public struct Constructor: Identifiable, Hashable {

    /// Identifier of the constructor.
    public let id: ConstructorID
    public let url: URL
    public let name: String
    public let nationality: String
}

// MARK: Decoding

extension Constructor: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "constructorId"
        case url
        case name
        case nationality
    }
}
