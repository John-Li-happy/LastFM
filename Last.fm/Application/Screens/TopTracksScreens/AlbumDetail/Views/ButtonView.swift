//
//  ButtonView.swift
//  Last.fm
//
//  Created by Zhaoyang Li on 9/15/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation
import UIKit

class ButtonView: UIView {
    lazy var sideImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addMainViews()
        setConstraints()
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addMainViews() {
        self.addSubview(sideImageView)
        self.addSubview(mainLabel)
    }
    
    private func setConstraints() {
        sideImageView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        //imageView
        let imageViewHeightConstraint = NSLayoutConstraint(item: sideImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.75, constant: 0)
        let imageViewWidthConstraint = NSLayoutConstraint(item: sideImageView, attribute: .width, relatedBy: .equal, toItem: sideImageView, attribute: .height, multiplier: 1, constant: 0)
        let imageViewHCenterYConstraint = NSLayoutConstraint(item: sideImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let imageViewCenterXConstraint = NSLayoutConstraint(item: sideImageView,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .centerX,
                                                            multiplier: 1,
                                                            constant: -25)
        //mainLabel
        let labelCenterYConstraint = NSLayoutConstraint(item: mainLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let labelHeightConstraint = NSLayoutConstraint(item: mainLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.75, constant: 0)
        let labelLeadingConstraint = NSLayoutConstraint(item: mainLabel, attribute: .leading, relatedBy: .equal, toItem: sideImageView, attribute: .trailing, multiplier: 1, constant: 10)
        let labelTrailingConstraint = NSLayoutConstraint(item: mainLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
                
        self.addConstraints([
            imageViewHeightConstraint, // imageview
            imageViewWidthConstraint,
            imageViewHCenterYConstraint,
            imageViewCenterXConstraint,
            labelCenterYConstraint, // label
            labelHeightConstraint,
            labelLeadingConstraint,
            labelTrailingConstraint
        ])
    }
    
    func configureButton(imageString: String, labelString: String) {
        sideImageView.image = UIImage(imageLiteralResourceName: imageString)
        mainLabel.text = labelString
    }
}
