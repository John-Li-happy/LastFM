//
//  SearchResultTableViewCell.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/18/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class SearchResultTableViewCell: UITableViewCell, ReusableCellProtocol {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        setSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubViews() {
        self.addSubview(nameLabel)
    }
    
    private func setConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelCenterYContstraint = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let nameLabelLeadingContstraint = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20)
        let nameLabelHeightContstraint = NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        let nameLabelTrailingContstraint = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 10)
        
        self.addConstraints([
            nameLabelCenterYContstraint,
            nameLabelLeadingContstraint,
            nameLabelHeightContstraint,
            nameLabelTrailingContstraint
        ])
    }

    func configureCell(name: String) {
        nameLabel.text = name
    }
}
