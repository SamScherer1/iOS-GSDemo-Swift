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
    fileprivate let bridgeIPString = "192.168.128.169"
    
    //
    //@property (nonatomic, assign) BOOL isEditingPoints;
    var isEditingPoints = false
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
        self.userLocation = kCLLocationCoordinate2DInvalid
        self.droneLocation = kCLLocationCoordinate2DInvalid
        self.mapController = MapController()
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(addWaypints(tapGesture:)))
        self.mapView.addGestureRecognizer(self.tapGesture!)//TODO: reconsider force unwrap
        
    }
    
    func initUI() {
        self.modeLabel.text = "N/A"
        self.gpsLabel.text = "0"
        self.vsLabel.text = "0.0 M/S"
        self.hsLabel.text = "0.0 M/S"
        self.altitudeLabel.text = "0 M"
    //
    //    self.gsButtonVC = [[GSButtonViewController alloc] initWithNibName:@"GSButtonViewController" bundle:[NSBundle mainBundle]];
    //    [self.gsButtonVC.view setFrame:CGRectMake(0, self.topBarView.frame.origin.y + self.topBarView.frame.size.height, self.gsButtonVC.view.frame.size.width, self.gsButtonVC.view.frame.size.height)];
    //    self.gsButtonVC.delegate = self;
    //    [self.view addSubview:self.gsButtonVC.view];
        
        //TODO: make a designated init for GSButtonViewController so as to not break encapsulation...
        self.gsButtonVC = GSButtonViewController(nibName:"GSButtonViewController", bundle:Bundle.main)
        if self.gsButtonVC != nil {//TODO: reconsider method of unwrapping property
            self.gsButtonVC!.view.frame = CGRect(x: 0.0,
                                                 y: self.topBarView.frame.origin.y + self.topBarView.frame.size.height,
                                                 width: self.gsButtonVC!.view.frame.size.width,
                                                 height: self.gsButtonVC!.view.frame.size.height)
            self.gsButtonVC!.delegate = self
            self.view.addSubview(self.gsButtonVC!.view)
        }

        self.waypointConfigVC = WaypointConfigViewController()

    //    self.waypointConfigVC.view.alpha = 0;
        self.waypointConfigVC?.view.alpha = 0
    //    self.waypointConfigVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.waypointConfigVC?.view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
    //
    //    [self.waypointConfigVC.view setCenter:self.view.center];
        self.waypointConfigVC?.view.center = self.view.center
    //
    //    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) //Check if it's using iPad and center the config view
    //    {
    //        self.waypointConfigVC.view.center = self.view.center;
    //    }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.waypointConfigVC?.view.center = self.view.center
        }
        
    //
    //    self.waypointConfigVC.delegate = self;
        self.waypointConfigVC?.delegate = self
    //    [self.view addSubview:self.waypointConfigVC.view];
        if self.waypointConfigVC != nil {//TODO: reconsider method of unwrapping...
            self.view.addSubview(self.waypointConfigVC!.view)
        }
    }

    func registerApp() {
        DJISDKManager.registerApp(with: self)
    }
    
    //MARK: DJISDKManagerDelegate Methods
    func appRegisteredWithError(_ error: Error?) {
        if let error = error {
            //        NSString *registerResult = [NSString stringWithFormat:@"Registration Error:%@", error.description];
            //        ShowMessage(@"Registration Result", registerResult, nil, @"OK");
            let registerResult = String(format: "Registration Error:%@", error.localizedDescription)
            DemoUtility.show(result: registerResult)
        } else {
            if useBridgeMode {
                DJISDKManager.enableBridgeMode(withBridgeAppIP: bridgeIPString)
            } else {
                DJISDKManager.startConnectionToProduct()
            }
        }
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
    
    func focusMap() {
        guard let droneLocation = self.droneLocation else {
            return
        }
        
        if CLLocationCoordinate2DIsValid(droneLocation) {
            let center = CLLocationCoordinate2D(latitude: droneLocation.latitude, longitude: droneLocation.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            let region = MKCoordinateRegion(center: center, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    //
    //MARK:  CLLocation Methods
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if self.locationManager == nil {
                self.locationManager = CLLocationManager()
                //            self.locationManager.delegate = self;
                self.locationManager?.delegate = self
                //            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                //            self.locationManager.distanceFilter = 0.1;
                self.locationManager?.distanceFilter = 0.1
                //TODO: need to check if you can requestAlwaysAuthorization? seems it should always have that method...
    //            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    //                [self.locationManager requestAlwaysAuthorization];
    //            }
                    self.locationManager?.requestAlwaysAuthorization()
            }
        } else {
            DemoUtility.show(result: "Location Service is not available")
        }

    }

    //MARK:  UITapGestureRecognizer Methods
    @objc func addWaypints(tapGesture:UITapGestureRecognizer) {
        let point = tapGesture.location(in: self.mapView)
        if tapGesture.state == UIGestureRecognizer.State.ended {
            if self.isEditingPoints {
                self.mapController?.add(point: point, for: self.mapView)
            }
        }
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
    
    func showAlertViewWith(title:String, message:String?) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: UIAlertController.Style.alert)
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
        
        UIView.animate(withDuration: 0.25) { [weak self] () in
            self?.waypointConfigVC?.view.alpha = 0
        }
        //
        //    for (int i = 0; i < self.waypointMission.waypointCount; i++) {
        //        DJIWaypoint* waypoint = [self.waypointMission waypointAtIndex:i];
        //        waypoint.altitude = [self.waypointConfigVC.altitudeTextField.text floatValue];
        //    }
        if let waypointMission = self.waypointMission, let waypointConfigVC = self.waypointConfigVC {
            for waypoint in waypointMission.allWaypoints() {
                waypoint.altitude = (waypointConfigVC.altitudeTextField.text! as NSString).floatValue//TODO: test empty string?
            }
        }

        if let waypointConfigVC = self.waypointConfigVC {
            self.waypointMission?.maxFlightSpeed = ((self.waypointConfigVC?.maxFlightSpeedTextField.text ?? "0.0") as NSString).floatValue
            self.waypointMission?.autoFlightSpeed = ((self.waypointConfigVC?.autoFlightSpeedTextField.text ?? "0.0") as NSString).floatValue
            
            let selectedHeadingIndex = waypointConfigVC.headingSegmentedControl.selectedSegmentIndex
            self.waypointMission?.headingMode = DJIWaypointMissionHeadingMode(rawValue:UInt(selectedHeadingIndex)) ?? DJIWaypointMissionHeadingMode.auto
            
            let selectedActionIndex = waypointConfigVC.actionSegmentedControl.selectedSegmentIndex
            self.waypointMission?.finishedAction = DJIWaypointMissionFinishedAction(rawValue: UInt8(selectedActionIndex)) ?? DJIWaypointMissionFinishedAction.noAction
        }
        
        if let waypointMission = self.waypointMission {
            self.missionOperator()?.load(waypointMission)
            
            self.missionOperator()?.addListener(toFinished: self, with: DispatchQueue.main, andBlock: { [weak self] (error: Error?) in
                if let error = error {
                    self?.showAlertViewWith(title: "Mission Execution Failed", message: String(format: "%@", error.localizedDescription))
                } else {
                    self?.showAlertViewWith(title: "Mission Execution Finished", message: nil)
                }
            })
        }
        
        self.missionOperator()?.uploadMission(completion: { (error:Error?) in
            if let error = error {
                let uploadErrorString = String(format: "Upload Mission failed:%@", error.localizedDescription)
                DemoUtility.show(result: uploadErrorString)
            } else {
                DemoUtility.show(result: "Upload Mission Finished")
            }
        })
    }
    
    //MARK: - DJIGSButtonViewController Delegate Methods
    func stopBtnActionIn(gsBtnVC: GSButtonViewController) {
        self.missionOperator()?.stopMission(completion: { (error:Error?) in
            if let error = error {
  //            NSString* failedMessage = [NSString stringWithFormat:@"Stop Mission Failed: %@", error.description];
  //            ShowMessage(@"", failedMessage, nil, @"OK");
                let failedMessage = String(format: "Stop Mission Failed: %@", error.localizedDescription)
                DemoUtility.show(result: failedMessage)
            } else {
                DemoUtility.show(result: "Stop Mission Finished")
            }
        })
    }
    
    func clearBtnActionIn(gsBtnVC: GSButtonViewController) {
        self.mapController?.cleanAllPoints(with: self.mapView)
    }
    
    func focusMapBtnActionIn(gsBtnVC: GSButtonViewController) {
        self.focusMap()
    }
    
    func startBtnActionIn(gsBtnVC: GSButtonViewController) {
        //    [[self missionOperator] startMissionWithCompletion:^(NSError * _Nullable error) {
        //        if (error){
        //        }else
        //        {
        //            ShowMessage(@"", @"Mission Started", nil, @"OK");
        //        }
        //    }];
        self.missionOperator()?.startMission(completion: { (error:Error?) in
            if let error = error {
                //            ShowMessage(@"Start Mission Failed", error.description, nil, @"OK");
                DemoUtility.show(result: String(format:"Start Mission Failed: %@", error.localizedDescription))
            } else {
                DemoUtility.show(result: "Mission Started")
            }
        })
    }
    
    func add(button: UIButton, actionIn gsBtnVC: GSButtonViewController) {
        if self.isEditingPoints {
            self.isEditingPoints = false
            button.setTitle("Add", for: UIControl.State.normal)
        } else {
            self.isEditingPoints = true
            button.setTitle("Finished", for: UIControl.State.normal)
        }
    }
    
    func configBtnActionIn(gsBtnVC: GSButtonViewController) {
        //    WeakRef(weakSelf);
        //
        //    NSArray* wayPoints = self.mapController.editPoints;
        //    if (wayPoints == nil || wayPoints.count < 2) { //DJIWaypointMissionMinimumWaypointCount is 2.
        //        ShowMessage(@"No or not enough waypoints for mission", @"", nil, @"OK");
        //        return;
        //    }
        
        
        guard let wayPoints = self.mapController?.editPoints else {
            DemoUtility.show(result: "No waypoints")
            return
        }
        if wayPoints.count < 2 {
            DemoUtility.show(result: "Not enough waypoints for mission")
            return
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] () in
            self?.waypointConfigVC?.view.alpha = 1.0
        }

        self.waypointMission?.removeAllWaypoints()
        
        if self.waypointMission == nil {
            self.waypointMission = DJIMutableWaypointMission()
        }
        
        for location in wayPoints {
            if CLLocationCoordinate2DIsValid(location.coordinate) {
                self.waypointMission?.add(DJIWaypoint(coordinate: location.coordinate))
            }
        }
        
    }
    
    func switchTo(mode: GSViewMode, inGSBtnVC: GSButtonViewController) {
        if mode == GSViewMode.edit {
            self.focusMap()
        }
    }
    
    //
    //MARK:  - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last?.coordinate
    }
    
    //MARK:  MKMapViewDelegate Method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKPointAnnotation.self) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin_Annotation")
            pinView.pinTintColor = UIColor.purple
            return pinView
        } else if annotation.isKind(of: AircraftAnnotation.self) {
            let annotationView = AircraftAnnotationView(annotation: annotation, reuseIdentifier: "Aircraft_Annotation")
            (annotation as? AircraftAnnotation)?.annotationView = annotationView
            return annotationView
        }
        return nil
    }

    //MARK:  DJIFlightControllerDelegate
    func flightController(_ fc: DJIFlightController, didUpdate state: DJIFlightControllerState) {
        self.droneLocation = state.aircraftLocation?.coordinate
        self.modeLabel.text = state.flightModeString
        self.gpsLabel.text = String(format: "@lu", UInt(state.satelliteCount))
        self.vsLabel.text = String(format: "@0.1f M/S", state.velocityZ)
        self.hsLabel.text = String(format: "@0.1f M/S", sqrt(pow(state.velocityX,2) + pow(state.velocityY,2)))
        self.altitudeLabel.text = String(format: "%0.1f M", state.altitude)
        
        //
        //    //[self.mapController updateAircraftLocation:self.droneLocation withMapView:self.mapView];
        //    double radianYaw = RADIAN(state.attitude.yaw);
        //    //[self.mapController updateAircraftHeading:radianYaw];
        //    [self.mapController updateAircraftHeadingWithHeading:radianYaw];
        
        if let droneLocation = droneLocation {
            self.mapController?.updateAircraft(location: droneLocation, with: self.mapView)
        }
        let radianYaw = state.attitude.yaw.degreesToRadians
        self.mapController?.updateAircraftHeading(heading: Float(radianYaw))
    }

    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        print("unused: didUpdateDatabaseDownloadProgress")
    }
    
}
