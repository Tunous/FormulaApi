import XCTest
@testable import FormulaApi

final class FilterCriteriaTests: BaseTestCase {

    func testCircuitFilter() throws {
        XCTAssertEqual(FilterCriteria.circuit(.monza).path, "/circuits/monza")
        XCTAssertEqual(FilterCriteria.circuit("custom").path, "/circuits/custom")
    }

    func testConstructorFilter() throws {
        XCTAssertEqual(FilterCriteria.constructor("mercedes").path, "/constructors/mercedes")
    }

    func testDriverFilter() throws {
        XCTAssertEqual(FilterCriteria.driver(.alonso).path, "/drivers/alonso")
        XCTAssertEqual(FilterCriteria.driver("custom").path, "/drivers/custom")
    }

    func testGridFilter() throws {
        XCTAssertEqual(FilterCriteria.grid(4).path, "/grid/4")
    }

    func testFinishingResultFilter() throws {
        XCTAssertEqual(FilterCriteria.finishingResult(.finished(position: 12)).path, "/results/12")
        XCTAssertEqual(FilterCriteria.finishingResult(.disqualified).path, "/results/D")
        XCTAssertEqual(FilterCriteria.finishingResult(.excluded).path, "/results/E")
        XCTAssertEqual(FilterCriteria.finishingResult(.failedToQualify).path, "/results/F")
        XCTAssertEqual(FilterCriteria.finishingResult(.notClassified).path, "/results/N")
        XCTAssertEqual(FilterCriteria.finishingResult(.retired).path, "/results/R")
        XCTAssertEqual(FilterCriteria.finishingResult(.withdrawn).path, "/results/W")

        XCTAssertEqual(FilterCriteria.finishingPosition(3).path, "/results/3")
    }

    func testFastestFilter() throws {
        XCTAssertEqual(FilterCriteria.fastest(1).path, "/fastest/1")
    }

    func testStatusFilter() throws {
        XCTAssertEqual(FilterCriteria.status("custom").path, "/status/custom")
    }

    func testDriverStandingFilter() throws {
        XCTAssertEqual(FilterCriteria.driverStanding(3).path, "/driverStandings/3")
    }

    func testConstructorStandingFilter() throws {
        XCTAssertEqual(FilterCriteria.constructorStanding(8).path, "/constructorStandings/8")
    }
}
