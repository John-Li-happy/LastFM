//
//  AlertTitleView.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 10/12/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class AlertTitleView: UIView {
    lazy var headShotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    lazy var singerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubViews() {
        self.addSubview(headShotImageView)
        self.addSubview(nameLabel)
        self.addSubview(singerLabel)
    }
    
    private func setConstraints() {
        headShotImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        singerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewCenterYConstraint = NSLayoutConstraint(item: headShotImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let imageViewLeadingConstraint = NSLayoutConstraint(item: headShotImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15)
        let imageViewHeightConstraint = NSLayoutConstraint(item: headShotImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 75)
        let imageViewWidthConstraint = NSLayoutConstraint(item: headShotImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 75)
        let nameLabelLeadingConstraint = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: headShotImageView, attribute: .trailing, multiplier: 1, constant: 10)
        let nameLabelTrailingConstraint = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -5)
        let nameLabelCenterYConstraint = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: headShotImageView, attribute: .centerY, multiplier: 1, constant: -16)
        let nameLabelHeightConstraint = NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        let singerLabelLeadingConstraint = NSLayoutConstraint(item: singerLabel, attribute: .leading, relatedBy: .equal, toItem: headShotImageView, attribute: .trailing, multiplier: 1, constant: 10)
        let singerLabelTrailingConstraint = NSLayoutConstraint(item: singerLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -5)
        let singerLabelCenterYConstraint = NSLayoutConstraint(item: singerLabel, attribute: .centerY, relatedBy: .equal, toItem: headShotImageView, attribute: .centerY, multiplier: 1, constant: 16)
        let singerLabelHeightConstraint = NSLayoutConstraint(item: singerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        
        self.addConstraints([
            imageViewCenterYConstraint, // imageView
            imageViewLeadingConstraint,
            imageViewHeightConstraint,
            imageViewWidthConstraint,
            nameLabelLeadingConstraint, // nameLabel
            nameLabelTrailingConstraint,
            nameLabelCenterYConstraint,
            nameLabelHeightConstraint,
            singerLabelLeadingConstraint, // singerLabel
            singerLabelTrailingConstraint,
            singerLabelCenterYConstraint,
            singerLabelHeightConstraint
        ])
    }
    
    func configureCell(image: UIImage, trackName: String, singerName: String) {
        headShotImageView.image = image
        nameLabel.text = trackName
        singerLabel.text = singerName
    }
}
