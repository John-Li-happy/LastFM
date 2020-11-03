//
//  TopAlbumsViewController.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/8/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SkeletonView
import UIKit

class TopAlbumsViewController: UIViewController {
    let topAlbumViewModel = TopAlbumViewModel()
    var pendingWorkItem: DispatchWorkItem?
    let searchResultRowHeight: CGFloat = 40
    var newTrendingAccomplished = false
    var topPopularAccomplished = false
    var newTrendingShowAllFlag = true
    var topAlbumsShowAllFlag = true
    var newTrendingLargerHeightConstraint = NSLayoutConstraint()
    var newTrendingSmallerHeightConstraint = NSLayoutConstraint()
    var topAlbumsLabelUpperTopConstraint = NSLayoutConstraint()
    var newTrendingDataFetchAccomplished = false
    var topAlbumDataFetchAccomplished = false
    let searchBar = UISearchBar()
    var blurEffectView = UIVisualEffectView()
    
    @IBOutlet weak private var newTrendingAlbumsCollectionView: UICollectionView! {
        didSet {
            newTrendingAlbumsCollectionView.delegate = self
            newTrendingAlbumsCollectionView.dataSource = self
            newTrendingAlbumsCollectionView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak private var topAlbumsCollectionView: UICollectionView! {
        didSet {
            topAlbumsCollectionView.delegate = self
            topAlbumsCollectionView.dataSource = self
            topAlbumsCollectionView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private var searchButton: UIBarButtonItem!
    @IBOutlet weak private var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.delegate = self
            searchResultTableView.dataSource = self
            searchResultTableView.isHidden = true
            searchResultTableView.rowHeight = searchResultRowHeight
            searchResultTableView.layer.zPosition = 100
        }
    }
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var newTrendingViewAllButton: UIButton! {
        didSet {
            newTrendingViewAllButton.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var topAlbumsLabel: UILabel!
    @IBOutlet weak private var topAlbumsViewAllButton: UIButton! {
        didSet {
            topAlbumsViewAllButton.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak private var newTrendingErrorCoverImage: UIImageView!
    @IBOutlet weak private var topAlbumErrorCoverImage: UIImageView!
        
    private func initialUISettings() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "Albums"
        constraintsSets()
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.layer.zPosition = 50
        blurEffectView.tag = 100
        blurEffectView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.rightBarButtonItem = searchButton
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
            searchResultTableView.isHidden = true
            navigationItem.titleView = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = nil
        topAlbumViewModel.searchedSongList.removeAll()
        searchResultTableView.reloadData()
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
            searchResultTableView.isHidden = true
            navigationItem.titleView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISettings()
        fetchTopPopularData()
        fetchNewTrendingData()
    }
    
    @IBAction private func topAlbumViewAllButtonTapped(_ sender: UIButton) {
        if topAlbumsShowAllFlag {
            topAlbumsShowAllFlag = false
            topAlbumsViewAllButton.setTitle("Show Less", for: .normal)
            contentView.addConstraint(topAlbumsLabelUpperTopConstraint)
            scrollView.isScrollEnabled = false
        } else {
            topAlbumsShowAllFlag = true
            topAlbumsViewAllButton.setTitle("View All", for: .normal)
            contentView.removeConstraint(topAlbumsLabelUpperTopConstraint)
            scrollView.isScrollEnabled = true
        }
    }
    
    @IBAction private func newTrendingViewAllButtonTapped(_ sender: UIButton) {
        if newTrendingShowAllFlag {
            newTrendingViewAllButton.setTitle("Show Less", for: .normal)
            newTrendingShowAllFlag = false
            contentView.removeConstraint(newTrendingSmallerHeightConstraint)
            contentView.addConstraint(newTrendingLargerHeightConstraint)
            if let layout = newTrendingAlbumsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
            scrollView.isScrollEnabled = false
        } else {
            newTrendingShowAllFlag = true
            newTrendingViewAllButton.setTitle("View All", for: .normal)
            contentView.removeConstraint(newTrendingLargerHeightConstraint)
            contentView.addConstraint(newTrendingSmallerHeightConstraint)
            if let layout = newTrendingAlbumsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            scrollView.isScrollEnabled = true
        }
        newTrendingAlbumsCollectionView.reloadData()
    }
    
    private func constraintsSets() {
        newTrendingLargerHeightConstraint = NSLayoutConstraint(item: newTrendingAlbumsCollectionView ?? UIView(),
                                                               attribute: .height,
                                                               relatedBy: .equal,
                                                               toItem: nil,
                                                               attribute: .height,
                                                               multiplier: 1,
                                                               constant: view.frame.height - 200)
        newTrendingSmallerHeightConstraint = NSLayoutConstraint(item: newTrendingAlbumsCollectionView ?? UIView(),
                                                                attribute: .height,
                                                                relatedBy: .equal,
                                                                toItem: nil,
                                                                attribute: .height,
                                                                multiplier: 1,
                                                                constant: 200)
        contentView.addConstraint(newTrendingSmallerHeightConstraint)
        topAlbumsLabelUpperTopConstraint = NSLayoutConstraint(item: topAlbumsLabel ?? UIView(),
                                                              attribute: .top,
                                                              relatedBy: .equal,
                                                              toItem: contentView,
                                                              attribute: .top,
                                                              multiplier: 1,
                                                              constant: 12)
    }
    
    private func fetchNewTrendingData() {
        topAlbumViewModel.parseNewTrendingAlbums { error in
            DispatchQueue.main.async {
                if error == nil {
                    self.newTrendingAlbumsCollectionView.reloadData()
                    self.newTrendingAccomplished = true
                    self.newTrendingDataFetchAccomplished = true
                    self.newTrendingAlbumsCollectionView.isUserInteractionEnabled = true
                    self.newTrendingViewAllButton.isUserInteractionEnabled = true
                } else {
                   self.newTrendingErrorCoverImage.image = UIImage(imageLiteralResourceName: AppConstants.ImageName.errorCoverImageViewName)
                   AlertManager.alert(forWhichPage: self, alertType: .invalidImage, alertMessage: "Unfetched Info", handler: nil)
               }
            }
        }
    }
    
    private func fetchTopPopularData() {
        topAlbumViewModel.parseTopPopularAlbum { error in
            DispatchQueue.main.async {
                if error == nil {
                    self.topAlbumsCollectionView.reloadData()
                    self.topPopularAccomplished = true
                    self.topAlbumDataFetchAccomplished = true
                    self.topAlbumsCollectionView.isUserInteractionEnabled = true
                    self.topAlbumsViewAllButton.isUserInteractionEnabled = true
                } else {
                    self.topAlbumErrorCoverImage.image = UIImage(imageLiteralResourceName: AppConstants.ImageName.errorCoverImageViewName)
                    AlertManager.alert(forWhichPage: self, alertType: .invalidImage, alertMessage: "Unfetched Info", handler: nil)
                }
            }
        }
    }
}

extension TopAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == newTrendingAlbumsCollectionView {
            let returnIdentifier = NewTrendingAlbumCollectionViewCell.reuseIdentifier
            return returnIdentifier
        } else {
            let returnIdentifier = TopPopularAlbumsCollectionViewCell.reuseIdentifier
            return returnIdentifier
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newTrendingAlbumsCollectionView {
            if topAlbumViewModel.newTrendingAlbumsDataSource.count < 3 {
                let three = 3
                return three
            } else {
                return topAlbumViewModel.newTrendingAlbumsDataSource.count
            }
        } else {
            if topAlbumViewModel.topPopularAlbumDataSource.count < 4 {
                let four = 4
                return four
            } else {
                return topAlbumViewModel.topPopularAlbumDataSource.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newTrendingAlbumsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewTrendingAlbumCollectionViewCell.reuseIdentifier, for: indexPath) as? NewTrendingAlbumCollectionViewCell else {
                return UICollectionViewCell() }
            cell.showAnimatedGradientSkeleton()
            if topAlbumViewModel.newTrendingAlbumsDataSource.count > 3 {
                let singleDataSource = topAlbumViewModel.newTrendingAlbumsDataSource[indexPath.row]
                cell.hideSkeleton()
                cell.configureNewTrendingCell(albumName: singleDataSource.name, artistName: singleDataSource.artist, headShotImage: singleDataSource.image, imageStatus: newTrendingShowAllFlag)
                return cell
            } else {
                cell.configureNewTrendingCell(albumName: "Album Name", artistName: "Singer Name", headShotImage: UIImage(), imageStatus: true)
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPopularAlbumsCollectionViewCell.reuseIdentifier, for: indexPath) as? TopPopularAlbumsCollectionViewCell else {
                return UICollectionViewCell() }
            cell.showAnimatedGradientSkeleton()
            if topAlbumViewModel.topPopularAlbumDataSource.count > 4 {
                let singleDataSouce = topAlbumViewModel.topPopularAlbumDataSource[indexPath.row]
                cell.hideSkeleton()
                cell.configureTopPopularCell(albumName: singleDataSouce.name, artistName: singleDataSouce.artist, headShotImage: singleDataSouce.image)
                return cell
            } else {
                cell.configureTopPopularCell(albumName: "AlbumName", artistName: "SingerName", headShotImage: UIImage())
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if let detailViewController = storyboard?.instantiateViewController(identifier: AppConstants.StoryboardID.albumDetailViewController) as? AlbumDetailViewController {
                if collectionView == newTrendingAlbumsCollectionView {
                    detailViewController.receivedAlbumName = topAlbumViewModel.newTrendingAlbumsDataSource[indexPath.row].name
                    detailViewController.receivedSingerName = topAlbumViewModel.newTrendingAlbumsDataSource[indexPath.row].artist
                } else {
                    detailViewController.receivedSingerName = topAlbumViewModel.topPopularAlbumDataSource[indexPath.row].artist
                    detailViewController.receivedAlbumName = topAlbumViewModel.topPopularAlbumDataSource[indexPath.row].name
                }
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        } else {
            // what if the iOS is not higher
        }
    }
}

extension TopAlbumsViewController: UISearchBarDelegate {
    @IBAction private func searchButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = nil
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.tintColor = UIColor.white
        searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.setRightBarButton(searchButton, animated: true)
        if let blurredView = view.viewWithTag(100) {
            blurredView.removeFromSuperview()
        }
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.text = nil
        }
        searchResultTableView.isHidden = true
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = searchButton
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = false
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(searchResultTableView)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingWorkItem?.cancel()
        pendingWorkItem = DispatchWorkItem {
            self.resultLoader(searchQuery: searchText)
        }
        guard let pendingWorkItem = pendingWorkItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: pendingWorkItem)
    }
    
    private func resultLoader(searchQuery: String) {
        guard let navBarHeight = self.navigationController?.navigationBar.frame.size.height else { return }
        let searchResultYPoint = navBarHeight + 40
        let searchResultWidth = self.view.frame.width - 50
        let searchResultXPoint = (view.frame.width - searchResultWidth) / 2
        topAlbumViewModel.parseSearchedResults(searchQuery: searchQuery) { searchedSongList in
            DispatchQueue.main.async {
                if self.topAlbumViewModel.searchedSongList.count > 5 {
                    self.searchResultTableView.frame = CGRect(x: searchResultXPoint, y: searchResultYPoint, width: searchResultWidth, height: self.searchResultRowHeight * 5 + 10)
                } else if 1...4 ~= self.topAlbumViewModel.searchedSongList.count {
                    self.searchResultTableView.frame = CGRect(
                        x: searchResultXPoint,
                        y: searchResultYPoint,
                        width: searchResultWidth,
                        height: CGFloat(self.topAlbumViewModel.searchedSongList.count) * self.searchResultRowHeight)
                } else if self.topAlbumViewModel.searchedSongList.isEmpty {
                    self.searchResultTableView.frame = CGRect(x: searchResultXPoint, y: searchResultYPoint, width: searchResultWidth, height: 0)
                }
                self.searchResultTableView.reloadData()
                self.searchResultTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            }
        }
    }
}

extension TopAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let counter = topAlbumViewModel.searchedSongList.count
        return counter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumSearchResultTableViewCell.reuseIdentifier, for: indexPath) as? AlbumSearchResultTableViewCell else {
            return UITableViewCell() }
        if let name = topAlbumViewModel.searchedSongList[indexPath.row].name {
            cell.configureCell(name: name)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
        if #available(iOS 13.0, *) {
            let searchedResultViewController = storyboard.instantiateViewController(identifier: "SearchedResultViewController") as SearchedResultViewController
            
            if let songName = topAlbumViewModel.searchedSongList[indexPath.row].name {
                searchedResultViewController.receivedString = songName as NSString
                searchedResultViewController.testValue = true
            }
            navigationController?.pushViewController(searchedResultViewController, animated: true)
        }
    }
}
