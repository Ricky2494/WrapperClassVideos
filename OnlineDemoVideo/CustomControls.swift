//
//  CustomControls.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 16/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit

@IBDesignable
class CustomControls: UIView {

    @IBOutlet weak var customControlsView: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var durationTimeLabel: UILabel!
    var delegate: DefineCustomControlActions!
    
    
    @IBAction func rewindButtonClick(_ sender: Any) {
        delegate.rewindButtonHandle()
        
    }
    
    @IBAction func timeSliderChange(_ sender: UISlider) {
        delegate.timeSliderHandle(sender: sender)
        
    }
    
    @IBAction func forwardButtonClick(_ sender: Any) {
        
        delegate.forwardButtonHandle()
    }
}

protocol DefineCustomControlActions {
    func timeSliderHandle(sender: UISlider)
    func rewindButtonHandle()
    func forwardButtonHandle()
    
}

