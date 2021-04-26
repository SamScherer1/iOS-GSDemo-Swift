//
//  GSButtonViewController.swift
//  GSDemo
//
//  Created by Samuel Scherer on 4/26/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import UIKit

@objc enum GSViewMode : Int {
    case view
    case edit
}

@objc protocol GSButtonViewControllerDelegate : class{ //TODO: remove @objc tags
    //- (void)stopBtnActionInGSButtonVC:(DJIGSButtonViewController *)GSBtnVC;
    //- (void)clearBtnActionInGSButtonVC:(DJIGSButtonViewController *)GSBtnVC;
    //- (void)focusMapBtnActionInGSButtonVC:(DJIGSButtonViewController *)GSBtnVC;
    //- (void)startBtnActionInGSButtonVC:(DJIGSButtonViewController *)GSBtnVC;
    //- (void)addBtn:(UIButton *)button withActionInGSButtonVC:(DJIGSButtonViewController *)GSBtnVC;
    //- (void)configBtnActionInGSButtonVC:(DJIGSButtonViewController *)GSBtnVC;
    //- (void)switchToMode:(DJIGSViewMode)mode inGSButtonVC:(DJIGSButtonViewController *)GSBtnVC;
    @objc func stopBtnActionIn(gsBtnVC:GSButtonViewController)
    @objc func clearBtnActionIn(gsBtnVC:GSButtonViewController)
    @objc func focusMapBtnActionIn(gsBtnVC:GSButtonViewController)
    @objc func startBtnActionIn(gsBtnVC:GSButtonViewController)
    @objc func add(button:UIButton, actionIn gsBtnVC:GSButtonViewController)
    @objc func configBtnActionIn(gsBtnVC:GSButtonViewController)
    @objc func switchTo(mode:GSViewMode, inGSBtnVC:GSButtonViewController)

}

@objc class GSButtonViewController : UIViewController {
    //@property (weak, nonatomic) IBOutlet UIButton *backBtn;
    @IBOutlet weak var backBtn: UIButton!
    //@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
    @IBOutlet weak var stopBtn: UIButton!
    //@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
    @IBOutlet weak var clearBtn: UIButton!
    //@property (weak, nonatomic) IBOutlet UIButton *focusMapBtn;
    @IBOutlet weak var focusMapBtn: UIButton!
    //@property (weak, nonatomic) IBOutlet UIButton *editBtn;
    @IBOutlet weak var editBtn: UIButton!
    //@property (weak, nonatomic) IBOutlet UIButton *startBtn;
    @IBOutlet weak var startBtn: UIButton!
    //@property (weak, nonatomic) IBOutlet UIButton *addBtn;
    @IBOutlet weak var addBtn: UIButton!
    //@property (weak, nonatomic) IBOutlet UIButton *configBtn;
    @IBOutlet weak var configBtn: UIButton!
    //@property (assign, nonatomic) DJIGSViewMode mode;
    var mode = GSViewMode.edit
    //@property (weak, nonatomic) id <DJIGSButtonViewControllerDelegate> delegate;
    @objc var delegate : GSButtonViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: need to set initial mode after super call?
    }
    
    
    //#pragma mark - Property Method
    //
    //- (void)setMode:(DJIGSViewMode)mode
    //{
    //
    //    _mode = mode;
    //    [_editBtn setHidden:(mode == DJIGSViewMode_EditMode)];
    //    [_focusMapBtn setHidden:(mode == DJIGSViewMode_EditMode)];
    //    [_backBtn setHidden:(mode == DJIGSViewMode_ViewMode)];
    //    [_clearBtn setHidden:(mode == DJIGSViewMode_ViewMode)];
    //    [_startBtn setHidden:(mode == DJIGSViewMode_ViewMode)];
    //    [_stopBtn setHidden:(mode == DJIGSViewMode_ViewMode)];
    //    [_addBtn setHidden:(mode == DJIGSViewMode_ViewMode)];
    //    [_configBtn setHidden:(mode == DJIGSViewMode_ViewMode)];
    //}
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
