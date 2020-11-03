//
//  ProfileViewController.swift
//  Last.fm
//
//  Created by Shawn on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SkeletonView
import UIKit

class ProfileViewController: UIViewController {
    let viewModel = ProfileViewModel()
    let group = DispatchGroup()
    
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var realNameLabel: UILabel!
    @IBOutlet weak private var genderLabel: UILabel!
    @IBOutlet weak private var ageLabel: UILabel!
    @IBOutlet weak private var playCountLabel: UILabel!
    @IBOutlet weak private var countryLabel: UILabel!
    @IBOutlet weak private var recentTracksCollectionView: UICollectionView!
    @IBOutlet weak private var noRecentTracksLabel: UILabel!
    @IBOutlet weak private var topArtistsCollectionView: UICollectionView!
    @IBOutlet weak private var noTopArtistsLabel: UILabel!
    @IBOutlet weak private var topTracksTableView: UITableView!
    @IBOutlet weak private var noTopTracksLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchDataGroup()
    }
    
    @IBAction private func logoutButtonTapped(_ sender: UIBarButtonItem) {
        AlertManager.alert(forWhichPage: self, alertType: .logoutConfirmation) { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.logout()
        }
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 3
        
        recentTracksCollectionView.delegate = self
        recentTracksCollectionView.dataSource = self
        topArtistsCollectionView.delegate = self
        topArtistsCollectionView.dataSource = self
        setCollectionViewFlowLayout()
        
        topTracksTableView.delegate = self
        topTracksTableView.dataSource = self
        
        showAllSkeletons(true)
    }
    
    func fetchDataGroup() {
        group.enter()
        self.fetchUserData()
        
        group.enter()
        self.fetchRecentTracksData()
        
        group.enter()
        self.fetchTopArtistsData()
        
        group.enter()
        self.fetchTopTracksData()
        
        group.notify(queue: DispatchQueue.main) {
            print("Data Fetch Complete!")
        }
    }
    
    private func showAllSkeletons(_ show: Bool) {
        // WAY - 1
//        avatarImageView.showAnimatedGradientSkeleton()
//        userNameLabel.showAnimatedGradientSkeleton()
//        realNameLabel.showAnimatedGradientSkeleton()
//        genderLabel.showAnimatedGradientSkeleton()
//        ageLabel.showAnimatedGradientSkeleton()
//        playCountLabel.showAnimatedGradientSkeleton()
//        countryLabel.showAnimatedGradientSkeleton()
        
        // WAY - 2
//        [avatarImageView, userNameLabel, realNameLabel, genderLabel, ageLabel, playCountLabel, countryLabel].forEach {
//            $0?.showAnimatedGradientSkeleton()
//        }
        
        // WAY - 3
//        let itemArray = [avatarImageView, userNameLabel, realNameLabel, genderLabel, ageLabel, playCountLabel, countryLabel]
//        for item in itemArray {
//            item?.showAnimatedGradientSkeleton()
//        }
        
        // WAY - 4
        guard let subviews = self.view.viewWithTag(10)?.subviews else { return }
        for subview in subviews {
            if subview.isKind(of: UIImageView.self) || subview.isKind(of: UILabel.self) {
                show ? subview.showAnimatedGradientSkeleton() : subview.hideSkeleton()
            }
        }
    }
    
//    private func hideAllSkeletons() {
//        self.avatarImageView.hideSkeleton()
//        self.userNameLabel.hideSkeleton()
//        self.realNameLabel.hideSkeleton()
//        self.genderLabel.hideSkeleton()
//        self.ageLabel.hideSkeleton()
//        self.playCountLabel.hideSkeleton()
//        self.countryLabel.hideSkeleton()
        
//        [avatarImageView, userNameLabel, realNameLabel, genderLabel, ageLabel, playCountLabel, countryLabel].forEach {
//            $0?.hideSkeleton()
//        }
        
