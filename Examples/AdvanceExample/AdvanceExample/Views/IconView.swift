//
//  IconView.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// General purpose "hand" drawn icon view.
class IconView: UIView {
    
    var iconColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var iconResizing: IconDrawFactory.ResizingBehavior = .aspectFit
    
    var iconType: IconDrawFactory.IconType = .arrowHead(direction: .left)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switch iconType {
        case .arrowHead(let direction):
            switch direction {
            case .left:
                IconDrawFactory.drawArrowHead(frame: rect, direction: .left, resizing: iconResizing, color: iconColor)
            case .right:
                IconDrawFactory.drawArrowHead(frame: rect, direction: .right, resizing: iconResizing, color: iconColor)
            }
        }
    }
}
