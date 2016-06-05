//
//  AlamofireXmlToObjects3Tests.swift
//  AlamofireXmlToObjects
//
//  Created by Edwin Vermeer on 6/5/16.
//  Copyright © 2016 evict. All rights reserved.
//

import XCTest
import Alamofire
import XMLDictionary
import EVReflection


class AllGames: EVObject {
    var __name: String?
}



class AlamofireXmlToObjects3Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        EVReflection.setBundleIdentifier(AllGames)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testResponseObject() {
        // This is an example of a functional test case.
        let URL: URLStringConvertible = "http://raw.githubusercontent.com/evermeer/AlamofireXmlToObjects/master/AlamofireXmlToObjectsTests/sample3_xml"
        let expectation = expectationWithDescription("\(URL)")

        Alamofire.request(.GET, URL)
            .responseObject { (response: Result<AllGames, NSError>) in

                expectation.fulfill()
                if let error = response.error {
                    XCTAssert(false, "ERROR: \(error.description)")
                } else {
                    if let result = response.value {
                        print("\(result.description)")

                    } else {
                        XCTAssert(false, "no result from service")
                    }
                }


        }

        waitForExpectationsWithTimeout(10, handler: { (error: NSError?) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }

}
