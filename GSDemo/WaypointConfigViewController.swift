//
//  WaypointConfigViewController.swift
//  GSDemo
//
//  Created by Samuel Scherer on 4/25/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import UIKit

@objc protocol WaypointConfigViewControllerDelegate : class {//TODO: remove @objc tag
    //TODO: static funcs only? why? Also, can use properties with {get} only?
    @objc func cancelBtnActionInDJIWaypointConfigViewController(viewController : WaypointConfigViewController)
    @objc func finishBtnActionInDJIWaypointConfigViewController(viewController : WaypointConfigViewController)
}

class WaypointConfigViewController : UIViewController {
    @IBOutlet weak var altitudeTextField: UITextField!
    @IBOutlet weak var autoFlightSpeedTextField: UITextField!
    @IBOutlet weak var maxFlightSpeedTextField: UITextField!
    @IBOutlet weak var actionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var headingSegmentedControl: UISegmentedControl!

    @objc weak var delegate : WaypointConfigViewControllerDelegate?
    
    init() {
        super.init(nibName: "WaypointConfigViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    func initUI() {
        self.altitudeTextField.text = "20" //Set the altitude to 20
        self.autoFlightSpeedTextField.text = "8" //Set the autoFlightSpeed to 8
        self.maxFlightSpeedTextField.text = "10" //Set the maxFlightSpeed to 10
        self.actionSegmentedControl.selectedSegmentIndex = 1 //Set the finishAction to DJIWaypointMissionFinishedGoHome
        self.headingSegmentedControl.selectedSegmentIndex = 0 //Set the headingMode to DJIWaypointMissionHeadingAuto
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        //TODO: getting an unrecognized selector calling from swift to Objc, convert DJIRootViewController next...
        //self.delegate?.cancelBtnActionInDJIWaypointConfigViewController(viewController:self)
    }

    @IBAction func finishBtnAction(_ sender: Any) {
        //TODO: getting an unrecognized selector calling from swift to Objc, convert DJIRootViewController next...
        //self.delegate?.finishBtnActionInDJIWaypointConfigViewController(viewController: self)
    }
}