//
//  ItemListView.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 06/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal enum CartItemButtonsTag: Int {
    case addManually
    case scan
    case title
}

internal protocol ItemListViewDelegate: class {
    func buttonDidTap(_ sender: UIButton)
}

internal class ItemListView: UIView {
    
    // MARK: - Private Properties
    
    private let contentView = UIView()
    private let totalPriceLabel = UILabel()
    private let gradientView = UIView()
    private let emptyTableLabel = UILabel()
    private let buttonContainer = UIView()
    private let buttonManualAdd = UIButton()
    private let buttonBarcodeScan = UIButton()
    private let buttonTitleScan = UIButton()
    
    // MARK: - Internal Properties
    
    internal weak var delegate: ItemListViewDelegate?
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
private extension ItemListView {
    @objc
    func buttonDidTap(_ sender: UIButton) {
        delegate?.buttonDidTap(sender)
    }
}

// MARK: - Setup View Appereance
private extension ItemListView {
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
        
        buttonManualAdd.tag = CartItemButtonsTag.addManually.rawValue
        buttonManualAdd.setImage(Assets.ItemList.addToCart.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonBarcodeScan.tag = CartItemButtonsTag.scan.rawValue
        buttonBarcodeScan.setImage(Assets.ItemList.barCodeScanner.withRenderingMode(.alwaysTemplate), for: .normal)
        let stack = UIStackView
            .horizontal
            .align(by: .center)
            .distribute(by: .fillEqually)
            .space(by: 10)
            .stack(buttonManualAdd, buttonBarcodeScan, buttonTitleScan)
        buttonContainer.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        setupButtonManualAdd()
        setupButtonBarcodeScan()
        setupButtonTitleScan()
    }
    
    func setupButtonManualAdd() {
        buttonManualAdd.tag = CartItemButtonsTag.addManually.rawValue
        buttonManualAdd.setImage(Assets.ItemList.addToCart.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonManualAdd.tintColor = .secondaryColor
        buttonManualAdd.imageView?.contentMode = .scaleAspectFit
        buttonManualAdd.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        buttonManualAdd.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    func setupButtonBarcodeScan() {
        buttonBarcodeScan.tag = CartItemButtonsTag.scan.rawValue
        buttonBarcodeScan.setImage(Assets.ItemList.barCodeScanner.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonBarcodeScan.tintColor = .secondaryColor
        buttonBarcodeScan.imageView?.contentMode = .scaleAspectFit
        buttonBarcodeScan.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        buttonBarcodeScan.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    func setupButtonTitleScan() {
        buttonTitleScan.tag = CartItemButtonsTag.title.rawValue
        buttonTitleScan.setImage(Assets.ItemList.titleScanner.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonTitleScan.tintColor = .secondaryColor
        buttonTitleScan.imageView?.contentMode = .scaleAspectFit
        buttonTitleScan.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        buttonTitleScan.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
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
