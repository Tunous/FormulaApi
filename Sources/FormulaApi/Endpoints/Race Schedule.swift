import Foundation

extension F1 {
    public static func races(season: RaceSeason = .all, by criteria: [Criteria]) async throws -> [Race] {
        let url = URL.races(season: season, by: criteria)
        let racesResponse = try await decodedData(RacesResponse.self, from: url)
        return racesResponse.races
    }
    
    public static func races(season: RaceSeason = .all, by criteria: Criteria...) async throws -> [Race] {
        return try await races(season: season, by: criteria)
    }
}

public struct Race: Decodable {
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

public struct Circuit: Decodable {
    public let id: CircuitID
    public let url: URL
    public let name: String
    public let location: Location
}

public struct Location: Decodable {
    public let lat: String
    public let long: String
    public let locality: String
    public let country: String
}

public struct RaceSeason: Hashable {
    let path: String

    public static let all = RaceSeason(path: "")
    public static let current = RaceSeason(path: "/current")
    public static func year(_ year: Int) -> RaceSeason { RaceSeason(path: "/\(year)") }
    public static func year(_ year: Int, round: Int) -> RaceSeason { RaceSeason(path: "/\(year)/\(round)") }
}

// MARK: - Private

extension URL {
    fileprivate static func races(season: RaceSeason, by criteria: [Criteria]) -> URL {
        var url = URL.base
        if !season.path.isEmpty {
            url.appendPathComponent(season.path)
        }
        for criterion in criteria {
            url.appendPathComponent(criterion.path)
        }
        if !criteria.isEmpty {
            url.appendPathComponent("races")
        }
        url.appendPathExtension("json")
        return url
    }
}

fileprivate struct RacesResponse: Decodable {
    enum RootKeys: String, CodingKey {
        case data = "MRData"
    }

    enum DataKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }

    enum RaceTableKeys: String, CodingKey {
        case races = "Races"
    }

    let races: [Race]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let tableContainer = try dataContainer.nestedContainer(keyedBy: RaceTableKeys.self, forKey: .raceTable)

        self.races = try tableContainer.decode([Race].self, forKey: .races)
    }
}

extension Race {
    enum CodingKeys: String, CodingKey {
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

extension Circuit {
    enum CodingKeys: String, CodingKey {
        case id = "circuitId"
        case url
        case name = "circuitName"
        case location = "Location"
    }
}
