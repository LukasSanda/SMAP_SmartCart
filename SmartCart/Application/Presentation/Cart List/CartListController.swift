//
//  CartListController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import SnapKit

internal class CartListController: UIViewController {
    
    // MARK: - Properties
    
    private var carts = [Cart]() {
        didSet { contentView.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .fade) }
    }
    
    private let contentView = CartListView()
    private let presenter: CartListPresenter
    
    // MARK: - Initialization
    
    internal init(presenter: CartListPresenter) {
        self.presenter = presenter
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.load()
    }
}

// MARK: - CartCellDelegate
extension CartListController: CartCellDelegate {
    func removeDidTap(inCell cell: CartCell) {
        guard let index = contentView.tableView.indexPath(for: cell) else {
            return
        }
        
        presenter.removeCart(carts[index.row])
    }
}

// MARK: - CartListDelegate
extension CartListController: CartListDelegate {
    func didLoadAvailableCarts(_ carts: [Cart]) {
        guard !carts.isEmpty else {
            contentView.isTableHidden = true
            logger.logInfo(message: "Successfully fetched but loaded empty array.")
            return
        }
        
        contentView.isTableHidden = false
        self.carts = carts
    }
    
    func presentController(_ controller: UIViewController) {
        controller.modalPresentationStyle = .formSheet
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func showController(_ controller: UIViewController) {
        navigationController?.show(controller, sender: nil)
    }
}

extension CartListController: CartListViewDelegate {
    func createNewDidTap() {
        presenter.createNewCart()
    }
}

// MARK: - UITableViewDelegate
extension CartListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CartListHeaderView()
        view.text = section == 0 ? "Last Created" : "All Created"
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetail(forCart: carts[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension CartListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(cell: CartCell.self, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CartCell else { return }
        let cart: Cart
        
        if indexPath.section == 0 {
            guard let firstCart = carts.first else { return }
            
            cart = firstCart
        } else {
            cart = carts[indexPath.row]
        }
        
        cell.delegate = self
        cell.isLastCreated = indexPath.section == 0
        cell.date = cart.created
        cell.totalPrice = calculateTotalPrice(forCart: cart)
    }
}

// MARK: - Action Selector
private extension CartListController {
    @objc
    func buttonMoreDidTap() {
        presenter.showMenu()
    }
}

// MARK: - Price Helper
private extension CartListController {
    func calculateTotalPrice(forCart cart: Cart) -> Double {
        var price: Double = 0.0
        cart.items?.forEach { item in
            guard let item = item as? Item else { return }
            price += item.price * Double(truncating: item.amount)
        }
        
        return price
    }
}

// MARK: - Setup View Appereance
private extension CartListController {
    func setup() {
        title = "Available Carts"
        contentView.delegate = self
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(cell: CartCell.self)
        
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Assets.buttonMore,
            style: .plain,
            target: self, action: #selector(buttonMoreDidTap))
        }
}
