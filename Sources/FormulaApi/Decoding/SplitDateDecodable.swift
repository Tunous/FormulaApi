import Foundation

@propertyWrapper
struct SplitDateDecodable: Decodable {
    enum CodingKeys: String, CodingKey {
        case date
        case time
    }
    
    let wrappedValue: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let datePart = try container.decode(String.self, forKey: .date)
        let timePart = try container.decodeIfPresent(String.self, forKey: .time)
        
        if let timePart = timePart {
            self.wrappedValue = try Date("\(datePart) \(timePart)", strategy: .iso8601DateTime)
        } else {
            self.wrappedValue = try Date(datePart, strategy: .iso8601DateOnly)
        }
    }
}

extension ParseStrategy where Self == Date.ISO8601FormatStyle {
    static var iso8601DateOnly: Self {
        Date.ISO8601FormatStyle.iso8601.year().month().day()
    }
    
    static var iso8601DateTime: Self {
        iso8601DateOnly.time(includingFractionalSeconds: false).dateTimeSeparator(.space)
    }
}
