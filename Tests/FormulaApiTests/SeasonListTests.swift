import XCTest
import Mocker
import FormulaApi

final class SeasonListTests: BaseTestCase {

    func testSeasonList() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/seasons.json", fileName: "seasons")

        let seasons = try await F1.seasons()

        XCTAssertEqual(seasons.count, 30)

        let season = try XCTUnwrap(seasons.first)
        XCTAssertEqual(season.season, "1950")
        XCTAssertEqual(season.url, "http://en.wikipedia.org/wiki/1950_Formula_One_season")
    }

    func testSeasonListByDriverAndConstructor() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/drivers/alonso/constructors/renault/seasons.json", fileName: "seasons-alonso-renault")

        let seasons = try await F1.seasons(by: .driver("alonso"), .constructor("renault"))

        XCTAssertEqual(seasons.count, 6)

        let season = try XCTUnwrap(seasons.first)
        XCTAssertEqual(season.season, "2003")
        XCTAssertEqual(season.url, "http://en.wikipedia.org/wiki/2003_Formula_One_season")
    }

    func testSeasonListByDriverAndStanding() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/drivers/alonso/driverStandings/1/seasons.json", fileName: "seasons-alonso-driverstanding")

        let seasons = try await F1.seasons(by: .driver("alonso"), .driverStanding(1))

        XCTAssertEqual(seasons.count, 2)

        let season = try XCTUnwrap(seasons.first)
        XCTAssertEqual(season.season, "2005")
        XCTAssertEqual(season.url, "http://en.wikipedia.org/wiki/2005_Formula_One_season")
    }

    func testSeasonListByConstructorAndStanding() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/constructors/renault/constructorStandings/1/seasons.json", fileName: "seasons-renault-constructorstanding")

        let seasons = try await F1.seasons(by: .constructor("renault"), .constructorStanding(1))

        XCTAssertEqual(seasons.count, 2)

        let season = try XCTUnwrap(seasons.first)
        XCTAssertEqual(season.season, "2005")
        XCTAssertEqual(season.url, "http://en.wikipedia.org/wiki/2005_Formula_One_season")
    }
}
