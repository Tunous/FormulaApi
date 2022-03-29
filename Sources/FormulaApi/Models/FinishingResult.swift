import SwiftUI

/// Driver's finishing result at the end of the race.
public enum FinishingResult: Hashable {
    
    /// Driver has finished the race at the specified `position`.
    case finished(position: Int)
    
    /// Driver has retired from the race.
    case retired
    
    /// Driver was disqualified from the race.
    case disqualified
    
    /// Driver was excluded from the race.
    case excluded
    
    /// Driver has withdrawn from the race.
    case withdrawn
    
    /// Driver has failed to qualify to the race.
    case failedToQualify
    
    /// Driver was mot classified in the race.
    case notClassified
    
    var rawValue: String {
        switch self {
        case .finished(let position):
            return "\(position)"
        case .retired:
            return "R"
        case .disqualified:
            return "D"
        case .excluded:
            return "E"
        case .withdrawn:
            return "W"
        case .failedToQualify:
            return "F"
        case .notClassified:
            return "N"
        }
    }
}
