//
//  DispatchQueue+Extension.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/19.
//

import Foundation

extension DispatchQueue {
    static func mainAsync(_ work: @escaping () -> Void ) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
}
