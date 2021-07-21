//
//  SurveyView.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/16.
//

import UIKit


class TopAlertView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    var titleLabelHeightConstraint: NSLayoutConstraint!
    var isFinsihLoad = false
    
    //MARK: - init
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
    
    //MARK: - setUpView
    private func loadView() {
        let bundle = Bundle(for: TopAlertView.self)
        let nib = UINib(nibName: "TopAlertView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    private func setUpView() {
        setUpButtonView()
        setUpStackView()
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height)
        stackView.backgroundColor = UIColor(named: "customWhiteGray")
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
    
    // MARK: -
    func updateView(by model: TopAlertModel) {
        isFinsihLoad = true
        
        DispatchQueue.mainAsync { [self] in
            agreeButton.setTitle(model.agree, for: .normal)
            cancelButton.setTitle(model.cancel, for: .normal)
            titleLabel.text = model.title
            subTitleLabel.text = model.subTitle
            
            agreeButton.isHidden = model.agree == nil
            cancelButton.isHidden = model.cancel == nil
            titleLabel.isHidden = model.title == nil
            subTitleLabel.isHidden = model.subTitle == nil
        }
    }
    
    // MARK: - Action 
    @objc func clickAgree() {
        SurveyPoster.post()
    }
}
