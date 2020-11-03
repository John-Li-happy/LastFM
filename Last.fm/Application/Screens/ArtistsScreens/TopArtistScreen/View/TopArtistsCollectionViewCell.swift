//
//  TopArtistsViewController.swift
//  Last.fm
//
//  Created by Tong Yi on 8/24/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class TopArtistsCollectionViewCell: UICollectionViewCell, ReusableCellProtocol {
    
    @IBOutlet weak private var artistImageView: UIImageView!
    @IBOutlet weak private var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.layer.contentsScale = UIScreen.main.scale
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = .zero
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
    
    func configureCell(artist: Artist) {
        self.cellWithRoundCorner()
        let image = UIImage(imageLiteralResourceName: AppConstants.ImageName.singerImageViewName)
        self.artistNameLabel.text = artist.name
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let weakSelf = self else { return }
//            guard let url = artist.image[1].text else { return }
//            let imageData = try? Data(contentsOf: url)
//            guard let data = imageData else { return }
            guard /*let artistImage = UIImage(data: imageData), */let cgImage = blurImage(image: image) else { return }
            DispatchQueue.main.async {
                weakSelf.artistImageView.image = UIImage(cgImage: cgImage)
            }
        }
    }
}
