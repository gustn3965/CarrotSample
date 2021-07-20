//
//  UIView+Extension.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import UIKit.UIView


extension UIView {
    func setRoundCorner(to value: CGFloat) {
        layer.cornerRadius = value
        clipsToBounds = true
    
    }
}
