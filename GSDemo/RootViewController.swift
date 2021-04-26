//
//  RootViewController.swift
//  GSDemo
//
//  Created by Samuel Scherer on 4/26/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import DJISDK


class RootViewController : UIViewController, GSButtonViewControllerDelegate, WaypointConfigViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, DJISDKManagerDelegate, DJIFlightControllerDelegate {
    
    fileprivate let useBridgeMode = true
    
    //
    //@property (nonatomic, assign) BOOL isEditingPoints;
    var isEditingPoints : Bool?
    //@property (nonatomic, strong) GSButtonViewController *gsButtonVC;
    var gsButtonVC : GSButtonViewController?
    //@property (nonatomic, strong) WaypointConfigViewController *waypointConfigVC;
    var waypointConfigVC : WaypointConfigViewController?
    //@property (nonatomic, strong) MapController *mapController;
    var mapController : MapController?
    //
    //@property(nonatomic, strong) CLLocationManager* locationManager;
    var locationManager : CLLocationManager?
    //@property(nonatomic, assign) CLLocationCoordinate2D userLocation;
    var userLocation : CLLocationCoordinate2D?
    //@property(nonatomic, assign) CLLocationCoordinate2D droneLocation;
    var droneLocation : CLLocationCoordinate2D?
    //@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
    var tapGesture : UITapGestureRecognizer?
    //
    //@property (weak, nonatomic) IBOutlet MKMapView *mapView;
    @IBOutlet weak var mapView: MKMapView!
    //@property (weak, nonatomic) IBOutlet UIView *topBarView;
    @IBOutlet weak var topBarView: UIView!
    //@property(nonatomic, strong) IBOutlet UILabel* modeLabel;
    @IBOutlet weak var modeLabel: UILabel!
    //@property(nonatomic, strong) IBOutlet UILabel* gpsLabel;
    @IBOutlet weak var gpsLabel: UILabel!
    //@property(nonatomic, strong) IBOutlet UILabel* hsLabel;
    @IBOutlet weak var hsLabel: UILabel!
    //@property(nonatomic, strong) IBOutlet UILabel* vsLabel;
    @IBOutlet weak var vsLabel: UILabel!
    //@property(nonatomic, strong) IBOutlet UILabel* altitudeLabel;
    @IBOutlet weak var altitudeLabel: UILabel!
    //@property(nonatomic, strong) DJIMutableWaypointMission* waypointMission;
    var waypointMission : DJIMutableWaypointMission?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startUpdateLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager?.stopUpdatingLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerApp()
        self.initUI()
        self.initData()
    }

    func prefersStatusBarHidden() -> Bool {
        return false
    }

    //MARK:  Init Methods
    func initData() {
    //    self.userLocation = kCLLocationCoordinate2DInvalid;
    //    self.droneLocation = kCLLocationCoordinate2DInvalid;
    //
    //    self.mapController = [[MapController alloc] init];
    //    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addWaypoints:)];
    //    [self.mapView addGestureRecognizer:self.tapGesture];
    }
    
    func initUI() {
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
    }

    func registerApp() {
        DJISDKManager.registerApp(with: self)
    }
    
    //MARK: DJISDKManagerDelegate Methods
    func appRegisteredWithError(_ error: Error?) {
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
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        if let _ = product, let flightController = DemoUtility.fetchFlightController() {
            flightController.delegate = self
        } else {
            //ShowMessage(@"Product disconnected", nil, nil, @"OK");
            DemoUtility.show(result: "Flight controller disconnected")
        }
        
        //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
        DJISDKManager.userAccountManager().logIntoDJIUserAccount(withAuthorizationRequired: false) { (state:DJIUserAccountState, error: Error?) in
            if let error = error {
                NSLog("Login failed: %@", error.localizedDescription)
            }
        }
    }
    
    //MARK: Action Methods
    func missionOperator() -> DJIWaypointMissionOperator? {
        return DJISDKManager.missionControl()?.waypointMissionOperator()
    }
    
    //
    func focusMap() {
        //    if (CLLocationCoordinate2DIsValid(self.droneLocation)) {
        //        MKCoordinateRegion region = {0};
        //        region.center = self.droneLocation;
        //        region.span.latitudeDelta = 0.001;
        //        region.span.longitudeDelta = 0.001;
        //
        //        [self.mapView setRegion:region animated:YES];
        //    }
    }
    //
    //MARK:  CLLocation Methods
    func startUpdateLocation() {
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
    }
    //
    //MARK:  UITapGestureRecognizer Methods
    //- (void)addWaypoints:(UITapGestureRecognizer *)tapGesture
    func addWaypints(tapGesture:UITapGestureRecognizer) {
        //    CGPoint point = [tapGesture locationInView:self.mapView];
        //
        //    if(tapGesture.state == UIGestureRecognizerStateEnded){
        //        if (self.isEditingPoints) {
        //            [self.mapController addWithPoint:point for:self.mapView];
        //        }
        //    }
    }
    
    //MARK - DJIWaypointConfigViewControllerDelegate Methods
    func cancelBtnActionInDJIWaypointConfigViewController(viewController: WaypointConfigViewController) {
        UIView.animate(withDuration: 0.25) { [weak self] () in
            self?.waypointConfigVC?.view.alpha = 0
        }
    }

    //
    //- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message
    //{
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    //    [alert addAction:okAction];
    //    [self presentViewController:alert animated:YES completion:nil];
    //}
    
    func showAlertViewWith(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func finishBtnActionInDJIWaypointConfigViewController(viewController: WaypointConfigViewController) {
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
    }
    
    //TODO: mark not showing? implement everywhere...
    //MARK - DJIGSButtonViewController Delegate Methods
    func stopBtnActionIn(gsBtnVC: GSButtonViewController) {
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
    }
    
    func clearBtnActionIn(gsBtnVC: GSButtonViewController) {
        //    //[self.mapController cleanAllPointsWithMapView:self.mapView];
        //    [self.mapController cleanAllPointsWith:self.mapView];
    }
    
    func focusMapBtnActionIn(gsBtnVC: GSButtonViewController) {
        self.focusMap()
    }
    
    func startBtnActionIn(gsBtnVC: GSButtonViewController) {
        //    [[self missionOperator] startMissionWithCompletion:^(NSError * _Nullable error) {
        //        if (error){
        //            ShowMessage(@"Start Mission Failed", error.description, nil, @"OK");
        //        }else
        //        {
        //            ShowMessage(@"", @"Mission Started", nil, @"OK");
        //        }
        //    }];
    }
    
    func add(button: UIButton, actionIn gsBtnVC: GSButtonViewController) {
        //    if (self.isEditingPoints) {
        //        self.isEditingPoints = NO;
        //        [button setTitle:@"Add" forState:UIControlStateNormal];
        //    }else
        //    {
        //        self.isEditingPoints = YES;
        //        [button setTitle:@"Finished" forState:UIControlStateNormal];
        //    }
    }
    
    func configBtnActionIn(gsBtnVC: GSButtonViewController) {
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
    }
    
    func switchTo(mode: GSViewMode, inGSBtnVC: GSButtonViewController) {
        //    if (mode == GSViewModeEdit) {
        //        [self focusMap];
        //    }
    }
    
    //
    //MARK:  - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //    CLLocation* location = [locations lastObject];
        //    self.userLocation = location.coordinate;
    }
    
    //MARK:  MKMapViewDelegate Method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKPointAnnotation.self) {
            //        MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin_Annotation"];
            //        pinView.pinTintColor = [UIColor purpleColor];
            //        return pinView;
        } else if annotation.isKind(of: AircraftAnnotation.self) {
            //        AircraftAnnotationView *annoView = [[AircraftAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Aircraft_Annotation"];
            //        ((AircraftAnnotation*)annotation).annotationView = annoView;
            //        return annoView;
        }
        return nil
    }

    //MARK:  DJIFlightControllerDelegate
    func flightController(_ fc: DJIFlightController, didUpdate state: DJIFlightControllerState) {
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
    }

    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        print("unused: didUpdateDatabaseDownloadProgress")
    }
    
}
