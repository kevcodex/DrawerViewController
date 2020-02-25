//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//
import UIKit

protocol CornerRadiusDecorator {
    func setCornerRadius(_ radius: CGFloat)
}

extension CornerRadiusDecorator where Self: UIView {
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = radius > 0
    }
}
