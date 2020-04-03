//
//  UIVew.swift
//  Flow
//
//  Created by Nikolai Timonin on 02.04.2020.
//

import UIKit

extension UIView {
    
    func appendConstraints(to view: UIView, withSafeArea isWithSafeArea: Bool = false) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if isWithSafeArea, #available(iOS 11.0, *) {
            
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
        } else {
            
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
    }
}
