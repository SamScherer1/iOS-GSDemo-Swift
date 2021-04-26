//
//  GSButtonViewController.swift
//  GSDemo
//
//  Created by Samuel Scherer on 4/26/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import UIKit

enum GSViewMode {
    case view
    case edit
}

protocol GSButtonViewControllerDelegate : class{
    func stopBtnActionIn(gsBtnVC:GSButtonViewController)
    func clearBtnActionIn(gsBtnVC:GSButtonViewController)
    func focusMapBtnActionIn(gsBtnVC:GSButtonViewController)
    func startBtnActionIn(gsBtnVC:GSButtonViewController)
    func add(button:UIButton, actionIn gsBtnVC:GSButtonViewController)
    func configBtnActionIn(gsBtnVC:GSButtonViewController)
    func switchTo(mode:GSViewMode, inGSBtnVC:GSButtonViewController)
}

class GSButtonViewController : UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var focusMapBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var configBtn: UIButton!
    var mode = GSViewMode.edit
    var delegate : GSButtonViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: need to set initial mode after super call?
    }
    
    //MARK - Property Method
    func setMode(mode:GSViewMode) {
        self.mode = mode
        self.editBtn.isHidden = (mode == GSViewMode.edit)
        self.focusMapBtn.isHidden = (mode == GSViewMode.edit)
        self.backBtn.isHidden = (mode == GSViewMode.view)
        self.clearBtn.isHidden = (mode == GSViewMode.view)
        self.startBtn.isHidden = (mode == GSViewMode.view)
        self.stopBtn.isHidden = (mode == GSViewMode.view)
        self.addBtn.isHidden = (mode == GSViewMode.view)
        self.configBtn.isHidden = (mode == GSViewMode.view)
    }
        
    //MARK - IBAction Methods
    @IBAction func backBtnAction(_ sender: Any) {
        self.setMode(mode: GSViewMode.view)
        self.delegate?.switchTo(mode: self.mode, inGSBtnVC: self)
    }
    
    @IBAction func stopBtnAction(_ sender: Any) {
        //    if ([_delegate respondsToSelector:@selector(stopBtnActionInGSButtonVC:)]) {
        //        [_delegate stopBtnActionInGSButtonVC:self];
        //    }
        self.delegate?.stopBtnActionIn(gsBtnVC: self)
    }
    
    @IBAction func clearBtnAction(_ sender: Any) {
        //    if ([_delegate respondsToSelector:@selector(clearBtnActionInGSButtonVC:)]) {
        //        [_delegate clearBtnActionInGSButtonVC:self];
        //    }
        self.delegate?.clearBtnActionIn(gsBtnVC: self)
    }
    
    @IBAction func focusMapBtnAction(_ sender: Any) {
        //    if ([_delegate respondsToSelector:@selector(focusMapBtnActionInGSButtonVC:)]) {
        //        [_delegate focusMapBtnActionInGSButtonVC:self];
        //    }
        self.delegate?.focusMapBtnActionIn(gsBtnVC: self)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        //    [self setMode:DJIGSViewMode_EditMode];
        //    if ([_delegate respondsToSelector:@selector(switchToMode:inGSButtonVC:)]) {
        //        [_delegate switchToMode:self.mode inGSButtonVC:self];
        //    }
        self.setMode(mode: GSViewMode.edit)
        self.delegate?.switchTo(mode: self.mode, inGSBtnVC: self)
    }
    
    @IBAction func startBtnAction(_ sender: Any) {
        //    if ([_delegate respondsToSelector:@selector(startBtnActionInGSButtonVC:)]) {
        //        [_delegate startBtnActionInGSButtonVC:self];
        //    }
        self.delegate?.startBtnActionIn(gsBtnVC: self)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        //    if ([_delegate respondsToSelector:@selector(addBtn:withActionInGSButtonVC:)]) {
        //        [_delegate addBtn:self.addBtn withActionInGSButtonVC:self];
        //    }
        self.delegate?.add(button: self.addBtn, actionIn: self)
    }
    

    @IBAction func configBtnAction(_ sender: Any) {
        //    if ([_delegate respondsToSelector:@selector(configBtnActionInGSButtonVC:)]) {
        //        [_delegate configBtnActionInGSButtonVC:self];
        //    }
        self.delegate?.configBtnActionIn(gsBtnVC: self)
    }
    
    
}
