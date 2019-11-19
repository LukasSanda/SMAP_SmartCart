//
//  CartContentView.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 06/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal enum CartItemButtonsTag: Int {
    case addManually
    case scan
}

internal protocol CartContentViewDelegate: class {
    func buttonDidTap(_ sender: UIButton)
}

internal class CartContentView: UIView {
    
    // MARK: - Private Properties
    
    private let contentView = UIView()
    private let totalPriceLabel = UILabel()
    private let gradientView = UIView()
    private let emptyTableLabel = UILabel()
    private let buttonContainer = UIView()
    private let buttonManualAdd = UIButton()
    private let buttonScan = UIButton()
    
    // MARK: - Internal Properties
    
    internal weak var delegate: CartContentViewDelegate?
    internal let tableView = UITableView()
    internal var isTableHidden: Bool {
        get { tableView.isHidden }
        set {
            tableView.isHidden = newValue
            totalPriceLabel.isHidden = newValue
            emptyTableLabel.isHidden = !newValue
        }
    }
    
    internal var totalPrice: Double = 0.0 {
        didSet {
            totalPriceLabel.attributedText = NSMutableAttributedString
                .setupAttributedText(
                    highlightedText: String(format: "%0.2f,- Kč", totalPrice),
                    normalText: "Cart Summary:",
                    highlightedFontSize: 18,
                    normalFontSize: 16) }
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

// MARK: - Action Selectors
private extension CartContentView {
    @objc
    func buttonDidTap(_ sender: UIButton) {
        delegate?.buttonDidTap(sender)
    }
}

// MARK: - Setup View Appereance
private extension CartContentView {
    func setup() {
        backgroundColor = .white
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupEmptyTableLabel()
        setupTotalPriceLabel()
        setupTable()
        setupGradientView()
        setupControlButtons()
        setupTextation()
    }
    
    func setupEmptyTableLabel() {
        emptyTableLabel.textColor = .lightGray
        emptyTableLabel.font = UIFont.systemFont(ofSize: 16)
        emptyTableLabel.numberOfLines = 0
        emptyTableLabel.textAlignment = .center
        contentView.addSubview(emptyTableLabel)
        
        emptyTableLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().inset(24)
        }
    }
    
    func setupTotalPriceLabel() {
        totalPriceLabel.isHidden = true
        contentView.addSubview(totalPriceLabel)
        
        totalPriceLabel.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    func setupTable() {
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = true
        tableView.separatorStyle = .none
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }
    }
    
    func setupControlButtons() {
        buttonContainer.backgroundColor = .primaryColor
        buttonContainer.layer.cornerRadius = 25
        contentView.addSubview(buttonContainer)
        
        buttonContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.left.right.equalToSuperview().inset(42)
            make.height.equalTo(50)
        }
        
        let separator = UIView()
        separator.backgroundColor = .secondaryColor
        buttonContainer.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(2)
        }
        
        buttonManualAdd.tag = CartItemButtonsTag.addManually.rawValue
        buttonManualAdd.setImage(Assets.CartItems.addToCart.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonScan.tag = CartItemButtonsTag.scan.rawValue
        buttonScan.setImage(Assets.CartItems.barCodeScanner.withRenderingMode(.alwaysTemplate), for: .normal)
        let stack = UIStackView
            .horizontal
            .align(by: .center)
            .distribute(by: .fillEqually)
            .space(by: 10)
            .stack(buttonManualAdd, buttonScan)
        buttonContainer.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonManualAdd.tintColor = .secondaryColor
        buttonManualAdd.imageView?.contentMode = .scaleAspectFit
        buttonManualAdd.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        buttonScan.tintColor = .secondaryColor
        buttonScan.imageView?.contentMode = .scaleAspectFit
        buttonScan.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        buttonManualAdd.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        buttonScan.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
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
        emptyTableLabel.text = "Collection is empty. Add new items with scanning product's barcode or add manually from known products."
    }
}
