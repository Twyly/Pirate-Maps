//
//  Place.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/3/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import Foundation

class Place: NSObject, NSCoding {
    
    let placeID: String
    let name: String
    let vicinity: String
    let coordinate: Coordinate

    init(placeID: String, name: String, coordinate: Coordinate, vicinity: String) {
        self.placeID = placeID
        self.name = name
        self.coordinate = coordinate
        self.vicinity = vicinity
        super.init()
    }
    
    //MARK: - NSCoding
    required convenience init(coder aDecoder: NSCoder) {
        let placeID = aDecoder.decodeObjectForKey("placeID") as! String
        let name = aDecoder.decodeObjectForKey("name") as! String
        let lat = aDecoder.decodeObjectForKey("lat") as! Double
        let lng = aDecoder.decodeObjectForKey("lng") as! Double
        let cord = Coordinate(latitude: lat, longitude: lng)
        let vic = aDecoder.decodeObjectForKey("vicinity") as! String
        self.init(placeID: placeID, name: name, coordinate: cord, vicinity: vic)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(placeID, forKey: "placeID")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(coordinate.latitude, forKey: "lat")
        aCoder.encodeObject(coordinate.longitude, forKey: "lng")
        aCoder.encodeObject(vicinity, forKey: "vicinity")
    }
    
    //MARK: - Saving/Retrieving
    struct ArchiveURLs {
        static var recentPlaces: String {
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory = paths.first as! String
            let filePath = documentsDirectory.stringByAppendingPathComponent("mapsRecent")
            return filePath
        }
    }
    
    class func recentlyVisitedPlaces() -> [Place] {
        let path = ArchiveURLs.recentPlaces
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            let places = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! [Place]
            return places
        } else {
            return [Place]()
        }
    }
    
    //TODO: - Remove this Stub
    class func nearbyAndLocalPlaces(coordinate: Coordinate) -> [Place] {
        return recentlyVisitedPlaces()
    }
    
    func saveToRecentHistory() {
        let path = ArchiveURLs.recentPlaces
        var places = Place.recentlyVisitedPlaces()
        places.append(self)
        NSKeyedArchiver.archiveRootObject(places, toFile: path)
    }
}

struct Service {
    static func allServices() -> [Service] {
      return [Service(name: "Gas Stations"), Service(name: "Groceries"), Service(name: "Pharmacies"), Service(name: "ATMs"), Service(name: "Convenience stores"), Service(name: "Post offices"), Service(name: "Florists"), Service(name: "Libraries"), Service(name: "Car wash"), Service(name: "Parking"), Service(name: "Copy shops"), Service(name: "Hospitals")]
    }
    let name: String
}

struct Coordinate {
    let latitude: Double
    let longitude: Double
}



