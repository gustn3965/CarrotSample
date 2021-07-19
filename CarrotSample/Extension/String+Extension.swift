//
//  String+Extension.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/07.
//

import Foundation

extension String {
    static func returnPriceString(with price: Int) -> String {
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        guard let priceStr = numberFormmater.string(from: NSNumber(value: price)) else { return ""}
        return priceStr
    }
}
