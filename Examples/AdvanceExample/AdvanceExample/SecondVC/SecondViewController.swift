//
//  SecondViewController.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit
import DrawerViewController

final class SecondViewController: UIViewController {
    
}

extension SecondViewController: DrawerListener {
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout {
        return SecondDrawerLayout()
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
