import SwiftUI

/// A type which uniquely describes a single circuit.
///
/// `FormulaApi` comes with a list of known circuits accessible as extensions on this type.
/// Alternatively you can create a custom identifier by providing raw string id of the circuit.
///
/// ## Topics
///
/// ### Custom circuit
///
/// - ``CircuitID/init(_:)``
/// - ``CircuitID/init(stringLiteral:)``
///
/// ### Known circuits
///
/// - ``CircuitID/monza``
///
/// ## See Also
///
/// - ``FilterCriteria/circuit(_:)``
/// - ``Circuit``
public struct CircuitID: ExpressibleByStringLiteral, Hashable {
    let id: String

    /// Creates a custom circuit identifier from a  raw string value.
    ///
    /// - Parameter id: Id of the circuit.
    public init(stringLiteral value: StringLiteralType) {
        self.id = value
    }

    /// Creates a custom circuit identifier from a  raw string value.
    ///
    /// - Parameter id: Id of the circuit.
    public init(_ id: String) {
        self.id = id
    }
}

extension CircuitID {
    /// Monza
    public static let monza = DriverID("monza")
}

// MARK: Decoding

extension CircuitID: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.id = try container.decode(String.self)
    }
}
