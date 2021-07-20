//
//  SellerTableViewCell.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/06.
//

import UIKit

class SellerTableViewCell: UITableViewCell {
    
    var sellerView: SellerView = SellerView()
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadSellerView(with: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSellerView(with: nil)
    }
    
    override func prepareForReuse() {
        updateSellerView(by: nil)
    }
    
    private func loadSellerView(with identifier: String?)  {
        change(sellerView, Type: SellerViewType(rawValue: identifier))
        
        contentView.addSubview(sellerView)
        sellerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
             sellerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             sellerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             sellerView.topAnchor.constraint(equalTo: contentView.topAnchor),
             sellerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
        updateSellerView(by: nil)
    }
    
    func updateSellerView(by seller: SellerModel?) {
        sellerView.updateView(by: seller)
    }
}
