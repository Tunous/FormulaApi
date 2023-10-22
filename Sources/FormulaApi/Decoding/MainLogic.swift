import Foundation

extension F1 {
    static func decodedData<Response: Decodable>(_ type: Response.Type, from url: URL) async throws -> Response {
        let (data, response) = try await urlSession.data(from: url)
        
        //print(String(data: data, encoding: .utf8)!)
        
        if let httpResponse = response as? HTTPURLResponse {
            if !(200..<300).contains(httpResponse.statusCode) {
                if (400..<500).contains(httpResponse.statusCode) {
                    throw Error.internal(statusCode: httpResponse.statusCode)
                }
                throw Error.external(statusCode: httpResponse.statusCode)
            }
        }
        
        return try decoder.decode(Response.self, from: data)
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
