import Foundation

/// Information about a race circuit.
public struct Circuit {

    /// Identifier of the circuit.
    public let id: CircuitID

    /// Link to Wikipedia page related to the circuit.
    public let url: URL

    /// Name of the circuit.
    public let name: String

    /// Location of the circuit.
    public let location: Location
}

// MARK: Decoding

extension Circuit: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "circuitId"
        case url
        case name = "circuitName"
        case location = "Location"
    }
}
