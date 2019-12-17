//
//  ManualAddController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 03/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal class ManualAddController: UIViewController {
    
    // MARK: - Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let presenter: ManualAddPresenter
    private let contentView = ManualAddView()
    
    private var selectedScope: ItemCategoryType?
    private var filteredProducts = [ItemEntity]()
    private var products = [ItemEntity]() {
        didSet { contentView.tableView.reloadData() }
    }
    
    internal var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    internal var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    // MARK: - Initialization
    
    internal init(presenter: ManualAddPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.load()
    }
}

// MARK: - ManualAddDelegate
extension ManualAddController: ManualAddDelegate {
    func didLoad(products: [ItemEntity]) {
        self.products = products
    }
    
    func presentController(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overCurrentContext
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func showController(_ controller: UIViewController) {
        navigationController?.show(controller, sender: self)
    }
}

// MARK: - AddItemDelegate
extension ManualAddController: AddItemDelegate {
    func willDisplayItemList() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ManualAddController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = isFiltering ? filteredProducts[indexPath.row] : products[indexPath.row]
        presenter.addItemToCart(product, withController: self)
    }
}

// MARK: - UITableViewDataSource
extension ManualAddController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredProducts.count : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(cell: ManualAddCell.self, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ManualAddCell else { return }
        let product = isFiltering ? filteredProducts[indexPath.row] : products[indexPath.row]
        
        cell.category = ItemCategoryType(rawValue: product.category)
        cell.title = product.title
        cell.descriptionText = product.desc
        cell.size = product.size
        cell.price = product.price
    }
}

// MARK: - UISearchResultsUpdating
extension ManualAddController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    
    filterContentForSearchText(text)
  }
}

// MARK: - Filtering
private extension ManualAddController {
    func filterContentForSearchText(_ searchText: String) {
        filteredProducts = products.filter { (product: ItemEntity) -> Bool in
            
            if isSearchBarEmpty {
                return false
            } else {
                return product.title.lowercased().contains(searchText.lowercased())
            }
        }
      
        contentView.tableView.reloadData()
    }
}

// MARK: - Action Selector
private extension ManualAddController {
    @objc
    func addButtonDidTap() {
        let alertController = UIAlertController(
            title: "Add New Product",
            message: "You are about to add unknown product. Are you sure you want to proceed to the add screen?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: "Proceed",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.presenter.showAddNewProduct(withController: self)
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        alertController.view.tintColor = .black
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Setup View Appereance
private extension ManualAddController {
    func setup() {
        title = "Manual Add"
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupSearchBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonDidTap))
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
