import Foundation

extension F1 {

    /// Returns information about Formula 1 drivers.
    ///
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Criteria used to refine the returned season list.
    ///   - page: Page to fetch. Defaults to fetching first 30 elements.
    ///
    /// - Returns: List of drivers matching the given filter `criteria`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func drivers(
        season: RaceSeason = .all,
        by criteria: [FilterCriteria] = [],
        page: Page? = nil
    ) async throws -> Paginable<Driver> {
        let url = URL.drivers(season: season, by: criteria, page: page)
        let response = try await decodedData(DriversResponse.self, from: url)
        let nextPageRequest = {
            try await F1.drivers(season: season, by: criteria, page: page)
        }
        return Paginable(
            elements: response.drivers,
            page: response.page,
            nextPageRequest: nextPageRequest
        )
    }
}

extension URL {
    mutating func appendCriteriaPathComponents(
        _ criteria: [FilterCriteria],
        endpoint: String,
        isEndpointCriterion: (FilterCriteria) -> Bool
    ) {
        var endpointFilter: FilterCriteria?
        for criterion in criteria {
            if isEndpointCriterion(criterion) {
                endpointFilter = criterion
                continue
            }
            appendPathComponent(criterion.path)
        }

        if let endpointFilter {
            appendPathComponent(endpointFilter.path)
        } else {
            appendPathComponent(endpoint)
        }
    }
}

extension URL {
    fileprivate static func drivers(season: RaceSeason, by criteria: [FilterCriteria], page: Page?) -> URL {
        var url = URL.base
        if !season.path.isEmpty {
            url.appendPathComponent(season.path)
        }
        url.appendCriteriaPathComponents(criteria, endpoint: "drivers") { criterion in
            if case .driver = criterion {
                return true
            }
            return false
        }
        url.appendPathExtension("json")
        return url.with(page: page)
    }
}

// MARK: - Decoding

struct DriversResponse: Decodable {
    private enum DataKeys: String, CodingKey {
        case driverTable = "DriverTable"
    }

    private enum DriverTableKeys: String, CodingKey {
        case drivers = "Drivers"
    }

    let drivers: [Driver]
    let page: Page

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: MRDataKeys.self)
        self.page = try rootContainer.decode(Page.self, forKey: .data)

        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let tableContainer = try dataContainer.nestedContainer(keyedBy: DriverTableKeys.self, forKey: .driverTable)

        self.drivers = try tableContainer.decode([Driver].self, forKey: .drivers)
    }
}
