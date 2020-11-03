//
//  MusicPlayerViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/21/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import AVFoundation
import MediaPlayer
import UIKit

@objc class MusicPlayerViewController: UIViewController {
    static var soundPlayer: AVAudioPlayer?
    @objc var receivedSongList = [ImportedPlayingSong]()
    @objc var receivedIndex = Int()
    var playIndex = Int()
    let musicViewModel = MusicViewModel()
    var shufflePlayedSequence = [Int]()
    var startSPinningTime = 0.0
    var pausedSpinningTime = 0.0
    var orderButtonTappedCounter = 0
    var shareButtonTapCounter = 0
    var previousNextFlag = 1 // 0 for previous, 1 for next
    
    @IBOutlet weak private var timeDurationSlider: UISlider!
    @IBOutlet weak private var errorMessageLabel: UILabel!
    @IBOutlet weak private var playingTimeLabel: UILabel!
    @IBOutlet weak private var totalTimeLabel: UILabel!
    @IBOutlet weak private var songNameLabel: UILabel! {
        didSet {
            songNameLabel.isHidden = true
        }
    }
    @IBOutlet weak private var singerNameLabel: UILabel! {
        didSet {
            singerNameLabel.isHidden = true
        }
    }
    @IBOutlet weak private var nextButton: UIButton!
    @IBOutlet weak private var previousButton: UIButton!
    @IBOutlet weak private var volumeImageView: UIImageView!
    @IBOutlet weak private var artistHeadShotIMageView: UIImageView! {
        didSet {
            artistHeadShotIMageView.contentMode = .scaleAspectFill
            artistHeadShotIMageView.layer.borderWidth = 5
            artistHeadShotIMageView.layer.borderColor = UIColor.white.cgColor
            artistHeadShotIMageView.isHidden = true
        }
    }
    @IBOutlet weak private var playButton: UIButton! {
        didSet {
            playButton.setTitle("", for: .normal)
            playButton.setImage(UIImage(imageLiteralResourceName: "playButton"), for: .normal)
        }
    }
    @IBOutlet weak private var orderButton: UIButton! {
        didSet {
            orderButton.setTitle("", for: .normal)
            switch ModeSetting.playMode {
            case .single:
                orderButton.setImage(UIImage(imageLiteralResourceName: "singleCycle"), for: .normal)
                
            case .sequential:
                orderButton.setImage(UIImage(imageLiteralResourceName: "sequenceCycle"), for: .normal)
                
            case .shuffle:
                orderButton.setImage(UIImage(imageLiteralResourceName: "shuffleCycle"), for: .normal)
            }
        }
    }
    @IBOutlet weak private var volumeSlider: UISlider! {
        didSet {
            volumeSlider.maximumValue = 1
            volumeSlider.minimumValue = 0
            volumeSlider.value = VolumeSetting.savedVolume
        }
    }
    
