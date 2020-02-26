//
//  CustomDrawerListener.swift
//  AdvanceExample
//
//  Created by Kevin Chen on 2/25/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import DrawerViewController

protocol CustomDrawerListener: DrawerListener {
    func drawerViewControllerDidPressGrabber(_ drawerViewController: DrawerViewController)
}

extension CustomDrawerListener {
    func drawerViewControllerDidPressGrabber(_ drawerViewController: DrawerViewController) {}
}
