//
//  ArtistDetailScreenViewController.swift
//  Last.fm
//
//  Created by Tong Yi on 8/27/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SkeletonView
import UIKit

class ArtistDetailViewController: UIViewController {
    var artist: Artist?
    let viewModel = ArtistDetailPageViewModel()
    var blurEffectView = UIVisualEffectView()
    var artistDetail: ArtistDetail?
    var tableViewFirstCellRowHeight: CGFloat = 200
    var tableViewThirdCellRowHeight: CGFloat = 180

    @IBOutlet weak private var artistImageView: UIImageView!
    @IBOutlet weak private var artistNameLabel: UILabel! {
        didSet {
            artistNameLabel.text = artist?.name
        }
    }
    @IBOutlet weak private var listenersNumLabel: UILabel! {
        didSet {
            listenersNumLabel.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak private var scrobblesNumLabel: UILabel! {
        didSet {
            scrobblesNumLabel.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak private var tableView: UITableView! 
    @IBOutlet weak private var playArtistButton: UIButton! {
        didSet {
            playArtistButton.isUserInteractionEnabled = false
        }
    }
    
    private func initialUIsettings() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.layer.zPosition = 50
        blurEffectView.tag = 100
        blurEffectView.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(blurredViewRemove), name: Notification.Name("ChannalBlurView"), object: nil)
        
        //flags settings
        ReloadFlags.artistTrackReloadFlag = 0
        ReloadFlags.artistAlbumReloadFlag = 0
        ReloadFlags.artistSimilarReloadFlag = 0
        
        ShowAllFlags.artistAlbumToAllFlag = true
        ShowAllFlags.artistTrackToAllFlag = true
        ShowAllFlags.artistSimilarToAllFlag = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUIsettings()
        setupTopViewUI()
        fetchArtistAlbumData()
        fetchArtistTopTracksData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction private func playArtistButtonTapped(_ sender: Any) {
        playTrack(indexPathRow: 0)
    }
    
    private func fetchArtistTopTracksData() {
        guard let artist = self.artist?.name else { return }
        viewModel.fetchArtistTopTracks(artistName: artist) { [weak self] error in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                ReloadFlags.artistTrackReloadFlag = 1
                weakSelf.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                weakSelf.playArtistButton.isUserInteractionEnabled = true
            }
        }
    }
    
    private func fetchArtistAlbumData() {
        guard let artist = self.artist?.name else { return }
        viewModel.fetchArtistTopAlbum(artistName: artist) {[weak self] error in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                ReloadFlags.artistAlbumReloadFlag = 1
                weakSelf.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
    }
    
    func setupTopViewUI() {
        guard let artist = self.artist else { return }
        viewModel.fetchArtisDetail(artistName: artist.name) { [weak self] artistDetail, error in
            guard let weakSelf = self, let artistDetail = artistDetail else { return }
            weakSelf.artistDetail = artistDetail
            
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                weakSelf.artistNameLabel.text = weakSelf.artist?.name
                weakSelf.scrobblesNumLabel.hideSkeleton()
                weakSelf.scrobblesNumLabel.text = accuracyFloat(number: artistDetail.scrolbbles)
                weakSelf.listenersNumLabel.hideSkeleton()
                weakSelf.listenersNumLabel.text = accuracyFloat(number: artistDetail.listeners)
                guard let cgImage = blurImage(image: artistDetail.headShot) else { return }
                weakSelf.artistImageView.image = UIImage(cgImage: cgImage)
                
                ReloadFlags.artistSimilarReloadFlag = 1
                weakSelf.tableView.reloadSections(IndexSet(integer: 2), with: .none)
            }
        }
    }
}

extension ArtistDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = Bundle.main.loadNibNamed(AppConstants.ArtistDetail.artistDetailViewForHeaderName, owner: nil, options: nil)?.first as? ViewForHeaderInSection else { return nil }
        
        switch section {
        case 0:
            view.configureHeaderView(sectionName: viewModel.sections[0])
            view.sectionTappedInt = 0
            
        case 1:
            view.configureHeaderView(sectionName: viewModel.sections[1])
            view.sectionTappedInt = 1
            
        default:
            view.configureHeaderView(sectionName: viewModel.sections[2])
            view.sectionTappedInt = 2
        }
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        AppConstants.ArtistDetail.heightForHeader
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return RowNumsForArtistDetailPage.topArtAlbumsOrSimilarArts.rawValue
            
        case 1:
            if ReloadFlags.artistTrackReloadFlag == 0 {
                let five = 5
                return five
            } else {
                if ShowAllFlags.artistTrackToAllFlag {
                    if viewModel.validArtistTopTrackList.count >= 5 {
                        let five = 5
                        return five
                    } else {
                        return viewModel.validArtistTopTrackList.count
                    }
                } else {
                    return viewModel.validArtistTopTrackList.count
                }
            }
            
        default:
            return RowNumsForArtistDetailPage.topArtAlbumsOrSimilarArts.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableViewFirstCellRowHeight
            
        case 1:
            let heightTwo: CGFloat = 60
            return heightTwo
            
        default:
            return tableViewThirdCellRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopAlbumsTableViewCell.reuseIdentifier, for: indexPath) as? TopAlbumsTableViewCell else {
                let cell = UITableViewCell()
                return cell
            }
            cell.validArtistAlbumList = viewModel.validArtistAlbumList
            cell.delegate = self
            cell.reloadCollectionView()
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTracksTableViewCell.reuseIdentifier, for: indexPath) as? TopTracksTableViewCell else {
                let cell = UITableViewCell()
                return cell
            }
            cell.showAnimatedGradientSkeleton()
            if ReloadFlags.artistTrackReloadFlag == 1 {
                cell.hideSkeleton()
                cell.configureCell(songName: viewModel.validArtistTopTrackList[indexPath.row].name, playCounts: viewModel.validArtistTopTrackList[indexPath.row].playCount)
                cell.contentView.isUserInteractionEnabled = true
                cell.isUserInteractionEnabled = true
                cell.delegate = self
                cell.selectedIndex = indexPath.row
            } else {
                cell.configureCell(songName: "--------------------------", playCounts: "-----")
            }

            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimilarArtistTableViewCell.reuseIdentifier, for: indexPath) as? SimilarArtistTableViewCell else {
                let cell = UITableViewCell()
                return cell
            }
            cell.similarSingerList = viewModel.similiarArtistList
            cell.delegate = self
            cell.reloadCollectionView()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("0 tapped")
            
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
            playTrack(indexPathRow: indexPath.row)
            print("1 tapped")
            
        default:
            print("2 tapped")
        }
    }
}

