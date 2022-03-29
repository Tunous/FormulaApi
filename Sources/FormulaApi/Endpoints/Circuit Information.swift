import Foundation

extension F1 {

    /// Returns information about circuits used in Formula 1.
    ///
    /// To filter the list based on year or round use the season parameter:
    ///
    /// ```swift
    /// let circuits = try await F1.circuits(season: .year(2022, round: .number(2)))
    /// ```
    ///
    /// To obtain information about a particular circuit use the ``FilterCriteria/circuit(_:)-1j1lk`` filter criteria.
    ///
    /// ```swift
    /// let circuits = try await F1.circuits(by: [.circuit(.monza)])
    /// ```
    /// 
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Criteria used to refine the returned season list.
    ///   - page: Page to fetch. Defaults to fetching first 30 elements.
    ///
    /// - Returns: List of circuits matching the given filter `criteria`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func circuits(
        season: RaceSeason = .all,
        by criteria: [FilterCriteria],
        page: Page? = nil
    ) async throws -> Paginable<Circuit> {
        let url = URL.circuits(season: season, by: criteria, page: page)
        let response = try await decodedData(CircuitsResponse.self, from: url)
        let nextPageRequest = {
            try await F1.circuits(season: season, by: criteria, page: page)
        }
        return Paginable(
            elements: response.circuits,
            page: response.page,
            nextPageRequest: nextPageRequest
        )
    }

    /// Returns information about circuits used in Formula 1.
    ///
    /// To filter the list based on year or round use the season parameter:
    ///
    /// ```swift
    /// let circuits = try await F1.circuits(season: .year(2022, round: .number(2)))
    /// ```
    ///
    /// To obtain information about a particular circuit use the ``FilterCriteria/circuit(_:)-1j1lk`` filter criteria.
    ///
    /// ```swift
    /// let circuits = try await F1.circuits(by: .circuit(.monza))
    /// ```
    ///
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Criteria used to refine the returned season list.
    ///   - page: Page to fetch. Defaults to fetching first 30 elements.
    ///
    /// - Returns: List of circuits matching the given filter `criteria`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func circuits(
        season: RaceSeason = .all,
        by criteria: FilterCriteria...,
        page: Page? = nil
    ) async throws -> Paginable<Circuit> {
        return try await circuits(season: season, by: criteria, page: page)
    }
}

extension URL {
    fileprivate static func circuits(season: RaceSeason, by criteria: [FilterCriteria], page: Page?) -> URL {
        var url = URL.base
        if !season.path.isEmpty {
            url.appendPathComponent(season.path)
        }

        var circuitFilter: FilterCriteria?
        for criterion in criteria {
            if criterion.path.starts(with: "/circuits") {
                circuitFilter = criterion
                continue
            }
            url.appendPathComponent(criterion.path)
        }

        if let circuitFilter = circuitFilter {
            url.appendPathComponent(circuitFilter.path)
        } else {
            url.appendPathComponent("circuits")
        }

        url.appendPathExtension("json")
        return url.with(page: page)
    }
}

// MARK: - Decoding

struct CircuitsResponse: Decodable {
    private enum DataKeys: String, CodingKey {
        case circuitTable = "CircuitTable"
    }

    private enum CircuitTableKeys: String, CodingKey {
        case circuits = "Circuits"
    }

    let circuits: [Circuit]
    let page: Page

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: MRDataKeys.self)
        self.page = try rootContainer.decode(Page.self, forKey: .data)

        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let tableContainer = try dataContainer.nestedContainer(keyedBy: CircuitTableKeys.self, forKey: .circuitTable)

        self.circuits = try tableContainer.decode([Circuit].self, forKey: .circuits)
    }
}
