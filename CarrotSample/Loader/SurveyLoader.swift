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

class SurveyLoader {
    
    func load(completion: @escaping (Result<SurveyModel, SurveyLoaderError>) -> Void ) {
        DispatchQueue.global().async {
            let survey = createRandomSurvey()
            completion(.success(survey))
        }
    }
}

class SurveyPoster {
    
    func post() {
        DispatchQueue.global().async {
            NotificationCenter.default.post(name: .surveyPost(), object: nil, userInfo: [Notification.Name.surveyPost(): true])
        }
    }
}
