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
    public static func seasons(season: RaceSeason = .all, by criteria: [FilterCriteria], page: Page? = nil) async throws -> PaginableSequence<Season> {
        let url = URL.seasons(season: season, by: criteria, page: page)
        let seasonsResponse = try await decodedData(SeasonsResponse.self, from: url)
        let page = Page(limit: seasonsResponse.limit, offset: seasonsResponse.offset)
        let nextPageRequest = {
            try await F1.seasons(season: season, by: criteria, page: page.next())
        }
        //return seasonsResponse.seasons
        return PaginableSequence(
            elements: seasonsResponse.seasons,
            limit: seasonsResponse.limit,
            offset: seasonsResponse.offset,
            total: seasonsResponse.total,
            nextPageRequest: nextPageRequest
        )
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
    public static func seasons(season: RaceSeason = .all, by criteria: FilterCriteria...) async throws -> PaginableSequence<Season> {
        return try await seasons(by: criteria)
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
        url.appendPathComponent("/seasons")
        url.appendPathExtension("json")
        
        return url.with(page: page)
    }
}

fileprivate struct SeasonsResponse: Decodable {
    enum RootKeys: String, CodingKey {
        case data = "MRData"
    }
    
    enum DataKeys: String, CodingKey {
        case seasonTable = "SeasonTable"
        case offset
        case limit
        case total
    }
    
    enum SeasonTableKeys: String, CodingKey {
        case seasons = "Seasons"
    }
    
    let seasons: [Season]
    let limit: Int
    let offset: Int
    let total: Int
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        
        print("before")
        guard let limit = Int(try dataContainer.decode(String.self, forKey: .limit)) else {
            throw DecodingError.dataCorruptedError(forKey: .limit, in: dataContainer, debugDescription: "Type mismatch")
        }
        guard let offset = Int(try dataContainer.decode(String.self, forKey: .offset)) else {
            throw DecodingError.dataCorruptedError(forKey: .offset, in: dataContainer, debugDescription: "Type mismatch")
        }
        guard let total = Int(try dataContainer.decode(String.self, forKey: .total)) else {
            throw DecodingError.dataCorruptedError(forKey: .total, in: dataContainer, debugDescription: "Type mismatch")
        }
        self.limit = limit
        self.offset = offset
        self.total = total
        
        let seasonTableContainer = try dataContainer.nestedContainer(keyedBy: SeasonTableKeys.self, forKey: .seasonTable)
        
        self.seasons = try seasonTableContainer.decode([Season].self, forKey: .seasons)
    }
}
