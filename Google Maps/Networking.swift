//
//  Networking.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/3/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

// Inspired/Taken from Chris Eidhof

import Foundation

//MARK: - GeneralLogic

public typealias JSONDictionary = [String : AnyObject]
public typealias ParameterDictionary = [String : String]

public enum Method: String { // Bluntly stolen from Alamofire
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

public enum Reason {
    case CouldNotParseJSON
    case NoData
    case NoSuccessStatusCode(statusCode: Int)
    case Other(NSError)
}

class Box<T> {
    let unbox: T
    init(_ value: T) {
        self.unbox = value
    }
}

// Segmentation Fault - We want to change this!
enum NetworkResponse<T> {
    case Success(Box<T>)
    case Failure(Reason)
}

public struct Resource<A> {
    
    let path: String
    let method : Method
    let queryParameters: ParameterDictionary
    let requestBody: NSData?
    let headers : [String:String]
    let parse: NSData -> A?
    
    init(path: String, method: Method, queryParameters: ParameterDictionary, requestBody: NSData?, headers: [String:String], parse: NSData -> A?) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.requestBody = requestBody
        self.headers = headers
        self.parse = parse
    }
    
    // JSON Initializer
    init(path: String, method: Method, requestParameters: ParameterDictionary, parse: JSONDictionary -> A?) {
        self.path = path
        self.method = method
        self.requestBody = nil
        self.headers = ["Content-Type": "application/json"]
        self.queryParameters = requestParameters
        self.parse =  { data in
            if let json = decodeJSON(data) {
                return parse(json)
            } else {
                return nil
            }
        }
    }
}

// Completion Handler Guarenteed to be called on the main thread
public func apiRequest<A>(baseURL: NSURL, resource: Resource<A>, failure: (Reason, NSData?) -> (), completion: A -> ()) {
    let session = NSURLSession.sharedSession()
    let url = baseURL.URLByAppendingPathComponent(resource.path)
    let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)!
    
    var queryItems = [NSURLQueryItem]()
    for (key, value) in resource.queryParameters {
        queryItems.append(NSURLQueryItem(name: key, value: value))
    }
    components.queryItems = queryItems
    
    let request = NSMutableURLRequest(URL: components.URL!)

    request.HTTPMethod = resource.method.rawValue
    request.HTTPBody = resource.requestBody

    for (key,value) in resource.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    (UIApplication.sharedApplication().delegate! as! AppDelegate).setNetworkActivityIndicatorVisable(true)
    let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
        dispatch_async(dispatch_get_main_queue()) {
            (UIApplication.sharedApplication().delegate! as! AppDelegate).setNetworkActivityIndicatorVisable(false)
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let responseData = data {
                        if let result = resource.parse(responseData) {
                            completion(result)
                        } else {
                            failure(Reason.CouldNotParseJSON, data)
                        }
                    } else {
                        failure(Reason.NoData, data)
                    }
                } else {
                    failure(Reason.NoSuccessStatusCode(statusCode: httpResponse.statusCode), data)
                }
            } else {
                failure(Reason.Other(error), data)
            }
        }
    }
    task.resume()
}

//MARK: - JSONAPI

func decodeJSON(data: NSData) -> JSONDictionary? {
    return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject]
}

func encodeJSON(dict: JSONDictionary) -> NSData? {
    return dict.count > 0 ? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil) : nil
}
