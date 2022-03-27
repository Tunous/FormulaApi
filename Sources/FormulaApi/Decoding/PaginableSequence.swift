import SwiftUI

public struct PaginableSequence<Element>: Collection {
    public let elements: [Element]
    public let page: Page
    public let nextPageRequest: () async throws -> PaginableSequence<Element>
    
    init(elements: [Element], page: Page, nextPageRequest: @escaping () async throws -> PaginableSequence<Element>) {
        self.elements = elements
        self.page = page
        self.nextPageRequest = nextPageRequest
    }
    
    public func getNextPage() async throws -> PaginableSequence<Element> {
        return try await nextPageRequest()
    }
    
    public var hasPreviousPage: Bool {
        page.offset > 0
    }
    
    public var hasNextPage: Bool {
        page.offset + page.limit < page.total
    }
    
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
