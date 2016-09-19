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

extension DataRequest {
    static var outputDictionary: Bool = false

    /**
    Adds a handler to be called once the request has finished.

    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response object (of type Mappable) and any error produced while making the request

    - returns: The request.
    */
    public func responseObject<T: EVObject>(_ completionHandler: @escaping (Result<T>) -> Void) -> Self {
        return responseObject(nil) { (request, response, data) in
            completionHandler(data)
        }
    }

    /**
    Adds a handler to be called once the request has finished.

    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.

    - returns: The request.
    */
    public func responseObject<T: EVObject>(_ completionHandler: @escaping (URLRequest?, HTTPURLResponse?, Result<T>) -> Void) -> Self {
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
    public func responseObject<T:EVObject>(_ queue: DispatchQueue? = nil, encoding: String.Encoding? = nil, completionHandler: @escaping (URLRequest?, HTTPURLResponse?, Result<T>) -> Void) -> Self {
        return responseString(encoding: encoding, completionHandler: { (response) -> Void in
            DispatchQueue.global().async {
                (queue ?? DispatchQueue.main).async {
                    switch response.result {
                    case .success(let xml):
                        let t = T()
                        if let result = NSDictionary(xmlString: xml) {
                            if DataRequest.outputDictionary {
                                print("Dictionary from XML = \(result)")
                            }
                            let _ = EVReflection.setPropertiesfromDictionary(result, anyObject: t)
                            completionHandler(self.request, self.response, Result.success(t))
                        } else {
                            completionHandler(self.request, self.response, Result.failure(NSError(domain: "NaN", code: 1, userInfo: nil)))
                        }
                    case .failure(let error):
                        completionHandler(self.request, self.response, Result.failure(error))
                    }
                }
                
            }
        })
    }
}

