//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

public protocol DrawerLayout: AnyObject {
    var currentPosition: DrawerViewController.Position { get set }
    
    func currentPositionInset() -> CGFloat?
    
    /// All values are based on a coordinate where the bottom left is zero.
    /// For example, a top inset will be 750 while a bottom inset will be 90.
    func inset(for position: DrawerViewController.Position) -> CGFloat?
}

public extension DrawerLayout {
    func currentPositionInset() -> CGFloat? {
        return inset(for: currentPosition)
    }
}

final public class DefaultDrawerLayout: DrawerLayout {
    
    public var currentPosition: DrawerViewController.Position = .hidden
    
    public init() {}
    
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
