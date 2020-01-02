//
//  AddItemView.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 01/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal class AddItemView: UIView {
    
    // MARK: - Private Properties
    
    private let backgroundView = UIView()
    
    private let contentView = UIView()
    private let categoryImageContainerView = UIView()
    private let categoryBackgroundView = UIView()
    private let categoryImageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let sizeLabel = UILabel()
    
    private let amountLabel = UILabel()
    private let increaseButton = UIButton()
    private let decreaseButton = UIButton()
    
    private let addButton = UIButton()
    private let closeButton = UIButton()
    
    // MARK: - Internal Properties
    
    internal var image = UIImage() {
        didSet { categoryImageView.image = image }
    }
    internal var title: String = "" {
        didSet { titleLabel.text = title.uppercased() }
    }
    
    internal var descriptionText: String = "" {
        didSet { descriptionLabel.text = descriptionText }
    }
    
    internal var size: String = "" {
        didSet { sizeLabel.text = "Size: \(size)" }
    }
    
    internal var amount: Int = 0 {
        didSet {
            decreaseButton.isEnabled = amount != 1
            amountLabel.attributedText = NSMutableAttributedString.setupAttributedText(
                highlightedText: amount.description,
                normalText: "Amount:  ",
                highlightedFontSize: 26,
                normalFontSize: 20)
        }
    }
    
    internal var addTitle: String = "" {
        didSet { addButton.setTitle(addTitle, for: .normal) }
    }
    
    internal var closeTitle: String = "" {
        didSet { closeButton.setTitle(closeTitle, for: .normal) }
    }
    
    internal enum ButtonTag: Int {
        case increase
        case decrease
        case addToCart
        case close
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
    
    // MARK: - Methods
    
    internal func buttonTarget(_ target: Any?, action: Selector, for events: UIControl.Event) {
        increaseButton.addTarget(target, action: action, for: events)
        decreaseButton.addTarget(target, action: action, for: events)
        addButton.addTarget(target, action: action, for: events)
        closeButton.addTarget(target, action: action, for: events)
    }
}

// MARK: - Setup View Appereance
private extension AddItemView {
    func setup() {
        setupBackgroundView()
        setupContentView()
        setupCategoryContainerView()
        setupCategoryImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupSizeLabel()
        setupAmountLabels()
        setupButtons()
    }
    
    func setupButtons() {
        addButton.tag = ButtonTag.addToCart.rawValue
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .heavy)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 25
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        closeButton.tag = ButtonTag.close.rawValue
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .bold)
        closeButton.setTitleColor(.red, for: .normal)
        closeButton.backgroundColor = .white
        closeButton.layer.cornerRadius = 25
        
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let stackView = UIStackView
            .vertical
            .align(by: .fill)
            .distribute(by: .fillEqually)
            .space(by: 16)
            .stack(addButton, closeButton)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(contentView.snp.bottom).offset(24)
            make.bottom.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupAmountLabels() {
        increaseButton.tag = ButtonTag.increase.rawValue
        increaseButton.contentMode = .scaleAspectFit
        increaseButton.setImage(Assets.ItemList.increase, for: .normal)
        contentView.addSubview(increaseButton)
        
        increaseButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(sizeLabel.snp.bottom).offset(20)
            make.size.equalTo(48)
            make.bottom.right.equalToSuperview().inset(20)
        }
        
        decreaseButton.tag = ButtonTag.decrease.rawValue
        decreaseButton.contentMode = .scaleAspectFit
        decreaseButton.setImage(Assets.ItemList.decrease, for: .normal)
        contentView.addSubview(decreaseButton)
        
        decreaseButton.isEnabled = false
        decreaseButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.centerY.equalTo(increaseButton)
            make.right.equalTo(increaseButton.snp.left).inset(-8)
        }
        
        amount = 1
        amountLabel.textAlignment = .left
        contentView.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(increaseButton)
            make.left.equalToSuperview().inset(32)
            make.right.equalTo(decreaseButton.snp.left).inset(16)
        }
    }
    
    func setupSizeLabel() {
        sizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        sizeLabel.textAlignment = .center
        sizeLabel.textColor = .gray
        contentView.addSubview(sizeLabel)
        
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        descriptionLabel.textColor = .gray
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryBackgroundView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupCategoryImageView() {
        categoryBackgroundView.backgroundColor = .primaryColor
        categoryBackgroundView.layer.cornerRadius = 40
        categoryImageContainerView.addSubview(categoryBackgroundView)
        
        categoryBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        categoryImageView.contentMode = .scaleAspectFit
        let image = Assets.Products.dairyProducts.withRenderingMode(.alwaysTemplate)
        
        categoryImageView.image = image
        categoryImageView.tintColor = .black
        categoryBackgroundView.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.center.equalTo(categoryImageContainerView)
            make.size.equalTo(50)
        }
    }
    
    func setupCategoryContainerView() {
        categoryImageContainerView.backgroundColor = .white
        categoryImageContainerView.layer.cornerRadius = 50
        contentView.addSubview(categoryImageContainerView)
        categoryImageContainerView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
    }
    
    func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 40
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(-60)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupBackgroundView() {
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.75
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
