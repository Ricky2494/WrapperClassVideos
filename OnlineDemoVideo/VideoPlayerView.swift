//
//  VideoPlayerView.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 03/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer?.player
        }
        set{
            playerLayer?.player = newValue
        }
    }
    var playerLayer: AVPlayerLayer? {
        return layer as! AVPlayerLayer
    }
    
    //override the layer class
    override class var layerClass: AnyClass {
        return AVPlayer.self
    }
}
