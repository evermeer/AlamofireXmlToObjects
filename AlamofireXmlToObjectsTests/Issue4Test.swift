//
//  Issue4Test.swift
//  AlamofireXmlToObjects
//
//  Created by Edwin Vermeer on 8/4/16.
//  Copyright © 2016 evict. All rights reserved.
//


import XCTest
import Alamofire
import XMLDictionary
import EVReflection


class XmlResponse: EVObject {
    var qlist: [QList]?
}

class QList: EVObject {
    var piname: String?
    var picell: String?
    var rinum: String?
}



class Issue4Test: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        EVReflection.setBundleIdentifier(JDBOR)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testIssue() {
        // This is an example of a functional test case.
        let URL: URLStringConvertible = "http://raw.githubusercontent.com/evermeer/AlamofireXmlToObjects/master/AlamofireXmlToObjectsTests/Issue4_xml"
        let expectation = expectationWithDescription("\(URL)")

        Alamofire.request(.GET, URL)
            .responseObject { (response: Result<XmlResponse, NSError>) in
                if let error = response.error {
                    XCTAssert(false, "ERROR: \(error.description)")
                } else {
                    if let result = response.value {
                        print("\(result.description)")

                    } else {
                        XCTAssert(false, "no result from service")
                    }
                }
                expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10, handler: { (error: NSError?) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }

}
