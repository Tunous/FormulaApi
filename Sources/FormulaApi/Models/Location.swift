import Foundation

/// Information about location of a circuit.
public struct Location: Hashable, Decodable {
    public let lat: String
    public let long: String
    public let locality: String
    public let country: String
}
