//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

open class DrawerViewController: UIViewController {
    
    private var fixedConstraints: [NSLayoutConstraint] = []
    private var topAnchor = NSLayoutConstraint()
    
    /// The initial top anchor constant when starting to drag the view
    private var initialConstant: CGFloat = 0
    
    public private(set) var drawerView: DrawerView = DrawerView()
    
    /// The drawer view's background color
    public var backgroundColor: UIColor = .white {
        didSet {
            drawerView.backgroundColor = backgroundColor
        }
    }
    
    public private(set) var layout: DrawerLayout!
    
    /// The max y the drawer view can be dragged to top.
    /// This should be less than the max position inset.
    public var drawerViewMaxY: CGFloat = 0
    
    /// The min y the view can be dragged to bottom.
    /// This should be less than the min position inset.
    public var drawerViewMinY: CGFloat = 0
    
    /// Is the view being dragged
    public var isDragging: Bool = false
    
    public var currentHeight: CGFloat {
        return topAnchor.constant
    }
    
    /// A mapping of the point to position.
    public var positionMapping: [CGFloat: Position] {
        var positionMapping: [CGFloat: Position] = [:]
        for position in Position.allCases {
            if let inset = layout.inset(for: position) {
                positionMapping[inset] = position
            }
        }
        return positionMapping
    }
    
