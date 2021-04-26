//
//  MapController.swift
//  GSDemo
//
//  Created by Samuel Scherer on 4/25/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapController : NSObject {
    
    @objc var editPoints : [CLLocation]
    var aircraftAnnotation : AircraftAnnotation?
    
    override init() {
        self.editPoints = [CLLocation]()
        super.init()
    }
    
    @objc func add(point:CGPoint, for mapView:MKMapView) {
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.editPoints.append(location)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    @objc func cleanAllPoints(with mapView: MKMapView) {
        self.editPoints.removeAll()
        let annotations = [MKAnnotation].init(mapView.annotations)
        for annotation : MKAnnotation in annotations {
            if annotation !== self.aircraftAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    @objc func updateAircraft(location:CLLocationCoordinate2D, with mapView:MKMapView) {
        if self.aircraftAnnotation == nil {
            self.aircraftAnnotation = AircraftAnnotation(coordinate: location)
            mapView.addAnnotation(self.aircraftAnnotation!)
        } else {
            self.aircraftAnnotation?.coordinate = location
        }
    }
    
    @objc func updateAircraftHeading(heading:Float) {
        if let _ = self.aircraftAnnotation {
            self.aircraftAnnotation!.update(heading: heading)
        }
    }
}
