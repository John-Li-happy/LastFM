//
//  DiscoverViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SkeletonView
import SwiftyGif
import UIKit

class DiscoverViewController: UIViewController, SwiftyGifDelegate {
    let logoAnimationView = LogoAnimationView()
    let topViewModel = TopViewModel()
    var pendingWorkItem: DispatchWorkItem?
    let searchResultRowHeight: CGFloat = 40
    let searchBar = UISearchBar()
    var searchTableHeightCosntraint = NSLayoutConstraint()
    var blurEffectView = UIVisualEffectView()
    
    @IBOutlet weak private var topSongCollectionView: UICollectionView! {
        didSet {
            topSongCollectionView.delegate = self
            topSongCollectionView.dataSource = self
            topSongCollectionView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var popularSongTableVIew: UITableView! {
        didSet {
            popularSongTableVIew.isUserInteractionEnabled = false
            popularSongTableVIew.delegate = self
            popularSongTableVIew.dataSource = self
            popularSongTableVIew.rowHeight = 60
        }
    }
    @IBOutlet weak private var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.isHidden = true
            searchResultTableView.delegate = self
            searchResultTableView.dataSource = self
            searchResultTableView.tableHeaderView = nil
            searchResultTableView.layer.zPosition = 100
        }
    }
    @IBOutlet weak private var mostPopularLabel: UILabel! {
        didSet {
            mostPopularLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    @IBOutlet weak private var forYouLabel: UILabel! {
        didSet {
            forYouLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet weak private var errorTableViewCoverImageView: UIImageView!
    @IBOutlet weak private var errorColllectionViewCoverImageView: UIImageView!
    @IBOutlet private var searchButton: UIBarButtonItem!
    
    private func initialUISetting() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Discover"
        //Blurview settings
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.layer.zPosition = 50
        blurEffectView.tag = 100
        blurEffectView.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(blurredViewRemove), name: Notification.Name("ChannalBlurView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableRotattion), name: Notification.Name("ChannalMusicPlayerDisAppeared"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.isLoginRootVC == false && AppDelegate.showAnimatedView {
            logoAnimationView.logoGifImageView.startAnimatingGif()
        }
        blurredViewRemove()
        navigationItem.rightBarButtonItem = searchButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetting()
        enableRotattion()
        fetchTopSongs()
        fetchPopularSongs()
        if AppDelegate.isLoginRootVC == false && AppDelegate.showAnimatedView {
            view.addSubview(logoAnimationView)
            logoAnimationView.pinEdgesToSuperView()
            logoAnimationView.logoGifImageView.delegate = self
            tabBarController?.tabBar.isTranslucent = true
        }
    }
    
    @IBAction private func searchButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = []
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder() // test for editing
    }
    
    func gifDidStart(sender: UIImageView) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.isHidden = false
        AppDelegate.showAnimatedView = false
    }
    
    private func fetchTopSongs() {
        topViewModel.parseTopSongs { [weak self] error  in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .invalidImage, handler: nil)
                    weakSelf.errorTableViewCoverImageView.image = UIImage(imageLiteralResourceName: AppConstants.ImageName.errorCoverImageViewName)
                }
                weakSelf.topSongCollectionView.reloadData()
                weakSelf.topSongCollectionView.isUserInteractionEnabled = true
            }
        }
    }
    
    private func fetchPopularSongs() {
        topViewModel.parsePopularSongs { [weak self] error in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .invalidImage, handler: nil)
                    weakSelf.errorColllectionViewCoverImageView.image = UIImage(imageLiteralResourceName: AppConstants.ImageName.errorCoverImageViewName)
                }
                self?.popularSongTableVIew.reloadData()
                self?.popularSongTableVIew.isUserInteractionEnabled = true
            }
        }
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
            let returnIdentifier = TopForYouCollectionViewCell.reuseIdentifier
            return returnIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let counter = topViewModel.topSongList.count
        if counter > 4 {
            return counter
        } else {
            let four = 4
            return four
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: TopForYouCollectionViewCell.reuseIdentifier, for: indexPath) as?
            TopForYouCollectionViewCell else {
            return UICollectionViewCell()
        }
        item.showAnimatedGradientSkeleton()
        if topViewModel.topSongList.count > 4 {
            if let image = topViewModel.topSongList[indexPath.row].headShot,
                let songName = topViewModel.topSongList[indexPath.row].songName,
                let singername = topViewModel.topSongList[indexPath.row].singer {
                item.hideSkeleton()
                item.configureCell(inputImage: image, inputSongName: songName, inputArtistName: singername)
            }
            return item
        } else {
            item.configureCell(inputImage: UIImage(), inputSongName: "Song name", inputArtistName: "SingerName")
            return item
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)

        if #available(iOS 13.0, *) {
            let playerVC = storyboard.instantiateViewController(identifier: AppConstants.StoryboardID.musicPlayerViewController) as MusicPlayerViewController
            var importingSongList = [ImportedPlayingSong]()
            for song in topViewModel.topSongList {
                if let songName = song.songName,
                   let singerName = song.singer {
                    let singleSongInfo = ImportedPlayingSong(songName: songName, singerName: singerName)
                    importingSongList.append(singleSongInfo)
                }
            }
            playerVC.receivedSongList = importingSongList
            playerVC.receivedIndex = indexPath.row
            
            let newNavC = UINavigationController(rootViewController: playerVC)
            disableRotation()
            self.present(newNavC, animated: true, completion: nil)
            view.addSubview(blurEffectView)
        }
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let returnIdentifier = GeoPopularSongsTableViewCell.reuseIdentifier
        return returnIdentifier
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == popularSongTableVIew {
            let counter = topViewModel.popularSongList.count
            if counter > 8 {
                return counter
            } else {
                let eight = 8
                return eight
            }
        } else {
            let counter = topViewModel.searchedSongList.count
            return counter
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == popularSongTableVIew {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GeoPopularSongsTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? GeoPopularSongsTableViewCell else {
                return UITableViewCell()}
            cell.showAnimatedGradientSkeleton()
            if topViewModel.popularSongList.count > 8 {
                if let image = topViewModel.popularSongList[indexPath.row].headShot,
                    let songName = topViewModel.popularSongList[indexPath.row].songName,
                    let singerName = topViewModel.popularSongList[indexPath.row].singer,
                    let duration = topViewModel.popularSongList[indexPath.row].duration {
                    cell.hideSkeleton()
                    cell.configureCell(songName: songName, headShotImage: image, singerName: singerName, durationTime: duration)
                } else {
                    cell.configureCell(songName: "Song Name", headShotImage: UIImage(), singerName: "Singer Name", durationTime: "Duration")
                }
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchSimiliarSongsTableViewCell.reuseIdentifier, for: indexPath) as? SearchSimiliarSongsTableViewCell else {
                return UITableViewCell() }
            if let name = topViewModel.searchedSongList[indexPath.row].name {
                cell.configureCell(songName: name)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        if tableView == popularSongTableVIew {
            if #available(iOS 13.0, *) {
                let playerViewController = storyboard.instantiateViewController(identifier: AppConstants.StoryboardID.musicPlayerViewController) as MusicPlayerViewController
                var importingSongList = [ImportedPlayingSong]()
                for song in topViewModel.popularSongList {
                    if let songName = song.songName,
                       let singerName = song.singer {
                        let singleSongInfo = ImportedPlayingSong(songName: songName, singerName: singerName)
                        importingSongList.append(singleSongInfo)
                    }
                }
                playerViewController.receivedSongList = importingSongList
                playerViewController.receivedIndex = indexPath.row
                
                let newNavC = UINavigationController(rootViewController: playerViewController)
                disableRotation()
                self.present(newNavC, animated: true, completion: nil)
                self.addBlurredView()
            }
        } else {
            if #available(iOS 13.0, *) {
                let searchedResultViewController = storyboard.instantiateViewController(identifier: "SearchedResultViewController") as SearchedResultViewController
                
                if let songName = topViewModel.searchedSongList[indexPath.row].name {
                    searchedResultViewController.receivedString = songName as NSString
                    searchedResultViewController.testValue = true
                }
                navigationController?.pushViewController(searchedResultViewController, animated: true)
            }
        }
    }
}

