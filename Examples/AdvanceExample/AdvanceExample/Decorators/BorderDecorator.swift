//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

protocol BorderDecorator {
    func setBorderWidth(_ width: CGFloat)
    func setBorderColor(_ color: UIColor)
}

extension BorderDecorator where Self: UIView {
    func setBorderWidth(_ width: CGFloat) {
        layer.borderWidth = width
    }
    
    func setBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
}
