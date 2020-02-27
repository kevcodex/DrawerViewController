//
//  CustomScrollHandler.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/26/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit
import DrawerViewController

final class CustomScrollHandler: DrawerScrollContentHandler {
    
}

extension CustomScrollHandler {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.targetScrollView == scrollView else { return }
        
        let panGesture = scrollView.panGestureRecognizer
        let translation = panGesture.translation(in: panGesture.view)
        
        // Only allow to move when the scroll view is
        // at top and pulling downward.
        // Or if drawer is not at top or mid.
        if canDrawerViewMove, scrollView.contentOffset.y <= 0.0, translation.y >= 0.0 {
            drawer?.scrollViewDidScroll(scrollView)
        } else if drawer?.isDragging ?? false {
            drawer?.scrollViewDidScroll(scrollView, initialOffset: scrollViewInitialOffset)
        } else if drawer?.layout.currentPosition != .top && drawer?.layout.currentPosition != .mid {
            drawer?.scrollViewDidScroll(scrollView, initialOffset: scrollViewInitialOffset)
        } else {
            canDrawerViewMove = false
        }
    }
}
