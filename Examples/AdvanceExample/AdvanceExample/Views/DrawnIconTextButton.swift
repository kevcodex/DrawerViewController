//
//  DrawnIconTextButton.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// A text with an "hand"-drawn icon to the left of it. Like "< Back"
class DrawnIconTextButton: IconTextButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        titleLabel.textColor = .systemBlue
        
        let iconView = IconView()
        iconView.iconColor = .systemBlue
        
        iconSize = CGSize(width: 12, height: 20)
        containerInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        setIconView(iconView, position: .left)
    }
}
