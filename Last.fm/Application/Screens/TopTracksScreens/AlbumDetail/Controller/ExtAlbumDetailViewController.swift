//
//  ExtAlbumDetailViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 10/12/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class ExtAlbumDetailViewController {
}

extension AlbumDetailViewController {
    func fethcDetailData() {
        albumDetailViewModel.parseAlbumDetailData(artist: receivedSingerName, albumName: receivedAlbumName) {[weak self] error in
            if error != nil { //edge case handling
            }
            DispatchQueue.main.async {
                // Content Settings
                let info =
                "\(self?.albumDetailViewModel.validAlbumDetailDataSource.songCount ?? String()) songs. \(self?.albumDetailViewModel.validAlbumDetailDataSource.totalTimeDuration ?? String()) min"
                self?.blurredView.setContentData(singerName: self?.receivedSingerName ?? String(),
                                                 albumName: self?.receivedAlbumName ?? String(),
                                                 info: info,
                                                 headShotImage: self?.albumDetailViewModel.validAlbumDetailDataSource.headShot ?? UIImage())
                // View Settings
                let blurredImageView = UIImageView(image: self?.albumDetailViewModel.validAlbumDetailDataSource.headShot)
                blurredImageView.contentMode = .scaleToFill
                let prepareCIImage = CIImage(image: self?.albumDetailViewModel.validAlbumDetailDataSource.headShot ?? UIImage())
                let blurFilter = CIFilter(name: "CIGaussianBlur")
                blurFilter?.setValue(prepareCIImage, forKey: kCIInputImageKey)
                blurFilter?.setValue(5, forKey: kCIInputRadiusKey)
                if let blurredImage = blurFilter?.outputImage {
                    let context = CIContext(options: nil)
                    let rect = CGRect(origin: CGPoint.zero, size: self?.albumDetailViewModel.validAlbumDetailDataSource.headShot.size ?? CGSize())
                    if let cgBlurredImage = context.createCGImage(blurredImage, from: rect) {
                        blurredImageView.image = UIImage(cgImage: cgBlurredImage)
                    }
                } else {
                    blurredImageView.image = self?.albumDetailViewModel.validAlbumDetailDataSource.headShot
                }
                self?.blurredView.addSubview(blurredImageView)
                blurredImageView.translatesAutoresizingMaskIntoConstraints = false
// MARK: - imageViewInBlurredView Constraint
                let imageTopConstraint = NSLayoutConstraint(item: blurredImageView, attribute: .top, relatedBy: .equal, toItem: self?.blurredView, attribute: .top, multiplier: 1, constant: 0)
                let imageTrailing = NSLayoutConstraint(item: blurredImageView, attribute: .trailing, relatedBy: .equal, toItem: self?.blurredView, attribute: .trailing, multiplier: 1, constant: 0)
                let imageLeading = NSLayoutConstraint(item: blurredImageView, attribute: .leading, relatedBy: .equal, toItem: self?.blurredView, attribute: .leading, multiplier: 1, constant: 0)
                let imageBottomConstraint = NSLayoutConstraint(item: blurredImageView, attribute: .bottom, relatedBy: .equal, toItem: self?.blurredView, attribute: .bottom, multiplier: 1, constant: 0)
                self?.blurredView.addConstraints([
                    imageTopConstraint,
                    imageTrailing,
                    imageLeading,
                    imageBottomConstraint
                ])
                self?.blurredView.sendSubviewToBack(blurredImageView)
                self?.trackTableView.reloadData()
            }
        }
    }
}

extension AlbumDetailViewController: BackWardForViewPassMessage {
    func shareButtonParentTapped() {
        let firstActivityItem = "\(receivedAlbumName)\n\(receivedSingerName)"
        var secondActivityItem = URL(string: "")
        if let url = URL(string: self.albumDetailViewModel.validAlbumDetailDataSource.url) { secondActivityItem = url }
        let thirdActivityItem = self.albumDetailViewModel.validAlbumDetailDataSource.headShot
        guard let secondActivityItemNonnull = secondActivityItem else { return }
        shareObject(firstActivityItem: firstActivityItem, secondActivityItem: secondActivityItemNonnull, thirdActivityItem: thirdActivityItem)
    }
    
    func playButtonparentTapped() {
        var importedSongList = [ImportedPlayingSong]()
        for song in albumDetailViewModel.validAlbumTrackdetailDataSource {
            let singleSong = ImportedPlayingSong(songName: song.trackName, singerName: song.trackSingerName)
            importedSongList.append(singleSong)
        }
        disableRotation()
        presentMusicPlayer(importIndex: 0, importedSongList: importedSongList)
    }
}
 
