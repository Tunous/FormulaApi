import Foundation

/// Filter used to limit response results to a specific race season.
///
/// ## Topics
///
/// ### Season filters
///
/// - ``all``
/// - ``current``
/// - ``current(round:)``
/// - ``year(_:round:)``
public enum RaceSeason: Hashable {

    /// Ignores season filter.
    case all
    
    /// Filters results to the current season and specified `round`.
    case current(round: RaceRound = .all)

    /// Filters results to a single `year` and optionally to a specific `round`.
    case year(_ year: Int, round: RaceRound = .all)
    
    /// Filters results to the current season.
    public static let current = RaceSeason.current(round: .all)
    
    var path: String {
        switch self {
        case .all:
            return ""
        case .current(round: let round):
            return "/current\(round.path)"
        case .year(let year, round: let round):
            return "/\(year)\(round.path)"
        }
    }
}
