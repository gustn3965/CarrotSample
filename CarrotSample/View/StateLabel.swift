//
//  ReservedLabel.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/06.
//

import UIKit

class StateLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView() {
        textColor = .white
        setRoundCorner(to: 5.0)
    }
    
    func updateView(by state: SellerModel.State) {
        backgroundColor = state.color
        text = state.text
    }
}
