//
//  ManualAddCell.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal class ManualAddCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let view = UIView()
    private let categoryImageContainerView = UIView()
    private let categoryImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let sizeLabel = UILabel()
    private let priceLabel = UILabel()
    
    // MARK: - Internal Properties
    
    internal var category: ItemCategoryType? {
        didSet {
            guard let category = category else { return }
            categoryImageView.image = category.getImage()
        }
    }
    
    internal var title: String = "" {
        didSet { titleLabel.text = title }
    }
    
    internal var descriptionText: String = "" {
        didSet { descriptionLabel.text = descriptionText }
    }
    
    internal var size: String = "" {
        didSet { sizeLabel.text = "Size: \(size)" }
    }
    
    internal var price = 0.0 {
        didSet { priceLabel.text = String(format: "Price: %.2f,- Kč", price) }
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

private extension ManualAddCell {
    func setup() {
        selectedBackgroundView = UIView()
        setupItemView()
        setupImageView()
        setupLabels()
    }
    
    func setupItemView() {
        view.backgroundColor = .cellBackgroundColor
        view.layer.cornerRadius = 32
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    func setupImageView() {
        categoryImageContainerView.layer.cornerRadius = 24
        categoryImageContainerView.backgroundColor = .white
        view.addSubview(categoryImageContainerView)
        
        categoryImageContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalTo(view)
            make.size.equalTo(48)
        }
        
        categoryImageView.contentMode = .scaleAspectFit
        categoryImageContainerView.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(26)
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
            make.top.bottom.equalTo(categoryImageContainerView)
            make.left.equalTo(categoryImageContainerView.snp.right).offset(16)
            make.right.equalToSuperview()
        }
    }
}
