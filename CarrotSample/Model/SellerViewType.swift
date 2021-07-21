//
//  ConvertidentifierToContraint.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import UIKit


/// SellerView를 `재활용`하기위해,  identifier에 따라 `Type`을 만든다.
/// `홈뷰컨틀로러의 테이블뷰`,  `중고거래상품찾는 테이블뷰`, `키워드알림의 테이블뷰`의 셀들의 뷰가 같다라고 생각함.
enum SellerViewType: String {
    case sellerCell = "sellerCell"
    case notificationCell = "notificationCell"
    
    init(rawValue: String?) {
        switch rawValue {
        case "sellerCell": self = .sellerCell
        case "notificationCell": self = .notificationCell
        default: self = .sellerCell
        }
    }
    
    var identifier: String { self.rawValue }
}
