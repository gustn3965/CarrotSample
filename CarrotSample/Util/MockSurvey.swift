//
//  MockSurvey.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import Foundation

func createRandomSurvey() -> SurveyModel{
    let titleList = ["만족하며 거래하고 있나요?a df dfds ",
                             "당근 어플이 살림에 도움이 되시나요? dfdf  dfdf ",
                             "친구를 초대하고 스타벅스 커피 쿠폰을 받으시겠어요?dafs asdfasdf f dsf",
                             "당근마켓 인턴이 되고싶나요? dfdfs asdf  d "]
    let cancelList = ["아니요", "아니요", "다음에 할게요", "아니요는 안돼요"]
    let agreeList = ["그럼요!", "그럼요!", "초대하기", "무조건 되고싶어요"]
    
    let idx = (0..<titleList.count).randomElement()!
    return SurveyModel(title: titleList[idx],
                cancel: cancelList[idx],
                agree: agreeList[idx])
}

