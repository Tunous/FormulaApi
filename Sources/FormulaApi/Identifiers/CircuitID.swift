import SwiftUI

/// A type which uniquely describes a single circuit.
public struct CircuitID: ExpressibleByStringLiteral {
    let id: String
    
    public init(stringLiteral value: StringLiteralType) {
        self.id = value
    }
    
    public init(_ id: String) {
        self.id = id
    }
}

extension CircuitID {
    /// Monza
    public static let monza = DriverID("monza")
}

extension CircuitID: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.id = try container.decode(String.self)
    }
}
