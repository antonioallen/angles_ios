//
//  Beacon.swift
//  Angles
//
//  Created by Antonio Allen on 6/8/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import Foundation

class Beacon {
    var UUID:String
    var major:Int
    var minor:Int
    var title:String
    var description:String
    var beaconType:String
    
    init(_UUID:String, _major:Int, _minor:Int, _title:String, _description:String, _beaconType:String) {
        self.UUID = _UUID
        self.major = _major
        self.minor = _minor
        self.title = _title
        self.description = _description
        self.beaconType = _beaconType
    }
}