    public weak var delegate: DrawerViewControllerDelegate? {
        didSet {
            layout = delegate?.drawerViewControllerLayout(in: self) ?? DefaultDrawerLayout()
        }
    }
    /// The time interval required to complete one oscillation. This affects the "duration" of the animation.
    public static var frequencyPeriod: CGFloat = 0.38
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.drawerViewControllerViewDidAppear(self)
    }
    
    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        updateFixedConstraints(for: newCollection)
        
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        delegate?.drawerViewControllerViewWillTransition(to: size, with: coordinator)
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        delegate?.drawerViewControllerTraitCollectionDidChange(previousTraitCollection)
    }
    
    // MARK: - Setup
    
    /// Initialize a newly created drawer panel controller.
    public init() {
        super.init(nibName: nil, bundle: nil)
        setUp()
    }
    
    private func setUp() {
        
        let passThroughView = PassThroughView(frame: view.bounds)
        view = passThroughView
        
        updatePositionLayout()

        drawerView = DrawerView(frame: view.bounds)
        drawerView.backgroundColor = backgroundColor
        
        view.addSubview(drawerView)
        
        // Set position initially hidden
        setupConstraints(to: .hidden)
        activateConstraints()
        
        setupGesture()
    }
    
    private func updateFixedConstraints(for newCollection: UITraitCollection) {
        
        NSLayoutConstraint.deactivate(fixedConstraints)
        if newCollection.verticalSizeClass == .compact {
            
            // TODO: - Maybe allow caller to determine horizontal width size?
            fixedConstraints = [
                drawerView.widthAnchor.constraint(equalToConstant: 375),
                drawerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0.0),
                drawerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0.0),
            ]
        } else {
            
            fixedConstraints = [
                drawerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0.0),
                drawerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0.0),
                drawerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0.0),
            ]
        }
        
        NSLayoutConstraint.activate(fixedConstraints)
    }
    
    // MARK: - Public Methods
    
    /// Add the drawer view controller to parent
    public func add(to viewController: UIViewController, animated: Bool = true) {
        
        guard parent == nil else {
            assertionFailure("Already added to vc")
            return
        }
        
        viewController.addChildVC(self)
        self.constrainToParent()
        
        // added to vc, then animate to initial position
        setupConstraints(to: layout.currentPosition)
        UIView.animate(withDuration: 0.25) {
            self.activateConstraints()
        }
    }
    
    public func showDrawerView(at position: Position,
                        vector: CGVector = .zero,
                        frequencyPeriod: CGFloat = DrawerViewController.frequencyPeriod,
                        animated: Bool,
                        completion: (() -> Void)? = nil) {
        
        setupTopConstraint(to: position)
        
        if animated {
            animateMovingDrawerView(with: vector, frequencyPeriod: frequencyPeriod, completion: completion)
        } else {
            self.activateConstraints()
            
            completion?()
            delegate?.drawerViewControllerDidCompleteMoving(self, to: layout.currentPosition)
        }
        
    }
    
    /// Set an embedded view controller to the drawer view
    /// - Parameters:
    ///     - bottomSpacing: Spacing needed to compensate for drawer view not filling entire screen.
    public func set(contentViewController: UIViewController, bottomSpacing: CGFloat? = nil) {
        
        addChild(contentViewController)
        
        drawerView.set(contentView: contentViewController.view, bottomSpacing: bottomSpacing ?? 0)
        
        contentViewController.didMove(toParent: self)
    }
    
    /// Call when you need to update the position layout.
    /// It will ask the delegate for the position layout.
    public func updatePositionLayout() {
        layout = delegate?.drawerViewControllerLayout(in: self) ?? DefaultDrawerLayout()
    }
    
    /// Finds the nearest position from current position
    /// and move drawer to that position
    public func snapToNearestPosition(from position: CGFloat, animated: Bool) {
        
        var positionPoint: CGFloat = 0
        
        let range = pointsContaining(targetPoint: position)
        
        switch range {
            
        case let (lowerValue?, nil):
            positionPoint = lowerValue
        case let (lowerValue?, upperValue?):
            let middle = (lowerValue + upperValue) / 2
            
            if position < middle {
                positionPoint = lowerValue
            } else {
                positionPoint = upperValue
            }
            
        case let (nil, upperValue?):
            positionPoint = upperValue
        case (.none, .none):
            assertionFailure("This should not happen")
            break
        }
        
        guard let position = positionMapping[positionPoint] else {
            assertionFailure("Something went wrong")
            setupTopConstraint(to: .hidden)
            return
        }
        
        showDrawerView(at: position, animated: animated)
    }
    
    /// Determine the points the selected point is between based on the defined positions.
    public func pointsContaining(targetPoint: CGFloat) -> (lowerValue: CGFloat?, upperValue: CGFloat?) {
        let insets = positionMapping.keys.sorted()
                
        return binarySearchRange(array: insets, target: targetPoint)
    }
    
    /// The positions that the target point is between.
    public func positionsContaining(targetPoint: CGFloat) -> (lowerPosition: Position?, upperPosition: Position?) {
        let range = pointsContaining(targetPoint: targetPoint)
        
        let positionMapping = self.positionMapping
        
        var lowerPosition: Position? = nil
        if let lowerValue = range.lowerValue,
            let lower = positionMapping[lowerValue] {
            lowerPosition = lower
        }
        
        var upperPosition: Position? = nil
        if let upperValue = range.upperValue,
            let upper = positionMapping[upperValue] {
            upperPosition = upper
        }
        
        return (lowerPosition, upperPosition)
    }
        
    // MARK: Embedded Scroll View Handling
    
    /// The reason this is needed is because a scroll view pan gesture will not always have the state .began.
    /// This can lead to weird bugs without it.
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.drawerViewControllerWillBeginDragging(self)
        initialConstant = topAnchor.constant
    }
    
    /// Call if you have an embedded scroll view in the content view
    /// and want to monitor the scrolling.
    /// By default, this will prevent the embeded scroll view from scrolling and move the drawer view instead.
    /// If you want to allow scrolling, you need to impliment custom logic in the scrollViewDidScroll caller.
    /// - Parameter initialOffset: The initial offset of the scroll view if you want it to stay in the same position, defaults to (0,0)
    public func scrollViewDidScroll(_ scrollView: UIScrollView, initialOffset: CGPoint? = nil) {
        
        if scrollView.panGestureRecognizer.state == .changed {
            handle(panGesture: scrollView.panGestureRecognizer)
        }
        
        // Keep the scroll from moving
        scrollView.contentOffset = initialOffset ?? .zero
        scrollView.showsVerticalScrollIndicator = false
    }
    
    /// The reason this is needed is because a scroll view pan gesture will not trigger the state .ended.
    /// So need to implement this method to trigger the .ended state.
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView)  {
        handle(panGesture: scrollView.panGestureRecognizer)
        scrollView.showsVerticalScrollIndicator = true
    }
    
    // MARK: - Private Methods
    
    private func setupGesture() {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handle))
        gesture.delegate = self
        drawerView.addGestureRecognizer(gesture)
    }
    
    private func setupConstraints(to position: Position) {
        
        // Deactivate any constraints
        NSLayoutConstraint.deactivate(fixedConstraints + [topAnchor])
        
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Replace all constraints with new ones
        updateFixedConstraints(for: traitCollection)
        
        setupTopConstraint(to: position)
    }
    
    private func setupTopConstraint(to position: Position) {
        layout.currentPosition = position
        let inset = layout.inset(for: position) ?? drawerViewMinY
        setupTopConstraint(to: inset)
    }
    
    private func setupTopConstraint(to inset: CGFloat) {
        NSLayoutConstraint.deactivate([topAnchor])
        
        topAnchor = view.bottomAnchor.constraint(equalTo: drawerView.topAnchor, constant: inset)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.deactivate(fixedConstraints + [topAnchor])
        
        NSLayoutConstraint.activate(fixedConstraints + [topAnchor])
        
        view.layoutIfNeeded()
    }
    
    private func activateTopConstraint() {
        NSLayoutConstraint.activate([topAnchor])
        
        view.layoutIfNeeded()
    }
    
    @objc private func handle(panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: panGesture.view)
        
        let translation = panGesture.translation(in: panGesture.view)

        let bottomY = drawerViewMinY
        let topY = view.bounds.height - drawerViewMaxY
        
        switch panGesture.state {
            
        case .began:
            delegate?.drawerViewControllerWillBeginDragging(self)
            initialConstant = topAnchor.constant
        case .changed:
            isDragging = true

            let dy = translation.y

            NSLayoutConstraint.deactivate([topAnchor])
            
            let touchConstraint = initialConstant - dy
            
            let newConstraint = max(bottomY, min(touchConstraint, topY))
            
            setupTopConstraint(to: newConstraint)
            
            delegate?.drawerViewControllerIsDragging(self, to: newConstraint)

            activateTopConstraint()

        case .ended, .cancelled, .failed:
            
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
            
            let projectedDY = project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
            
            let currentY = topAnchor.constant
            
            let projectedConstraint = currentY - projectedDY
            
            var positionPoint: CGFloat = 0
            
            let range = pointsContaining(targetPoint: currentY)
            
            switch range {
                
            case let (lowerValue?, nil):
                positionPoint = lowerValue
            case let (lowerValue?, upperValue?):
                let middle = (lowerValue + upperValue) / 2
                
                if projectedConstraint < middle {
                    positionPoint = lowerValue
                } else {
                    positionPoint = upperValue
                }
                
            case let (nil, upperValue?):
                positionPoint = upperValue
            case (.none, .none):
                assertionFailure("This should not happen")
                break
            }
            
            guard let position = positionMapping[positionPoint] else {
                assertionFailure("Something went wrong")
                setupTopConstraint(to: .hidden)
                return
            }
            
            let vector = CGVector(dx: 0, dy: velocity.y / projectedDY)
            
            delegate?.drawerViewControllerDidEndDragging(self,
                                                         with: velocity,
                                                         currentPoint: currentY,
                                                         projectedPosition: position)
            isDragging = false
            
            showDrawerView(at: position, vector: vector, animated: true)
            
        case .possible:
            break
        @unknown default:
            break
        }
    }
    
    private func animateMovingDrawerView(with initialVelocity: CGVector, frequencyPeriod: CGFloat, completion: (() -> Void)? = nil) {
        
        let timing = UISpringTimingParameters(dampingRatio: 1.0,
                                              frequencyPeriod: frequencyPeriod,
                                              initialVelocity: initialVelocity)
        
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timing)
        animator.isInterruptible = false
        
        animator.addAnimations { [weak self] in
            self?.activateTopConstraint()
        }
        
        animator.addCompletion { [weak self] (position) in
            guard let strongSelf = self else {
                return
            }
            
            completion?()
            
            strongSelf.delegate?.drawerViewControllerDidCompleteMoving(strongSelf, to: strongSelf.layout.currentPosition)
        }
        
        animator.startAnimation()
    }
    
    // From WWDC
    /// Distance travelled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return (initialVelocity / 1000.0) * decelerationRate / (1.0 - decelerationRate)
    }
    
    // A bit overkill
    /// Binary search algorithm to find where the target value is between two values in a sorted array.
    ///
    /// - Parameters:
    ///   - array: The array with comparable values
    ///   - target: The target value you want to compare against.
    /// - Returns: Tuple with the lower value and upper value. Nil if it's infinite or doesn't exist for some reason
    private func binarySearchRange<T: Comparable>(array: [T], target: T) -> (lowerValue: T?, upperValue: T?) {
        var lowerIndex = 0
        var upperIndex = array.count
        
        while lowerIndex < upperIndex {
            
            let mid = lowerIndex + (upperIndex - lowerIndex) / 2
            
            if target <= array[mid]  {
                if let previous = array[safe: mid - 1] {
                    if target >= previous {
                        return (previous, array[mid])
                    } else {
                        upperIndex = mid
                    }
                } else {
                    return (nil, array[mid])
                }
            } else if target > array[mid] {
                if let next = array[safe: mid + 1] {
                    
                    if target <= next {
                        return (array[mid], next)
                    } else {
                        lowerIndex = mid + 1
                    }
                } else {
                    return (array[mid], nil)
                }
            }
        }
        
        return (nil, nil)
    }
    
    public enum Position: Equatable, CaseIterable {
        case hidden
        case bottom
        case mid
        case top
    }
}

// MARK: - Gesture Recognizer Delegate

extension DrawerViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let foo = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        // Do not trigger gesture if swiping left or right
        let translation = foo.translation(in: foo.view)

        return translation.y != 0
    }

}
