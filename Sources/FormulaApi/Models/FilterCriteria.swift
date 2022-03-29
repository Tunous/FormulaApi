import Foundation

/// Criteria that can be used to filter results returned by various API requests.
public struct FilterCriteria {
    let path: String
    
    /// Filters a request to only return entries related to the given `circuit`.
    ///
    /// For example when used in ``F1/seasons(season:by:page:)-o9s8`` method, the criteria will
    /// limit the returned seasons to only these, which included the given circuit in their schedule.
    ///
    /// - Parameter circuit: The circuit to filter by. Can be either a regular string or a know circuit
    /// from the ``CircuitID`` type.
    public static func circuit(_ circuit: CircuitID) -> FilterCriteria {
        FilterCriteria(path: "/circuits/\(circuit.id)")
    }
    
    /// Filters a request to only return entries related to the given `circuit`.
    ///
    /// For example when used in ``F1/seasons(season:by:page:)-o9s8`` method, the criteria will
    /// limit the returned seasons to only these, which included the given circuit in their schedule.
    ///
    /// - Parameter circuit: The id of a circuit to filter by.
    public static func circuit(_ circuit: String) -> FilterCriteria {
        Self.circuit(CircuitID(circuit))
    }
    
    /// Filters a request to only return entries related to
    /// the given `constructor`.
    public static func constructor(_ constructor: String) -> FilterCriteria {
        FilterCriteria(path: "/constructors/\(constructor)")
    }
    
    /// Filters a request to only return entries related to the given `driver`.
    ///
    /// - Parameter driver: The driver to filter by. Can be either a regular string or a known driver
    /// from the ``DriverID`` type.
    ///
    /// - Returns: Filter criteria based on driver id.
    public static func driver(_ driver: DriverID) -> FilterCriteria {
        FilterCriteria(path: "/drivers/\(driver.id)")
    }
    
    /// Filters a request to only return entries related to the given `driver`.
    ///
    /// - Parameter driver: The id of a driver to filter by.
    ///
    /// - Returns: Filter criteria based on driver id.
    public static func driver(_ driver: String) -> FilterCriteria {
        Self.driver(DriverID(driver))
    }
    
    /// Filters a request to only return entries related to the given starting grid `position`.
    public static func grid(_ position: Int) -> FilterCriteria {
        FilterCriteria(path: "/grid/\(position)")
    }
    
    /// Filters a request to only return entries related to the given `result` at the end of the race.
    public static func finishingResult(_ result: FinishingResult) -> FilterCriteria {
        FilterCriteria(path: "/results/\(result.rawValue)")
    }
    
    /// Filters a request to only return entries related to the given `position` at the end of the race.
    public static func finishingPosition(_ position: Int) -> FilterCriteria {
        finishingResult(.finished(position: position))
    }
    
    /// Filters a request to only return entries related to the time at the given `rank`.
    public static func fastest(_ rank: Int) -> FilterCriteria {
        FilterCriteria(path: "/fastest/\(rank)")
    }
    
    /// Filters a request to only return entries related to the given finishing `status`.
    public static func status(_ status: String) -> FilterCriteria {
        FilterCriteria(path: "/status/\(status)")
    }
    
    /// Filters a request to only return entries related to the driver at the given standing `position`.
    public static func driverStanding(_ position: Int) -> FilterCriteria {
        FilterCriteria(path: "/driverStandings/\(position)")
    }
    
    /// Filters a request to only return entries related to the constructor at the given standing `position`.
    public static func constructorStanding(_ position: Int) -> FilterCriteria {
        FilterCriteria(path: "/constructorStandings/\(position)")
    }
}
