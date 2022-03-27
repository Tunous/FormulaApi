import Foundation

extension F1 {

    /// Returns schedule of Formula 1 races.
    ///
    /// Race schedule can be refined by adding one or more of `FilterCiriteria`. For example to list all
    /// races where a specific driver has drivern at a particular circuit:
    ///
    /// ```swift
    /// let races = try await F1.races(by: [.driver(.alonso), .circuit(.monza)])
    /// ```
    ///
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Filter ciriteria used to refine the returned race schedule.
    ///
    /// - Returns: List of races matching the given filter `criteria` and `season`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func races(season: RaceSeason = .all, by criteria: [FilterCriteria]) async throws -> [Race] {
        let url = URL.races(season: season, by: criteria)
        let racesResponse = try await decodedData(RacesResponse.self, from: url)
        return racesResponse.races
    }

    /// Returns schedule of Formula 1 races.
    ///
    /// Race schedule can be refined by adding one or more of `FilterCiriteria`. For example to list all
    /// races where a specific driver has drivern at a particular circuit:
    ///
    /// ```swift
    /// let races = try await F1.races(by: .driver(.alonso), .circuit(.monza))
    /// ```
    ///
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Filter ciriteria used to refine the returned race schedule.
    ///
    /// - Returns: List of races matching the given filter `criteria` and `season`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func races(season: RaceSeason = .all, by criteria: FilterCriteria...) async throws -> [Race] {
        return try await races(season: season, by: criteria)
    }
}

// MARK: - Private

extension URL {
    fileprivate static func races(season: RaceSeason, by criteria: [FilterCriteria]) -> URL {
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

    enum DataKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }

    enum RaceTableKeys: String, CodingKey {
        case races = "Races"
    }

    let races: [Race]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MRDataKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let tableContainer = try dataContainer.nestedContainer(keyedBy: RaceTableKeys.self, forKey: .raceTable)

        self.races = try tableContainer.decode([Race].self, forKey: .races)
    }
}

enum MRDataKeys: String, CodingKey {
    case data = "MRData"
}
