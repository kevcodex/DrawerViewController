//
//  BlurAnimator.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// Manager for animating a blur effect based on a moving object. E.g. as you scroll, it will incrementally blur
class BlurAnimator {
    
    private var animator: UIViewPropertyAnimator
    
    private let blurView: UIVisualEffectView
    
    private let blurEffect: UIBlurEffect
    
    private weak var containerView: UIView?
    
    /// The starting point of where the bluring should begin
    private(set) var initialPoint: CGFloat?
    
    // Note: cannot check for getter blurView.effect == nil for isblurred because using fractions
    // in animation will instantly execute the animation block.
    var isBlurred = true
    
    init(containerView: UIView, isBlurred: Bool) {
                
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurView)
        
        containerView.bringSubviewToFront(blurView)
        
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            blurView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        self.blurEffect = blurEffect
        self.containerView = containerView
        self.blurView = blurView
        self.isBlurred = isBlurred
        animator = UIViewPropertyAnimator()
        animator.isInterruptible = false
        
        if !isBlurred {
            self.blurView.effect = nil
        }
    }
    
    /// - Parameter initialPoint: A nil initial point will not allow incrementing and you should just call "complete" immediately
    func beginUnBlur(initialPoint: CGFloat?, duration: TimeInterval) {
        
        guard isBlurred,
            animator.state == .inactive  else {
            return
        }
        
        self.initialPoint = initialPoint
        animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        
        animator.addAnimations { [weak self] in
            self?.blurView.effect = nil
        }
    }
    
    /// - Parameter initialPoint: A nil initial point will not allow incrementing and you should just call "complete" immediately
    func beginBlur(initialPoint: CGFloat?, duration: TimeInterval) {
        
        guard !isBlurred,
            animator.state == .inactive else {
            return
        }
        
        self.initialPoint = initialPoint
        animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        
        animator.addAnimations { [weak self] in
            self?.blurView.effect = self?.blurEffect
        }
    }
    
    func incrementBlurEffect(newPoint: CGFloat, expectedFinalPoint: CGFloat) {
        guard let initialPoint = initialPoint else {
            return
        }
        
        let totalDistance = expectedFinalPoint - initialPoint
        let distance = expectedFinalPoint - newPoint
        
        let fraction = 1.0 - distance / totalDistance
        
        animator.fractionComplete = fraction
    }
    
    func completeBlurEffect(reversed: Bool, completion: (() -> Void)? = nil) {
        
        animator.isReversed = reversed

        animator.startAnimation()
        
        animator.addCompletion { [weak self] (_) in
            
            guard let strongSelf = self else {
                return
            }
            
            if reversed {
                
                if strongSelf.isBlurred {
                    strongSelf.blurView.effect = self?.blurEffect
                } else {
                    strongSelf.blurView.effect = nil
                }
            } else {
                strongSelf.isBlurred = !strongSelf.isBlurred
            }
                        
            strongSelf.initialPoint = nil
            
            completion?()
        }
    }
}
