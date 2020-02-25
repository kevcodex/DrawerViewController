//
//  IconTextButton.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

/// A simple button with an icon either on the left or right side of the text.
class IconTextButton: BasicButton, CornerRadiusDecorator, BorderDecorator {
    
    let stackView = UIStackView()
    
    let titleLabel = UILabel()
    
    private(set) var iconView = UIView()
    
    var iconSize = CGSize(width: 14, height: 35) {
        didSet {
            iconViewWidthConstraint?.constant = iconSize.width
            iconViewHeightConstraint?.constant = iconSize.height
        }
    }
    
    /// Insets for the stack view container.
    /// Make sure all values are positive as internally will resolve correctly.
    var containerInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) {
        didSet {
            topConstraint?.constant = containerInsets.top
            bottomConstraint?.constant = -containerInsets.bottom
            leftSideConstraint?.constant = containerInsets.left
            rightSideConstraint?.constant = containerInsets.right
        }
    }
    
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var leftSideConstraint: NSLayoutConstraint?
    private var rightSideConstraint: NSLayoutConstraint?
    private var iconViewWidthConstraint: NSLayoutConstraint?
    private var iconViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        setUpStackView()
        
        setUpTextLabel()
    }
    
    private func setUpStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        
        addSubview(stackView)
        
        topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: containerInsets.top)
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -containerInsets.bottom)
        rightSideConstraint = stackView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: containerInsets.right)
        leftSideConstraint = stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: containerInsets.left)
        
        topConstraint?.isActive = true
        bottomConstraint?.isActive = true
        rightSideConstraint?.isActive = true
        leftSideConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setUpTextLabel() {
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setIconView(_ view: UIView, position: IconPosition) {
        stackView.removeArrangedSubview(iconView)
        iconView.removeFromSuperview()
        
        self.iconView = view
        
        let containerView = UIView()
        containerView.isUserInteractionEnabled = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.isUserInteractionEnabled = false
        iconView.backgroundColor = .clear
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        switch position {
        case .left:
            stackView.insertArrangedSubview(containerView, at: 0)
        case .right:
            stackView.addArrangedSubview(containerView)
        }
        containerView.addSubview(iconView)
        
        iconViewWidthConstraint = iconView.widthAnchor.constraint(equalToConstant: iconSize.width)
        iconViewHeightConstraint = iconView.heightAnchor.constraint(equalToConstant: iconSize.height)
        
        iconViewWidthConstraint?.isActive = true
        iconViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            iconView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            iconView.leftAnchor.constraint(equalTo: containerView.leftAnchor)
        ])
    }
}

extension IconTextButton {
    /// The position the icon should be on
    enum IconPosition {
        case left
        case right
    }
}
