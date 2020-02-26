//
//  Blurrable.swift
//  AdvanceExample
//
//  Created by Kevin Chen on 2/25/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

protocol Blurrable: class {
    var blurAnimator: BlurAnimator? { get set }
    
    func unBlur(initialPoint: CGFloat?)
    func blur(initialPoint: CGFloat?, completion: (() -> Void)?)
}
