import XCTest
@testable import FormulaApi

final class PaginationTests: BaseTestCase {

    func testGetNextPageExecutesRequest() async throws {
        var hasExecuted = false
        let paginable = Paginable(elements: ["A", "B"], page: Page(limit: 30, offset: 0)) {
            hasExecuted = true
            return Paginable(elements: ["C", "D"], page: Page(limit: 30, offset: 30), nextPageRequest: { throw F1.Error.external(statusCode: 500) })
        }

        let nextPage = try await paginable.getNextPage()

        XCTAssertTrue(hasExecuted)
        XCTAssertEqual(nextPage.elements, ["C", "D"])
        XCTAssertEqual(nextPage.page.limit, 30)
        XCTAssertEqual(nextPage.page.offset, 30)
    }

    func testFirstPageWithMoreAvailable() throws {
        let page = Page(limit: 30, offset: 0, total: 50)
        XCTAssertEqual(page.hasPreviousPage, false)
        XCTAssertEqual(page.hasNextPage, true)
    }

    func testFirstPageWithTotalReached() throws {
        let page = Page(limit: 30, offset: 0, total: 30)
        XCTAssertEqual(page.hasPreviousPage, false)
        XCTAssertEqual(page.hasNextPage, false)
    }

    func testNextPageWithMoreAvailable() throws {
        let page = Page(limit: 30, offset: 10, total: 50)
        XCTAssertEqual(page.hasPreviousPage, true)
        XCTAssertEqual(page.hasNextPage, true)
    }

    func testNextPageWithTotalReached() throws {
        let page = Page(limit: 30, offset: 20, total: 50)
        XCTAssertEqual(page.hasPreviousPage, true)
        XCTAssertEqual(page.hasNextPage, false)
    }
}
