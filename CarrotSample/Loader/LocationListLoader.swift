//
//  LocationListLoader.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/19.
//

import Foundation

/// 현재 사용자의 설정한 지역리스트를 비동기적으로 가져오는 객체 
struct LocationListLoader {
    
    static func load(_ completion: @escaping (([String]) -> Void )) {
        DispatchQueue.global().async {
            let list = ["산본동", "아현동", "석수동"]
            completion(list)
        }
    }
}