    private func initailSettings() {
        MusicPlayerViewController.soundPlayer?.stop()
        playIndex = receivedIndex
        self.playButton.isUserInteractionEnabled = false
        self.previousButton.isUserInteractionEnabled = false
        self.nextButton.isUserInteractionEnabled = false
        self.timeDurationSlider.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.top, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.title = "Now Playing"
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes as [NSAttributedString.Key: Any]
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(.playback)
            
            MusicPlayerViewController.soundPlayer?.prepareToPlay()
            MusicPlayerViewController.soundPlayer?.play()
        } catch { print("ERROR", error.localizedDescription) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let musicPlayer = MusicPlayerViewController.soundPlayer {
            if !musicPlayer.isPlaying {
                print("will resume")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headShotImageViewSetUp()
        print("did resume")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initailSettings()
        disPlayMusic()
        setupMediaPlayerNotificationView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        NotificationCenter.default.post(name: NSNotification.Name("ChannalBlurView"), object: nil)
        
        if let musicPlayer = MusicPlayerViewController.soundPlayer {
            if !musicPlayer.isPlaying {
                print("stopped")
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ChannalMusicPlayerDisAppeared"), object: nil)
    }
    @IBAction private func playStopButtonTapped(_ sender: UIButton) {
        playStophandler()
    }
    @IBAction private func previousButtonTapped(_ sender: UIButton) {
        trackToPreviousSong()
    }
    @IBAction private func nextButtonTapped(_ sender: UIButton) {
        trackToNextSong()
    }
    @IBAction private func orderButtonTapped(_ sender: UIButton) {
        switch ModeSetting.playMode {
        case .single:
            ModeSetting.playMode = .sequential
            orderButton.setImage(UIImage(imageLiteralResourceName: "sequenceCycle"), for: .normal)
            
        case .sequential:
            ModeSetting.playMode = .shuffle
            orderButton.setImage(UIImage(imageLiteralResourceName: "shuffleCycle"), for: .normal)
            
        case .shuffle:
            ModeSetting.playMode = .single
            orderButton.setImage(UIImage(imageLiteralResourceName: "singleCycle"), for: .normal)
        }
    }
    @IBAction private func volumeSliderDragged(_ sender: UISlider) {
        if MusicPlayerViewController.soundPlayer != nil {
            VolumeSetting.savedVolume = volumeSlider.value
            MusicPlayerViewController.soundPlayer?.volume = VolumeSetting.savedVolume
        }
    }
    @IBAction private func progresserSliderDragged(_ sender: UISlider) {
        if let musicSoundPlayer = MusicPlayerViewController.soundPlayer {
            if musicSoundPlayer.isPlaying {
                MusicPlayerViewController.soundPlayer?.stop()
                MusicPlayerViewController.soundPlayer?.currentTime = Double(timeDurationSlider.value)
                MusicPlayerViewController.soundPlayer?.prepareToPlay()
                MusicPlayerViewController.soundPlayer?.play()
            } else {
                MusicPlayerViewController.soundPlayer?.currentTime = Double(timeDurationSlider.value)
            }
        }
    }
    @IBAction private func shareButtonTapped(_ sender: UIButton) {
        easternEgg()
        let firstActivityItem = "\(receivedSongList[playIndex].songName)\n\(receivedSongList[playIndex].singername)"
        guard let secondActivityItem = URL(string: self.musicViewModel.validSongInfo.urlString) else { return }
        let thirdActivityItem = self.musicViewModel.validSongInfo.headShot
        shareFeature(firstActivityItem: firstActivityItem, secondActivityItem: secondActivityItem, thirdActivityItem: thirdActivityItem)
    }
    private func headShotImageViewSetUp() {
        var topConstraint = NSLayoutConstraint()
        if UIDevice.modelName == "iPhone 11 Pro Max" || UIDevice.modelName == "Simulator iPhone 11 Pro Max" { // XS max
            topConstraint = NSLayoutConstraint(item: artistHeadShotIMageView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: volumeSlider, attribute: .bottom, multiplier: 1, constant: 125)
        } else if UIDevice.modelName == "iPod touch (7th generation)" || UIDevice.modelName == "Simulator iPod touch (7th generation)" { 
            topConstraint = NSLayoutConstraint(item: artistHeadShotIMageView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: volumeSlider, attribute: .bottom, multiplier: 1, constant: 20)
        } else if UIDevice.modelName == "iPhone 8 Plus" || UIDevice.modelName == "Simulator iPhone 8 Plus" {
            topConstraint = NSLayoutConstraint(item: artistHeadShotIMageView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: volumeSlider, attribute: .bottom, multiplier: 1, constant: 55)
        } else if UIDevice.modelName == "iPhone 11" || UIDevice.modelName == "Simulator iPhone 11" { // Xr
            topConstraint = NSLayoutConstraint(item: artistHeadShotIMageView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: volumeSlider, attribute: .bottom, multiplier: 1, constant: 90)
        } else if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulaotr iPhone XS Max" { 
            topConstraint = NSLayoutConstraint(item: artistHeadShotIMageView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: volumeSlider, attribute: .bottom, multiplier: 1, constant: 120)
        } else if UIDevice.modelName == "iPhone 8" ||
                    UIDevice.modelName == "Simulator iPhone 8" ||
                    UIDevice.modelName == "iPhone SE (2nd generation)" ||
                    UIDevice.modelName == "Simulator iPhone SE (2nd generation)" {
            topConstraint = NSLayoutConstraint(item: artistHeadShotIMageView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: volumeSlider, attribute: .bottom, multiplier: 1, constant: 60)
        } else if UIDevice.modelName == "iPad Pro (12.9-inch) (4th generation)" || UIDevice.modelName == "Simulator iPad Pro (12.9-inch) (4th generation)"{
            topConstraint = NSLayoutConstraint(item: artistHeadShotIMageView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: volumeSlider, attribute: .bottom, multiplier: 1, constant: 120)
        }
        view.addConstraint(topConstraint)
        artistHeadShotIMageView.layer.cornerRadius = artistHeadShotIMageView.frame.size.height / 2
        artistHeadShotIMageView.isHidden = false
        songNameLabel.isHidden = false
        singerNameLabel.isHidden = false
    }
    func playStophandler() {
        if let musicSoundPlayer = MusicPlayerViewController.soundPlayer {
            if musicSoundPlayer.isPlaying {
                playButton.setTitle("", for: .normal)
                playButton.setImage(UIImage(imageLiteralResourceName: "playButton"), for: .normal)
                pauseRotating()
                MusicPlayerViewController.soundPlayer?.pause()
            } else {
                playButton.setTitle("", for: .normal)
                playButton.setImage(UIImage(imageLiteralResourceName: "pause"), for: .normal)
                startRotatingImageView()
                MusicPlayerViewController.soundPlayer?.play()
            }
        }
    }
    func trackToPreviousSong() {
        previousNextFlag = 0
        MusicPlayerViewController.soundPlayer?.stop()
        playButton.isUserInteractionEnabled = false
        switch ModeSetting.playMode {
        case .single:
            disPlayMusic()
            
        case .sequential:
            if playIndex == 0 {
                playIndex = receivedSongList.count - 1
            } else {
                playIndex -= 1
            }
            disPlayMusic()
            
        case .shuffle:
            playIndex = Int.random(in: 0..<receivedSongList.count)
            disPlayMusic()
        }
        artistHeadShotIMageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    func trackToNextSong() {
        previousNextFlag = 1
        MusicPlayerViewController.soundPlayer?.stop()
        playButton.isUserInteractionEnabled = false
        switch ModeSetting.playMode {
        case .single:
            disPlayMusic()
            
        case .sequential:
            if playIndex == receivedSongList.count - 1 {
                playIndex = 0
            } else {
                playIndex += 1
            }
            disPlayMusic()
            
        case .shuffle:
            playIndex = Int.random(in: 0..<receivedSongList.count)
            disPlayMusic()
        }
        artistHeadShotIMageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    private func startRotatingImageView() {
        if let animationKeys = artistHeadShotIMageView.layer.animationKeys() {
            for animationKey in animationKeys where animationKey == "rotationAnimation" {
                let pausedTime = artistHeadShotIMageView.layer.timeOffset
                if pausedTime > 0 {
                    artistHeadShotIMageView.layer.speed = 0.01
                    artistHeadShotIMageView.layer.timeOffset = 0
                    artistHeadShotIMageView.layer.beginTime = artistHeadShotIMageView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                }
                return
            }
            addImageViewRotateAnimation()
        } else { addImageViewRotateAnimation() }
    }
    private func addImageViewRotateAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        startSPinningTime = Date().timeIntervalSinceReferenceDate
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        artistHeadShotIMageView.layer.speed = 0.01
        rotation.repeatCount = Float.greatestFiniteMagnitude
        artistHeadShotIMageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    private func pauseRotating() {
        pausedSpinningTime = Date().timeIntervalSinceReferenceDate
        let pausedTime = artistHeadShotIMageView.layer.convertTime(CACurrentMediaTime(), from: nil)
        artistHeadShotIMageView.layer.speed = 0.0
        artistHeadShotIMageView.layer.timeOffset = pausedTime
    }
    private func disPlayMusic() {
        MusicPlayerViewController.soundPlayer?.stop()
        musicViewModel.audioInfohandle(songName: receivedSongList[playIndex].songName, singerName: receivedSongList[playIndex].singername) { songInfoNotNil, error  in
            print("now playing \(self.receivedSongList[self.playIndex].songName)")
            self.observerAdded()
            let userInfoData = [
                "userInfoData": NCSongInfo(songName: self.receivedSongList[self.playIndex].songName,
                                           singerName: self.receivedSongList[self.playIndex].singername,
                                           headShotImage: self.musicViewModel.validSongInfo.headShot)
            ]
            NotificationCenter.default.post(name: NSNotification.Name("ChannalNC01"), object: nil, userInfo: userInfoData)
            if error == nil, songInfoNotNil {
                let url = URL(string: self.musicViewModel.validSongInfo.urlString)
                guard let validURL = url else { return }
                URLSession.shared.downloadTask(with: validURL) { url, _, error in
                    if let url = url, error == nil {
                        do { MusicPlayerViewController.soundPlayer = try AVAudioPlayer(contentsOf: url)
                            DispatchQueue.main.async { MusicPlayerViewController.soundPlayer?.volume = self.volumeSlider.value }
                        } catch { print("error in playing", error.localizedDescription) }
                        DispatchQueue.main.async {
                            self.songNameLabel.text = self.receivedSongList[self.playIndex].songName
                            self.singerNameLabel.text = self.receivedSongList[self.playIndex].singername
                            self.timeDurationSlider.maximumValue = Float(MusicPlayerViewController.soundPlayer?.duration ?? 0)
                            self.totalTimeLabel.text = String(format: "00:%02d", Int(MusicPlayerViewController.soundPlayer?.duration ?? 0))
                            self.artistHeadShotIMageView.layer.speed = 1
                            UIView.transition(with: self.artistHeadShotIMageView,
                                              duration: 0.5,
                                              options: .transitionFlipFromLeft,
                                              animations: { self.artistHeadShotIMageView.image = self.musicViewModel.validSongInfo.headShot },
                                              completion: nil)
                            self.playButton.setImage(UIImage(imageLiteralResourceName: "pause"), for: .normal)
                            MusicPlayerViewController.soundPlayer?.prepareToPlay()
                            MusicPlayerViewController.soundPlayer?.play()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.startRotatingImageView()
                                self.playButton.isUserInteractionEnabled = true
                                self.previousButton.isUserInteractionEnabled = true
                                self.nextButton.isUserInteractionEnabled = true
                                self.timeDurationSlider.isUserInteractionEnabled = true
                            }
                        }
                    }
                }.resume()
            } else if error == nil, !songInfoNotNil {
                self.errorHandler() 
            } else if error != nil {
                self.errorHandler()
            }
        }
    }
    private func errorHandler() {
        DispatchQueue.main.async {
            self.previousButton.isUserInteractionEnabled = false
            self.nextButton.isUserInteractionEnabled = false
            self.errorMessageLabel.isHidden = false
            self.songNameLabel.text = self.receivedSongList[self.playIndex].songName
            self.singerNameLabel.text = self.receivedSongList[self.playIndex].singername
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.errorMessageLabel.isHidden = true
            if self.previousNextFlag == 1 {
                self.trackToNextSong()
            } else {
                self.trackToPreviousSong()
            }
        }
    }
    @objc private func updateTime() {
        let curretnTime = Int(MusicPlayerViewController.soundPlayer?.currentTime ?? 0)
        let minutes = curretnTime / 60
        let seconds = curretnTime - minutes / 60
        playingTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        // volume
        MusicPlayerViewController.soundPlayer?.volume = volumeSlider.value
        if volumeSlider.value <= 0.33 {
            volumeImageView.image = UIImage(imageLiteralResourceName: "volumeLow")
        } else if volumeSlider.value <= 0.67 {
            volumeImageView.image = UIImage(imageLiteralResourceName: "volumeMid")
        } else {
            volumeImageView.image = UIImage(imageLiteralResourceName: "volumeHigh")
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    @objc private func updateSlider() {
        guard let nowTime = MusicPlayerViewController.soundPlayer?.currentTime else { return }
        timeDurationSlider.value = Float(nowTime)
        if timeDurationSlider.value == timeDurationSlider.maximumValue, timeDurationSlider.maximumValue == 1.0 { return }
        if timeDurationSlider.value >= timeDurationSlider.maximumValue - 0.2 {
            MusicPlayerViewController.soundPlayer?.currentTime = 0
            trackToNextSong()
        }
    }
}
