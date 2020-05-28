//
//  UIViewController.swift
//  Flow
//
//  Created by Nikolai Timonin on 21.05.2020.
//

import UIKit

extension UIViewController {

    var contaier: ContainerController? {
        return parent as? ContainerController
    }

    var stackContaier: StackContainerController? {
        return parent as? StackContainerController
    }

    var flatContainer: FlatContainerController? {
        return parent as? FlatContainerController
    }
}

