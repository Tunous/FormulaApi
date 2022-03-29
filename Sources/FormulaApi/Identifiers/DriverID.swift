import Foundation

/// A type which uniquely describes a single driver.
///
/// `FormulaApi` comes with a list of known driver accessible as extensions on this type.
/// Alternatively you can create a custom identifier by providing raw string id of the driver.
///
/// ## Topics
///
/// ### Custom drivers
///
/// - ``DriverID/init(_:)``
/// - ``DriverID/init(stringLiteral:)``
///
/// ### Known drivers
///
/// - ``DriverID/alonso``
///
/// ## See Also
///
/// - ``FilterCriteria/driver(_:)-3n6ov``
public struct DriverID: ExpressibleByStringLiteral, Hashable {
    let id: String

    /// Creates a custom driver identifier from a  raw string value.
    ///
    /// - Parameter id: Id of the driver.
    public init(stringLiteral value: StringLiteralType) {
        self.id = value
    }

    /// Creates a custom driver identifier from a raw string value.
    ///
    /// - Parameter id: Id of the driver.
    public init(_ id: String) {
        self.id = id
    }
}

// MARK: - Known drivers

extension DriverID {
    /// Fernando Alonso
    public static let alonso = DriverID("alonso")
}

// MARK: - Decoding

extension DriverID: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.id = try container.decode(String.self)
    }
}