extension DiscoverViewController: UISearchBarDelegate {    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingWorkItem?.cancel()
        pendingWorkItem = DispatchWorkItem {
            self.resultLoader(searchQuery: searchText)
        }
        guard let pendingWorkItem = pendingWorkItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: pendingWorkItem)
    }
    
    private func resultLoader(searchQuery: String) {
        topViewModel.parseSearchedResults(searchQuery: searchQuery) { searchedSongList in
            DispatchQueue.main.async {
                for constraint in self.view.constraints where constraint == self.searchTableHeightCosntraint {
                    self.view.removeConstraint(self.searchTableHeightCosntraint)
                }
                
                if self.topViewModel.searchedSongList.count > 5 {
                    self.searchTableHeightCosntraint = NSLayoutConstraint(item: self.searchResultTableView ?? UIView(),
                                                                          attribute: .height,
                                                                          relatedBy: .equal,
                                                                          toItem: nil,
                                                                          attribute: .height,
                                                                          multiplier: 1,
                                                                          constant: self.searchResultRowHeight * 5 + 10)
                     self.view.addConstraint(self.searchTableHeightCosntraint)
                } else if 1...4 ~= self.topViewModel.searchedSongList.count {
                    self.searchTableHeightCosntraint = NSLayoutConstraint(item: self.searchResultTableView ?? UIView(),
                                                                          attribute: .height,
                                                                          relatedBy: .equal,
                                                                          toItem: nil,
                                                                          attribute: .height,
                                                                          multiplier: 1,
                                                                          constant: self.searchResultRowHeight * CGFloat(self.topViewModel.searchedSongList.count) + 10)
                    self.view.addConstraint(self.searchTableHeightCosntraint)
                } else if self.topViewModel.searchedSongList.isEmpty {
                    self.searchTableHeightCosntraint = NSLayoutConstraint(item: self.searchResultTableView ?? UIView(),
                                                                          attribute: .height,
                                                                          relatedBy: .equal,
                                                                          toItem: nil,
                                                                          attribute: .height,
                                                                          multiplier: 1,
                                                                          constant: 0)
                    self.view.addConstraint(self.searchTableHeightCosntraint)
                }
                self.searchResultTableView.reloadData()
                self.searchResultTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = false
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(searchResultTableView)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.setRightBarButton(searchButton, animated: true)
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.text = nil
        }
        blurredViewRemove()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        if #available(iOS 13.0, *) {
            let searchedResultViewController = storyboard.instantiateViewController(identifier: "SearchedResultViewController") as SearchedResultViewController
            if let searchQuery = searchBar.text {
                searchedResultViewController.receivedString = searchQuery as NSString
                searchedResultViewController.testValue = true
                navigationController?.pushViewController(searchedResultViewController, animated: true)
            }
        }
    }
    
    @objc private func blurredViewRemove() {
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
            initialUISetting()
            searchResultTableView.isHidden = true
            navigationItem.titleView = nil
        }
    }
    @objc private func addBlurredView() {
        view.addSubview(blurEffectView)
    }
}
