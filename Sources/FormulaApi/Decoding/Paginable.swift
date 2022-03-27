import SwiftUI

public struct Paginable<Element> {
    public let elements: [Element]
    public let page: Page
    public let nextPageRequest: () async throws -> Paginable<Element>
    
    init(elements: [Element], page: Page, nextPageRequest: @escaping () async throws -> Paginable<Element>) {
        self.elements = elements
        self.page = page
        self.nextPageRequest = nextPageRequest
    }
    
    public func getNextPage() async throws -> Paginable<Element> {
        return try await nextPageRequest()
    }
}

extension Paginable: Collection {
    
    public var startIndex: Int {
        elements.startIndex
    }
    
    public var endIndex: Int {
        elements.endIndex
    }
    
    public subscript(position: Int) -> Element {
        elements[position]
    }
    
    public func index(after i: Int) -> Int {
        elements.index(after: i)
    }
    
    public func makeIterator() -> Array<Element>.Iterator {
        elements.makeIterator()
    }
}
