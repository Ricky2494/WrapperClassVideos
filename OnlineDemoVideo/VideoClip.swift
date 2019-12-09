//
//  VideoClip.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 03/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit

   class VideoClip: NSObject {
      let url: URL
      
      init(url: URL) {
        self.url = url
        super.init()
      }
      
      class func allClips() -> [VideoClip] {
        var clips: [VideoClip] = []
   
        let names = ["newYorkFlip", "bulletTrain", "monkey", "shark"]
        for name in names {
          let urlPath = Bundle.main.path(forResource: name, ofType: "mp4")!
          let url = URL(fileURLWithPath: urlPath)
          
          let clip = VideoClip(url: url)
          clips.append(clip)
        }

        return clips
      }
    }
