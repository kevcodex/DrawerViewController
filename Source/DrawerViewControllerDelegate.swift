//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

public protocol DrawerViewControllerDelegate: class, DrawerEvent {
    
}

/// Add to some object that needs to listen to drawer events.
public protocol DrawerListener: DrawerEvent {
    
}

/// Base protocol for all drawer events
public protocol DrawerEvent {
    
    func drawerViewControllerViewDidAppear(_ drawerViewController: DrawerViewController)
    
    /// Called when the user starts dragging the drawer view
    func drawerViewControllerWillBeginDragging(_ drawerViewController: DrawerViewController)
    
    /// Called when the user is dragging the drawer view
    func drawerViewControllerIsDragging(_ drawerViewController: DrawerViewController,
                                        to point: CGFloat)
    
    /// Called when the user finishes dragging the drawer view
    func drawerViewControllerDidEndDragging(_ drawerViewController: DrawerViewController,
                                            with velocity: CGPoint,
                                            currentPoint: CGFloat,
                                            projectedPosition: DrawerViewController.Position?)
    
    func drawerViewControllerWillCompleteMoving(_ drawerViewController: DrawerViewController,
                                                to position: DrawerViewController.Position?)
    
    func drawerViewControllerDidCompleteMoving(_ drawerViewController: DrawerViewController,
                                               to position: DrawerViewController.Position?)
    
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout

    func drawerViewControllerTraitCollectionDidChange(in drawerViewController: DrawerViewController, previousTraitCollection: UITraitCollection?)
    
    func drawerViewControllerViewWillTransition(_ drawerViewController: DrawerViewController, to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
}

public extension DrawerEvent {
    func drawerViewControllerViewDidAppear(_ drawerViewController: DrawerViewController) {}
    
    /// Called when the user starts dragging the drawer view
    func drawerViewControllerWillBeginDragging(_ drawerViewController: DrawerViewController) {}
    
    /// Called when the user is dragging the drawer view
    func drawerViewControllerIsDragging(_ drawerViewController: DrawerViewController,
                                        to point: CGFloat) {}
    
    /// Called when the user finishes dragging the drawer view
    func drawerViewControllerDidEndDragging(_ drawerViewController: DrawerViewController,
                                            with velocity: CGPoint,
                                            currentPoint: CGFloat,
                                            projectedPosition: DrawerViewController.Position?) {}
    
    func drawerViewControllerWillCompleteMoving(_ drawerViewController: DrawerViewController,
                                                to position: DrawerViewController.Position?) {}
    
    func drawerViewControllerDidCompleteMoving(_ drawerViewController: DrawerViewController,
                                               to position: DrawerViewController.Position?) {}
    
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout {
        return DefaultDrawerLayout()
    }
    
    func drawerViewControllerTraitCollectionDidChange(in drawerViewController: DrawerViewController, previousTraitCollection: UITraitCollection?) {}
    
    func drawerViewControllerViewWillTransition(_ drawerViewController: DrawerViewController, to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {}
}
