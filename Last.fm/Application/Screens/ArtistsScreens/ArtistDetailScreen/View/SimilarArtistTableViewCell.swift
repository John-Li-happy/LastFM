//
//  SimilarArtistTableViewCell.swift
//  Last.fm
//
//  Created by Tong Yi on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SkeletonView
import UIKit

class SimilarArtistTableViewCell: UITableViewCell, ReusableCellProtocol {
    var similarSingerList = [SimiliarArtist]()
    weak var delegate: SimiliarArtistBackWardDelegate?
    
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
            layout.scrollDirection = ShowAllFlags.artistSimilarToAllFlag ? .horizontal : .vertical
        }
    }
}

extension SimilarArtistTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ReloadFlags.artistSimilarReloadFlag == 0 {
            let four = 4
            return four
        } else {
            collectionView.isUserInteractionEnabled = true
            let counter = similarSingerList.count
            return counter
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarArtistCollectionViewCell.reuseIdentifier, for: indexPath) as? SimilarArtistCollectionViewCell else {
            let item = UICollectionViewCell()
            return item }
        item.showAnimatedGradientSkeleton()
        if ReloadFlags.artistSimilarReloadFlag == 0 {
            item.configureItem(name: "-----", image: UIImage(imageLiteralResourceName: "unfetchedImage"))
        } else {
            item.hideSkeleton()
            item.configureItem(name: similarSingerList[indexPath.row].artistName, image: similarSingerList[indexPath.row].headShotImage)
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.similarParentEventHandler(selectedItem: indexPath.row)
    }
}

extension SimilarArtistTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let identifire = SimilarArtistTableViewCell.reuseIdentifier
        return identifire
    }
}
