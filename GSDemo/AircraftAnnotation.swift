//
//  AircraftAnnotation.swift
//  GSDemo
//
//  Created by Samuel Scherer on 4/25/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import MapKit

class AircraftAnnotation : NSObject, MKAnnotation {
    @objc var coordinate : CLLocationCoordinate2D//TODO: readonly vars in swift? public but not open?
    @objc var annotationView : AircraftAnnotationView?
    
    @objc init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
    @objc func update(heading:Float) {
        self.annotationView?.update(heading: heading)
    }
}
