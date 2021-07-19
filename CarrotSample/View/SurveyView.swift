//
//  SurveyView.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import UIKit


class SurveyView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    var titleLabelHeightConstraint: NSLayoutConstraint!
    var isFinsihLoad = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        setUpView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        setUpView()
    }
    
    
    
    private func loadView() {
        let bundle = Bundle(for: SurveyView.self)
        let nib = UINib(nibName: "SurveyView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
        [view.leadingAnchor.constraint(equalTo: leadingAnchor),
         view.trailingAnchor.constraint(equalTo: trailingAnchor),
         view.topAnchor.constraint(equalTo: topAnchor),
         view.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    private func setUpView() {
        setUpButtonView()
        setUpStackView()
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height)
    }
    
    private func setUpButtonView() {
        cancelButton.backgroundColor = .white
        cancelButton.tintColor = .black
        agreeButton.backgroundColor = UIColor(named: "carrotColor")
        agreeButton.tintColor = .white
        cancelButton.setRoundCorner(to: 5.0)
        agreeButton.setRoundCorner(to: 5.0)
        
        cancelButton.addTarget(self, action: #selector(clickAgree), for: .touchUpInside)
        agreeButton.addTarget(self, action: #selector(clickAgree), for: .touchUpInside)
    }
    
    private func setUpStackView() {
        stackView.setRoundCorner(to: 7.0)
    }
    
    func updateSurveyView(with model: SurveyModel) {
        isFinsihLoad = true
        
            agreeButton.setTitle(model.agree, for: .normal)
            cancelButton.setTitle(model.cancel, for: .normal)
        titleLabel.text = model.title
        
//        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height)
//        titleLabelHeightConstraint.isActive = true
//        print(titleLabel.intrinsicContentSize)
//        
//        NSLayoutConstraint.activate(
//            [agreeButton.heightAnchor.constraint(equalToConstant: 60)])
        
    }
    
    
    @objc func clickAgree() {
        SurveyPoster().post()
    }
    
}
