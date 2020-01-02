//
//  AddProductPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol AddProductPresenter {
    func add(title: String?, ean: String?, description: String?, price: Double?, size: String?, category: ItemCategoryType?)
}

internal protocol AddProductDelegate: class {
    func didAddProduct()
    func showEmptyFieldsNotification(withController: UIAlertController)
}

internal class AddProductPresenterImpl: AddProductPresenter {
    
    // MARK: - Private Properties
    
    private let addItemProduct: AddItemProduct
    
    // MARK: - Internal Properties
    
    internal struct EmptyFields {
        var isTitleEmpty = true
        var isEanEmpty = true
        var isDescriptionEmpty = true
        var isPriceEmpty = true
        var isSizeEmpty = true
        var isCategoryEmpty = true
        
        func areAllSatisfied() -> Bool {
            return !isTitleEmpty
                && !isEanEmpty
                && !isDescriptionEmpty
                && !isPriceEmpty
                && !isSizeEmpty
                && !isCategoryEmpty
        }
    }
    
    internal weak var delegate: AddProductDelegate?
    
    // MARK: - Initialization
    
    internal init(addItemProduct: AddItemProduct) {
        self.addItemProduct = addItemProduct
    }
    
    // MARK: - Protocol
    
    func add(title: String?, ean: String?, description: String?, price: Double?, size: String?, category: ItemCategoryType?) {
        var emptyFields = EmptyFields()
        var itemEntity = ItemEntity()
        
        // Validation
        if let title = title {
            itemEntity.title = title
            emptyFields.isTitleEmpty = false
        }
        if let ean = ean {
            itemEntity.ean = ean
            emptyFields.isEanEmpty = false
        }
        if let description = description {
            itemEntity.desc = description
            emptyFields.isDescriptionEmpty = false
        }
        if let price = price {
            itemEntity.price = price
            emptyFields.isPriceEmpty = false
        }
        if let size = size {
            itemEntity.size = size
            emptyFields.isSizeEmpty = false
        }
        if let category = category {
            itemEntity.category = category.rawValue
            emptyFields.isCategoryEmpty = false
        }
        
        guard emptyFields.areAllSatisfied() else {
            delegate?.showEmptyFieldsNotification(
                withController: createEmptyFieldsAlert(withStruct: emptyFields))
            return
        }
        
        addItemProduct.add(itemEntity) {
            self.delegate?.didAddProduct()
        }
    }
}

private extension AddProductPresenterImpl {
    func createEmptyFieldsAlert(withStruct emptyFields: EmptyFields) -> UIAlertController {
        var missingFields: String = ""
        
        if emptyFields.isTitleEmpty {
            missingFields += "Title"
        }
        
        if emptyFields.isEanEmpty {
            missingFields += missingFields.isEmpty ? "EAN" : ", EAN"
        }
        
        if emptyFields.isDescriptionEmpty {
            missingFields += missingFields.isEmpty ? "Description" : ", Description"
        }
        
        if emptyFields.isPriceEmpty {
            missingFields += missingFields.isEmpty ? "Price" : ", Price"
        }
        
        if emptyFields.isSizeEmpty {
            missingFields += missingFields.isEmpty ? "Size" : ", Size"
        }
        
        if emptyFields.isCategoryEmpty {
            missingFields += missingFields.isEmpty ? "Category" : ", Category"
        }
        
        let alertController = UIAlertController(
            title: "",
            message: "You have to fill-up all data. Please, add missing data:\n\(missingFields)",
            preferredStyle: .alert)
        alertController.view.tintColor = .black
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}
