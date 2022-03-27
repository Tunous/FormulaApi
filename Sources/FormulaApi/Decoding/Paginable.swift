import SwiftUI

/// Response which includes pagination support.
///
/// Structures of this type are returned from various request methods. You can use it like a regular array
/// to access its elements. Additionally you can access `page` property to read information about current page.
/// To fetch next page use the `getNextPage` method.
public struct Paginable<Element> {

    /// Elements contained in the current page.
    public let elements: [Element]

    /// Information about the current page.
    public let page: Page

    let nextPageRequest: () async throws -> Paginable<Element>
    
    init(elements: [Element], page: Page, nextPageRequest: @escaping () async throws -> Paginable<Element>) {
        self.elements = elements
        self.page = page
        self.nextPageRequest = nextPageRequest
    }

    /// Gets next page of the original request.
    ///
    /// All of the parameters specified in the original request are preserved.
    ///
    /// - Returns: Paginable response with elements from next page.
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
