//
//  CLLocationCoordinate2D+Extensions.swift
//  AR_Navigation
//
//  Created by Gleb Radchenko on 11/11/17.
//  Copyright © 2017 Gleb Radchenko. All rights reserved.
//

import Foundation
import CoreLocation

struct Constants {
    static var metersInLat: Double = 6373000
    static var metersInLon: Double = 5602900
}

extension Double {
    var metersToLat: Double { return self / Constants.metersInLat }
    var metersToLon: Double { return self / Constants.metersInLon }
}

extension CLLocationCoordinate2D {
    func bearing(to coordinate: CLLocationCoordinate2D) -> Double {
        let a = sin(coordinate.longitude.degToRad - longitude.degToRad) * cos(coordinate.latitude.degToRad)
        let b = cos(latitude.degToRad) * sin(coordinate.latitude.degToRad) - sin(latitude.degToRad) * cos(coordinate.latitude.degToRad) * cos(coordinate.longitude.degToRad - longitude.degToRad)
        return atan2(a, b)
    }
    
    func direction(to coordinate: CLLocationCoordinate2D) -> CLLocationDirection {
        return bearing(to: coordinate).radToDeg
    }
    
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
    
    func coordinate(with bearing: Double, distance: Double) -> CLLocationCoordinate2D {
        
        let distRadLat = distance.metersToLat
        let distRadLon = distance.metersToLon
        
        let lat1 = latitude.degToRad
        let lon1 = longitude.degToRad
        
        let lat2 = asin(sin(lat1) * cos(distRadLat) + cos(lat1) * sin(distRadLat) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadLon) * cos(lat1), cos(distRadLon) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2.radToDeg, longitude: lon2.radToDeg)
    }
}
