//
//  AlamofireXmlToObjects.swift
//  AlamofireXmlToObjects
//
//  Created by Edwin Vermeer on 6/21/15.
//  Copyright (c) 2015 evict. All rights reserved.
//

import Foundation
import EVReflection
import XMLDictionary
import Alamofire

extension Request {
    static var outputDictionary: Bool = false

    /**
    Adds a handler to be called once the request has finished.

    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response object (of type Mappable) and any error produced while making the request

    - returns: The request.
    */
    public func responseObject<T: EVObject>(completionHandler: (Result<T, NSError>) -> Void) -> Self {
        return responseObject(nil) { (request, response, data) in
            completionHandler(data)
        }
    }

    /**
    Adds a handler to be called once the request has finished.

    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.

    - returns: The request.
    */
    public func responseObject<T: EVObject>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<T, NSError>) -> Void) -> Self {
        return responseObject(nil) { (request, response, data) in
            completionHandler(request, response, data)
        }
    }

    /**
    Adds a handler to be called once the request has finished.

    - parameter queue: The queue on which the completion handler is dispatched.
    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.

    - returns: The request.
    */
    public func responseObject<T: EVObject>(queue: dispatch_queue_t?, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<T, NSError>) -> Void) -> Self {
        return responseString(completionHandler: { (response) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(queue ?? dispatch_get_main_queue()) {
                    switch response.result {
                    case .Success(let xml):
                        let t = T()
                        if let result = NSDictionary(XMLString: xml) {
                            if Request.outputDictionary {
                                print("Dictionary from XML = \(result)")
                            }
                            EVReflection.setPropertiesfromDictionary(result, anyObject: t)
                            completionHandler(self.request, self.response, Result.Success(t))
                        } else {
                            completionHandler(self.request, self.response, Result.Failure(NSError(domain: "NaN", code: 1, userInfo: nil)))
                        }
                    case .Failure(let error):
                        completionHandler(self.request, self.response, Result.Failure(error ?? NSError(domain: "NaN", code: 1, userInfo: nil)))
                    }
                }
            }
        })
    }
}
