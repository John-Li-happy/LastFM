//
//  TopTracksTableViewCell.swift
//  Last.fm
//
//  Created by Tong Yi on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class TopTracksTableViewCell: UITableViewCell, ReusableCellProtocol {
    var selectedIndex = Int()
    weak var delegate: TracksBackWardDelegate?
    
    @IBOutlet weak private var trackNameLabel: UILabel!
    @IBOutlet weak private var trackListenerLabel: UILabel!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var ellipsisButton: UIButton!
    
    // MARK: - IBAction
    @IBAction private func playButtonTapped(_ sender: Any) {
        delegate?.playParentButtonTapped(selectedCellIndex: selectedIndex)
    }
    
    @IBAction private func moreButtonTapped(_ sender: Any) {
        delegate?.moreParentButtonTapped(selectedCellIndex: selectedIndex)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
        playButton.roundedBorderButton()
        ellipsisButton.isUserInteractionEnabled = true
        self.contentView.bringSubviewToFront(playButton)
        self.contentView.bringSubviewToFront(ellipsisButton)
    }
    
    func configureCell(songName: String, playCounts: String) {
        if ReloadFlags.artistTrackReloadFlag == 1 {
            self.isUserInteractionEnabled = true
        }

        trackNameLabel.text = songName
        trackListenerLabel.text = playCounts
    }
}
