//
//  SurveyLoader.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import Foundation

enum SurveyLoaderError: Error {
    case invalid
}

/// 최상단에 나타나는 설문조사 받아오는 객체
struct SurveyLoader {
    
    static func load(completion: @escaping (Result<TopAlertModel, SurveyLoaderError>) -> Void ) {
        DispatchQueue.global().async {
            let survey = createRandomSurvey()
            completion(.success(survey))
        }
    }
}

struct SurveyPoster {

    static func post() {
        DispatchQueue.global().async {
            NotificationCenter.default.post(name: .surveyPost(), object: nil, userInfo: [Notification.Name.surveyPost(): true])
        }
    }
}
