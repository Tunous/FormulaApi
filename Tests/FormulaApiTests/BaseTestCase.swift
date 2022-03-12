//
//  File.swift
//  
//
//  Created by Łukasz Rutkowski on 06/03/2022.
//

import Foundation
import XCTest
import Mocker
import FormulaApi

class BaseTestCase: XCTestCase {

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        F1.urlSession = URLSession(configuration: configuration)
    }

    func mockSuccess(url: URL, fileName: String) throws {
        let responseFileUrl = try XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: "json"), "Response file not found \(fileName)")
        let data = try Data(contentsOf: responseFileUrl)
        Mock(url: url, dataType: .json, statusCode: 200, data: [.get: data]).register()
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)!
    }
}
