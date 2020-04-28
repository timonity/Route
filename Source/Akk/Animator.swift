//
//  Animator.swift
//  Flow
//
//  Created by Nikolai Timonin on 05.04.2020.
//

import UIKit

public protocol Animator: UIViewControllerAnimatedTransitioning {
    
    var isOpening: Bool { get set }
}
