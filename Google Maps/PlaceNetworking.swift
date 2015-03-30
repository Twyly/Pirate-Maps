//
//  PlaceNetworking.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/3/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import Foundation

extension Place {
    
    internal class func fetchNearbyPlaces(text: String, coordinate: Coordinate, completion: (places: [Place], failReason: Reason?) -> ()) {
        
        let parameters: ParameterDictionary = [PlacesNetworkManager.Parameters.queryText : text, PlacesNetworkManager.Parameters.location : coordinate.textRepresentation, PlacesNetworkManager.Parameters.radius : "1000"]
        
        PlacesNetworkManager.sharedInstance.request(PlacesNetworkManager.EndPoints.textSearch, method: .GET, parameters: parameters, parse: parse, completion: { response in
            switch response {
            case .Success(let result):
                completion(places: result.unbox, failReason: nil)
            case .Failure(let failureReason):
                completion(places: [], failReason: failureReason)
            }
        })
    }
    
    // As class method are still not supported. Factor this into a parsing protocol
    private class var parse: JSONDictionary -> [Place]? {
        return { dict in
            if let places = dict[PlacesNetworkManager.JSONResponse.results] as? [JSONDictionary] {
                var allPlaces = [Place]()
                for place in places {
                    if let
                        name = place[PlacesNetworkManager.JSONResponse.name] as? String,
                        identifier = place[PlacesNetworkManager.JSONResponse.name] as? String,
                        vicinity = place[PlacesNetworkManager.JSONResponse.name] as? String,
                        geom = place[PlacesNetworkManager.JSONResponse.geometry] as? JSONDictionary,
                        loc = geom[PlacesNetworkManager.JSONResponse.location] as? JSONDictionary,
                        lat = loc[PlacesNetworkManager.JSONResponse.lat] as? Double,
                        lng = loc[PlacesNetworkManager.JSONResponse.lng] as? Double
                    {
                        let newPlace = Place(placeID: identifier, name: name, coordinate: Coordinate(latitude: lat, longitude: lng), vicinity: vicinity)
                        allPlaces.append(newPlace)
                    }
                }
                return allPlaces
            }
            return nil
        }
    }
}

extension Coordinate {
    private var textRepresentation: String {
        return "\(latitude),\(longitude)"
    }
}