//        let itemArray = [avatarImageView, userNameLabel, realNameLabel, genderLabel, ageLabel, playCountLabel, countryLabel]
//        for item in itemArray {
//            item?.hideSkeleton()
//        }
//    }
    
    func fetchUserData() {
        viewModel.fetchAPIData(apiParams: viewModel.userInfoParams) { [weak self] error in
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                weakSelf.displayUserData()
            }
            weakSelf.group.leave()
        }
    }
    
    func displayUserData() {
        guard let avatarUrlString = viewModel.userDataSource.image?[3].imageUrl,
            let realname = viewModel.userDataSource.realName,
            let username = viewModel.userDataSource.name,
            let gender = viewModel.userDataSource.gender,
            let age = viewModel.userDataSource.age,
            let playcount = viewModel.userDataSource.playCount,
            let country = viewModel.userDataSource.country else { return }
        
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: avatarUrlString) else { return }
            do {
                let avatarData = try Data(contentsOf: url)
                let avatar = UIImage(data: avatarData)
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatar
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        DispatchQueue.main.async {
//            self.hideAllSkeletons()
            self.showAllSkeletons(false)
            
            self.realNameLabel.text = realname
            self.userNameLabel.text = "@" + username
            self.genderLabel.text = gender
            self.ageLabel.text = age
            self.playCountLabel.text = playcount
            self.countryLabel.text = country
        }
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: AppConstants.LoginKey.loginStatusKey)
        
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        
        if let loginPage = storyboard.instantiateInitialViewController() {
            let window = UIApplication.shared.windows.first
            window?.rootViewController = loginPage
            window?.makeKeyAndVisible()
            AppDelegate.showAnimatedView = false
        }
    }
}

