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

// In this view we have a table view where the drawer insets are dynamic based on various things.
final class FirstViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
        
    lazy var tableViewHandler: FirstTableHandler = {
        FirstTableHandler(viewModel: viewModel)
    }()
    
    weak var delegate: FirstViewControllerDelegate?
    weak var blurrable: Blurrable?
    
    var viewModel = FirstViewModel()
    
    static let cellHeight: CGFloat = 140
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHandler.targetScrollView = tableView
        tableViewHandler.delegate = self
        
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

extension FirstViewController: CustomDrawerListener {
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout {
        
        let topInset: CGFloat
        let midInset: CGFloat
        
        // Dynamically set the insets based on the safe area and frame and cell height and trait layout.
        if traitCollection.verticalSizeClass == .compact {
            topInset = drawerViewController.view.frame.height - drawerViewController.view.safeAreaInsets.top - 20
            
            midInset = drawerViewController.drawerView.topAreaHeight + drawerViewController.view.safeAreaInsets.bottom
        } else {
            topInset = drawerViewController.view.frame.height - drawerViewController.view.safeAreaInsets.top - 44
            
            midInset = FirstViewController.cellHeight + drawerViewController.drawerView.topAreaHeight + drawerViewController.view.safeAreaInsets.bottom
        }
        
        return FirstDrawerLayout(mid: midInset, top: topInset)
    }
    
    func drawerViewControllerDidPressGrabber(_ drawerViewController: DrawerViewController) {
        if drawerViewController.layout.currentPosition == .top {
            drawerViewController.showDrawerView(at: .mid, animated: true)
            blurrable?.unBlur(initialPoint: nil)
        } else {
            drawerViewController.showDrawerView(at: .top, animated: true)
            blurrable?.blur(initialPoint: nil, completion: nil)
        }
    }
        
    func drawerViewControllerTraitCollectionDidChange(in drawerViewController: DrawerViewController, previousTraitCollection: UITraitCollection?) {
        let currentPosition = drawerViewController.layout.currentPosition
        drawerViewController.updatePositionLayout()
        drawerViewController.showDrawerView(at: currentPosition, animated: true)
    }
}

final class FirstDrawerLayout: DrawerLayout {
    var currentPosition: DrawerViewController.Position = .hidden
    
    let mid: CGFloat?
    let top: CGFloat?
    
    init(mid: CGFloat?, top: CGFloat?) {
        self.mid = mid
        self.top = top
    }
    
    func inset(for position: DrawerViewController.Position) -> CGFloat? {
        switch position {
        case .hidden:
            return nil
        case .bottom:
            return nil
        case .mid:
            return mid
        case .top:
            return top
        }
    }
}
