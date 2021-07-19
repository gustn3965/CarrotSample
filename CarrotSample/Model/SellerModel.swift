//
//  SellerModel.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/06.
//

import Foundation
import UIKit.UIImage

/// 판매자의 정보를 담는 객체입니다.
class SellerModel {
    
    /// 판매자의 판매상태를 나타냅니다.
    /// * reserved - 예약중
    /// * sold - 판매완료
    /// * selling - 판매중
    enum State: String {
        case reserved = "reserved"
        case sold = "sold"
        case selling = "selling"
        
        var color: UIColor? {
            switch self {
            case .reserved: return UIColor(named: "reservedColor")
            case .sold: return .black
            case .selling: return nil
            }
        }
        
        var text: String? {
            switch self {
            case .reserved: return "  예약중  "
            case .sold: return "  거래완료  "
            case .selling: return nil
            }
        }
        
        init(rawValue: String) {
            switch rawValue {
            case "reserved": self = .reserved
            case "sold": self = .sold
            case "selling": self = .selling
            default: self = .selling
            }
        }
    }
    
    var thumbnail: UIImage?
    var title: String
    var location: String
    var price: Int
    var state: State
    var messageCount: Int
    var likeCount: Int
    
    init(_ title: String,
         _ location: String,
         _ price: Int,
         _ state: State,
         _ messageCount: Int = 0,
         _ likeCount: Int = 0) {
        self.title = title
        self.location = location
        self.price = price
        self.state = state
        self.messageCount = messageCount
        self.likeCount = likeCount
    }
}