extension ProfileViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == self.recentTracksCollectionView {
            let returnIdentifier = RecentTracksCollectionViewCell.reuseIdentifier
            return returnIdentifier
        } else {
            let returnIdentifier = TopArtistsCollectionViewCell.reuseIdentifier
            return returnIdentifier
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func setCollectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        layout.itemSize = CGSize(width: width / 2.5, height: width / 2.5)
        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 0
        recentTracksCollectionView.collectionViewLayout = layout

        let topArtistsLayout = UICollectionViewFlowLayout()
        topArtistsLayout.scrollDirection = .horizontal
//        let width2 = UIScreen.main.bounds.width
        topArtistsLayout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
//        topArtistsLayout.itemSize = CGSize(width: width2 / 3, height: width2 / 2.5)
        topArtistsLayout.itemSize = CGSize(width: 150, height: 195)
        topArtistsLayout.minimumInteritemSpacing = 0
        topArtistsLayout.minimumLineSpacing = 25
        topArtistsCollectionView.collectionViewLayout = topArtistsLayout
    }
    
    func fetchRecentTracksData() {
        viewModel.fetchAPIData(apiParams: viewModel.recentTracksParams) { [weak self] error in
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                if weakSelf.viewModel.recentTracksDataSource.isEmpty {
                    weakSelf.noRecentTracksLabel.isHidden = false
                    weakSelf.recentTracksCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
                } else {
                    weakSelf.noRecentTracksLabel.isHidden = true
                }
                weakSelf.recentTracksCollectionView.reloadData()
            }
            weakSelf.group.leave()
        }
    }
    
    func fetchTopArtistsData() {
        viewModel.fetchAPIData(apiParams: viewModel.topArtistsParams) { [weak self] error in
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                if weakSelf.viewModel.topArtistsDataSource.isEmpty {
                    weakSelf.noTopArtistsLabel.isHidden = false
                    weakSelf.topArtistsCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
                } else {
                    weakSelf.noTopArtistsLabel.isHidden = true
                }
                weakSelf.topArtistsCollectionView.reloadData()
            }
            weakSelf.group.leave()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recentTracksCollectionView {
            let numOfItems = self.viewModel.recentTracksDataSource.count
            return numOfItems
        } else {
            let numOfItems = self.viewModel.topArtistsDataSource.count
            return numOfItems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = UICollectionViewCell()
        
        if collectionView == self.recentTracksCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentTracksCollectionViewCell.reuseIdentifier, for: indexPath) as? RecentTracksCollectionViewCell else {
                return collectionViewCell }
            cell.showAnimatedGradientSkeleton()
            let track = self.viewModel.recentTracksDataSource[indexPath.row]
            guard let trackCover = track.image?[3].imageUrl, let trackName = track.name, let artist = track.artist?.artistName else { return collectionViewCell }
            DispatchQueue.main.async {
                cell.hideSkeleton()
                cell.configureCell(trackCover: trackCover, trackName: trackName, artist: artist)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTopArtistsCollectionViewCell.reuseIdentifier, for: indexPath) as? UserTopArtistsCollectionViewCell else {
                return collectionViewCell }
            cell.showAnimatedGradientSkeleton()
            let artist = self.viewModel.topArtistsDataSource[indexPath.row]
            guard let artistAvatar = artist.image?[3].imageUrl, let artistName = artist.name, let playCount = artist.playCount else { return collectionViewCell }
            DispatchQueue.main.async {
                cell.hideSkeleton()
                cell.configureCell(artistAvatar: artistAvatar, artistName: artistName, playCount: playCount)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.recentTracksCollectionView {
            let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
            
            if #available(iOS 13.0, *) {
                let playerVC = storyboard.instantiateViewController(identifier: AppConstants.StoryboardID.musicPlayerViewController) as MusicPlayerViewController
                var importingSongList = [ImportedPlayingSong]()
                for song in viewModel.recentTracksDataSource {
                    if let songName = song.name,
                       let singerName = song.artist?.artistName {
                        let singleSongInfo = ImportedPlayingSong(songName: songName, singerName: singerName)
                        importingSongList.append(singleSongInfo)
                    }
                }
                playerVC.receivedSongList = importingSongList
                playerVC.receivedIndex = indexPath.row
                
                navigationController?.pushViewController(playerVC, animated: true)
            }
        } else {
            let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
            let artistVC = storyboard.instantiateViewController(identifier: AppConstants.StoryboardID.artistDetailViewController) as ArtistDetailViewController
            guard let singerName = self.viewModel.topArtistsDataSource[indexPath.row].name else { return }
            let artist = Artist(name: singerName, reference: "", url: nil, image: nil)
            artistVC.artist = artist
            navigationController?.pushViewController(artistVC, animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func fetchTopTracksData() {
        viewModel.fetchAPIData(apiParams: viewModel.topTracksParams) { [weak self] error in
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                if weakSelf.viewModel.topTracksDataSource.isEmpty {
                    weakSelf.noTopTracksLabel.isHidden = false
                    weakSelf.topTracksTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
                } else {
                    weakSelf.noTopTracksLabel.isHidden = true
                }
                weakSelf.topTracksTableView.reloadData()
            }
            weakSelf.group.leave()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfItems = viewModel.topTracksDataSource.count
        return numOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTopTracksTableViewCell.reuseIdentifier, for: indexPath) as? UserTopTracksTableViewCell else {
            return tableViewCell }
        cell.showAnimatedGradientSkeleton()
        let track = self.viewModel.topTracksDataSource[indexPath.row]
        guard let trackCover = track.image?[3].imageUrl, let trackName = track.name, let artist = track.artist?.name, let duration = track.duration else { return tableViewCell }
        DispatchQueue.main.async {
            cell.hideSkeleton()
            cell.configureCell(trackCover: trackCover, trackName: trackName, artist: artist, duration: duration)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        if #available(iOS 13.0, *) {
            let playerVC = storyboard.instantiateViewController(identifier: AppConstants.StoryboardID.musicPlayerViewController) as MusicPlayerViewController
            
            var importingSongList = [ImportedPlayingSong]()
            for song in viewModel.topTracksDataSource {
                if let songName = song.name,
                   let singerName = song.artist?.name {
                    let singleSongInfo = ImportedPlayingSong(songName: songName, singerName: singerName)
                    importingSongList.append(singleSongInfo)
                }
            }
            playerVC.receivedSongList = importingSongList
            playerVC.receivedIndex = indexPath.row
            
            navigationController?.pushViewController(playerVC, animated: true)
        } else {
            // lower 13.0
        }
    }
}
