//
//  VideoLooperView.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 03/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit
import AVFoundation

class VideoLooperView: UIView {

    let clips: [VideoClip]
//    let videoPlayerView = VideoPlayerView()
    @objc private let player = AVQueuePlayer()
    private var token: NSKeyValueObservation?
    init(clips: [VideoClip]) {
        self.clips = clips
        
        super.init(frame: .zero)
        
        initializePlayer()
      }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    //  Setting up a player
    private func initializePlayer() {
//      videoPlayerView.player = player
      
    addAllVideosToPlayer()

      player.volume = 0.0
      player.play()
      
      token = player.observe(\.currentItem) { [weak self] player, _ in
        if player.items().count == 1 {
          self?.addAllVideosToPlayer()
        }
      }
    }
    //   Create player items from video URLs and insert them into the player's list
    private func addAllVideosToPlayer() {
      for video in clips {
        let asset = AVURLAsset(url: video.url)
        let item = AVPlayerItem(asset: asset)
        player.insert(item, after: player.items().last)
      }
    }
    
    // Add methods to pause and play when the view leaves the screen
    func pause() {
      player.pause()
    }

    func play() {
      player.play()
    }
}
