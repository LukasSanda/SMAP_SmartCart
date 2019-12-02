//
//  AddItemController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 01/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal class AddItemController: UIViewController {
    
    // MARK: - Private Properties
    
    private let item: ItemEntity
    private let contentView = AddItemView()
    private let presenter: AddItemPresenter
    
    // MARK: - Initialization
    
    internal init(presenter: AddItemPresenter, item: ItemEntity) {
        self.presenter = presenter
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Action Selector
private extension AddItemController {
    @objc
    func buttonDidTap(_ sender: UIButton) {
        switch sender.tag {
        case AddItemView.ButtonTag.increase.rawValue:
            contentView.amount += 1
        case AddItemView.ButtonTag.decrease.rawValue:
            contentView.amount -= 1
        case AddItemView.ButtonTag.addToCart.rawValue:
            presenter.add(item, ofAmount: contentView.amount) {
                self.dismiss(animated: true, completion: nil)
            }
            
        case AddItemView.ButtonTag.close.rawValue:
            self.dismiss(animated: true, completion: nil)
        default:
            return
        }
    }
}

// MARK: - Setup View Appereance
private extension AddItemController {
    func setup() {
        setupLocalization()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        guard let category = ItemCategoryType(rawValue: item.category) else { return }
        
        contentView.title = item.title
        contentView.descriptionText = item.desc
        contentView.size = item.size.description + category.getSizeUnit()
        contentView.image = category.getImage()
        contentView.buttonTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    func setupLocalization() {
        contentView.addTitle = "Add To Cart"
        contentView.closeTitle = "Close"
    }
}
