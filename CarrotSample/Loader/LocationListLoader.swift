//
//  LocationListLoader.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/19.
//

import Foundation

struct LocationListLoader {
    
    static func load(_ completion: @escaping (([String]) -> Void )) {
        DispatchQueue.global().async {
            let list = ["산본동", "아현동", "석수동"]
            completion(list)
        }
    }
}
