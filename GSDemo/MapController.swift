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
    
    @objc func add(point:CGPoint, withMapView:MKMapView) {
        //TODO
        //    CLLocationCoordinate2D coordinate = [mapView convertPoint:point toCoordinateFromView:mapView];
        //    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        //    [_editPoints addObject:location];
        //    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
        //    annotation.coordinate = location.coordinate;
        //    [mapView addAnnotation:annotation];
    }
    
    @objc func cleanAllPoints(with mapView: MKMapView) {
        //TODO
        //    [_editPoints removeAllObjects];
        //    NSArray* annos = [NSArray arrayWithArray:mapView.annotations];
        //    for (int i = 0; i < annos.count; i++) {
        //        id<MKAnnotation> ann = [annos objectAtIndex:i];
        //
        //        if (![ann isEqual:self.aircraftAnnotation]) { //Add it to check if the annotation is the aircraft's and prevent it from removing
        //            [mapView removeAnnotation:ann];
        //        }
        //
        //    }

    }
    
    @objc func updateAircraft(location:CLLocationCoordinate2D, with mapView:MKMapView) {
        if self.aircraftAnnotation == nil {
            self.aircraftAnnotation = AircraftAnnotation(coordinate: location)
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
