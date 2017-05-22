//
//  ClockAnnotation.swift
//  DropItLikeItsClock
//
//  Created by Jeff Kelley on 5/22/17.
//  Copyright © 2017 Jeff Kelley. All rights reserved.
//

import MapKit

class ClockAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let timeZone: TimeZone
    
    init(coordinate: CLLocationCoordinate2D, timeZone: TimeZone) {
        self.coordinate = coordinate
        self.timeZone = timeZone
        
        super.init()
    }

}
