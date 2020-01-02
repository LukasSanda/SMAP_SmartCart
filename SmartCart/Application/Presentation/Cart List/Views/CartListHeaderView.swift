//
//  CartListHeaderView.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 06/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal class CartListHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Private Properties
    
    private let label = UILabel()
    
    // MARK: - Internal Properties
    
    internal var text = "" {
        didSet { label.text = text.uppercased() }
    }
    
    // MARK: - Initialization
    
    override internal init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup View Appereance
private extension CartListHeaderView {
    func setup() {
        contentView.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .lightGray
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
    }
}
