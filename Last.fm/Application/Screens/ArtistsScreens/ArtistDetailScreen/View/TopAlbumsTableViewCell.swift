//
//  TopAlbumsTableViewCell.swift
//  Last.fm
//
//  Created by Tong Yi on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SkeletonView
import UIKit

class TopAlbumsTableViewCell: UITableViewCell, ReusableCellProtocol {
    
    var validArtistAlbumList = [ValidArtistAlbum]()
    weak var delegate: AlbumBackWardDelegate?
    
    @IBOutlet weak private var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isUserInteractionEnabled = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = ShowAllFlags.artistAlbumToAllFlag ? .horizontal : .vertical
        }
    }
}

extension TopAlbumsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ReloadFlags.artistAlbumReloadFlag == 0 {
            let four = 4
            return four
        } else {
            collectionView.isUserInteractionEnabled = true
            let counter = validArtistAlbumList.count
            return counter
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopAlbumsCollectionViewCell.reuseIdentifier, for: indexPath) as? TopAlbumsCollectionViewCell else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.showAnimatedGradientSkeleton()
        if ReloadFlags.artistAlbumReloadFlag == 1 {
            let singleAlbum = validArtistAlbumList[indexPath.row]
            cell.hideSkeleton()
            cell.configureCell(name: singleAlbum.name, listeners: singleAlbum.playCount, image: singleAlbum.headShotImage)
        } else {
            cell.configureCell(name: "-----", listeners: "-----", image: UIImage(imageLiteralResourceName: "unfetchedImage"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.albumParentEventHandler(selectedItem: indexPath.row)
    }
}

extension TopAlbumsTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let identifier = TopAlbumsTableViewCell.reuseIdentifier
        return identifier
    }
}
