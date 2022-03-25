import SwiftUI

/// Describes criteria that can be used to filter results returned
/// by various F1 API requests.
public struct Criteria {
    let path: String
    
    /// Filters a request to only return entries related to
    /// the given `circuit`.
    ///
    /// For example when used in ``F1.seasons`` method, the criteria will
    /// limit the returned seasons to only these, which included the
    /// given circuit in their schedule.
    public static func circuit(_ circuit: String) -> Criteria {
        Criteria(path: "/circuits/\(circuit)")
    }
    
    /// Filters a request to only return entries related to
    /// the given `constructor`.
    public static func constructor(_ constructor: String) -> Criteria {
        Criteria(path: "/constructors/\(constructor)")
    }
    
    /// Filters a request to only return entries related to
    /// the given `driver`.
    public static func driver(_ driver: DriverID) -> Criteria {
        Criteria(path: "/drivers/\(driver.id)")
    }
    
    /// Filters a request to only return entries related to
    /// the given starting grid `position`.
    public static func grid(_ position: Int) -> Criteria {
        Criteria(path: "/grid/\(position)")
    }
    
    /// Filters a request to only return entries related to
    /// the given `position` at the end of the race.
    public static func result(_ position: Int) -> Criteria {
        Criteria(path: "/results/\(position)")
    }
    
    /// Filters a request to only return entries related to
    /// the time at the given `rank`.
    public static func fastest(_ rank: Int) -> Criteria {
        Criteria(path: "/fastest/\(rank)")
    }
    
    /// Filters a request to only return entries related to
    /// the given finishing `status`.
    public static func status(_ status: String) -> Criteria {
        Criteria(path: "/status/\(status)")
    }
    
    /// Filters a request to only return entries related to
    /// the driver at the given standing `position`.
    public static func driverStanding(_ position: Int) -> Criteria {
        Criteria(path: "/driverStandings/\(position)")
    }
    
    /// Filters a request to only return entries related to
    /// the constructor at the given standing `position`.
    public static func constructorStanding(_ position: Int) -> Criteria {
        Criteria(path: "/constructorStandings/\(position)")
    }
}
