//
//  ViewController.swift
//  AdvanceExample
//
//  Created by Kevin Chen on 2/23/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit
import DrawerViewController

// A more advanced example of the drawer with a map in the background, a navigation controller/table view in drawer, animator that changes with drawer movement, and touch events for the grabber view. Each vc in the nav. cont. has different drawer steps.

final class ContainerViewController: UIViewController {
    
    private let drawer = DrawerViewController()
    private let drawerBackButton = DrawnIconTextButton()
    
    private var mapViewController: MapViewController!
    
    private let contentNavigationController = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
        setUpDrawerContent()
        setUpDrawer()
    }
    
    // MARK: - SetUp Methods
    
    private func setUpMap() {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        mapViewController = storyboard.instantiateViewController(identifier: "MapViewController")
        
        addChildVC(mapViewController)
        mapViewController.constrainToParent()
    }
    
    private func setUpDrawerContent() {
        
        let storyboard = UIStoryboard(name: "First", bundle: nil)
        
        let firstVC: FirstViewController = storyboard.instantiateViewController(identifier: "FirstViewController") 
        firstVC.drawer = drawer
        firstVC.delegate = self
        firstVC.blurrable = mapViewController
        
        contentNavigationController.setNavigationBarHidden(true, animated: false)
        contentNavigationController.setViewControllers([firstVC], animated: false)
    }

    private func setUpDrawer() {
        drawer.delegate = self
        
        let bottomSpacing = drawer.view.frame.height - (drawer.layout.inset(for: .top) ?? drawer.view.frame.height)
        
        drawer.add(to: self)
        drawer.set(contentViewController: contentNavigationController, bottomSpacing: bottomSpacing)
        
        drawer.backgroundColor = .init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        drawer.drawerView.grabberViewColor = .init(white: 0, alpha: 0.2)
        
        // Setup a "back" button
        drawerBackButton.titleLabel.text = "Back"
        drawerBackButton.titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        
        drawerBackButton.addTarget(self,
                                   action: #selector(drawerBackButtonDidPress),
                                   for: .touchUpInside)

        drawerBackButton.isHidden = true
        
        drawer.drawerView.setLeftBarView(drawerBackButton)
        
        // Setup touch area at the grab view
        drawer.drawerView.setTopTapArea(target: self, action: #selector(drawerGrabberDidPress), width: 150)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // This is just because you'll get a warning about the table view is not added to hierarchy yet.
        // Also to update the layout vased on safe insets which are not determined until view did appear
        drawer.updatePositionLayout()
        drawer.showDrawerView(at: .mid, animated: true)
    }
    
     @objc private func drawerBackButtonDidPress() {
        contentNavigationController.popViewController(animated: true)
        
        guard let topViewController = contentNavigationController.topViewController else {
            return
        }
        
        switch topViewController {
        case is FirstViewController:
            drawerBackButton.isHidden = true
            drawer.updatePositionLayout()
            drawer.showDrawerView(at: .mid, animated: true)
        default:
            break
        }
    }
    
    @objc private func drawerGrabberDidPress(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            guard let topViewController = contentNavigationController.topViewController as? CustomDrawerListener else {
                return
            }
            
            topViewController.drawerViewControllerDidPressGrabber(drawer)
        }
    }
}

// MARK: - Drawer Delegate
extension ContainerViewController: DrawerViewControllerDelegate {
    func drawerViewControllerLayout(in drawerViewController: DrawerViewController) -> DrawerLayout {
        guard let topViewController = contentNavigationController.topViewController as? DrawerListener else {
            assertionFailure("bloop")
            return DefaultDrawerLayout()
        }
        
        return topViewController.drawerViewControllerLayout(in: drawerViewController)
    }
    
    func drawerViewControllerWillBeginDragging(_ drawerViewController: DrawerViewController) {
        guard let topViewController = contentNavigationController.topViewController else {
            return
        }
        
        switch topViewController {
        case is FirstViewController:
            mapViewController.drawerViewControllerWillBeginDragging(drawerViewController)
        default:
            break
        }
    }
    
    func drawerViewControllerIsDragging(_ drawerViewController: DrawerViewController, to point: CGFloat) {
        
        guard let topViewController = contentNavigationController.topViewController else {
            return
        }
        
        switch topViewController {
        case is FirstViewController:
            mapViewController.drawerViewControllerIsDragging(drawerViewController, to: point)
           
        default:
            break
        }
    }
    
    func drawerViewControllerDidEndDragging(_ drawerViewController: DrawerViewController, with velocity: CGPoint, currentPoint: CGFloat, projectedPosition: DrawerViewController.Position?) {
        
        guard let topViewController = contentNavigationController.topViewController else {
            return
        }

        switch topViewController {
        case is FirstViewController:
            mapViewController.drawerViewControllerDidEndDragging(drawerViewController, with: velocity, currentPoint: currentPoint, projectedPosition: projectedPosition)
        default:
            break
        }
    }
    
    func drawerViewControllerTraitCollectionDidChange(in drawerViewController: DrawerViewController, previousTraitCollection: UITraitCollection?) {
        guard let topViewController = contentNavigationController.topViewController as? DrawerListener else {
            return
        }
        
        topViewController.drawerViewControllerTraitCollectionDidChange(in: drawerViewController, previousTraitCollection: previousTraitCollection)
    }
}

// MARK: - First View Controller Delegate
extension ContainerViewController: FirstViewControllerDelegate {
    func firstViewController(_ firstViewController: FirstViewController, didSelectCity city: City) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let secondVC: SecondViewController = storyboard.instantiateViewController(identifier: "SecondViewController")
        
        let initialPoint = self.drawer.layout.currentPositionInset() ?? 0
        mapViewController.unBlur(initialPoint: initialPoint)
        
        contentNavigationController.pushViewController(secondVC, animated: true)
        
        drawer.updatePositionLayout()
        drawer.showDrawerView(at: .mid, animated: true)
        
        drawerBackButton.isHidden = false
    }
}
