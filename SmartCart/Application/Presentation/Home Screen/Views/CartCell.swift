//
//  CartCell.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol CartCellDelegate: class {
    func removeDidTap(inCell cell: CartCell)
}

internal class CartCell: UITableViewCell {
    
    // MARK: - Private Properties

    private let view = UIView()
    private let imageContainerView = UIView()
    private let cartImageView = UIImageView(image: Assets.HomeScreen.shoppingCart)
    private let dateLabel = UILabel()
    private let totalPriceLabel = UILabel()
    private let removeButton = UIButton()
    
    private let totalPriceFormat = "Total price: %f,- Kč"
    
    // MARK: - Internal Properties
    
    internal var date = Date() {
        didSet { handleDateLabel(withDate: date) }
    }
    
    internal var totalPrice: Double = 0.0 {
        didSet { handleTotalPriceLabel(withPrice: totalPrice) }
    }
    
    internal var isLastCreated = false {
        didSet {
            removeButton.isHidden = isLastCreated
            
            view.snp.remakeConstraints { remake in
                if self.isLastCreated {
                    remake.right.equalToSuperview().inset(20)
                } else {
                    remake.right.equalTo(removeButton.snp.left).offset(-16)
                }
                
                remake.top.equalToSuperview().inset(8)
                remake.left.equalToSuperview().inset(16)
                remake.bottom.equalToSuperview().inset(12)
            }
        }
    }
    
    internal weak var delegate: CartCellDelegate?
    
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
private extension CartCell {
    @objc
    func removeDidTap() {
        delegate?.removeDidTap(inCell: self)
    }
}

// MARK: - Setup View Appereance
private extension CartCell {
    func setup() {
        selectedBackgroundView = UIView()
        
        removeButton.addTarget(self, action: #selector(removeDidTap), for: .touchUpInside)
        removeButton.setImage(Assets.delete, for: .normal)
        removeButton.contentMode = .scaleAspectFit
        contentView.addSubview(removeButton)
        
        removeButton.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }
        
        view.backgroundColor = .cellBackgroundColor
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(removeButton.snp.left).offset(-16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        setupImageView()
        
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        let stack = UIStackView
            .vertical
            .space(by: 5)
            .distribute(by: .fillProportionally)
            .align(by: .leading)
            .stack(dateLabel, totalPriceLabel)
        
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.bottom.equalTo(imageContainerView)
            make.left.equalTo(imageContainerView.snp.right).offset(8)
        }
        
        view.layer.cornerRadius = 27
    }
    
    func setupImageView() {
        imageContainerView.backgroundColor = .white
        view.addSubview(imageContainerView)
        
        imageContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalTo(view)
            make.size.equalTo(44)
        }
        
        imageContainerView.layer.cornerRadius = 22
        
        cartImageView.contentMode = .scaleAspectFit
        imageContainerView.addSubview(cartImageView)
        cartImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(22)
        }
    }
}

// MARK: - Formatters
private extension CartCell {
    func handleTotalPriceLabel(withPrice price: Double) {
        totalPriceLabel.attributedText = NSMutableAttributedString.setupAttributedText(
            highlightedText: String(format: "%.2f,- Kč", price),
            normalText: "Total Price:")
    }
    
    func handleDateLabel(withDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd. MM. YYYY"
        dateLabel.text = formatter.string(from: date).description
    }
}
