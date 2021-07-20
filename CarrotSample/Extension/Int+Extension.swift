//
//  String+Extension.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/07.
//

import Foundation

extension Int {
    func returnPriceString() -> String {
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        guard let priceStr = numberFormmater.string(from: NSNumber(value: self)) else { return ""}
        return priceStr
    }
}
