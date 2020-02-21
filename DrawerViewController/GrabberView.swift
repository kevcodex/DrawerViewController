//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

public class GrabberView: UIView {
    
    public var barColor = UIColor.gray {
        didSet {
            backgroundColor = barColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = barColor
    }
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = barColor
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    public func setUp() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = frame.size.height * 0.5
    }
}
