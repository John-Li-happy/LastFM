//
//  UserTopTracksTableViewCell.swift
//  Last.fm
//
//  Created by Shawn on 9/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class UserTopTracksTableViewCell: UITableViewCell, ReusableCellProtocol {
    @IBOutlet weak private var trackCoverImageView: UIImageView!
    @IBOutlet weak private var trackNameLabel: UILabel!
    @IBOutlet weak private var trackArtistLabel: UILabel!
    @IBOutlet weak private var trackDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(trackCover: String, trackName: String, artist: String, duration: String) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: trackCover) else { return }
            do {
                let coverData = try Data(contentsOf: url)
                let cover = UIImage(data: coverData)
                DispatchQueue.main.async {
                    self.trackCoverImageView.image = cover
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        self.trackNameLabel.text = trackName
        self.trackArtistLabel.text = artist
        if let durationInt = Int(duration) {
            let durationSeconds = durationInt % 60
            let durationMinutes = (durationInt - durationSeconds) / 60
            if durationSeconds < 10 {
                self.trackDurationLabel.text = "\(durationMinutes)" + ":0" + "\(durationSeconds)"
            } else {
                self.trackDurationLabel.text = "\(durationMinutes)" + ":" + "\(durationSeconds)"
            }
        }
    }
}
