//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

public protocol DrawerLayout: class {
    var currentPosition: DrawerViewController.Position { get set }
    
    func currentPositionInset() -> CGFloat?
    
    /// From the bottom
    func inset(for position: DrawerViewController.Position) -> CGFloat?
}

public extension DrawerLayout {
    func currentPositionInset() -> CGFloat? {
        return inset(for: currentPosition)
    }
}

final public class DefaultDrawerLayout: DrawerLayout {
    
    public var currentPosition: DrawerViewController.Position = .hidden
    
    public func inset(for position: DrawerViewController.Position) -> CGFloat? {
        switch position {
        case .hidden:
            return nil
        case .bottom:
            return 90
        case .mid:
            return 270
        case .top:
            return 750
        }
    }
}
