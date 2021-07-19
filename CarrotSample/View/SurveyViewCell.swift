//
//  SurveyViewCell.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import UIKit.UITableViewCell

class SurveyViewCell: UITableViewCell {
    
    private var surveyView: SurveyView = SurveyView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadSurveyView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSurveyView()
    }
    
    private func loadSurveyView()  {
        contentView.addSubview(surveyView)
        surveyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [surveyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             surveyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             surveyView.topAnchor.constraint(equalTo: contentView.topAnchor),
             surveyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    func updateSurveyView(with model: SurveyModel) {
        DispatchQueue.main.async { [self] in
            surveyView.updateSurveyView(with: model)
//            contentView.heightAnchor.constraint(equalToConstant: contentView.intrinsicContentSize.height).isActive = true 
//            contentView.layoutSubviews()
            
        }
        
    }
}
