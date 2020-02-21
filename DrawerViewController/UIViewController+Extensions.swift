//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

internal extension UIViewController {
    
    /// - Parameter viewController: The view controller to add
    /// - Parameter view: The view to add the view controller to. If nil, will add to the parent.
    func addChildVC(_ viewController: UIViewController, to view: UIView? = nil) {
        addChild(viewController)
        
        let view: UIView = view ?? self.view
        
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func removeFromParentVC() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    @discardableResult func constrainToParent(with insets: UIEdgeInsets = .zero) -> EdgeConstraints? {
        guard let parentView = parent?.view else { return nil }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let top = view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: insets.top)
        let bottom = view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: insets.bottom)
        let left = view.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: insets.left)
        let right = view.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: insets.right)
        
        NSLayoutConstraint.activate([top, bottom, left, right])
        
        return EdgeConstraints(top: top, bottom: bottom, left: left, right: right)
    }
}

struct EdgeConstraints {
    
    var top: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var left: NSLayoutConstraint?
    var right: NSLayoutConstraint?
}
