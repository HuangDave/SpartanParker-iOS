//
//  TransactionTableViewCell.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 12/9/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    private let dateLabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textAlignment = .left
    }
    private let amountLabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 12.0)
        $0.textAlignment = .center
    }

    var transaction: Transaction? {
        didSet {
            if transaction != nil {
                dateLabel.text = transaction?.formattedDate
                amountLabel.text = "$" + (transaction?.amount.stringValue)!
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let padding: CGFloat = 10.0
        let minimumAmountLabelWidth: CGFloat = 100.0
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                        constant: padding * 4.0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: amountLabel.leftAnchor).isActive = true
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                          constant: -padding).isActive = true
        amountLabel.widthAnchor.constraint(equalToConstant: minimumAmountLabelWidth).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
