//
//  MockLocationCertification.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/21.
//

import Foundation

func createRandomLocationCertification(name: String, with population: Int) -> TopAlertModel {
    let title = "따뜻한 거래를 시작해보세요!"
    let subTitle = "지금 동네인증을 하고 \(name) 근처 이웃 \(population.returnPriceString())명과 거래하세요."
    let cancel: String? = nil
    let agree: String = "동네인증하고 시작하기"
    return TopAlertModel(title: title,
                       subTitle: subTitle,
                       cancel: cancel,
                       agree: agree)
}
