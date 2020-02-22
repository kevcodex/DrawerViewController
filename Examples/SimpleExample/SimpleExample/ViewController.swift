//
//  ViewController.swift
//  SimpleExample
//
//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit
import DrawerViewController

// A very simple example to add a basic content view to the drawer with custom insets.
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let drawer = DrawerViewController()
        drawer.delegate = self
        
        let contentViewController = UIViewController()
        contentViewController.view.backgroundColor = .red
        
        let bottomSpacing = drawer.view.frame.height - (drawer.layout.inset(for: .top) ?? drawer.view.frame.height)
        
        drawer.add(to: self)
        drawer.set(contentViewController: contentViewController, bottomSpacing: bottomSpacing)
        
        drawer.backgroundColor = .init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        drawer.drawerView.grabberViewColor = .init(white: 0, alpha: 0.2)
        
        drawer.showDrawerView(at: .bottom, animated: true)
    }
}

extension ViewController: DrawerViewControllerDelegate {
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout {
        return CustomDrawerLayout()
    }
}

final class CustomDrawerLayout: DrawerLayout {
    var currentPosition: DrawerViewController.Position = .hidden
    
    init() {}
    
    func inset(for position: DrawerViewController.Position) -> CGFloat? {
        switch position {
        case .hidden:
            return nil
        case .bottom:
            return 90
        case .mid:
            return 270
        case .top:
            return 800
        }
    }
}
