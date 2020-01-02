//
//  AddProductController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal class AddProductController: UITableViewController {
    
    // MARK: - Enums
    
    private enum Section: Int, CaseIterable {
        case mainInfo
        case description
        case secondaryInfo
        case category
    }
    
    // MARK: - Private Properties
    
    private var productTitle: String?
    private var productEan: String?
    private var productDescription: String?
    private var productPrice: Double?
    private var productSize: String?
    private var productCategory: ItemCategoryType?
    
    private let presenter: AddProductPresenter
    
    // MARK: - Initialization
    
    internal init(presenter: AddProductPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableDataSource
internal extension AddProductController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .mainInfo:         return 2
        case .description:      return 1
        case .secondaryInfo:    return 2
        case .category:         return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .mainInfo:         return 40
        case .description:      return 100
        case .secondaryInfo:    return 40
        case .category:         return 40
        }
    }
}

// MARK: - UITableViewDelegate
internal extension AddProductController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray
        
        let result: String
        switch section {
        case .mainInfo:         result = "Identification"
        case .description:      result = "Description"
        case .secondaryInfo:    result = "Additional Information"
        case .category:         result = "Category"
        }
        
        label.text = result.uppercased()
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCellAppereance(forIndexPath: indexPath)
    }
}

// MARK: - AddProductSelectionDelegate
extension AddProductController: AddProductSelectionDelegate {
    func didSelectCell(_ cell: AddProductSelectionCell) {
        let controller = UIAlertController(
            title: "Product Category",
            message: "Please, choose one of the listed category for your product.",
            preferredStyle: .actionSheet)
        controller.view.tintColor = .black
        
        for type in ItemCategoryType.allCases {
            let action = UIAlertAction(
            title: type.getTitle(),
            style: .default) { _ in
                self.productCategory = type
                self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
            }
            
            controller.addAction(action)
        }
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navigationController?.present(controller, animated: true, completion: nil)
    }
}

// MARK: - AddProductTextViewCellDelegate
extension AddProductController: AddProductTextViewCellDelegate {
    func textViewDidEndEditing(_ textView: UITextView, inCell cell: AddProductTextViewCell) {
        productDescription = textView.text
    }
}

// MARK: - AddProductDelegate
extension AddProductController: AddProductDelegate {
    func showEmptyFieldsNotification(withController: UIAlertController) {
        navigationController?.present(withController, animated: true, completion: nil)
    }
    
    func didAddProduct() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - AddProductTextFieldCellDelegate
extension AddProductController: AddProductTextFieldCellDelegate {
    func textFieldDidEndEditing(_ textfield: UITextField, inCell cell: AddProductTextFieldCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let section = Section(rawValue: indexPath.section),
            var text = textfield.text else {
                return
        }
        
        switch section {
        case .mainInfo:
            if indexPath.row == 0 {
                productTitle = text
            } else {
                productEan = text
            }
            
        case .secondaryInfo:
            if indexPath.row == 0 {
                text.removeSubrange(text.index(text.endIndex, offsetBy: -3)..<text.endIndex)
                productPrice = Double(text)
            } else {
                productSize = text
            }
            
        default:
            return
        }
    }
}

// MARK: - Action Selectors
private extension AddProductController {
    @objc
    func doneDidTap() {
        presenter.add(
            title: productTitle,
            ean: productEan,
            description: productDescription,
            price: productPrice,
            size: productSize,
            category: productCategory)
    }
}

// MARK: - Setup View Appereance
private extension AddProductController {
    func setup() {
        title = "Add New Product"
        view.backgroundColor = .white
        
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(cell: AddProductTextFieldCell.self)
        tableView.register(cell: AddProductTextViewCell.self)
        tableView.register(cell: AddProductSelectionCell.self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidTap))
    }
    
    func setupCellAppereance(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        let cell: UITableViewCell
        
        switch section {
        case .mainInfo:
            cell = tableView.dequeue(cell: AddProductTextFieldCell.self, for: indexPath)
            setupIdentificationCell(cell, forIndexPath: indexPath)
            
        case .description:
            cell = tableView.dequeue(cell: AddProductTextViewCell.self, for: indexPath)
            guard let addCell = cell as? AddProductTextViewCell else { return UITableViewCell() }
            addCell.placeholder = "Enter Product Description"
            addCell.delegate = self
            
        case .secondaryInfo:
            cell = tableView.dequeue(cell: AddProductTextFieldCell.self, for: indexPath)
            setupSecondaryInfoCell(cell, forIndexPath: indexPath)
            
        case .category:
            cell = tableView.dequeue(cell: AddProductSelectionCell.self, for: indexPath)
            guard let addCell = cell as? AddProductSelectionCell else { return UITableViewCell() }
            
            addCell.descriptionText = "Type of Product"
            addCell.buttonTitle = productCategory?.getTitle() ?? "Tap to Choose"
            addCell.delegate = self
        }
        
        return cell
    }
    
    func setupSecondaryInfoCell(_ cell: UITableViewCell, forIndexPath indexPath: IndexPath) {
        guard let addCell = cell as? AddProductTextFieldCell else { return }
        
        switch indexPath.row {
        case 0:
            addCell.isPriceCell = true
            addCell.descriptionText = "Price"
            addCell.textField.placeholder = "25 Kč"
            addCell.textField.keyboardType = .decimalPad
            addCell.delegate = self
            
        case 1:
            addCell.descriptionText = "Size"
            addCell.textField.placeholder = "500 ml"
            addCell.delegate = self
            
        default:
            return
        }
    }
    
    func setupIdentificationCell(_ cell: UITableViewCell, forIndexPath indexPath: IndexPath) {
        guard let addCell = cell as? AddProductTextFieldCell else { return }
        
        switch indexPath.row {
        case 0:
            addCell.descriptionText = "Title"
            addCell.textField.placeholder = "Coca-Cola"
            addCell.textField.autocorrectionType = .no
            addCell.delegate = self
            
        case 1:
            addCell.descriptionText = "EAN"
            addCell.textField.placeholder = "5449000130389"
            addCell.textField.keyboardType = .decimalPad
            addCell.delegate = self
            
        default:
            return
        }
    }
}
