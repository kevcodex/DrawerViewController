//  Created by Kevin Chen on 2/21/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

public class DrawerView: UIView {
    
    var grabberView = GrabberView()
    
    var leftBarView: UIView?
    
    private weak var contentView: UIView?
    
    // TODO: - Future allow top area and grabber view width/height to be changeable
    let topAreaHeight: CGFloat = 35
    let grabberHeight: CGFloat = 5
    
    var grabberSpacing: CGFloat {
        return (topAreaHeight - grabberHeight) / 2
    }
    
    var cornerRadius: CGFloat = 24.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var grabberViewColor: UIColor = .gray {
        didSet {
            grabberView.barColor = grabberViewColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        addSubview(grabberView)
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: - Future allow grabber view width/height changeable
        NSLayoutConstraint.activate([
            grabberView.widthAnchor.constraint(equalToConstant: 40),
            grabberView.heightAnchor.constraint(equalToConstant: grabberHeight),
            grabberView.topAnchor.constraint(equalTo: topAnchor, constant: grabberSpacing),
            grabberView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    /// Add the contentView
    ///
    /// - Parameters:
    ///   - contentView: The view to add
    ///   - bottomSpacing: Spacing needed to compensate for drawer view not filling entire screen
    func set(contentView: UIView, bottomSpacing: CGFloat) {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: grabberView.bottomAnchor, constant: grabberSpacing),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomSpacing)
            ])
        
        self.contentView = contentView
    }
    
    func setLeftBarView(_ view: UIView) {
        
        leftBarView?.removeFromSuperview()
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            view.centerYAnchor.constraint(equalTo: grabberView.centerYAnchor)
        ])
        
        if let contentView = contentView {
            view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor).isActive = true
        }
        
        leftBarView = view
    }
    
    func setTopTapArea(target: Any?, action: Selector?, width: CGFloat) {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.heightAnchor.constraint(equalToConstant: topAreaHeight),
            view.widthAnchor.constraint(equalToConstant: width),
            view.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(tapGesture)
        
        self.sendSubviewToBack(view)
    }
}

