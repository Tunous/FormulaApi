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
    ///   - page: Page to fetch. Defaults to fetching first 30 elements.
    ///
    /// - Returns: List of seasons matching the given filter `criteria`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func seasons(
        season: RaceSeason = .all,
        by criteria: [FilterCriteria] = [],
        page: Page? = nil
    ) async throws -> Paginable<Season> {
        let url = URL.seasons(season: season, by: criteria, page: page)
        let seasonsResponse = try await decodedData(SeasonsResponse.self, from: url)
        let nextPageRequest = {
            try await F1.seasons(season: season, by: criteria, page: seasonsResponse.page.next())
        }
        return Paginable(
            elements: seasonsResponse.seasons,
            page: seasonsResponse.page,
            nextPageRequest: nextPageRequest
        )
    }
}

// MARK: - Private

extension URL {
    fileprivate static func seasons(season: RaceSeason, by criteria: [FilterCriteria], page: Page?) -> URL {
        var url = URL.base
        if !season.path.isEmpty {
            url.appendPathComponent(season.path)
        }
        for criterion in criteria {
            url.appendPathComponent(criterion.path)
        }
        url.appendPathComponent("seasons")
        url.appendPathExtension("json")

        return url.with(page: page)
    }
}

fileprivate struct SeasonsResponse: Decodable {
    
    enum DataKeys: String, CodingKey {
        case seasonTable = "SeasonTable"
    }
    
    enum SeasonTableKeys: String, CodingKey {
        case seasons = "Seasons"
    }
    
    let seasons: [Season]
    let page: Page
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: MRDataKeys.self)
        self.page = try rootContainer.decode(Page.self, forKey: .data)

        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let seasonTableContainer = try dataContainer.nestedContainer(keyedBy: SeasonTableKeys.self, forKey: .seasonTable)
        
        self.seasons = try seasonTableContainer.decode([Season].self, forKey: .seasons)
    }
}
