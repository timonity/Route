//
//  Button.swift
//  FlowExample
//
//  Created by Nikolai Timonin on 23.04.2020.
//  Copyright © 2020 HOME. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }
    
    func setupWith(action: Action) {
        
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        if #available(iOS 11.0, *) {
            backgroundColor = UIColor(named: "main_button")!
        } else {
            
        }
        
        setTitle(action.title, for: .normal)
        tag = action.rawValue
    }
}
