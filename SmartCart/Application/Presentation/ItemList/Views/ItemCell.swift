//
//  ItemCell.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 06/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal enum ItemCellButtonTagType: Int {
    case delete
    case decrease
    case increase
}

internal protocol ItemCellDelegate: class {
    func controlButtonDidTap(_ sender: UIButton, inCell cell: ItemCell)
}

internal class ItemCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let view = UIView()
    private let amountContainer = UIView()
    private let amountLabel = UILabel()
    private let imageContainerView = UIView()
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let sizeLabel = UILabel()
    private let priceLabel = UILabel()
    private let totalPriceLabel = UILabel()
    
    private let increaseButton = UIButton()
    private let decreaseButton = UIButton()
    private let deleteButton = UIButton()
    
    // MARK: - Internal Properties
    
    internal weak var delegate: ItemCellDelegate?
    internal var title = "" {
        didSet { titleLabel.text = title }
    }
    
    internal var desc = "" {
        didSet { descriptionLabel.text = desc }
    }
    
    internal var size = "" {
        didSet { sizeLabel.text = "Size: \(size)" }
    }
    
    internal var price = 0.0 {
        didSet { priceLabel.text = String(format: "Price: %.2f,- Kč", price) }
    }
    
    internal var amount: Int = 1 {
        didSet {
            amountLabel.text = amount.description
            totalPriceLabel.attributedText = NSMutableAttributedString.setupAttributedText(
                highlightedText: String(format: "%.2f,- Kč", price * Double(amount)),
                normalText: "Total Price:",
                highlightedFontSize: 16,
                normalFontSize: 14)
        }
    }
    
    internal var category: ItemCategoryType? {
        didSet {
            guard let category = self.category else { return }
            productImageView.image = category.getImage()
        }
    }
    
    // MARK: - Initialization
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Action Selectors
private extension ItemCell {
    @objc
    func buttonDidTap(_ sender: UIButton) {
        delegate?.controlButtonDidTap(sender, inCell: self)
    }
}

// MARK: - Setup View Appereance
private extension ItemCell {
    func setup() {
        selectedBackgroundView = UIView()
        
        setupAmountView()
        setupItemView()
        setupImageView()
        setupLabels()
        setupBottomControlView()
        setupPriceLabel()
    }
    
    func setupAmountView() {
        amountContainer.layer.cornerRadius = 22
        amountContainer.backgroundColor = .primaryColor
        contentView.addSubview(amountContainer)
        
        amountContainer.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalToSuperview().inset(20)
        }
        
        amountContainer.addSubview(amountLabel)
        amountLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        amountLabel.textColor = .secondaryColor
        amountLabel.textAlignment = .center
        
        amountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupItemView() {
        view.backgroundColor = .cellBackgroundColor
        view.layer.cornerRadius = 35
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.right.equalTo(amountLabel.snp.left).inset(-8)
        }
        
        amountContainer.snp.makeConstraints { make in
            make.centerY.equalTo(view)
        }
    }
    
    func setupImageView() {
        imageContainerView.backgroundColor = .white
        view.addSubview(imageContainerView)
        
        imageContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalTo(view)
            make.size.equalTo(50)
        }
        
        imageContainerView.layer.cornerRadius = 25
        
        productImageView.contentMode = .scaleAspectFit
        imageContainerView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
    }
    
    func setupLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        titleLabel.textColor = .black
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        descriptionLabel.textColor = .gray
        
        sizeLabel.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        sizeLabel.textColor = .gray
        
        let stack = UIStackView
            .vertical
            .align(by: .leading)
            .distribute(by: .fillProportionally)
            .stack(titleLabel, descriptionLabel, sizeLabel)
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.bottom.equalTo(imageContainerView)
            make.left.equalTo(imageContainerView.snp.right).offset(16)
            make.right.equalToSuperview()
        }
    }
    
    func setupBottomControlView() {
        increaseButton.tag = ItemCellButtonTagType.increase.rawValue
        increaseButton.contentMode = .scaleAspectFit
        increaseButton.setImage(Assets.ItemList.increase, for: .normal)
        contentView.addSubview(increaseButton)
        
        increaseButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).inset(-8)
            make.centerX.equalTo(amountContainer)
            make.size.equalTo(32)
            make.bottom.equalToSuperview().inset(16)
        }
        
        decreaseButton.tag = ItemCellButtonTagType.decrease.rawValue
        decreaseButton.contentMode = .scaleAspectFit
        decreaseButton.setImage(Assets.ItemList.decrease, for: .normal)
        contentView.addSubview(decreaseButton)
        
        decreaseButton.snp.makeConstraints { make in
            make.centerY.equalTo(increaseButton)
            make.size.equalTo(increaseButton)
            make.right.equalTo(increaseButton.snp.left).offset(-12)
        }
        
        deleteButton.tag = ItemCellButtonTagType.delete.rawValue
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.setImage(Assets.delete, for: .normal)
        
        contentView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(increaseButton)
            make.size.equalTo(increaseButton)
            make.right.equalTo(decreaseButton.snp.left).offset(-12)
        }
        
        deleteButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    func setupPriceLabel() {
        priceLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        priceLabel.textColor = .gray
        
        let stack = UIStackView
            .vertical
            .align(by: .leading)
            .distribute(by: .fillProportionally)
            .stack(priceLabel, totalPriceLabel)
        contentView.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.bottom.equalTo(deleteButton)
            make.left.equalTo(view)
            make.right.lessThanOrEqualTo(deleteButton.snp.left).inset(-8)
        }
    }
}
