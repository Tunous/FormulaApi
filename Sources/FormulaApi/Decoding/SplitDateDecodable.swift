import SwiftUI

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
            let parseStrategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)Z", timeZone: .init(secondsFromGMT: 0)!)
            self.wrappedValue = try Date("\(datePart) \(timePart)", strategy: parseStrategy)
        } else {
            let parseStrategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)", timeZone: .init(secondsFromGMT: 0)!)
            self.wrappedValue = try Date(datePart, strategy: parseStrategy)
        }
    }
}
