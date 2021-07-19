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
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        textColor = .white
        makeLayerRound()
    }
    
    func setBackground(with state: SellerModel.State) {
        backgroundColor = state.color
    }
    
    func setText(with state: SellerModel.State) {
        text = state.text
    }
    
    func makeLayerRound() {
        setRoundCorner(to: 5.0)
    }
  
}
