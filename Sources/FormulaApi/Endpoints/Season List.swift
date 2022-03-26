import Foundation

extension F1 {

    /// List the seasons currently supported by the API.
    ///
    /// Season lists can be refined by adding one or more of ``FilterCriteria``. For example, to list all seasons where
    /// a specific driver has driven for a particular constructor:
    ///
    /// ```swift
    /// let seasons = try await F1.seasons(by: [.driver("alonso"), .constructor("renault")])
    /// ```
    ///
    /// Alternatively, to list the seasons where a specific driver or constructor has achieved a particular final position in the championship:
    ///
    /// ```swift
    /// let seasons = try await F1.seasons(by: [.driver("alonso"), .driverStanding(1)])
    /// let seasons = try await F1.seasons(by: [.constructor("renault"), .constructorStanding(1)])
    /// ```
    ///
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Criteria used to refine the returned season list.
    ///
    /// - Returns: List of seasons matching the given filter `criteria`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func seasons(season: RaceSeason = .all, by criteria: [FilterCriteria]) async throws -> [Season] {
        let url = URL.seasons(season: season, by: criteria)
        let seasonsResponse = try await decodedData(SeasonsResponse.self, from: url)
        return seasonsResponse.seasons
    }

    /// List the seasons currently supported by the API.
    ///
    /// Season lists can be refined by adding one or more of ``FilterCriteria``. For example, to list all seasons where
    /// a specific driver has driven for a particular constructor:
    ///
    /// ```swift
    /// let seasons = try await F1.seasons(by: .driver("alonso"), .constructor("renault"))
    /// ```
    ///
    /// Alternatively, to list the seasons where a specific driver or constructor has achieved a particular final position in the championship:
    ///
    /// ```swift
    /// let seasons = try await F1.seasons(by: .driver("alonso"), .driverStanding(1))
    /// let seasons = try await F1.seasons(by: .constructor("renault"), .constructorStanding(1))
    /// ```
    ///
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Criteria used to refine the returned season list.
    ///
    /// - Returns: List of seasons matching the given filter `criteria`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func seasons(season: RaceSeason = .all, by criteria: FilterCriteria...) async throws -> [Season] {
        return try await seasons(by: criteria)
    }
}

// MARK: - Private

extension URL {
    fileprivate static func seasons(season: RaceSeason, by criteria: [FilterCriteria]) -> URL {
        var url = URL.base
        if !season.path.isEmpty {
            url.appendPathComponent(season.path)
        }
        for criterion in criteria {
            url.appendPathComponent(criterion.path)
        }
        url.appendPathComponent("/seasons")
        url.appendPathExtension("json")
        return url
    }
}

fileprivate struct SeasonsResponse: Decodable {
    enum RootKeys: String, CodingKey {
        case data = "MRData"
    }
    
    enum DataKeys: String, CodingKey {
        case seasonTable = "SeasonTable"
    }
    
    enum SeasonTableKeys: String, CodingKey {
        case seasons = "Seasons"
    }
    
    let seasons: [Season]
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let seasonTableContainer = try dataContainer.nestedContainer(keyedBy: SeasonTableKeys.self, forKey: .seasonTable)
        
        self.seasons = try seasonTableContainer.decode([Season].self, forKey: .seasons)
    }
}
