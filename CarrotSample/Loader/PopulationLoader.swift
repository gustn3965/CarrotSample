//
//  PopulationLoader.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/19.
//

import Foundation

/// 특정지역 인구수 가져오는 객체
struct PopulationLoader {
    
    static func load(_ completion: @escaping (Int) -> Void) {
        DispatchQueue.global().async {
            let population = createRandomNumber(with: 123400..<2310000)
            completion(population)
        }
    }
}
