//
//  Venue.swift
//  Coffee
//
//  Created by Melissa on 12/4/15.
//  Copyright © 2015 DLHackDay. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Venue: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    
    dynamic var latitude: Float = 0
    dynamic var longitude: Float = 0
    
    dynamic var address: String = ""
    
    var coordinate: CLLocation {
        return CLLocation(latitude: Double(latitude), longitude: Double(longitude));
    }
    
    override static func primaryKey() -> String? {
        return "id";
    }
}
