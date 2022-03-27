import XCTest
import FormulaApi

final class PaginationTests: BaseTestCase {

    func testDecodePage() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/seasons.json", fileName: "seasons")

        let seasons = try await F1.seasons()

        let page = seasons.page
        XCTAssertEqual(page.limit, 30)
        XCTAssertEqual(page.offset, 0)
        XCTAssertEqual(page.total, 73)

        XCTAssertEqual(seasons.first?.season, "1950")
    }

    func testDecodeNextPage() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/seasons.json", fileName: "seasons")

        let seasons = try await F1.seasons()

        XCTAssertEqual(seasons.first?.season, "1950")

        try mockSuccess(url: "https://ergast.com/api/f1/seasons.json?limit=30&offset=30", fileName: "seasons-page2")

        let seasons2 = try await seasons.getNextPage()

        let page = seasons2.page
        XCTAssertEqual(page.limit, 30)
        XCTAssertEqual(page.offset, 30)
        XCTAssertEqual(page.total, 73)

        XCTAssertEqual(seasons2.first?.season, "1980")
    }

}
