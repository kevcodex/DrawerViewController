//
//  IconDrawFactory.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// Factory to generate "hand" drawn icons
class IconDrawFactory {
        
    private init() {}
    
    class func drawArrowHead(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 25, height: 44),
                             direction: ArrowDirection,
                             resizing: ResizingBehavior = .aspectFit,
                             color: UIColor = .black) {
        let context = UIGraphicsGetCurrentContext()!

        // Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 25, height: 44), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 25, y: resizedFrame.height / 44)

        // Combined Shape
        let combinedShape = UIBezierPath()
        combinedShape.move(to: CGPoint(x: 21.51, y: 0.02))
        combinedShape.addCurve(to: CGPoint(x: 24.33, y: 1.03), controlPoint1: CGPoint(x: 22.52, y: -0.08), controlPoint2: CGPoint(x: 23.56, y: 0.25))
        combinedShape.addLine(to: CGPoint(x: 42.01, y: 18.7))
        combinedShape.addCurve(to: CGPoint(x: 42.01, y: 23.65), controlPoint1: CGPoint(x: 43.37, y: 20.07), controlPoint2: CGPoint(x: 43.37, y: 22.29))
        combinedShape.addCurve(to: CGPoint(x: 37.06, y: 23.65), controlPoint1: CGPoint(x: 40.64, y: 25.02), controlPoint2: CGPoint(x: 38.43, y: 25.02))
        combinedShape.addLine(to: CGPoint(x: 21.52, y: 8.11))
        combinedShape.addLine(to: CGPoint(x: 5.98, y: 23.65))
        combinedShape.addCurve(to: CGPoint(x: 1.03, y: 23.65), controlPoint1: CGPoint(x: 4.61, y: 25.02), controlPoint2: CGPoint(x: 2.39, y: 25.02))
        combinedShape.addCurve(to: CGPoint(x: 1.03, y: 18.7), controlPoint1: CGPoint(x: -0.34, y: 22.29), controlPoint2: CGPoint(x: -0.34, y: 20.07))
        combinedShape.addLine(to: CGPoint(x: 18.7, y: 1.03))
        combinedShape.addCurve(to: CGPoint(x: 21.51, y: 0.02), controlPoint1: CGPoint(x: 19.47, y: 0.26), controlPoint2: CGPoint(x: 20.51, y: -0.08))

        combinedShape.close()
        combinedShape.move(to: CGPoint(x: 21.51, y: 0.02))
        context.saveGState()
        context.translateBy(x: 12.34, y: 21.52)
        
        let rotation: CGFloat
        switch direction {
            
        case .left:
            rotation = 270
        case .right:
            rotation = 90
        }
        
        context.rotate(by: rotation * .pi / 180)
        context.translateBy(x: -21.52, y: -12.34)
        combinedShape.usesEvenOddFillRule = true
        color.setFill()
        combinedShape.fill()
        context.restoreGState()

        context.restoreGState()
    }
}


// MARK: - Resizing Behavior

extension IconDrawFactory {
    
    enum ResizingBehavior: String {
        /// The content is proportionally resized to fit into the target rectangle.
        case aspectFit
        /// The content is proportionally resized to completely fill the target rectangle.
        case aspectFill
        /// The content is stretched to match the entire target rectangle.
        case stretch
        /// The content is centered in the target rectangle, but it is NOT resized.
        case center
        
        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}

// MARK: - Icon Types

extension IconDrawFactory {
    
    enum IconType {
        case arrowHead(direction: ArrowDirection)
    }
    
    enum ArrowDirection {
        case left
        case right
    }
}
