//
//  DJIRootViewController.m
//  GSDemo
//
//  Created by DJI on 7/7/15.
//  Copyright (c) 2015 DJI. All rights reserved.
//

//#import "DJIRootViewController.h"
//#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
//#import <DJISDK/DJISDK.h>
//#import "DemoUtility.h"
//#import <GSDemo-Swift.h>
//
//#define ENTER_DEBUG_MODE 1
//
//@interface DJIRootViewController ()<GSButtonViewControllerDelegate, WaypointConfigViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, DJISDKManagerDelegate, DJIFlightControllerDelegate>
//
//@property (nonatomic, assign) BOOL isEditingPoints;
//@property (nonatomic, strong) GSButtonViewController *gsButtonVC;
//@property (nonatomic, strong) WaypointConfigViewController *waypointConfigVC;
//@property (nonatomic, strong) MapController *mapController;
//
//@property(nonatomic, strong) CLLocationManager* locationManager;
//@property(nonatomic, assign) CLLocationCoordinate2D userLocation;
//@property(nonatomic, assign) CLLocationCoordinate2D droneLocation;
//@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
//
//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (weak, nonatomic) IBOutlet UIView *topBarView;
//@property(nonatomic, strong) IBOutlet UILabel* modeLabel;
//@property(nonatomic, strong) IBOutlet UILabel* gpsLabel;
//@property(nonatomic, strong) IBOutlet UILabel* hsLabel;
//@property(nonatomic, strong) IBOutlet UILabel* vsLabel;
//@property(nonatomic, strong) IBOutlet UILabel* altitudeLabel;
//
//@property(nonatomic, strong) DJIMutableWaypointMission* waypointMission;
//@end
//
//@implementation DJIRootViewController
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self startUpdateLocation];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.locationManager stopUpdatingLocation];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self registerApp];
//
//    [self initUI];
//    [self initData];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}
//
//MARK:  Init Methods
//-(void)initData
//{
//    self.userLocation = kCLLocationCoordinate2DInvalid;
//    self.droneLocation = kCLLocationCoordinate2DInvalid;
//
//    self.mapController = [[MapController alloc] init];
//    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addWaypoints:)];
//    [self.mapView addGestureRecognizer:self.tapGesture];
//}
//
//-(void) initUI
//{
//    self.modeLabel.text = @"N/A";
//    self.gpsLabel.text = @"0";
//    self.vsLabel.text = @"0.0 M/S";
//    self.hsLabel.text = @"0.0 M/S";
//    self.altitudeLabel.text = @"0 M";
//
//    self.gsButtonVC = [[GSButtonViewController alloc] initWithNibName:@"GSButtonViewController" bundle:[NSBundle mainBundle]];
//    [self.gsButtonVC.view setFrame:CGRectMake(0, self.topBarView.frame.origin.y + self.topBarView.frame.size.height, self.gsButtonVC.view.frame.size.width, self.gsButtonVC.view.frame.size.height)];
//    self.gsButtonVC.delegate = self;
//    [self.view addSubview:self.gsButtonVC.view];
//
//    //self.waypointConfigVC = [[WaypointConfigViewController alloc] initWithNibName:@"WaypointConfigViewController" bundle:[NSBundle mainBundle]];
//    self.waypointConfigVC = [WaypointConfigViewController new];
//    self.waypointConfigVC.view.alpha = 0;
//    self.waypointConfigVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//
//    [self.waypointConfigVC.view setCenter:self.view.center];
//
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) //Check if it's using iPad and center the config view
//    {
//        self.waypointConfigVC.view.center = self.view.center;
//    }
//
//    self.waypointConfigVC.delegate = self;
//    [self.view addSubview:self.waypointConfigVC.view];
//}
//
//-(void) registerApp
//{
//    //Please enter your App key in the info.plist file to register the app.
//    [DJISDKManager registerAppWithDelegate:self];
//}
//
//MARK:  DJISDKManagerDelegate Methods
//- (void)appRegisteredWithError:(NSError *)error
//{
//    if (error){
//        NSString *registerResult = [NSString stringWithFormat:@"Registration Error:%@", error.description];
//        ShowMessage(@"Registration Result", registerResult, nil, @"OK");
//    }
//    else{
//#if ENTER_DEBUG_MODE
//        [DJISDKManager enableBridgeModeWithBridgeAppIP:@"192.168.128.169"];
//#else
//        [DJISDKManager startConnectionToProduct];
//#endif
//    }
//}
//
//- (void)productConnected:(DJIBaseProduct *)product
//{
//    if (product){
//        DJIFlightController* flightController = [DemoUtility fetchFlightController];
//        if (flightController) {
//            flightController.delegate = self;
//        }
//    }else{
//        ShowMessage(@"Product disconnected", nil, nil, @"OK");
//    }
//
//    //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
//    [[DJISDKManager userAccountManager] logIntoDJIUserAccountWithAuthorizationRequired:NO withCompletion:^(DJIUserAccountState state, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Login failed: %@", error.description);
//        }
//    }];
//
//}
//
//
//MARK: Action Methods
//
//-(DJIWaypointMissionOperator *)missionOperator {
//    return [DJISDKManager missionControl].waypointMissionOperator;
//}
//
//- (void)focusMap
//{
//    if (CLLocationCoordinate2DIsValid(self.droneLocation)) {
//        MKCoordinateRegion region = {0};
//        region.center = self.droneLocation;
//        region.span.latitudeDelta = 0.001;
//        region.span.longitudeDelta = 0.001;
//
//        [self.mapView setRegion:region animated:YES];
//    }
//}
//
//MARK:  CLLocation Methods
//-(void) startUpdateLocation
//{
//    if ([CLLocationManager locationServicesEnabled]) {
//        if (self.locationManager == nil) {
//            self.locationManager = [[CLLocationManager alloc] init];
//            self.locationManager.delegate = self;
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//            self.locationManager.distanceFilter = 0.1;
//            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//                [self.locationManager requestAlwaysAuthorization];
//            }
//            [self.locationManager startUpdatingLocation];
//        }
//    }else
//    {
//        ShowMessage(@"Location Service is not available", @"", nil, @"OK");
//    }
//}
//
//MARK:  UITapGestureRecognizer Methods
//- (void)addWaypoints:(UITapGestureRecognizer *)tapGesture
//{
//    CGPoint point = [tapGesture locationInView:self.mapView];
//
//    if(tapGesture.state == UIGestureRecognizerStateEnded){
//        if (self.isEditingPoints) {
//            [self.mapController addWithPoint:point for:self.mapView];
//        }
//    }
//}
//
//MARK:  - DJIWaypointConfigViewControllerDelegate Methods
//
////- (void)cancelBtnActionInDJIWaypointConfigViewController:(WaypointConfigViewController *)waypointConfigVC
////{
////    WeakRef(weakSelf);
////
////    [UIView animateWithDuration:0.25 animations:^{
////        WeakReturn(weakSelf);
////        weakSelf.waypointConfigVC.view.alpha = 0;
////    }];
////
////}
//
//- (void)cancelBtnActionInDJIWaypointConfigViewControllerWithViewController:(WaypointConfigViewController * _Nonnull)viewController {
//    WeakRef(weakSelf);
//
//    [UIView animateWithDuration:0.25 animations:^{
//        WeakReturn(weakSelf);
//        weakSelf.waypointConfigVC.view.alpha = 0;
//    }];
//}
//
//- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message
//{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:okAction];
//    [self presentViewController:alert animated:YES completion:nil];
//}
//
//- (void)finishBtnActionInDJIWaypointConfigViewController:(WaypointConfigViewController *)waypointConfigVC {
////    WeakRef(weakSelf);
////
////    [UIView animateWithDuration:0.25 animations:^{
////        WeakReturn(weakSelf);
////        weakSelf.waypointConfigVC.view.alpha = 0;
////    }];
////
////    for (int i = 0; i < self.waypointMission.waypointCount; i++) {
////        DJIWaypoint* waypoint = [self.waypointMission waypointAtIndex:i];
////        waypoint.altitude = [self.waypointConfigVC.altitudeTextField.text floatValue];
////    }
////
////    self.waypointMission.maxFlightSpeed = [self.waypointConfigVC.maxFlightSpeedTextField.text floatValue];
////    self.waypointMission.autoFlightSpeed = [self.waypointConfigVC.autoFlightSpeedTextField.text floatValue];
////    self.waypointMission.headingMode = (DJIWaypointMissionHeadingMode)self.waypointConfigVC.headingSegmentedControl.selectedSegmentIndex;
////    [self.waypointMission setFinishedAction:(DJIWaypointMissionFinishedAction)self.waypointConfigVC.actionSegmentedControl.selectedSegmentIndex];
////
////    [[self missionOperator] loadMission:self.waypointMission];
////
////    WeakRef(target);
////
////    [[self missionOperator] addListenerToFinished:self withQueue:dispatch_get_main_queue() andBlock:^(NSError * _Nullable error) {
////
////        WeakReturn(target);
////
////        if (error) {
////            [target showAlertViewWithTitle:@"Mission Execution Failed" withMessage:[NSString stringWithFormat:@"%@", error.description]];
////        }
////        else {
////            [target showAlertViewWithTitle:@"Mission Execution Finished" withMessage:nil];
////        }
////    }];
////
////    [[self missionOperator] uploadMissionWithCompletion:^(NSError * _Nullable error) {
////        if (error){
////            NSString* uploadError = [NSString stringWithFormat:@"Upload Mission failed:%@", error.description];
////            ShowMessage(@"", uploadError, nil, @"OK");
////        }else {
////            ShowMessage(@"", @"Upload Mission Finished", nil, @"OK");
////        }
////    }];
//
//}
//
//- (void)finishBtnActionInDJIWaypointConfigViewControllerWithViewController:(WaypointConfigViewController * _Nonnull)viewController {
//    WeakRef(weakSelf);
//
//    [UIView animateWithDuration:0.25 animations:^{
//        WeakReturn(weakSelf);
//        weakSelf.waypointConfigVC.view.alpha = 0;
//    }];
//
//    for (int i = 0; i < self.waypointMission.waypointCount; i++) {
//        DJIWaypoint* waypoint = [self.waypointMission waypointAtIndex:i];
//        waypoint.altitude = [self.waypointConfigVC.altitudeTextField.text floatValue];
//    }
//
//    self.waypointMission.maxFlightSpeed = [self.waypointConfigVC.maxFlightSpeedTextField.text floatValue];
//    self.waypointMission.autoFlightSpeed = [self.waypointConfigVC.autoFlightSpeedTextField.text floatValue];
//    self.waypointMission.headingMode = (DJIWaypointMissionHeadingMode)self.waypointConfigVC.headingSegmentedControl.selectedSegmentIndex;
//    [self.waypointMission setFinishedAction:(DJIWaypointMissionFinishedAction)self.waypointConfigVC.actionSegmentedControl.selectedSegmentIndex];
//
//    [[self missionOperator] loadMission:self.waypointMission];
//
//    WeakRef(target);
//
//    [[self missionOperator] addListenerToFinished:self withQueue:dispatch_get_main_queue() andBlock:^(NSError * _Nullable error) {
//
//        WeakReturn(target);
//
//        if (error) {
//            [target showAlertViewWithTitle:@"Mission Execution Failed" withMessage:[NSString stringWithFormat:@"%@", error.description]];
//        }
//        else {
//            [target showAlertViewWithTitle:@"Mission Execution Finished" withMessage:nil];
//        }
//    }];
//
//    [[self missionOperator] uploadMissionWithCompletion:^(NSError * _Nullable error) {
//        if (error){
//            NSString* uploadError = [NSString stringWithFormat:@"Upload Mission failed:%@", error.description];
//            ShowMessage(@"", uploadError, nil, @"OK");
//        }else {
//            ShowMessage(@"", @"Upload Mission Finished", nil, @"OK");
//        }
//    }];
//}
//
//MARK:  - DJIGSButtonViewController Delegate Methods
//
//- (void)stopBtnActionInGsButtonVC:(GSButtonViewController *)GSBtnVC
//{
//    [[self missionOperator] stopMissionWithCompletion:^(NSError * _Nullable error) {
//        if (error){
//            NSString* failedMessage = [NSString stringWithFormat:@"Stop Mission Failed: %@", error.description];
//            ShowMessage(@"", failedMessage, nil, @"OK");
//        }else
//        {
//            ShowMessage(@"", @"Stop Mission Finished", nil, @"OK");
//        }
//
//    }];
//
//}
//
//- (void)clearBtnActionInGsButtonVC:(GSButtonViewController *)GSBtnVC
//{
//    //[self.mapController cleanAllPointsWithMapView:self.mapView];
//    [self.mapController cleanAllPointsWith:self.mapView];
//}
//
//- (void)focusMapBtnActionInGsBtnVC:(GSButtonViewController *)GSBtnVC {
//    [self focusMap];
//}
//
//
//- (void)configBtnActionInGsButtonVC:(GSButtonViewController *)GSBtnVC
//{
//    WeakRef(weakSelf);
//
//    NSArray* wayPoints = self.mapController.editPoints;
//    if (wayPoints == nil || wayPoints.count < 2) { //DJIWaypointMissionMinimumWaypointCount is 2.
//        ShowMessage(@"No or not enough waypoints for mission", @"", nil, @"OK");
//        return;
//    }
//
//    [UIView animateWithDuration:0.25 animations:^{
//        WeakReturn(weakSelf);
//        weakSelf.waypointConfigVC.view.alpha = 1.0;
//    }];
//
//    if (self.waypointMission){
//        [self.waypointMission removeAllWaypoints];
//    }
//    else{
//        self.waypointMission = [[DJIMutableWaypointMission alloc] init];
//    }
//
//    for (int i = 0; i < wayPoints.count; i++) {
//        CLLocation* location = [wayPoints objectAtIndex:i];
//        if (CLLocationCoordinate2DIsValid(location.coordinate)) {
//            DJIWaypoint* waypoint = [[DJIWaypoint alloc] initWithCoordinate:location.coordinate];
//            [self.waypointMission addWaypoint:waypoint];
//        }
//    }
//
//}
//
//- (void)startBtnActionInGsButtonVC:(GSButtonViewController *)GSBtnVC
//{
//    [[self missionOperator] startMissionWithCompletion:^(NSError * _Nullable error) {
//        if (error){
//            ShowMessage(@"Start Mission Failed", error.description, nil, @"OK");
//        }else
//        {
//            ShowMessage(@"", @"Mission Started", nil, @"OK");
//        }
//    }];
//
//}
//
//- (void)switchToMode:(GSViewMode)mode inGSButtonVC:(GSButtonViewController *)GSBtnVC {
//    if (mode == GSViewModeEdit) {
//        [self focusMap];
//    }
//
//}
//
//- (void)addBtn:(UIButton *)button withActionInGsButtonVC:(GSButtonViewController *)GSBtnVC {
    //    if (self.isEditingPoints) {
    //        self.isEditingPoints = NO;
    //        [button setTitle:@"Add" forState:UIControlStateNormal];
    //    }else
    //    {
    //        self.isEditingPoints = YES;
    //        [button setTitle:@"Finished" forState:UIControlStateNormal];
    //    }
