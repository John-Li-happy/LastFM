//
//  ViewForHeaderInSection.swift
//  Last.fm
//
//  Created by Tong Yi on 9/2/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

class ViewForHeaderInSection: UIView, ReusableCellProtocol {
    weak var delegate: ShowAllBackWardDelegate?
    var sectionTappedInt = Int()

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var viewAllButton: UIButton! {
        didSet {
            switch sectionTappedInt {
            case 0:
                if ShowAllFlags.artistAlbumToAllFlag {
                    viewAllButton.setTitle("View All", for: .normal)
                } else {
                    viewAllButton.setTitle("View Less", for: .normal)
                }
                viewAllButton.isUserInteractionEnabled = ReloadFlags.artistAlbumReloadFlag == 0 ? false : true
                
            case 1:
                if ShowAllFlags.artistTrackToAllFlag {
                    viewAllButton.setTitle("View All", for: .normal)
                } else {
                    viewAllButton.setTitle("View Less", for: .normal)
                }
                viewAllButton.isUserInteractionEnabled = ReloadFlags.artistTrackReloadFlag == 0 ? false : true
                
            default:
                if ShowAllFlags.artistSimilarToAllFlag {
                    viewAllButton.setTitle("View All", for: .normal)
                } else {
                    viewAllButton.setTitle("View Less", for: .normal)
                }
                viewAllButton.isUserInteractionEnabled = ReloadFlags.artistSimilarReloadFlag == 0 ? false : true
            }
        }
    }
    
    @IBAction private func viewAllButtonTapped(_ sender: UIButton) {
        switch sectionTappedInt {
        case 0:
            if ShowAllFlags.artistAlbumToAllFlag {
                ShowAllFlags.artistAlbumToAllFlag = false
            } else {
                ShowAllFlags.artistAlbumToAllFlag = true
            }
            
        case 1:
            if ShowAllFlags.artistTrackToAllFlag {
                ShowAllFlags.artistTrackToAllFlag = false
            } else {
                ShowAllFlags.artistTrackToAllFlag = true
            }
            
        default:
            if ShowAllFlags.artistSimilarToAllFlag {
                ShowAllFlags.artistSimilarToAllFlag = false
            } else {
                ShowAllFlags.artistSimilarToAllFlag = true
            }
        }
        
        delegate?.showAllParentHandler(tappedInt: sectionTappedInt)
    }
    
    func configureHeaderView(sectionName: String) {
        headerLabel.text = sectionName
    }
}
