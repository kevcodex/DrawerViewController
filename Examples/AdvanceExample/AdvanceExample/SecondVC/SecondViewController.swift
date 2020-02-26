//
//  SecondViewController.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit
import DrawerViewController

protocol SecondViewControllerDelegate: class {
    func secondViewControllerViewDidAppear(_ secondViewController: SecondViewController)
}

// In this view we have a scroll view where the insets need to adjust based on drawer position.
// We want it where you can still scroll through at mid and top, but not at bottom and thus have a custom drawer scroll handler 
final class SecondViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: SecondViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do this so you can update scroll insets correctly since various dimensions are not loaded until after view did appear
        delegate?.secondViewControllerViewDidAppear(self)
    }
    
    func updateScrollInsets(drawer: DrawerViewController, position: DrawerViewController.Position) {
        let inset = drawer.layout.inset(for: position) ?? 0
        
        // Dynamically adjust scorll inset to scroll entire available area.
        // So thats the height of the view minus the drawer inset + stack view spacing + top space + bottom safe area insets
        let newInset = UIEdgeInsets(top: 0,
                                    left: 0,
                                    bottom: self.view.frame.height
                                        - inset
                                        + 30
                                        + 10
                                        + drawer.view.safeAreaInsets.bottom,
                                    right: 0)
        
        UIView.animate(withDuration: 0.3) {
            switch position {
            case .bottom:
                break
                
            case .mid:
                self.scrollView.contentInset = newInset
                
            case .top:
                self.scrollView.contentInset = newInset
            default:
                break
            }
        }
    }
}

extension SecondViewController: DrawerListener {
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout {
        updateScrollInsets(drawer: drawerViewController, position: drawerViewController.layout.currentPosition)
        return SecondDrawerLayout()
    }
    
    func drawerViewControllerDidEndDragging(_ drawerViewController: DrawerViewController, with velocity: CGPoint, currentPoint: CGFloat, projectedPosition: DrawerViewController.Position?) {
        guard let position = projectedPosition else { return }
        
        updateScrollInsets(drawer: drawerViewController, position: position)
    }
}

final class SecondDrawerLayout: DrawerLayout {
    var currentPosition: DrawerViewController.Position = .hidden
    
    func inset(for position: DrawerViewController.Position) -> CGFloat? {
        switch position {
        case .hidden:
            return nil
        case .bottom:
            return 110
        case .mid:
            return 290
        case .top:
            return 750
        }
    }
}
