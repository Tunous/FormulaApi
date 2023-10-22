import XCTest
@testable import FormulaApi

class CircuitsTests: BaseTestCase {

    func testAllCircuits() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/circuits.json", fileName: "circuits")

        let circuits = try await F1.circuits()

        XCTAssertEqual(circuits.count, 30)
        XCTAssertEqual(circuits.page.total, 79)

        let circuit = try XCTUnwrap(circuits.first)
        XCTAssertEqual(circuit.name, "Adelaide Street Circuit")
        XCTAssertEqual(circuit.url, "http://en.wikipedia.org/wiki/Adelaide_Street_Circuit")
        XCTAssertEqual(circuit.id, "adelaide")
        XCTAssertEqual(circuit.location.lat, "-34.9272")
        XCTAssertEqual(circuit.location.long, "138.617")
        XCTAssertEqual(circuit.location.locality, "Adelaide")
        XCTAssertEqual(circuit.location.country, "Australia")
    }

    func testCircuitsSeason2010() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/2010/circuits.json", fileName: "circuits-2010")

        let circuits = try await F1.circuits(season: .year(2010))

        XCTAssertEqual(circuits.count, 19)
        XCTAssertEqual(circuits.page.total, 19)

        let circuit = try XCTUnwrap(circuits.first)
        XCTAssertEqual(circuit.name, "Albert Park Grand Prix Circuit")
        XCTAssertEqual(circuit.url, "http://en.wikipedia.org/wiki/Melbourne_Grand_Prix_Circuit")
        XCTAssertEqual(circuit.id, "albert_park")
        XCTAssertEqual(circuit.location.lat, "-37.8497")
        XCTAssertEqual(circuit.location.long, "144.968")
        XCTAssertEqual(circuit.location.locality, "Melbourne")
        XCTAssertEqual(circuit.location.country, "Australia")
    }

    func testCircuitsSeason2010Round2() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/2010/2/circuits.json", fileName: "circuits-2010-2")

        let circuits = try await F1.circuits(season: .year(2010, round: .number(2)))

        XCTAssertEqual(circuits.count, 1)
        XCTAssertEqual(circuits.page.total, 1)

        let circuit = try XCTUnwrap(circuits.first)
        XCTAssertEqual(circuit.name, "Albert Park Grand Prix Circuit")
        XCTAssertEqual(circuit.url, "http://en.wikipedia.org/wiki/Melbourne_Grand_Prix_Circuit")
        XCTAssertEqual(circuit.id, "albert_park")
        XCTAssertEqual(circuit.location.lat, "-37.8497")
        XCTAssertEqual(circuit.location.long, "144.968")
        XCTAssertEqual(circuit.location.locality, "Melbourne")
        XCTAssertEqual(circuit.location.country, "Australia")
    }

    func testCircuitById() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/circuits/monza.json", fileName: "circuits-monza")

        let circuits = try await F1.circuits(by: [.circuit(.monza)])

        XCTAssertEqual(circuits.count, 1)
        XCTAssertEqual(circuits.page.total, 1)

        let circuit = try XCTUnwrap(circuits.first)
        XCTAssertEqual(circuit.name, "Autodromo Nazionale di Monza")
        XCTAssertEqual(circuit.url, "http://en.wikipedia.org/wiki/Autodromo_Nazionale_Monza")
        XCTAssertEqual(circuit.id, "monza")
        XCTAssertEqual(circuit.location.lat, "45.6156")
        XCTAssertEqual(circuit.location.long, "9.28111")
        XCTAssertEqual(circuit.location.locality, "Monza")
        XCTAssertEqual(circuit.location.country, "Italy")
    }

    func testCircuitByDriverAndConstructor() async throws {
        try mockSuccess(url: "https://ergast.com/api/f1/drivers/alonso/constructors/mclaren/circuits.json", fileName: "circuits-alonso-mclaren")

        let circuits = try await F1.circuits(by: [.driver(.alonso), .constructor(.mcLaren)])

        XCTAssertEqual(circuits.count, 27)
        XCTAssertEqual(circuits.page.total, 27)

        let circuit = try XCTUnwrap(circuits.first)
        XCTAssertEqual(circuit.name, "Albert Park Grand Prix Circuit")
        XCTAssertEqual(circuit.url, "http://en.wikipedia.org/wiki/Melbourne_Grand_Prix_Circuit")
        XCTAssertEqual(circuit.id, "albert_park")
        XCTAssertEqual(circuit.location.lat, "-37.8497")
        XCTAssertEqual(circuit.location.long, "144.968")
        XCTAssertEqual(circuit.location.locality, "Melbourne")
        XCTAssertEqual(circuit.location.country, "Australia")
    }

}
