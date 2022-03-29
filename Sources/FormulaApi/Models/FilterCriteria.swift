import Foundation

/// Criteria that can be used to filter results returned by various API requests.
public enum FilterCriteria: Hashable {
    
    /// Filters a request to only return entries related to the given `circuit`.
    ///
    /// For example when used in ``F1/seasons(season:criteria:page:)`` method, the criteria will
    /// limit the returned seasons to only these, which included the given circuit in their schedule.
    ///
    /// - Parameter circuit: The circuit to filter by. Can be either a regular string or a know circuit
    /// from the ``CircuitID`` type.
    case circuit(_ circuit: CircuitID)
    
    /// Filters a request to only return entries related to
    /// the given `constructor`.
    case constructor(_ constructor: String)
    
    /// Filters a request to only return entries related to the given `driver`.
    ///
    /// - Parameter driver: The driver to filter by. Can be either a regular string or a known driver
    /// from the ``DriverID`` type.
    ///
    /// - Returns: Filter criteria based on driver id.
    case driver(_ driver: DriverID)
    
    /// Filters a request to only return entries related to the given starting grid `position`.
    case grid(position: Int)
    
    /// Filters a request to only return entries related to the given `result` at the end of the race.
    case finishingResult(_ result: FinishingResult)
    
    /// Filters a request to only return entries related to the time at the given `rank`.
    case fastest(rank: Int)
    
    /// Filters a request to only return entries related to the given finishing `status`.
    case status(_ status: String)
    
    /// Filters a request to only return entries related to the driver at the given standing `position`.
    case driverStanding(position: Int)
    
    /// Filters a request to only return entries related to the constructor at the given standing `position`.
    case constructorStanding(position: Int)

    /// Filters a request to only return entries related to the given `circuit`.
    ///
    /// For example when used in ``F1/seasons(season:criteria:page:)`` method, the criteria will
    /// limit the returned seasons to only these, which included the given circuit in their schedule.
    ///
    /// - Parameter circuit: The id of a circuit to filter by.
    public static func circuit(id circuit: String) -> FilterCriteria {
        Self.circuit(CircuitID(circuit))
    }

    /// Filters a request to only return entries related to the given `driver`.
    ///
    /// - Parameter driver: The id of a driver to filter by.
    ///
    /// - Returns: Filter criteria based on driver id.
    public static func driver(id driver: String) -> FilterCriteria {
        Self.driver(DriverID(driver))
    }

    /// Filters a request to only return entries related to the given `position` at the end of the race.
    public static func finishingPosition(_ position: Int) -> FilterCriteria {
        finishingResult(.finished(position: position))
    }
}

// MARK: - Private

extension FilterCriteria {
    var path: String {
        switch self {
        case .circuit(let circuit):
            return "/circuits/\(circuit.id)"
        case .constructor(let constructor):
            return "/constructors/\(constructor)"
        case .driver(let driver):
            return "/drivers/\(driver.id)"
        case .grid(position: let position):
            return "/grid/\(position)"
        case .finishingResult(let result):
            return "/results/\(result.rawValue)"
        case .fastest(let rank):
            return "/fastest/\(rank)"
        case .status(let status):
            return "/status/\(status)"
        case .driverStanding(position: let position):
            return "/driverStandings/\(position)"
        case .constructorStanding(position: let position):
            return "/constructorStandings/\(position)"
        }
    }
}
