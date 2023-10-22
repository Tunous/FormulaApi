import Foundation

/// A type which uniquely describes a single constructor.
///
/// `FormulaApi` comes with a list of known constructors accessible as extensions on this type.
/// Alternatively you can create a custom identifier by providing raw string id of the constructor.
///
/// ## Topics
///
/// ### Custom constructor
///
/// - ``ConstructorID/init(_:)``
/// - ``ConstructorID/init(stringLiteral:)``
///
/// ### Known constructors
///
/// - ``ConstructorID/ferrari``
/// - ``ConstructorID/mcLaren``
/// - ``ConstructorID/renault`` 
///
/// ## See Also
///
/// - ``FilterCriteria/constructor(_:)``
public struct ConstructorID: ExpressibleByStringLiteral, Hashable {
    let id: String

    /// Creates a custom constructor identifier from a  raw string value.
    ///
    /// - Parameter id: Id of the circuit.
    public init(stringLiteral value: StringLiteralType) {
        self.id = value
    }

    /// Creates a custom constructor identifier from a  raw string value.
    ///
    /// - Parameter id: Id of the constructor.
    public init(_ id: String) {
        self.id = id
    }
}

extension ConstructorID {
    /// Ferrari
    public static let ferrari = ConstructorID("ferrari")

    /// McLaren
    public static let mcLaren = ConstructorID("mclaren")

    /// Renault
    public static let renault = ConstructorID("renault")
}

// MARK: Decoding

extension ConstructorID: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.id = try container.decode(String.self)
    }
}
