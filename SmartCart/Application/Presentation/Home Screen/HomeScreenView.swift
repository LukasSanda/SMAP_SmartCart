//
//  HomeScreenView.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import SnapKit

internal class HomeScreenView: UIView {
    
    // MARK: - Private Properties
    
    private let contentView = UIView()
    private let gradientView = UIView()
    private let buttonCreateNewCart = UIButton()
    private let labelNoHistory = UILabel()
    
    // MARK: - Internal Properties
    
    internal let tableView = UITableView()
    
    internal var isTableHidden: Bool {
        get { tableView.isHidden }
        set {
            tableView.isHidden = newValue
            labelNoHistory.isHidden = !newValue
        }
    }
    
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

private extension HomeScreenView {
    func setup() {
        backgroundColor = .white
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        setupNoHistoryLabel()
        setupTable()
        setupGradientView()
        setupCreateNewButton()
        
        setupTextation()

    }
    
    func setupNoHistoryLabel() {
        labelNoHistory.textColor = .lightGray
        labelNoHistory.font = UIFont.systemFont(ofSize: 16)
        labelNoHistory.numberOfLines = 0
        labelNoHistory.textAlignment = .center
        contentView.addSubview(labelNoHistory)
        
        labelNoHistory.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().inset(24)
        }
    }
    
    func setupTable() {
        tableView.isHidden = true
        tableView.separatorStyle = .none
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setupCreateNewButton() {
        buttonCreateNewCart.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .semibold)
        buttonCreateNewCart.setTitleColor(.white, for: .normal)
        buttonCreateNewCart.backgroundColor = UIColor.primaryColor
        contentView.addSubview(buttonCreateNewCart)
        
        buttonCreateNewCart.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.left.right.equalToSuperview().inset(42)
            make.height.equalTo(50)
        }
        
        buttonCreateNewCart.layer.cornerRadius = 25
    }
    
    func setupGradientView() {
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.bottomMargin.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(
            x: gradientView.frame.origin.x,
            y: gradientView.frame.origin.y,
            width: UIScreen.main.bounds.width,
            height: 100)
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.cgColor
        ]
        
        gradient.locations = [0.0, 0.25]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupTextation() {
        buttonCreateNewCart.setTitle("Create new".uppercased(), for: .normal)
        labelNoHistory.text = "There is no history. Create new cart to fill-up with your products!"
    }
}