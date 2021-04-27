//
//  DemoUtility.swift
//  PlaybackDemo
//
//  Created by Samuel Scherer on 4/13/21.
//  Copyright © 2021 DJI. All rights reserved.
//
import Foundation
import DJISDK

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
}

class DemoUtility: NSObject {
    
    //TODO: is this more complicated show result function necessary?
//    inline void ShowMessage(NSString *title, NSString *message, id target, NSString *cancleBtnTitle)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:target cancelButtonTitle:cancleBtnTitle otherButtonTitles:nil];
//            [alert show];
//        });
//    }
    
    public class func show(result:String) {//TODO: should I make this a global function like the objc original?
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: nil, message: result as String, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertViewController.addAction(okAction)
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            rootViewController?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    public class func fetchFlightController() -> DJIFlightController? {
        if let aircraft = DJISDKManager.product() as? DJIAircraft {
            return aircraft.flightController
        }
        return nil
    }
}
