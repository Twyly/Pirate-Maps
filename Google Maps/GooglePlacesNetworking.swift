//
//  GooglePlacesNetworking.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/3/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import Foundation

let append = "?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise&key=AddYourOwnKeyHere"


class PlacesNetworkManager {
    
    internal struct EndPoints {
        static let nearbySearch = "nearbysearch/json"
        static let textSearch = "textsearch/json"
    }
    
    internal struct Parameters {
        static let key = "key"
        static let location = "location" // Takes the form of "lat,long"
        static let radius = "radius"
        static let queryText = "query"
    }
    
    internal struct JSONResponse {
        static let results = "results"
        static let placeID = "place_id"
        static let name = "name"
        static let vicinity = "vicinity"
        static let geometry = "geometry"
        static let location = "location"
        static let lat = "lat"
        static let lng = "lng"

    }
    
    private let browserAPIKey = "AIzaSyB75P9AzB6KfkR6fQsHn-GHJMiurJ735_A"
    private let baseURL = NSURL(string: "https://maps.googleapis.com/maps/api/place/")!
    
    class var sharedInstance : PlacesNetworkManager {
        struct Static {
            static let instance : PlacesNetworkManager = PlacesNetworkManager()
        }
        return Static.instance
    }
    
    
    func request<T>(path: String, method: Method, parameters: ParameterDictionary, parse: JSONDictionary -> T?, completion: (response: NetworkResponse<T>) -> ()) {
        
        var requestParameters: ParameterDictionary = [PlacesNetworkManager.Parameters.key : browserAPIKey]
        requestParameters.merge(parameters)
        let headers = ["Content-Type": "application/json", "Accept": "application/json"]
        let resource = Resource(path: path, method: method, requestParameters: requestParameters, parse: parse)
    
        apiRequest(baseURL, resource, { reason, data  in
            completion(response: .Failure(reason))
            }, {result in
                let box = Box(result)
                completion(response: .Success(box))
        })
    }
    
}