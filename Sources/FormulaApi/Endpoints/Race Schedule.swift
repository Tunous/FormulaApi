import Foundation

extension F1 {
    public static func races(season: RaceSeason? = nil, by criteria: Criteria...) async throws -> [Race] {
        let url = URL.races(season: season, by: criteria)
        let racesResponse = try await decodedData(RacesResponse.self, from: url)
        return racesResponse.races
    }
}

public struct Race: Decodable {
    public let season: String
    public let round: String
    public let url: URL
    public let name: String
    public let circuit: Circuit
    public let date: Date
}

public struct Circuit: Decodable {
    public let id: String
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

public struct RaceSeason {
    let path: String

    public static let current = RaceSeason(path: "/current")
    public static func year(_ year: Int) -> RaceSeason { RaceSeason(path: "/\(year)") }
    public static func year(_ year: Int, round: Int) -> RaceSeason { RaceSeason(path: "/\(year)/\(round)") }
}

// MARK: - Private

extension URL {
    fileprivate static func races(season: RaceSeason?, by criteria: [Criteria]) -> URL {
        var url = URL.base
        if let season = season {
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

        let datePart = try container.decode(String.self, forKey: .date)
        let timePart = try container.decodeIfPresent(String.self, forKey: .time)

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        if let timePart = timePart {
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ssZ"
            guard let date = formatter.date(from: "\(datePart) \(timePart)") else {
                throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Unknown date format")
            }

            self.date = date
        } else {
            formatter.dateFormat = "YYYY-MM-dd"
            guard let date = formatter.date(from: datePart) else {
                throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Unknown date format")
            }

            self.date = date
        }
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
