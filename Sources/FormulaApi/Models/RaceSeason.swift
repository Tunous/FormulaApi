import Foundation

/// Filter used to limit response results to a specific race season
///
/// ## Topics
///
/// ### Season filters
///
/// - ``all``
/// - ``current``
/// - ``year(_:)``
/// - ``year(_:round:)``
public struct RaceSeason: Hashable {
    let path: String

    /// Ignores season filter.
    public static let all = RaceSeason(path: "")

    /// Filters results to the current season.
    public static let current = RaceSeason(path: "/current")

    /// Filters results to a single `year`
    public static func year(_ year: Int) -> RaceSeason { RaceSeason(path: "/\(year)") }

    /// Filters results to a specific `round` of a single `year`.
    public static func year(_ year: Int, round: Int) -> RaceSeason { RaceSeason(path: "/\(year)/\(round)") }
}
