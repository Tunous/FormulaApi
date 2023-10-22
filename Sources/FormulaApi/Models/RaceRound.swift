import SwiftUI

/// Filter used to limit response results to a specific race round.
///
/// ## Topics
///
/// ### Round filters
///
/// - ``all``
/// - ``last``
/// - ``next``
/// - ``number(_:)``
public enum RaceRound: Hashable {
    
    /// Ignores round filter.
    case all
    
    /// Filters results to the last round.
    case last
    
    /// Filters results to the next round.
    case next
    
    /// Filters results to a round with specified `number`.
    case number(_ number: Int)
    
    var path: String {
        switch self {
        case .all:
            return ""
        case .last:
            return "/last"
        case .next:
            return "/next"
        case .number(let number):
            return "/\(number)"
        }
    }
}

extension RaceRound: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .number(value)
    }
}
