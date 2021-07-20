//
//  MockSeller.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/06.
//

import Foundation

func createMockSeller() -> SellerModel{
    let title = createRandomString(to: 200)
    let location = createRandomLocation() + " " +  createRandomString(to: 10)
    let price = createRandomNumber(with: 1000..<1000000)
    let state = createRandomState()
    let messageCount = createRandomNumber(with: 0..<10)
    let likeCount = createRandomNumber(with: 0..<10)
    return SellerModel(title,
                       location,
                       price,
                       state,
                       messageCount,
                       likeCount)
}

private func createRandomString(to count: Int ) -> String  {
    let strList = (65..<123).map{String(Unicode.Scalar($0)!)}
    var title: String = ""
    for _ in 0..<(0..<count).randomElement()! {
        title.append(strList.randomElement()!)
    }
    return title
}

private func createRandomLocation() -> String {
    let strList = ["군포시","서울시","부산시","수원시"]
    let strList2 = ["산본동","부곡동","안양동","광정동"]
    let str = strList.randomElement()! + " " + strList2.randomElement()!
    return str
}

func createRandomNumber(with range: Range<Int>) -> Int {
    return (range).randomElement()!
}

private func createRandomState() -> SellerModel.State {
    let stateList =  ["reserved", "sold", "selling"]
    return SellerModel.State(rawValue: stateList.randomElement()!)
}


