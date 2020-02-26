//
//  MapViewController.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit
import MapKit
import DrawerViewController

final class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var blurAnimator: BlurAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurAnimator = BlurAnimator(containerView: self.view, isBlurred: false)
    }
}

// MARK: - Blur Methods

extension MapViewController: Blurrable {
    
    func unBlur(initialPoint: CGFloat?) {
        blurAnimator?.beginUnBlur(initialPoint: initialPoint, duration: TimeInterval(DrawerViewController.frequencyPeriod))
        blurAnimator?.completeBlurEffect(reversed: false)
    }
    
    func blur(initialPoint: CGFloat?, completion: (() -> Void)? = nil) {
        blurAnimator?.beginBlur(initialPoint: initialPoint, duration: TimeInterval(DrawerViewController.frequencyPeriod))
        blurAnimator?.completeBlurEffect(reversed: false, completion: completion)
    }
}

// MARK: - Drawer Listener

extension MapViewController: DrawerListener {
    func drawerViewControllerWillBeginDragging(_ drawerViewController: DrawerViewController) {
        
        guard let initialPoint = drawerViewController.layout.currentPositionInset(),
            let blurAnimator = blurAnimator else {
                return
        }
        
        if blurAnimator.isBlurred {
            
            blurAnimator.beginUnBlur(initialPoint: initialPoint, duration: TimeInterval(DrawerViewController.frequencyPeriod))
        } else {
            
            blurAnimator.beginBlur(initialPoint: initialPoint, duration: TimeInterval(DrawerViewController.frequencyPeriod))
        }
    }
    
    func drawerViewControllerIsDragging(_ drawerViewController: DrawerViewController, to point: CGFloat) {
        
        let pointsBetween = drawerViewController.pointsContaining(targetPoint: point)
        
        guard let blurAnimator = blurAnimator,
            let upperValue = pointsBetween.upperValue,
            let lowerValue = pointsBetween.lowerValue else {
                return
        }
        
        let finalPoint: CGFloat
        
        if blurAnimator.isBlurred {
            finalPoint = lowerValue
        } else {
            finalPoint = upperValue
        }
        
        blurAnimator.incrementBlurEffect(newPoint: point, expectedFinalPoint: finalPoint)
        
    }
    
    func drawerViewControllerDidEndDragging(_ drawerViewController: DrawerViewController, with velocity: CGPoint, currentPoint: CGFloat, projectedPosition: DrawerViewController.Position?) {
        
        guard let blurAnimator = blurAnimator,
            let position = projectedPosition,
            let newPosition = drawerViewController.layout.inset(for: position) else {
                return
        }
        
        if newPosition == blurAnimator.initialPoint {
            blurAnimator.completeBlurEffect(reversed: true)
        } else {
            blurAnimator.completeBlurEffect(reversed: false)
        }
    }
}