//}
//
//MARK:  - CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation* location = [locations lastObject];
//    self.userLocation = location.coordinate;
//}
//
//MARK:  MKMapViewDelegate Method
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
//        MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin_Annotation"];
//        pinView.pinTintColor = [UIColor purpleColor];
//        return pinView;
//
//    }else if ([annotation isKindOfClass:[AircraftAnnotation class]])
//    {
//        AircraftAnnotationView *annoView = [[AircraftAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Aircraft_Annotation"];
//        ((AircraftAnnotation*)annotation).annotationView = annoView;
//        return annoView;
//    }
//
//    return nil;
//}
//
//MARK:  DJIFlightControllerDelegate
//
//- (void)flightController:(DJIFlightController *)fc didUpdateState:(DJIFlightControllerState *)state
//{
//    self.droneLocation = state.aircraftLocation.coordinate;
//    self.modeLabel.text = state.flightModeString;
//    self.gpsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)state.satelliteCount];
//    self.vsLabel.text = [NSString stringWithFormat:@"%0.1f M/S",state.velocityZ];
//    self.hsLabel.text = [NSString stringWithFormat:@"%0.1f M/S",(sqrtf(state.velocityX*state.velocityX + state.velocityY*state.velocityY))];
//    self.altitudeLabel.text = [NSString stringWithFormat:@"%0.1f M",state.altitude];
//
//    //[self.mapController updateAircraftLocation:self.droneLocation withMapView:self.mapView];
//    [self.mapController updateAircraftWithLocation:self.droneLocation with:self.mapView];
//    double radianYaw = RADIAN(state.attitude.yaw);
//    //[self.mapController updateAircraftHeading:radianYaw];
//    [self.mapController updateAircraftHeadingWithHeading:radianYaw];
//}
//
//
//
//@end
