//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// Handler for allowing drawer to move based on content scroll view.
/// Add to your view controller that has a scroll view you want to track.
/// Defaults to only allow scroll when at top position and will pull drawer down when at top of the scroll.
open class DrawerScrollContentHandler: NSObject {
    
    /// Can the drawer move when the table view is scrolling or moving.
    public var canDrawerViewMove = true
    // Used for drawer dragging
    public var scrollViewInitialOffset: CGPoint?
    
    public weak var drawer: DrawerViewController?
    /// The content scroll view you want to monitor.
    public weak var targetScrollView: UIScrollView?
    
    /// Make sure to set both drawer and targetScrollView in order for this to work
    public init(targetScrollView: UIScrollView? = nil, drawer: DrawerViewController? = nil) {
        self.targetScrollView = targetScrollView
        self.drawer = drawer
    }
}

extension DrawerScrollContentHandler: UIScrollViewDelegate {
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        guard self.targetScrollView == scrollView else { return }
        
        scrollViewInitialOffset = scrollView.contentOffset
        
        drawer?.scrollViewWillBeginDragging(scrollView)
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.targetScrollView == scrollView else { return }
        
        let panGesture = scrollView.panGestureRecognizer
        let translation = panGesture.translation(in: panGesture.view)
        
        // Only allow to move when the scroll view is
        // at top and pulling downward.
        // Or if drawer is not at top.
        if canDrawerViewMove, scrollView.contentOffset.y <= 0.0, translation.y >= 0.0 {
            drawer?.scrollViewDidScroll(scrollView)
        } else if drawer?.isDragging ?? false {
            drawer?.scrollViewDidScroll(scrollView, initialOffset: scrollViewInitialOffset)
        } else if drawer?.layout.currentPosition != .top {
            drawer?.scrollViewDidScroll(scrollView, initialOffset: scrollViewInitialOffset)
        } else {
            canDrawerViewMove = false
        }
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.targetScrollView == scrollView else { return }
        
        if canDrawerViewMove {
            drawer?.scrollViewDidEndDragging(scrollView)
        }
    }
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard self.targetScrollView == scrollView else { return }
        
        // Keep the offset to initial to prevent scrolling when drawer is moving
        if canDrawerViewMove {
            // Fixes bug where if you are bouncing and tap on the scroll, it will get in a bad state where you can't touch anything until after you scroll again.
            if !scrollView.isBouncing {
                scrollView.setContentOffset(scrollViewInitialOffset ?? .zero, animated: false)
            }
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard self.targetScrollView == scrollView else { return }
        
        // For bug where drawer is still decelerating,
        // but when you move drawer through other means,
        // this method gets triggered but scroll view did scroll still gets triggered,
        // causing the offset to be the old initial offset
        scrollViewInitialOffset = scrollView.contentOffset
        
        canDrawerViewMove = true
        scrollView.showsVerticalScrollIndicator = true
    }
}
