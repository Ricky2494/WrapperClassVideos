//
//  VideoPlayViewController.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 05/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayViewController: UIViewController {
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var pausePlayButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    
    
    var isPlaying: Bool = true
    var isPausePlayButtonVisible: Bool = true
    var isCurrentTimeLabelVisible: Bool = true
    var isDurationTimeLabelVisible: Bool = true
    var isTimeSliderVisible: Bool = true
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    //    var pausePlayButton: UIButton?
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.01)
        
        return view
    }()
    
    var videoUrl: URL!
    var videos: [Video] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlayerView(isPausePlayButtonVisible: isPausePlayButtonVisible, isTimeSliderVisible: isTimeSliderVisible, isCurrentTimeLabelVisible: isCurrentTimeLabelVisible, isDurationTimeLabelVisible: isDurationTimeLabelVisible)

    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        playerLayer.frame = videoPlayView.bounds

    }
    func controlsRequireCheck() {
       
        
    }
    
    
    func setUpPlayerView(isPausePlayButtonVisible: Bool, isTimeSliderVisible: Bool, isCurrentTimeLabelVisible: Bool, isDurationTimeLabelVisible: Bool)
    {
        if isPausePlayButtonVisible {
            self.pausePlayButton.isHidden = false
        }
        else {
            self.pausePlayButton.isHidden = true
        }
        if isTimeSliderVisible {
            self.timeSlider.isHidden = false
        }
        else {
            self.timeSlider.isHidden = true
        }
        if isCurrentTimeLabelVisible && isDurationTimeLabelVisible {
            currentTimeLabel.isHidden = false
            durationTimeLabel.isHidden = false
            
        }
        player = AVPlayer(url: videoUrl)
        self.playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resize
        playerLayer.frame = videoPlayView.bounds
        videoPlayView.layer.insertSublayer(playerLayer, at: 0)
        perform(#selector(handlePause))
//        perform(#selector(timeSliderChange(_:)))
        player?.play()
        addTimeObserver()
    }
    
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton?.setImage(UIImage(systemName: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton?.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
        }

    
    @IBAction func rewindButtonClick(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player!.currentTime())
        var newTime = currentTime - 3.0
        
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player!.seek(to: time)
        
    }
    
    @IBAction func fastForwardButtonClick(_ sender: Any) {
        guard let duration = player!.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds(player!.currentTime())
        let newTime = currentTime + 3.0
        
        if newTime < (CMTimeGetSeconds(duration)) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            player!.seek(to: time)
        }
        
    }
    @objc func timeSliderChange(_ sender: UISlider) {
        if isTimeSliderVisible {
        player?.seek(to: CMTimeMake(value: Int64(sender.value), timescale: 1))
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.pausePlayButton.alpha = 1
        }
        player?.play()
        pausePlayButton?.setImage(UIImage(systemName: "pause"), for: .normal)
    }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player?.currentItem?.duration.seconds, duration > 0.0 {
            self.durationTimeLabel.text = getTimeString(from: (player?.currentItem!.duration)!)
            
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
    func addTimeObserver() {
        player?.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)

        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player?.currentItem else {return}
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0.0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
            
            if self?.timeSlider.value == self?.timeSlider.maximumValue{
                self?.pausePlayButton?.setImage(UIImage(systemName: "play"), for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.pausePlayButton.alpha = 1
                    UIView.animate(withDuration: 1.0) {
                        self?.pausePlayButton.alpha = 0
                    }
                }
            }
        })
    }
}

