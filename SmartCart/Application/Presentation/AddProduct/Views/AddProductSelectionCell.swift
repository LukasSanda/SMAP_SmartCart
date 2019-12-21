//
//  AddProductSelectionCell.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 07/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol AddProductSelectionDelegate: class {
    func didSelectCell(_ cell: AddProductSelectionCell)
}

internal class AddProductSelectionCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let descriptionLabel = UILabel()
    private let categoryButton = UIButton()
    private let discloureImageView = UIImageView()
    
    // MARK: - Internal Properties
    
    internal weak var delegate: AddProductSelectionDelegate?
    internal var descriptionText: String = "" {
        didSet { descriptionLabel.text = descriptionText }
    }
    
    internal var buttonTitle: String = "" {
        didSet { categoryButton.setTitle(buttonTitle, for: .normal) }
    }
    
    // MARK: - Initialiazation
    
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
private extension AddProductSelectionCell {
    @objc
    func buttonDidTap() {
        delegate?.didSelectCell(self)
    }
}

// MARK: - Setup View Appereance
private extension AddProductSelectionCell {
    func setup() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        setupDisclosure()
        setupLabels()
    }
    
    func setupLabels() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        descriptionLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        categoryButton.setContentHuggingPriority(.sceneSizeStayPut, for: .horizontal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        
        let stack = UIStackView
            .horizontal
            .distribute(by: .fill)
            .space(by: 16)
            .align(by: .fill)
            .stack(descriptionLabel, categoryButton)
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(discloureImageView.snp.left).inset(-10)
        }
    }
    
    func setupDisclosure() {
        discloureImageView.contentMode = .scaleAspectFit
        discloureImageView.image = Assets.AddProduct.select
        discloureImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            .rotated(by: (CGFloat(Double.pi / 2)))
        
        contentView.addSubview(discloureImageView)
        
        discloureImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(30)
            make.size.equalTo(24)
        }
    }
}
