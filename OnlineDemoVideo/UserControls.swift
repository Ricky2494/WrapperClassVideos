//
//  UserControls.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 17/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit

class UserControls: UIView {

    @IBOutlet weak var userControlsView: UIView!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var fullscreenButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
      
    var delegateUser: DefineUserControlActions!
    
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        delegateUser.volumeSliderHandle(sender: sender)
    
    }
    
    @IBAction func volumeButtonClicked(_ sender: Any) {
        delegateUser.volumeButtonHandle()
    }
    
    
    
}
protocol DefineUserControlActions {
    func volumeButtonHandle()
    func volumeSliderHandle(sender: UISlider)
}