extension AlbumDetailViewController: BackWardsForCellPass {
    func playButtonParentTapped(selectedRow: Int) {
        var importedSongList = [ImportedPlayingSong]()
        for song in albumDetailViewModel.validAlbumTrackdetailDataSource {
            let singleSong = ImportedPlayingSong(songName: song.trackName, singerName: song.trackSingerName)
            importedSongList.append(singleSong)
        }
        presentMusicPlayer(importIndex: selectedRow, importedSongList: importedSongList)
    }
    
    func moreButtonParentTapped(selectedRow: Int, songName: String, singerName: String) {
        let actionSheetAlertController = UIAlertController(title: "\n\n\n", message: "", preferredStyle: .actionSheet)
        //Set TitleView
        let titleView = AlertTitleView()
        actionSheetAlertController.view.addSubview(titleView)
        titleView.configureCell(image: self.albumDetailViewModel.validAlbumDetailDataSource.headShot, trackName: songName, singerName: receivedSingerName)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        let titltViewTopConstraint = NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: actionSheetAlertController.view, attribute: .top, multiplier: 1, constant: 0)
        let titltViewLeftConstraint = NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: actionSheetAlertController.view, attribute: .left, multiplier: 1, constant: 5)
        let titltViewRightConstraint = NSLayoutConstraint(item: titleView,
                                                          attribute: .right,
                                                          relatedBy: .equal,
                                                          toItem: actionSheetAlertController.view,
                                                          attribute: .right,
                                                          multiplier: 1,
                                                          constant: -5)
        let titltViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)

        actionSheetAlertController.view.addConstraints([
            titltViewTopConstraint,
            titltViewLeftConstraint,
            titltViewRightConstraint,
            titltViewHeightConstraint
        ])
        
        //Set Actions
        let shareAction = UIAlertAction(title: "Share To", style: .default) { _ in
            let firstActivityItem = "\(songName) from\n \(self.receivedAlbumName)"
            var secondActivityItem = URL(string: "")
            if let url = URL(string: self.albumDetailViewModel.validAlbumDetailDataSource.url) { secondActivityItem = url }
            let thirdActivityItem = self.albumDetailViewModel.validAlbumDetailDataSource.headShot
            guard let secondActivityItemNonnull = secondActivityItem else { return }
            self.shareObject(firstActivityItem: firstActivityItem, secondActivityItem: secondActivityItemNonnull, thirdActivityItem: thirdActivityItem)
        }
        let searchSimiliarTrackAction = UIAlertAction(title: "Different version Tracks", style: .default) { _ in
            self.searchSimiliarTrack(songName: songName)
        }
        let searchArtistAction = UIAlertAction(title: "Search This Artist", style: .default) { _ in
            self.searchArtist(selectedRow: selectedRow)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //Add Actions
        actionSheetAlertController.addAction(shareAction)
        actionSheetAlertController.addAction(searchSimiliarTrackAction)
        actionSheetAlertController.addAction(searchArtistAction)
        actionSheetAlertController.addAction(cancelAction)
        present(actionSheetAlertController, animated: true, completion: nil)
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
    
    func searchSimiliarTrack(songName: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
            let searchedResultViewController = storyboard.instantiateViewController(identifier: "SearchedResultViewController") as SearchedResultViewController
            searchedResultViewController.receivedString = songName as NSString
            navigationController?.pushViewController(searchedResultViewController, animated: true)
        }
    }
    
    func searchArtist(selectedRow: Int) {
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        let artistDetailViewController = storyboard.instantiateViewController(identifier: "ArtistDetailViewController") as ArtistDetailViewController
        let singerName = self.albumDetailViewModel.validAlbumTrackdetailDataSource[selectedRow].trackSingerName
        let artist = Artist(name: singerName, reference: "", url: nil, image: nil)
        artistDetailViewController.artist = artist
        navigationController?.pushViewController(artistDetailViewController, animated: true)
    }
    
    @objc func blurredViewRemove() {
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
            navigationItem.titleView = nil
        }
    }
    
    @objc func addBlurredView() {
        view.addSubview(blurEffectView)
    }
    
    @objc func disableRotation() {
        guard let tabBarController = self.tabBarController as? MainTabBarController else {
            print("no tab bar found")
            return }
        tabBarController.setObserver()
        let storeIDDic = ["id": false]
        NotificationCenter.default.post(name: NSNotification.Name("ChannalNCRotate"), object: nil, userInfo: storeIDDic)
    }
    
    @objc func enableRotattion() {
        guard let tabBarController = self.tabBarController as? MainTabBarController else {
            print("no tab bar found")
            return }
        tabBarController.setObserver()
        let storeIDDic = ["id": true]
        NotificationCenter.default.post(name: NSNotification.Name("ChannalNCRotate"), object: nil, userInfo: storeIDDic)
    }
}
