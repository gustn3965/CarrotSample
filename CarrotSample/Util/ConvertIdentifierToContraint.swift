//
//  ConvertidentifierToContraint.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import UIKit


/// SellerView를 `재활용`하기위해,  identifier에 따라 `Type`을 만든다.
/// 홈뷰컨틀로러의 테이블뷰,  중고거래상품찾는 테이블뷰, 키워드알림의 테이블뷰의 셀들의 뷰가 같다라고 생각함.
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

/// SellerView를 재활용하기위해,  `Type`에 따라 `SellerView`의 레이아웃을 변경한다.
func change(_ sellerView: SellerView, Type type: SellerViewType) {
    let heightConstant = convertToConstant(by: type)
    sellerView.imageViewHeightContraint.constant = heightConstant
    sellerView.imageViewHeightContraint.isActive = true 
    
    switch type {
    case .sellerCell:
        sellerView.topStackView.isHidden = false
        sellerView.middleStackView.isHidden = false
        sellerView.bottomStackView.isHidden = false
    case .notificationCell:
        sellerView.topStackView.isHidden = false
        sellerView.middleStackView.isHidden = true
        sellerView.bottomStackView.isHidden = true
    }
}

private func convertToConstant(by type: SellerViewType) -> CGFloat{
    switch type {
    case .sellerCell : return 120.0
    case .notificationCell: return 60.0
    }
}
