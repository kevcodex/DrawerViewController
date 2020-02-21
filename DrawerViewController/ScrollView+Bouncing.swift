//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

internal extension UIScrollView {
    var isBouncing: Bool {
        return isBouncingTop || isBouncingBottom
    }
    
    private var isBouncingTop: Bool {
        return contentOffset.y < -contentInset.top
    }
    
    private var isBouncingBottom: Bool {
        return contentOffset.y > contentSize.height - bounds.height + contentInset.bottom
    }
}
