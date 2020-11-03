//
//  ModeSetting.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/21/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import AVFoundation
import Foundation

enum VolumeSetting {
    static var savedVolume = AVAudioSession.sharedInstance().outputVolume
}

enum ModeSetting {
   static var playMode = PlayMode.sequential
}
