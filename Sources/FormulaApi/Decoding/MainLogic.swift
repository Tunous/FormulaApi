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
    static func endpoint(named endpointName: String, season: RaceSeason, criteria: [FilterCriteria], page: Page?) -> URL {
        var url = URL.base
        if !season.path.isEmpty {
            url.appendPathComponent(season.path)
        }
        for criterion in criteria {
            url.appendPathComponent(criterion.path)
        }
        url.appendPathComponent(endpointName)
        url.appendPathExtension("json")

        return url.with(page: page)
    }
}
