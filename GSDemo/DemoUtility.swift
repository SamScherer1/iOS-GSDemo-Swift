//
//  DemoUtility.swift
//  PlaybackDemo
//
//  Created by Samuel Scherer on 4/13/21.
//  Copyright © 2021 DJI. All rights reserved.
//
import Foundation
import DJISDK

class DemoUtility: NSObject {
    
    //TODO: is this more complicated show result function necessary?
//    inline void ShowMessage(NSString *title, NSString *message, id target, NSString *cancleBtnTitle)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:target cancelButtonTitle:cancleBtnTitle otherButtonTitles:nil];
//            [alert show];
//        });
//    }
    
    public class func show(result:NSString) {//TODO: convert to string once no ObjC class uses this. Also should I make this a global function like the objc original?
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: nil, message: result as String, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertViewController.addAction(okAction)
            let navController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            navController.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    public class func fetchProduct () -> DJIBaseProduct? {
        return DJISDKManager.product()
    }
    
    public class func fetchAircraft () -> DJIAircraft? {
        return DJISDKManager.product() as? DJIAircraft
    }
    
    public class func fetchCamera () -> DJICamera? {
        if let aircraft = DJISDKManager.product() as? DJIAircraft {
            return aircraft.camera
        }
        return nil
    }
    
    public class func fetchFlightController() -> DJIFlightController? {
        if let aircraft = DJISDKManager.product() as? DJIAircraft {
            return aircraft.flightController
        }
        return nil
    }
}
