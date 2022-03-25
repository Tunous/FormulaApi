import SwiftUI

/// A type which uniquely describes a single driver.
public struct DriverID: ExpressibleByStringLiteral {
    let id: String
    
    public init(stringLiteral value: StringLiteralType) {
        self.id = value
    }
    
    public init(_ id: String) {
        self.id = id
    }
}

extension DriverID {
    /// Fernando Alonso
    public static let alonso = DriverID("alonso")
}
