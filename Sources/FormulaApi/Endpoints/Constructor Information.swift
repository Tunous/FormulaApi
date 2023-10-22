import Foundation

extension F1 {

    /// Returns information about Formula 1 constructors.
    ///
    /// - Parameters:
    ///   - season: Limits results to specific season. By default all seasons will be returned.
    ///   - criteria: Criteria used to refine the returned season list.
    ///   - page: Page to fetch. Defaults to fetching first 30 elements.
    ///
    /// - Returns: List of constructors matching the given filter `criteria`.
    ///
    /// - Throws: ``F1/Error`` if network request fails.
    public static func constructors(
        season: RaceSeason = .all,
        by criteria: [FilterCriteria] = [],
        page: Page? = nil
    ) async throws -> Paginable<Constructor> {
        let url = URL.constructors(season: season, by: criteria, page: page)
        let response = try await decodedData(ConstructorsResponse.self, from: url)
        let nextPageRequest = {
            try await F1.constructors(season: season, by: criteria, page: page)
        }
        return Paginable(
            elements: response.constructors,
            page: response.page,
            nextPageRequest: nextPageRequest
        )
    }
}

extension URL {
    fileprivate static func constructors(season: RaceSeason, by criteria: [FilterCriteria], page: Page?) -> URL {
        var url = URL.base
        if !season.path.isEmpty {
            url.appendPathComponent(season.path)
        }
        url.appendCriteriaPathComponents(criteria, endpoint: "constructors") { criterion in
            if case .constructor = criterion {
                return true
            }
            return false
        }
        url.appendPathExtension("json")
        return url.with(page: page)
    }
}

// MARK: - Decoding

struct ConstructorsResponse: Decodable {
    private enum DataKeys: String, CodingKey {
        case constructorTable = "ConstructorTable"
    }

    private enum ConstructorTableKeys: String, CodingKey {
        case constructors = "Constructors"
    }

    let constructors: [Constructor]
    let page: Page

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: MRDataKeys.self)
        self.page = try rootContainer.decode(Page.self, forKey: .data)

        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let tableContainer = try dataContainer.nestedContainer(keyedBy: ConstructorTableKeys.self, forKey: .constructorTable)

        self.constructors = try tableContainer.decode([Constructor].self, forKey: .constructors)
    }
}