extension ArtistDetailViewController: AlbumBackWardDelegate, TracksBackWardDelegate, SimiliarArtistBackWardDelegate {
    func similarParentEventHandler(selectedItem: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let artistDetailVC = storyBoard.instantiateViewController(identifier: "ArtistDetailViewController") as? ArtistDetailViewController else { return }
        guard let url = URL(string: "neverUseThis") else { return }
        let artistFolder = Artist(name: self.viewModel.similiarArtistList[selectedItem].artistName, reference: "", url: url, image: nil)
        artistDetailVC.artist = artistFolder
        self.navigationController?.pushViewController(artistDetailVC, animated: true)
    }
    
    func playParentButtonTapped(selectedCellIndex: Int) {
        playTrack(indexPathRow: selectedCellIndex)
    }
    
    func moreParentButtonTapped(selectedCellIndex: Int) {
        guard let singerName = artist?.name else { return }
        let actionSheetAlertController = UIAlertController(title: "\n\n\n", message: "", preferredStyle: .actionSheet)
        //Set TitleView ???
        guard let titleView = Bundle.main.loadNibNamed("SharetoHeaderView", owner: nil, options: nil)?.first as? SharetoHeaderView else { return }
        titleView.configureView(image: UIImage(imageLiteralResourceName: "SingerExample"), song: self.viewModel.validArtistTopTrackList[selectedCellIndex].name, singer: artist?.name ?? "")
        actionSheetAlertController.view.addSubview(titleView)
        // MARK: TitleView Constraints
        titleView.translatesAutoresizingMaskIntoConstraints = false
        let titleViewTopConstraint = NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: actionSheetAlertController.view, attribute: .top, multiplier: 1, constant: 15)
        let titleViewLeadingConstraint = NSLayoutConstraint(item: titleView,
                                                            attribute: .leading,
                                                            relatedBy: .equal,
                                                            toItem: actionSheetAlertController.view,
                                                            attribute: .leading,
                                                            multiplier: 1,
                                                            constant: 5)
        let titleViewTrailingConstraint = NSLayoutConstraint(item: titleView,
                                                             attribute: .trailing,
                                                             relatedBy: .equal,
                                                             toItem: actionSheetAlertController.view,
                                                             attribute: .trailing,
                                                             multiplier: 1,
                                                             constant: -5)
        let titleViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 80)
        actionSheetAlertController.view.addConstraints([
            titleViewTopConstraint,
            titleViewLeadingConstraint,
            titleViewTrailingConstraint,
            titleViewHeightConstraint
        ])
        //Set Actions
        let shareAction = UIAlertAction(title: "Share To", style: .default) { _ in
            let firstActivityItem = "\(self.viewModel.validArtistTopTrackList[selectedCellIndex].name) from\n \(singerName)"
            var secondActivityItem = URL(string: "")
            if let url = URL(string: self.artistDetail?.url.path ?? "") { secondActivityItem = url }
            let thirdActivityItem = self.artistDetail?.headShot
            guard let secondActivityItemNonnull = secondActivityItem else { return }
            self.shareObject(firstActivityItem: firstActivityItem, secondActivityItem: secondActivityItemNonnull, thirdActivityItem: thirdActivityItem ?? UIImage())
        }
        let searchSimiliarTrackAction = UIAlertAction(title: "Different version Tracks", style: .default) { _ in
            self.searchSimiliarTrack(songName: self.viewModel.validArtistTopTrackList[selectedCellIndex].name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //Add Actions
        actionSheetAlertController.addAction(shareAction)
        actionSheetAlertController.addAction(searchSimiliarTrackAction)
        actionSheetAlertController.addAction(cancelAction)
        present(actionSheetAlertController, animated: true, completion: nil)
    }
    func albumParentEventHandler(selectedItem: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyBoard.instantiateViewController(identifier: AppConstants.StoryboardID.albumDetailViewController) as? AlbumDetailViewController {
            detailViewController.receivedAlbumName = viewModel.validArtistAlbumList[selectedItem].name
            guard let singerName = artist?.name else { return }
            detailViewController.receivedSingerName = singerName
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    @objc func addBlurredView() {
        view.addSubview(blurEffectView)
    }
    @objc func blurredViewRemove() {
        if let blurredView = self.view.viewWithTag(100) {
            blurredView.removeFromSuperview()
            navigationItem.titleView = nil
        }
    }
    func searchSimiliarTrack(songName: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: AppConstants.StoryboardID.mainStoryboard, bundle: nil)
            let searchedResultViewController = storyboard.instantiateViewController(identifier: "SearchedResultViewController") as SearchedResultViewController
            searchedResultViewController.receivedString = songName as NSString
            navigationController?.pushViewController(searchedResultViewController, animated: true)
        }
    }
}

extension ArtistDetailViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let identifier = TopTracksTableViewCell.reuseIdentifier
        return identifier
    }
}

extension ArtistDetailViewController: ShowAllBackWardDelegate {
    func showAllParentHandler(tappedInt: Int) {
        switch tappedInt {
        case 0:
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            if !ShowAllFlags.artistAlbumToAllFlag {
                tableViewFirstCellRowHeight = tableView.frame.size.height - (self.tabBarController?.tabBar.frame.size.height ?? CGFloat(0.0))
                tableView.isScrollEnabled = false
                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            } else {
                tableViewFirstCellRowHeight = CGFloat(200)
                tableView.isScrollEnabled = true
                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            
        case 1:
            if !ShowAllFlags.artistTrackToAllFlag {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
            } else {
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
            
        default:
            if !ShowAllFlags.artistSimilarToAllFlag {
                tableViewThirdCellRowHeight = tableView.frame.size.height - (self.tabBarController?.tabBar.frame.size.height ?? CGFloat(0.0))
                tableView.isScrollEnabled = false
                tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
                tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: true)
            } else {
                tableViewThirdCellRowHeight = CGFloat(180)
                tableView.isScrollEnabled = true
                tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
            }
        }
    }
}
