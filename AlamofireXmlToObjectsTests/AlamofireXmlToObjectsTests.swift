//
//  AlamofireXmlToObjectsTests.swift
//  AlamofireXmlToObjectsTests
//
//  Created by Edwin Vermeer on 6/21/15.
//  Copyright (c) 2015 evict. All rights reserved.
//

import XCTest
import Alamofire
import XMLDictionary
import EVReflection

class WeatherResponse: EVObject {
    var location: String?
    var three_day_forecast: [Forecast] = [Forecast]()
}

class Forecast: EVObject {
    var day: String?
    var temperature: NSNumber?
    var conditions: String?
}


class AlamofireXmlToObjectsTests: XCTestCase {
    
        override func setUp() {
            super.setUp()
            // Put setup code here. This method is called before the invocation of each test method in the class.
            EVReflection.setBundleIdentifier(Forecast)
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            super.tearDown()
        }

    
        func testResponseObject() {
            // This is an example of a functional test case.
            let URL: URLStringConvertible = "http://raw.githubusercontent.com/evermeer/AlamofireXmlToObjects/master/AlamofireXmlToObjectsTests/sample_xml"
            let expectation = expectationWithDescription("\(URL)")
                        
            Alamofire.request(.GET, URL)
                .responseObject { (response: Result<WeatherResponse, NSError>) in
                
                expectation.fulfill()
                if let result = response.value {
                    print("\(result.description)")
                    XCTAssertNotNil(result.location, "Location should not be nil")
                    XCTAssertNotNil(result.three_day_forecast, "ThreeDayForcast should not be nil")
                    for forecast in result.three_day_forecast {
                        XCTAssertNotNil(forecast.day, "day should not be nil")
                        XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                        XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
                    }
                    
                } else {
                    XCTAssert(true, "no result from service")
                }
                
                    
            }
            
            waitForExpectationsWithTimeout(10, handler: { (error: NSError?) -> Void in
                XCTAssertNil(error, "\(error)")
            })
        }
    
    
        func testResponseObject2() {
            // This is an example of a functional test case.
            
            let URL = "http://raw.githubusercontent.com/evermeer/AlamofireXmlToObjects/master/AlamofireXmlToObjectsTests/sample_xml"
            let expectation = expectationWithDescription("\(URL)")
            
            Alamofire.request(.GET, URL)
                .responseObject { (request: NSURLRequest?, HTTPURLResponse: NSHTTPURLResponse?, response: Result<WeatherResponse, NSError>) in
                    
                expectation.fulfill()
                    if let result = response.value {
                        XCTAssertNotNil(result.location, "Location should not be nil")
                        XCTAssertNotNil(result.three_day_forecast, "ThreeDayForcast should not be nil")
                        
                        for forecast in result.three_day_forecast {
                            XCTAssertNotNil(forecast.day, "day should not be nil")
                            XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                            XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
                        }
                    } else {
                        XCTAssert(true, "Could not get result from service")
                    }
            }
            
            waitForExpectationsWithTimeout(10, handler: { (error: NSError?) -> Void in
                XCTAssertNil(error, "\(error)")
            })
        }        
    }

