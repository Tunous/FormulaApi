import Foundation

extension F1 {
    static func decodedData<Response: Decodable>(_ type: Response.Type, from url: URL) async throws -> Response {
        let (data, response) = try await urlSession.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            if !(200..<300).contains(httpResponse.statusCode) {
                if (400..<500).contains(httpResponse.statusCode) {
                    throw Error.internal(statusCode: httpResponse.statusCode)
                }
                throw Error.external(statusCode: httpResponse.statusCode)
            }
        }
        
        //print(String(data: data, encoding: .utf8)!)
        
        return try decoder.decode(Response.self, from: data)
    }
}
