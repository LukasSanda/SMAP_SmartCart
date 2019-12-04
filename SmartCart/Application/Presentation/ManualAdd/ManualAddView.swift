//
//  ManualAddView.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 03/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal class ManualAddView: UIView {
    
    // MARK: - Properties
    
    internal let tableView = UITableView()
    
    // MARK: - Initialization
    
    internal init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup View Appereance
private extension ManualAddView {
    func setup() {
        tableView.separatorStyle = .none
        tableView.register(cell: ManualAddCell.self)
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

