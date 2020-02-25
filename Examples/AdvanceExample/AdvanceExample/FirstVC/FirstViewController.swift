//
//  FirstViewController.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit
import DrawerViewController

protocol FirstViewControllerDelegate: class {
    func firstViewController(_ firstViewController: FirstViewController, didSelectCity city: City)
}

final class FirstViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewHandler: FirstTableHandler?
    
    weak var drawer: DrawerViewController?
    weak var delegate: FirstViewControllerDelegate?
    
    var viewModel = FirstViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHandler = FirstTableHandler(viewModel: viewModel, targetScrollView: tableView, drawer: drawer)
        tableViewHandler?.delegate = self
        
        tableView.dataSource = tableViewHandler
        tableView.delegate = tableViewHandler
        
        viewModel.populate()
        tableView.reloadData()
    }
}

extension FirstViewController: FirstTableHandlerDelegate {
    func firstTableHandler(_ firstTableHandler: FirstTableHandler, didSelectCity city: City) {
        delegate?.firstViewController(self, didSelectCity: city)
    }
}

extension FirstViewController: DrawerListener {
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout {
        return FirstDrawerLayout()
    }
}

final class FirstDrawerLayout: DrawerLayout {
    var currentPosition: DrawerViewController.Position = .hidden
    
    func inset(for position: DrawerViewController.Position) -> CGFloat? {
        switch position {
        case .hidden:
            return nil
        case .bottom:
            return nil
        case .mid:
            return 200
        case .top:
            return 750
        }
    }
}
