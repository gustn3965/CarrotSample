//
//  Notification.Name+Extension.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import Foundation

extension Notification.Name {
    static func surveyPost() -> Self {
        return Notification.Name("surveyPost")
    }
    static func locationPost() -> Self {
        return Notification.Name("notificationPost")
    }
}
