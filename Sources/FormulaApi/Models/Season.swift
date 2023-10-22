import Foundation

/// Information about a race season.
public struct Season: Hashable, Decodable {

    /// Name of the season
    public let season: String

    /// Link to Wikipedia page related to the season.
    public let url: URL
}
