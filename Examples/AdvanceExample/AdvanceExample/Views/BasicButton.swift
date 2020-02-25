//
//  BasicButton.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// Basic button that animates touch down and etc.
/// Default does a alpha change. Override methods to change
class BasicButton: UIControl {
    
    /// The duration of the touch animation
    var touchAnimationDuration: Double = 0.1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSelectionActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSelectionActions()
    }
    
    func addSelectionActions() {
        addTarget(self, action: #selector(animateTouched), for: .touchDown)
        addTarget(self, action: #selector(animateDeTouched), for: .touchCancel)
        addTarget(self, action: #selector(animateSelected), for: .touchUpInside)
        addTarget(self, action: #selector(animateDeTouched), for: .touchDragExit)
        addTarget(self, action: #selector(animateTouched), for: .touchDragEnter)
    }
    
    @objc func animateTouched() {
        UIView.animate(withDuration: touchAnimationDuration) {
            self.press(true)
        }
    }
    
    @objc func animateDeTouched() {
        UIView.animate(withDuration: touchAnimationDuration) {
            self.press(false)
        }
    }
    
    @objc func animateSelected() {
        UIView.animate(withDuration: touchAnimationDuration) {
            self.press(false)
            
            self.isSelected = !self.isSelected
        }
    }
    
    func press(_ isPressed: Bool) {
        alpha = isPressed ? 0.75 : 1
    }
}
