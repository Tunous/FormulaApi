import XCTest
import Mocker
import FormulaApi

final class RaceScheduleTests: BaseTestCase {

    func testRaceSchedule() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/2012.json", fileName: "races-2012")

        let races = try await F1.races(season: .year(2012))

        XCTAssertEqual(races.count, 20)

        let race = try XCTUnwrap(races.first)
        XCTAssertEqual(race.season, "2012")
        XCTAssertEqual(race.round, "1")
        XCTAssertEqual(race.url, "http://en.wikipedia.org/wiki/2012_Australian_Grand_Prix")
        XCTAssertEqual(race.name, "Australian Grand Prix")
        XCTAssertEqual(race.date, DateComponents(calendar: .current, timeZone: .init(secondsFromGMT: 0), year: 2012, month: 3, day: 18, hour: 6, minute: 0, second: 0).date)

        let circuit = race.circuit
        XCTAssertEqual(circuit.id, "albert_park")
        XCTAssertEqual(circuit.url, "http://en.wikipedia.org/wiki/Melbourne_Grand_Prix_Circuit")
        XCTAssertEqual(circuit.name, "Albert Park Grand Prix Circuit")

        let location = circuit.location
        XCTAssertEqual(location.lat, "-37.8497")
        XCTAssertEqual(location.long, "144.968")
        XCTAssertEqual(location.locality, "Melbourne")
        XCTAssertEqual(location.country, "Australia")
    }

    func testCurrentRaceSchedule() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/current.json", fileName: "races-current")

        let races = try await F1.races(season: .current)

        XCTAssertTrue(!races.isEmpty)
    }

    func testRaceRoundSchedule() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/2008/5.json", fileName: "races-2008-5")

        let races = try await F1.races(season: .year(2008, round: .number(5)))

        XCTAssertTrue(!races.isEmpty)
    }

    func testRacesWithDriverAndCircuit() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/drivers/alonso/circuits/monza/races.json", fileName: "races-alonso-monza")

        let races = try await F1.races(by: .driver("alonso"), .circuit("monza"))

        XCTAssertTrue(!races.isEmpty)
    }

    func testDecodePage() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/2012.json", fileName: "races-2012")
        try mockSuccess(url: "https://ergast.com/api/f1/2012.json?limit=30&offset=30", fileName: "races-2012-page2")

        let races = try await F1.races(season: .year(2012))
        let races2 = try await races.getNextPage()

        let page = races.page
        XCTAssertEqual(page.limit, 30)
        XCTAssertEqual(page.offset, 0)
        XCTAssertEqual(page.total, 20)

        let page2 = races2.page
        XCTAssertEqual(page2.limit, 30)
        XCTAssertEqual(page2.offset, 30)
        XCTAssertEqual(page2.total, 20)
    }
}
