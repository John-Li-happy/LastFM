//
//  ExtArtistDetailViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 10/18/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class ExtArtistDetailViewController {
}

extension ArtistDetailViewController {
    func playTrack(indexPathRow: Int) {
        let storyBoard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        guard let singerName = artist?.name else { return }
        var importedSongList = [ImportedPlayingSong]()
        for song in viewModel.validArtistTopTrackList {
            let singleSong = ImportedPlayingSong(songName: song.name, singerName: singerName)
            importedSongList.append(singleSong)
        }
        guard let playerVC = storyBoard.instantiateViewController(identifier: AppConstants.StoryboardID.musicPlayerViewController) as? MusicPlayerViewController else { return }
        playerVC.receivedSongList = importedSongList
        playerVC.receivedIndex = indexPathRow
        let newNavC = UINavigationController(rootViewController: playerVC)
        self.present(newNavC, animated: true, completion: nil)
        self.addBlurredView()
    }
    
    func shareObject(firstActivityItem: String, secondActivityItem: URL, thirdActivityItem: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [firstActivityItem, secondActivityItem as Any, thirdActivityItem], applicationActivities: nil)
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
