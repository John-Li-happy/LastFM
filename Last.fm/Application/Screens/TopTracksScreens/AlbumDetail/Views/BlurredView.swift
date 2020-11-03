//
//  BlurredView.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/15/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class BlurredView: UIView {
    lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    lazy var headShotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        return imageView
    }()
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        let backView = ButtonView()
        button.addSubview(backView)
        button.sendSubviewToBack(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: backView, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: backView, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: backView, attribute: .leading, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: backView, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0)
        button.addConstraints([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingConstraint
        ])
        backView.configureButton(imageString: "playButton", labelString: "Play")
        return button
    }()
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        let backView = ButtonView()
        button.addSubview(backView)
        button.sendSubviewToBack(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: backView, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: backView, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: backView, attribute: .leading, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: backView, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0)
        button.addConstraints([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingConstraint
        ])
        backView.configureButton(imageString: "shareButton", labelString: "Share")
        return button
    }()
    
   weak var delegate: BackWardForViewPassMessage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstrintsFirstPart()
        setConstraintsSecontpart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(albumNameLabel)
        self.addSubview(singerNameLabel)
        self.addSubview(infoLabel)
        self.addSubview(headShotImageView)
        self.bringSubviewToFront(headShotImageView)
        self.addSubview(playButton)
        self.addSubview(shareButton)
    }
    
    private func setConstrintsFirstPart() {
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false; singerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false; headShotImageView.translatesAutoresizingMaskIntoConstraints = false
        //AlbumNameLabel
        let albumNameLabelTopConstriant = NSLayoutConstraint(item: albumNameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 40)
        let albumNameLabelLeadingConstriant = NSLayoutConstraint(item: albumNameLabel,
                                                                 attribute: .leading,
                                                                 relatedBy: .equal,
                                                                 toItem: headShotImageView,
                                                                 attribute: .trailing,
                                                                 multiplier: 1,
                                                                 constant: 20)
        let albumNameLabelHeightConstriant = NSLayoutConstraint(item: albumNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 25)
        let albumNameLabelTrailingConstriant = NSLayoutConstraint(item: albumNameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30)
        //SingerNameLabel
        let singerNameLabelTopConstraint = NSLayoutConstraint(item: singerNameLabel, attribute: .top, relatedBy: .equal, toItem: albumNameLabel, attribute: .bottom, multiplier: 1, constant: 6)
        let singerNameLabelTrailingConstraint = NSLayoutConstraint(item: singerNameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -70)
        let singerNameLabelLeadingConstraint = NSLayoutConstraint(item: singerNameLabel,
                                                                  attribute: .leading,
                                                                  relatedBy: .equal,
                                                                  toItem: headShotImageView,
                                                                  attribute: .trailing,
                                                                  multiplier: 1,
                                                                  constant: 20)
        let singerNameLabelHeightConstraint = NSLayoutConstraint(item: singerNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        //InfoLabel
        let infoLabelTopConstraint = NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: singerNameLabel, attribute: .bottom, multiplier: 1, constant: 3)
        let infoLabelTrailingConstraint = NSLayoutConstraint(item: infoLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15)
        let infoLabelLeadingConstraint = NSLayoutConstraint(item: infoLabel, attribute: .leading, relatedBy: .equal, toItem: headShotImageView, attribute: .trailing, multiplier: 1, constant: 20)
        let infoLabelHeightConstraint = NSLayoutConstraint(item: infoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        //HeadShotImageView
        let headShotImageTopConstraint = NSLayoutConstraint(item: headShotImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 35)
        let headShotImageLeadingConstraint = NSLayoutConstraint(item: headShotImageView,
                                                                attribute: .leading,
                                                                relatedBy: .equal,
                                                                toItem: self,
                                                                attribute: .leading,
                                                                multiplier: 1,
                                                                constant: 35)
        let headShotImageWidthConstraint = NSLayoutConstraint(item: headShotImageView,
                                                              attribute: .width,
                                                              relatedBy: .equal,
                                                              toItem: nil,
                                                              attribute: .height,
                                                              multiplier: 1,
                                                              constant: 100)
        let headShotImageHeightConstraint = NSLayoutConstraint(item: headShotImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        self.addConstraints([
            albumNameLabelTopConstriant, // albumLabel
            albumNameLabelLeadingConstriant,
            albumNameLabelHeightConstriant,
            albumNameLabelTrailingConstriant,
            singerNameLabelTopConstraint, // singerLabel
            singerNameLabelTrailingConstraint,
            singerNameLabelLeadingConstraint,
            singerNameLabelHeightConstraint,
            infoLabelTopConstraint, // infoLabel
            infoLabelTrailingConstraint,
            infoLabelLeadingConstraint,
            infoLabelHeightConstraint,
            headShotImageTopConstraint, // headShot
            headShotImageLeadingConstraint,
            headShotImageWidthConstraint,
            headShotImageHeightConstraint
        ])
    }
    private func setConstraintsSecontpart() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        //PlayButton
        let playButtonBottomConstraint = NSLayoutConstraint(item: playButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -15)
        let playButtonLeadingConstraint = NSLayoutConstraint(item: playButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 35)
        let playButtonHeightConstraint = NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        let playButtonTrailingConstraint = NSLayoutConstraint(item: playButton,
                                                              attribute: .trailing,
                                                              relatedBy: .greaterThanOrEqual,
                                                              toItem: shareButton,
                                                              attribute: .leading,
                                                              multiplier: 1,
                                                              constant: -55)
        //ShareButton
        let shareButtonVerticalConstraint = NSLayoutConstraint(item: shareButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1, constant: 0)
        let shareButtonTrailingConstraint = NSLayoutConstraint(item: shareButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -35)
        let shareButtonheightConstraint = NSLayoutConstraint(item: shareButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        let shareButtonWidthConstraint = NSLayoutConstraint(item: shareButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 1, constant: 0)
        
        self.addConstraints([
            playButtonBottomConstraint, // play button
            playButtonLeadingConstraint,
            playButtonHeightConstraint,
            playButtonTrailingConstraint,
            shareButtonVerticalConstraint, // share button
            shareButtonTrailingConstraint,
            shareButtonheightConstraint,
            shareButtonWidthConstraint
        ])
    }
    
    func setContentData(singerName: String, albumName: String, info: String, headShotImage: UIImage) {
        singerNameLabel.text = singerName
        albumNameLabel.text = albumName
        infoLabel.text = info
        headShotImageView.image = headShotImage
    }
    
    @objc func playButtonTapped() {
        delegate?.playButtonparentTapped()
    }
    
    @objc func shareButtonTapped() {
        delegate?.shareButtonParentTapped()
    }
}
