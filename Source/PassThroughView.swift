//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// Simple view to allow touch events to pass through itself, but not subviews
internal class PassThroughView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        switch view {
        case self:
            return nil
        default:
            return view
        }
    }
}
