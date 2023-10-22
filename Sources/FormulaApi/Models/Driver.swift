import Foundation

/// Information about a driver.
public struct Driver: Identifiable, Hashable {

    /// Identifier of the driver.
    public let id: DriverID

    /// Permanent number of the driver.
    ///
    /// - Note: Only drivers who participated in the 2014 season onwards have a permanent driver number.
    public let permanentNumber: Int?

    public let code: String
    public let url: URL
    public let givenName: String
    public let familyName: String
    public let dateOfBirth: Date
    public let nationality: String
}

// MARK: Decoding

extension Driver: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "driverId"
        case permanentNumber
        case code
        case url
        case givenName
        case familyName
        case dateOfBirth
        case nationality
    }
}
