import Foundation

/// Information about a race weekend in a season.
public struct Race {
    public let season: String
    public let round: String
    public let url: URL
    public let name: String
    public let circuit: Circuit
    public let date: Date
    public let firstPractice: Date?
    public let secondPractice: Date?
    public let thirdPractice: Date?
    public let qualifying: Date?
    public let sprint: Date?
}

// MARK: Decoding

extension Race: Decodable {
    private enum CodingKeys: String, CodingKey {
        case season
        case round
        case url
        case name = "raceName"
        case circuit = "Circuit"
        case date
        case time
        case firstPractice = "FirstPractice"
        case secondPractice = "SecondPractice"
        case thirdPractice = "ThirdPractice"
        case qualifying = "Qualifying"
        case sprint = "Sprint"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.season = try container.decode(String.self, forKey: .season)
        self.round = try container.decode(String.self, forKey: .round)

        let urlString = try container.decode(String.self, forKey: .url)
        guard
            let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
        else {
            throw DecodingError.dataCorruptedError(forKey: .url, in: container, debugDescription: "Malformed URL")
        }
        self.url = url
        self.name = try container.decode(String.self, forKey: .name)
        self.circuit = try container.decode(Circuit.self, forKey: .circuit)
        self.date = try SplitDateDecodable(from: decoder).wrappedValue
        self.firstPractice = try container.decodeIfPresent(SplitDateDecodable.self, forKey: .firstPractice)?.wrappedValue
        self.secondPractice = try container.decodeIfPresent(SplitDateDecodable.self, forKey: .secondPractice)?.wrappedValue
        self.thirdPractice = try container.decodeIfPresent(SplitDateDecodable.self, forKey: .thirdPractice)?.wrappedValue
        self.qualifying = try container.decodeIfPresent(SplitDateDecodable.self, forKey: .qualifying)?.wrappedValue
        self.sprint = try container.decodeIfPresent(SplitDateDecodable.self, forKey: .sprint)?.wrappedValue
    }
}
