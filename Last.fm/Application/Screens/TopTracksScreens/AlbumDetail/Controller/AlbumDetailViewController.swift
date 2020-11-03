//
//  AlbumViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

@objc class AlbumDetailViewController: UIViewController {
    @objc var receivedAlbumName = String()
    @objc var receivedSingerName = String()
    let albumDetailViewModel = AlbumDetailViewModel()
    let blurredView = BlurredView()
    let trackTableView = UITableView()
    let searchTableView = UITableView()
    var loadingLabel = UILabel()
    var blurEffectView = UIVisualEffectView()
    var numberOfRows = 0
    var searchButtonItem = UIBarButtonItem()
    var searchBar = UISearchBar()
    var pendingWorkItem: DispatchWorkItem?
    var searchTableHeightCosntraint = NSLayoutConstraint()
    var searchResultRowHeight = 40
    var searchedResultShowDataFlag = true
    var temInt = Int()
    
    private func initialUISettings() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nodataSHown), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(enableRotattion), name: Notification.Name("ChannalMusicPlayerDisAppeared"), object: nil)
        view.backgroundColor = .init(red: 24 / 255, green: 27 / 255, blue: 44 / 255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        // blurred View ( for popup ) init
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.layer.zPosition = 50
        blurEffectView.tag = 100
        blurEffectView.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(blurredViewRemove), name: Notification.Name("ChannalBlurView"), object: nil)
        
        //error handler UI setting
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = UIColor.white
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 21)
        loadingLabel.isHidden = true
        view.addSubview(loadingLabel)
        
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        // MARK: - loadingLabel Constraint
        let loadingLabelXConstraint = NSLayoutConstraint(item: loadingLabel, attribute: .centerX, relatedBy: .equal, toItem: trackTableView, attribute: .centerX, multiplier: 1, constant: 0)
        let loadingLabelYConstraint = NSLayoutConstraint(item: loadingLabel, attribute: .centerY, relatedBy: .equal, toItem: trackTableView, attribute: .centerY, multiplier: 1, constant: 0)
        let loadingLabelWidthConstraint = NSLayoutConstraint(item: loadingLabel, attribute: .width, relatedBy: .equal, toItem: trackTableView, attribute: .width, multiplier: 1, constant: 0)
        let loadingLabelHeightConstraint = NSLayoutConstraint(item: loadingLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)

        view.addConstraints([
            loadingLabelXConstraint,
            loadingLabelYConstraint,
            loadingLabelWidthConstraint,
            loadingLabelHeightConstraint
        ])
    }
    
    private func initialViewsUISetUp() {
        blurredView.delegate = self
        view.addSubview(blurredView)
        
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        // MARK: - blurredView Constraint
        let blurredViewTopConstraint = NSLayoutConstraint(item: blurredView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let blurredViewLeadingConstraint = NSLayoutConstraint(item: blurredView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let blurredViewtrailingConstraint = NSLayoutConstraint(item: blurredView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let blurredViewHeightConstraint = NSLayoutConstraint(item: blurredView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 200)
        
        view.addConstraints([
            blurredViewTopConstraint,
            blurredViewHeightConstraint,
            blurredViewLeadingConstraint,
            blurredViewtrailingConstraint
        ])
        
        trackTableView.delegate = self
        trackTableView.dataSource = self
        trackTableView.rowHeight = 60
        view.addSubview(trackTableView)
        trackTableView.backgroundColor = .clear
        trackTableView.register(AlbumTracksTableViewCell.self, forCellReuseIdentifier: AlbumTracksTableViewCell.reuseIdentifier)
        
        trackTableView.translatesAutoresizingMaskIntoConstraints = false
        // MARK: - trackTableVIew Constraint
        let tableViewTopConstraint = NSLayoutConstraint(item: trackTableView, attribute: .top, relatedBy: .equal, toItem: blurredView, attribute: .bottom, multiplier: 1, constant: 10)
        let tableViewBottomConstraint = NSLayoutConstraint(item: trackTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let tableViewTrailingConstraint = NSLayoutConstraint(item: trackTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let tableViewLeadingConstraint = NSLayoutConstraint(item: trackTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        
        view.addConstraints([
            tableViewTopConstraint,
            tableViewBottomConstraint,
            tableViewTrailingConstraint,
            tableViewLeadingConstraint
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewsSetUp()
        fethcDetailData()
        initialViewsUISetUp()
        initialUISettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.rightBarButtonItem = searchButtonItem
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
            searchTableView.isHidden = true
            navigationItem.titleView = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = nil
        albumDetailViewModel.searchedSongList.removeAll()
        searchTableView.reloadData()
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
            searchTableView.isHidden = true
            navigationItem.titleView = nil
        }
    }
    
    @objc private func searchButtonTapped() {
        searchedResultShowDataFlag = true
        navigationItem.rightBarButtonItems = []
        self.navigationItem.setHidesBackButton(true, animated: true)
        //text field
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder() // test for editing
    }
    
    private func searchViewsSetUp() {
        searchButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        searchButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = searchButtonItem
        
        // search Table View
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.rowHeight = 40
        searchTableView.isHidden = true
        view.addSubview(searchTableView)
        view.bringSubviewToFront(searchTableView)
        searchTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
// MARK: - searchTableView Constraint
        let searchTableViewTopConstraint = NSLayoutConstraint(item: searchTableView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let searchTableViewWidthConstraint = NSLayoutConstraint(item: searchTableView,
                                                                attribute: .width,
                                                                relatedBy: .equal,
                                                                toItem: view.safeAreaLayoutGuide,
                                                                attribute: .width,
                                                                multiplier: 1,
                                                                constant: -50)
        searchTableHeightCosntraint = NSLayoutConstraint(item: searchTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 210)
        let searchTableViewCenterXConstraint = NSLayoutConstraint(item: searchTableView,
                                                                  attribute: .centerX,
                                                                  relatedBy: .equal,
                                                                  toItem: view.safeAreaLayoutGuide,
                                                                  attribute: .centerX,
                                                                  multiplier: 1,
                                                                  constant: 0)
        
        view.addConstraints([
            searchTableViewTopConstraint,
            searchTableViewWidthConstraint,
            searchTableHeightCosntraint,
            searchTableViewCenterXConstraint
        ])
    }
    
    @objc private func nodataSHown() {
        if trackTableView.visibleCells.isEmpty {
            loadingLabel.isHidden = false
        } else {
            loadingLabel.isHidden = true
        }
    }
    
    func presentMusicPlayer(importIndex: Int, importedSongList: [ImportedPlayingSong]) {
        let storyBoard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        guard let playerVC = storyBoard.instantiateViewController(identifier: AppConstants.StoryboardID.musicPlayerViewController) as? MusicPlayerViewController else { return }
        playerVC.receivedSongList = importedSongList
        playerVC.receivedIndex = importIndex
        let newNavC = UINavigationController(rootViewController: playerVC)
        self.present(newNavC, animated: true, completion: nil)
        self.addBlurredView()
    }
}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == trackTableView {
            let counter = albumDetailViewModel.validAlbumTrackdetailDataSource.count
            return counter
        } else {
            if searchedResultShowDataFlag {
                let counter = albumDetailViewModel.searchedSongList.count
                return counter
            } else {
                let counter = 0
                return counter
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == trackTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTracksTableViewCell.reuseIdentifier) as? AlbumTracksTableViewCell else {
                return UITableViewCell() }
            let singleTrack = albumDetailViewModel.validAlbumTrackdetailDataSource[indexPath.row]
            cell.delegate = self
            cell.selectedRow = indexPath.row
            cell.songName = singleTrack.trackName
            cell.singerName = singleTrack.trackSingerName
            cell.configureCell(songName: singleTrack.trackName, duration: singleTrack.trackDuration)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
            if let name = albumDetailViewModel.searchedSongList[indexPath.row].name {
                cell.configureCell(name: name)
            } else {
                cell.configureCell(name: "Unfetched Track Name")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        
        if tableView == trackTableView {
            var importedSongList = [ImportedPlayingSong]()
            for song in albumDetailViewModel.validAlbumTrackdetailDataSource {
                let singleSong = ImportedPlayingSong(songName: song.trackName, singerName: song.trackSingerName)
                importedSongList.append(singleSong)
            }
            presentMusicPlayer(importIndex: indexPath.row, importedSongList: importedSongList)
        } else {
            if #available(iOS 13.0, *) {
                let searchedResultViewController = storyBoard.instantiateViewController(identifier: "SearchedResultViewController") as SearchedResultViewController
                if let songName = self.albumDetailViewModel.searchedSongList[indexPath.row].name {
                    searchedResultViewController.receivedString = songName as NSString
                } else {
                    searchedResultViewController.receivedString = " "
                }
                navigationController?.pushViewController(searchedResultViewController, animated: true)
            }
        }
    }
}

extension AlbumDetailViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.setHidesBackButton(false, animated: true)
        navigationItem.rightBarButtonItem = searchButtonItem
        searchTableView.isHidden = true
        navigationItem.titleView = nil
        searchBar.text = nil
        searchedResultShowDataFlag = false
        searchTableView.reloadData()
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
        }
        view.bringSubviewToFront(trackTableView)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTableView.isHidden = false
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 100
        blurEffectView.isUserInteractionEnabled = true
        view.addSubview(blurEffectView)
// MARK: - blurredEffectView constraint
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        let blurrdEffectTopConstraint = NSLayoutConstraint(item: blurEffectView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let blurrdEffectLeadingConstraint = NSLayoutConstraint(item: blurEffectView,
                                                               attribute: .leading,
                                                               relatedBy: .equal,
                                                               toItem: view,
                                                               attribute: .leading,
                                                               multiplier: 1,
                                                               constant: 0)
        let blurrdEffectTrailingConstraint = NSLayoutConstraint(item: blurEffectView,
                                                                attribute: .trailing,
                                                                relatedBy: .equal,
                                                                toItem: view,
                                                                attribute: .trailing,
                                                                multiplier: 1,
                                                                constant: 0)
        let blurrdEffectBottomConstraint = NSLayoutConstraint(item: blurEffectView,
                                                              attribute: .bottom,
                                                              relatedBy: .equal,
                                                              toItem: view.safeAreaLayoutGuide,
                                                              attribute: .bottom,
                                                              multiplier: 1,
                                                              constant: 0)
        
        view.addConstraints([
            blurrdEffectTopConstraint,
            blurrdEffectLeadingConstraint,
            blurrdEffectTrailingConstraint,
            blurrdEffectBottomConstraint
        ])
        view.bringSubviewToFront(searchTableView)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingWorkItem?.cancel()
        pendingWorkItem = DispatchWorkItem {
            self.resultLoader(searchQuery: searchText)
        }
        guard let pendingWorkItem = pendingWorkItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: pendingWorkItem)
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
    
    private func resultLoader(searchQuery: String) {
        albumDetailViewModel.parseSearchedResults(searchQuery: searchQuery) { _ in
            DispatchQueue.main.async {
                for constraint in self.view.constraints where constraint == self.searchTableHeightCosntraint {
                    self.view.removeConstraint(self.searchTableHeightCosntraint)
                }
                // MARK: - searchTableHeight change
                if self.albumDetailViewModel.searchedSongList.count > 5 {
                    self.searchTableHeightCosntraint = NSLayoutConstraint(item: self.searchTableView,
                                                                          attribute: .height,
                                                                          relatedBy: .equal,
                                                                          toItem: nil,
                                                                          attribute: .height,
                                                                          multiplier: 1,
                                                                          constant: CGFloat(self.searchResultRowHeight * 5 + 10))
                     self.view.addConstraint(self.searchTableHeightCosntraint)
                } else if 1...4 ~= self.albumDetailViewModel.searchedSongList.count {
                    self.searchTableHeightCosntraint = NSLayoutConstraint(item: self.searchTableView,
                                                                          attribute: .height,
                                                                          relatedBy: .equal,
                                                                          toItem: nil,
                                                                          attribute: .height,
                                                                          multiplier: 1,
                                                                          constant: CGFloat(self.searchResultRowHeight) * CGFloat(self.albumDetailViewModel.searchedSongList.count) + 10)
                    self.view.addConstraint(self.searchTableHeightCosntraint)
                } else if self.albumDetailViewModel.searchedSongList.isEmpty {
                    self.searchTableHeightCosntraint = NSLayoutConstraint(item: self.searchTableView,
                                                                          attribute: .height,
                                                                          relatedBy: .equal,
                                                                          toItem: nil,
                                                                          attribute: .height,
                                                                          multiplier: 1,
                                                                          constant: 0)
                    self.view.addConstraint(self.searchTableHeightCosntraint)
                }
                self.searchTableView.reloadData()
                self.searchTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            }
        }
    }
}
