//
//  DJIAircraftAnnotation.h
//  DJISdkDemo
//
//  Created by Ares on 15/4/27.
//  Copyright (c) 2015年 DJI. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <GSDemo-Swift.h>

@interface DJIAircraftAnnotation : NSObject<MKAnnotation>

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, weak) AircraftAnnotationView* annotationView;

-(id) initWithCoordiante:(CLLocationCoordinate2D)coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

-(void) updateHeading:(float)heading;

@end
