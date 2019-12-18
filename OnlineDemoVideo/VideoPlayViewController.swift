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
    
    var userControlsObject: UserControls?
    var customControls:CustomControls?
    var currentTimeGlobal = Int()
    var isPlaying: Bool = true
    var isMuted: Bool = false
    var isPausePlayButtonVisible: Bool = true
    var isCurrentTimeLabelVisible: Bool = true
    var isDurationTimeLabelVisible: Bool = true
    var isTimeSliderVisible: Bool = true
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    var videoUrl: URL!
    var videos: [Video] = []
    var timer: Timer?
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.01)
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlayerView(isPausePlayButtonVisible: isPausePlayButtonVisible, isTimeSliderVisible: isTimeSliderVisible, isCurrentTimeLabelVisible: isCurrentTimeLabelVisible, isDurationTimeLabelVisible: isDurationTimeLabelVisible)
//        customView.frame = customControlView.bounds
//        customControlView.addSubview(customView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        playerLayer.frame = videoPlayView.bounds
        
    }
    
    @objc func handleTapAction() {
        timer?.invalidate()
        timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.hideBothControls), userInfo: nil, repeats: false)
        showControls(hide: !pausePlayButton.isHidden)
    }
    func showControls(hide: Bool) {
        pausePlayButton.isHidden = hide
        customControls?.isHidden = hide
    }
    @objc func hideBothControls() {
        pausePlayButton.isHidden = true
        customControls?.isHidden = true
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
            self.customControls?.timeSlider.isHidden = false
        }
        else {
            self.customControls?.timeSlider.isHidden = true
        }
        if isCurrentTimeLabelVisible && isDurationTimeLabelVisible {
            customControls?.currentTimeLabel.isHidden = false
            customControls?.durationTimeLabel.isHidden = false
            customControls?.rewindButton.isHidden = false
            customControls?.forwardButton.isHidden = false
        }
        else {
            customControls?.currentTimeLabel.isHidden = true
            customControls?.durationTimeLabel.isHidden = true
            customControls?.rewindButton.isHidden = true
            customControls?.forwardButton.isHidden = true
        }
        loadUserControls()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapAction))
//        let centreTap = UITapGestureRecognizer.init(target: self, action: #selector(handleCentrePause))

        tap.numberOfTapsRequired = 1
        videoPlayView.addGestureRecognizer(tap)
        player = AVPlayer(url: videoUrl)
        self.playerLayer = AVPlayerLayer(player: player)
        //        playerLayer.videoGravity = .resize
        playerLayer.frame = videoPlayView.bounds
        videoPlayView.layer.insertSublayer(playerLayer, at: 0)
        player?.play()
        loadCustomView()

        addTimeObserver()
    }
    
    @IBAction func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton?.setImage(UIImage(systemName: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton?.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    func loadUserControls() {
        userControlsObject = UIView.fromNib()
                           userControlsObject?.delegateUser = self
                           videoPlayView.addSubview(userControlsObject!)
                           videoPlayView.bringSubviewToFront(userControlsObject!)
                           userControlsObject?.translatesAutoresizingMaskIntoConstraints = false
                           userControlsObject?.leadingAnchor.constraint(equalTo: videoPlayView.leadingAnchor).isActive = true
                           userControlsObject?.trailingAnchor.constraint(equalTo: videoPlayView.trailingAnchor).isActive = true
                           userControlsObject?.topAnchor.constraint(equalTo: videoPlayView.topAnchor , constant: 50).isActive = true
                           userControlsObject?.centerXAnchor.constraint(equalTo: videoPlayView.centerXAnchor).isActive = true
                           userControlsObject?.widthAnchor.constraint(equalTo: videoPlayView.widthAnchor).isActive = true
                           userControlsObject?.heightAnchor.constraint(equalToConstant: 100)
           
    }
    
    func loadCustomView() {
        customControls = UIView.fromNib()
                    customControls?.delegate = self
                    videoPlayView.addSubview(customControls!)
                    videoPlayView.bringSubviewToFront(customControls!)
                   
                    customControls?.translatesAutoresizingMaskIntoConstraints = false
                    customControls?.leadingAnchor.constraint(equalTo: videoPlayView.leadingAnchor).isActive = true
                    customControls?.trailingAnchor.constraint(equalTo: videoPlayView.trailingAnchor).isActive = true
                    customControls?.bottomAnchor.constraint(equalTo: videoPlayView.bottomAnchor).isActive = true
                    customControls?.centerXAnchor.constraint(equalTo: videoPlayView.centerXAnchor).isActive = true
                    customControls?.widthAnchor.constraint(equalTo: videoPlayView.widthAnchor).isActive = true
                    customControls?.heightAnchor.constraint(equalToConstant: 50)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: videoPlayView)
            var x = UIScreen.main.bounds.width / 2.0
            var y = UIScreen.main.bounds.height / 2.0
            print(x)
            print(y)
            var center = CGPoint(x: x, y: y)
            if position == center {
                if isPlaying{
                    player?.pause()
                }
                else {
                    player?.play()
                }
            }
            print(position)
        }
    }

    func start()
    {
        timer?.invalidate()
        timer =  nil
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.hideBothControls), userInfo: nil, repeats: false)
        
    }
    
    func addTimeObserver() {
        player?.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player?.currentItem else {return}
            self?.customControls?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.customControls?.timeSlider.minimumValue = 0.0
            self?.customControls?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.customControls?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
            self?.customControls?.durationTimeLabel.text = self?.getTimeString(from: (currentItem.duration))
            
            if self?.customControls?.timeSlider.value == self?.customControls?.timeSlider.maximumValue{
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
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player?.currentItem?.duration.seconds, duration > 0.0 {
            //            self.durationTimeLabel.text = getTimeString(from: (player?.currentItem!.duration)!)
        }
        if keyPath == "status", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if self?.playerLayer.player?.currentItem?.status == .readyToPlay{
                        self?.start()
                    }
                }
            }
        }
    }
}

extension VideoPlayViewController: DefineCustomControlActions {
    
    func rewindButtonHandle() {
         let currentTime = CMTimeGetSeconds(player!.currentTime())
               var newTime = currentTime - 3.0
               if newTime < 0 {
                   newTime = 0
               }
               let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
               player!.seek(to: time)
    }
    

    func timeSliderHandle(sender: UISlider) {
        if let customSlider = customControls {
            self.player?.seek(to: CMTimeMake(value: Int64(sender.value), timescale: Int32(1)))
            UIView.animate(withDuration: 1.0) { [weak self] in
                self?.pausePlayButton.alpha = 1
            }
            player?.play()
            pausePlayButton?.setImage(UIImage(systemName: "pause"), for: .normal)
        }
    }
    
   
    func forwardButtonHandle() {
        guard let duration = player!.currentItem?.duration else {return}
               let currentTime = CMTimeGetSeconds(player!.currentTime())
               var newTime = currentTime + 3.0
               if newTime < (CMTimeGetSeconds(duration)) {
                   let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
                   player!.seek(to: time)
               }
               if newTime >= (CMTimeGetSeconds(duration)) {
                   newTime = CMTimeGetSeconds(duration)
               }
            }
        }

extension VideoPlayViewController: DefineUserControlActions {
    func volumeButtonHandle() {
        
    }
    
    func volumeSliderHandle(sender: UISlider) {
        
    }
}


extension UIView {

    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: T.self, options: nil)![0] as! T
    }
}
