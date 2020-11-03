//
//  albumTrackTableCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class AlbumTracksTableViewCell: UITableViewCell, ReusableCellProtocol {
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(AlbumTracksTableViewCell.cellPlayButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(imageLiteralResourceName: "playWithCircle"), for: .normal)
        button.tintColor = .red
        return button
    }()
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(AlbumTracksTableViewCell.cellMoreButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(imageLiteralResourceName: "ellipsisWhite"), for: .normal)
        button.isUserInteractionEnabled = true
        button.layer.zPosition = 99999999999999
        return button
    }()
    lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    weak var delegate: BackWardsForCellPass?
    var selectedRow = Int()
    var songName = String()
    var singerName = String()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: AlbumTracksTableViewCell.reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.isUserInteractionEnabled = false
        setSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cellPlayButtonTapped() {
        delegate?.playButtonParentTapped(selectedRow: selectedRow)
    }
    
    @objc func cellMoreButtonTapped() {
        delegate?.moreButtonParentTapped(selectedRow: selectedRow, songName: songName, singerName: singerName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setSubViews() {
        self.addSubview(playButton)
        self.addSubview(songNameLabel)
        self.addSubview(durationLabel)
        self.addSubview(moreButton)
        self.bringSubviewToFront(moreButton)
    }
    
    private func setConstraints() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        //playButton
        let playbuttonCenterYContstraint = NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let playbuttonheightContstraint = NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        let playbuttonWidthContstraint = NSLayoutConstraint(item: playButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .height, multiplier: 1, constant: 0)
        let playbuttonLeadingContstraint = NSLayoutConstraint(item: playButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20)
        //NameLabel
        let nameLabelLeadingContstraint = NSLayoutConstraint(item: songNameLabel, attribute: .leading, relatedBy: .equal, toItem: playButton, attribute: .trailing, multiplier: 1, constant: 15)
        let nameLabelCenterYContstraint = NSLayoutConstraint(item: songNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let nameLabelWidthContstraint = NSLayoutConstraint(item: songNameLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: 250)
        nameLabelWidthContstraint.priority = UILayoutPriority(rawValue: 750)
        let nameLabelheightContstraint = NSLayoutConstraint(item: songNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        //durationLabel
        let durationLabelleadingContstraint = NSLayoutConstraint(item: durationLabel,
                                                                 attribute: .leading,
                                                                 relatedBy: .greaterThanOrEqual,
                                                                 toItem: songNameLabel,
                                                                 attribute: .trailing,
                                                                 multiplier: 1,
                                                                 constant: 0)
        let durationLabelCenterYContstraint = NSLayoutConstraint(item: durationLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let durationLabelheightContstraint = NSLayoutConstraint(item: durationLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        let durationLabelWidthContstraint = NSLayoutConstraint(item: durationLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50)
        //moreButton
        let moreButtonLeadingContstraint = NSLayoutConstraint(item: moreButton, attribute: .leading, relatedBy: .equal, toItem: durationLabel, attribute: .trailing, multiplier: 1, constant: 10)
        let moreButtonCenterYContstraint = NSLayoutConstraint(item: moreButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let moreButtonWidthContstraint = NSLayoutConstraint(item: moreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 20)
        let moreButtonheightContstraint = NSLayoutConstraint(item: moreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        let moreButtonTrailingContstraint = NSLayoutConstraint(item: moreButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20)
        
        self.addConstraints([
            playbuttonCenterYContstraint, // play button
            playbuttonheightContstraint,
            playbuttonWidthContstraint,
            playbuttonLeadingContstraint,
            nameLabelLeadingContstraint, // name Label
            nameLabelCenterYContstraint,
            nameLabelWidthContstraint,
            nameLabelheightContstraint,
            durationLabelleadingContstraint, // duration Label
            durationLabelCenterYContstraint,
            durationLabelheightContstraint,
            durationLabelWidthContstraint,
            moreButtonLeadingContstraint, // more button
            moreButtonCenterYContstraint,
            moreButtonWidthContstraint,
            moreButtonheightContstraint,
            moreButtonTrailingContstraint
        ])
    }
    
    func configureCell(songName: String, duration: String) {
        songNameLabel.text = songName
        durationLabel.text = duration
    }
}
