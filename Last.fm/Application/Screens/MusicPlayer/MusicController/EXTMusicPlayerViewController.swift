//
//  EXTMusicPlayerViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/28/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import MediaPlayer
import SafariServices
import UIKit

class EXTMusicPlayerViewController {
}

extension MusicPlayerViewController {
    func easternEgg() {
        if shareButtonTapCounter > 5 {
            shareButtonTapCounter = 0
            let urlString = "https://devhumor.com"
            guard let url = URL(string: urlString) else { return }
            let esternEggVC = SFSafariViewController(url: url)
            self.present(esternEggVC, animated: true, completion: nil)
            return
        }
        shareButtonTapCounter += 1
    }
    func shareFeature(firstActivityItem: String, secondActivityItem: URL, thirdActivityItem: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [firstActivityItem, secondActivityItem, thirdActivityItem], applicationActivities: nil)
        if #available(iOS 13.0, *) {
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
        }
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        if #available(iOS 13.0, *) {
            activityViewController.isModalInPresentation = true
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension MusicPlayerViewController {
    @objc func notificationCenterInfoSetup(notification: NSNotification) {
        var nowPlayingInfo = [String: Any]()
        guard let userInfoData = notification.userInfo?["userInfoData"] as? NCSongInfo else { return }
        nowPlayingInfo[MPMediaItemPropertyTitle] = userInfoData.songName
        nowPlayingInfo[MPMediaItemPropertyArtist] = userInfoData.singername
        let image = userInfoData.headShotImage
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ -> UIImage in
                                                                            let image = image
            return image
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ChannalNC01"), object: nil)
    }
    func observerAdded() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCenterInfoSetup(notification:)), name: NSNotification.Name("ChannalNC01"), object: nil)
    }
    func setupMediaPlayerNotificationView() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.playStophandler()
            return .success
        }
        commandCenter.pauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.playStophandler()
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.trackToPreviousSong()
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.trackToNextSong()
            return .success
        }
    }
}
