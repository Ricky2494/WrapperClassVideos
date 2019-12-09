//
//  VideoFeedViewController.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 03/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit
import AVKit

class VideoFeedViewController: UIViewController {
    
    @IBOutlet weak var testTableView: UITableView!
    
    var videos: [Video] = []
    let videoCellReuseIdentifier  = "VideoCell"
    //let videoPreviewLooper = VideoLooperView(clips: VideoClip.allClips())
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()

        videos = Video.localVideos()
      loadViews()
    }
    
    func loadViews() {
      view.backgroundColor = .white
      
      testTableView.register(VideoViewTableViewCell.classForCoder(), forCellReuseIdentifier: videoCellReuseIdentifier)
      testTableView.delegate = self
      testTableView.dataSource = self
      //view.addSubview(videoPreviewLooper)
    }
}


extension VideoFeedViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: videoCellReuseIdentifier, for: indexPath) as? VideoViewTableViewCell else {
          return VideoViewTableViewCell()
        }
        cell.video = videos[indexPath.row]
        return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let video = videos[indexPath.row]
        return VideoViewTableViewCell.height(for: video)
      }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //2 Create an AVPlayerViewController and present it when the user taps
        let video = videos[indexPath.row]
        let storyBoardID = UIStoryboard(name: "Main", bundle: nil)
               let videoPlayVC = storyBoardID.instantiateViewController(withIdentifier: "VideoPlayViewController") as? VideoPlayViewController
        videoPlayVC?.videoUrl = video.url
        videoPlayVC?.isTimeSliderVisible = false
        videoPlayVC?.isPausePlayButtonVisible = false
        videoPlayVC?.isCurrentTimeLabelVisible = false
        videoPlayVC?.isDurationTimeLabelVisible = false
        //videoPlayVC?.setUpPlayerView(isPausePlayButtonVisible: false, isTimeSliderVisible: false)
        self.navigationController?.pushViewController(videoPlayVC!, animated: true)
        func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        testTableView.frame = view.bounds
    
      }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    }

}
