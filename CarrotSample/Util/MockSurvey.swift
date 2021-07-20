//
//  MockSurvey.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import Foundation

func createRandomSurvey() -> TopAlertModel{
    let titleList = ["만족하며 거래하고 있나요?",
                     "당근 어플이 살림에 도움이 되시나요? ",
                     "친구를 초대하고 스타벅스 커피 쿠폰을 받으시겠어요?",
                     "당근마켓 인턴이 되고싶나요?"]
    let cancelList = ["아니요", "아니요", "다음에 할게요", "아니요는 안돼요"]
    let agreeList = ["그럼요!", "그럼요!", "초대하기", "무조건 되고싶어요"]
    
    let idx = (0..<titleList.count).randomElement()!
    return TopAlertModel(title: titleList[2],
                       subTitle: nil,
                       cancel: cancelList[2],
                       agree: agreeList[2])
}


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
