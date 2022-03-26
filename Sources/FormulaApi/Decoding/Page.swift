import SwiftUI

public struct Page {
    public let limit: Int
    public let offset: Int
    
    public init(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }
    
    public func next() -> Page {
        return Page(limit: limit, offset: offset + limit)
    }
}
