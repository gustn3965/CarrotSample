//
//  SurveyViewCell.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import UIKit.UITableViewCell

class TopAlertTableViewCell: UITableViewCell {
    
    private var topAlertView: TopAlertView = TopAlertView()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadSurveyView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSurveyView()
    }
    
    //MARK: - setUpView
    private func loadSurveyView()  {
        contentView.addSubview(topAlertView)
        topAlertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [topAlertView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             topAlertView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             topAlertView.topAnchor.constraint(equalTo: contentView.topAnchor),
             topAlertView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    //MARK: - 
    func updateTopAlertView(by model: TopAlertModel) {
            topAlertView.updateView(by: model)
    }
}
