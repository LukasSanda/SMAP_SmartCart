//
//  SettingsView.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 17/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import MapKit

internal protocol SettingsViewDelegate: class {
    func deleteDataDidTap()
    func saveLocationDidTap()
}

internal class SettingsView: UIView {
    
    // MARK: - Private Properties
    
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    
    private let supermarketContainer = UIView()
    private let favoriteShopLabel = UILabel()
    private let favoriteShopDescLabel = UILabel()
    private let moreInfoButton = UIButton()
    private let saveShopLocationButton = UIButton()
    private let shopLocationView = UIImageView(image: Assets.Settings.mapTracking)
    
    private let deleteDataContainer = UIView()
    private let deleteDataLabel = UILabel()
    private let deleteDataDescLabel = UILabel()
    private let deleteDataButton = UIButton()
    
    private var isMoreInfoHidden: Bool = true {
        didSet {
            if isMoreInfoHidden {
                favoriteShopDesc = favoriteShopDesc.replacingOccurrences(of: moreInfoDesc, with: "")
            } else {
                favoriteShopDesc += moreInfoDesc
            }
        }
    }
    
    // MARK: - Internal Properties
    
    internal var isPinSelected: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.shopLocationView.alpha = self.isPinSelected ? 0 : 1
            }
        }
    }
    
    internal let mapView = MKMapView()
    internal var favoriteShopTitle: String = "" {
        didSet { favoriteShopLabel.text = favoriteShopTitle }
    }
    internal var favoriteShopDesc: String = "" {
        didSet { favoriteShopDescLabel.text = favoriteShopDesc }
    }
    internal var moreInfoDesc: String = ""
    internal var moreInfoTitle: String = "" {
        didSet { moreInfoButton.setTitle(moreInfoTitle, for: .normal) }
    }
    internal var lessInfoTitle: String = ""
    internal var saveLocationTitle: String = "" {
        didSet { saveShopLocationButton.setTitle(saveLocationTitle, for: .normal) }
    }
    internal var deleteDataTitle: String = "" {
        didSet { deleteDataLabel.text = deleteDataTitle }
    }
    internal var deleteDataDesc: String = "" {
        didSet { deleteDataDescLabel.text = deleteDataDesc }
    }
    internal var deleteDataButtonTitle: String = "" {
        didSet { deleteDataButton.setTitle(deleteDataButtonTitle, for: .normal) }
    }
    internal weak var delegate: SettingsViewDelegate?
    
    // MARK: - Initialization
    
    internal init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Action Selectors
private extension SettingsView {
    @objc
    func saveButtonDidTap() {
        delegate?.saveLocationDidTap()
    }
    
    @objc
    func moreInfoDidTap() {
        isMoreInfoHidden.toggle()
        moreInfoButton.setTitle(isMoreInfoHidden ? moreInfoTitle : lessInfoTitle, for: .normal)
    }
    
    @objc
    func deleteDataDidTap() {
        delegate?.deleteDataDidTap()
    }
}

// MARK: - Setup View Appereance
private extension SettingsView {
    func setup() {
        backgroundColor = .white
        setupContainerView()
        
        setupFavoriteContainer()
        setupShopTitle()
        setupShopDesc()
        setupMapView()
        setupSaveShopLocation()
        
        setupDeleteDataContainer()
        setupDeleteDataTitle()
        setupDeleteDataDesc()
        setupDeleteDataButton()
    }
    
    func setupContainerView() {
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
        }
    }
    
    func setupFavoriteContainer() {
        supermarketContainer.backgroundColor = .cellBackgroundColor
        supermarketContainer.layer.cornerRadius = 25
        containerView.addSubview(supermarketContainer)
        supermarketContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupShopTitle() {
        favoriteShopLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        supermarketContainer.addSubview(favoriteShopLabel)
        favoriteShopLabel.snp.makeConstraints { make in
            make.top.equalTo(supermarketContainer).offset(10)
            make.left.equalToSuperview().inset(20)
        }
    }
    
    func setupShopDesc() {
        favoriteShopDescLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        favoriteShopDescLabel.textColor = .darkGray
        favoriteShopDescLabel.numberOfLines = 0
        supermarketContainer.addSubview(favoriteShopDescLabel)
        favoriteShopDescLabel.snp.makeConstraints { make in
            make.top.equalTo(favoriteShopLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        moreInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        moreInfoButton.setTitleColor(.systemBlue, for: .normal)
        moreInfoButton.addTarget(self, action: #selector(moreInfoDidTap), for: .touchUpInside)
        supermarketContainer.addSubview(moreInfoButton)
        moreInfoButton.snp.makeConstraints { make in
            make.top.equalTo(favoriteShopDescLabel.snp.bottom)
            make.left.equalTo(favoriteShopDescLabel)
        }
    }
    
    func setupMapView() {
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 25
        supermarketContainer.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(moreInfoButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(300)
        }
        
        shopLocationView.isUserInteractionEnabled = false
        mapView.addSubview(shopLocationView)
        shopLocationView.snp.makeConstraints { make in
            make.bottom.equalTo(mapView.snp.centerY)
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    func setupSaveShopLocation() {
        saveShopLocationButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        saveShopLocationButton.layer.cornerRadius = 20
        saveShopLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .semibold)
        saveShopLocationButton.setTitleColor(.white, for: .normal)
        saveShopLocationButton.backgroundColor = UIColor.primaryColor
        supermarketContainer.addSubview(saveShopLocationButton)
        
        saveShopLocationButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setupDeleteDataContainer() {
        deleteDataContainer.backgroundColor = .cellBackgroundColor
        deleteDataContainer.layer.cornerRadius = 25
        containerView.addSubview(deleteDataContainer)
        deleteDataContainer.snp.makeConstraints { make in
            make.top.equalTo(supermarketContainer.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.greaterThanOrEqualToSuperview().inset(20)
        }
    }
    
    func setupDeleteDataTitle() {
        deleteDataLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        deleteDataContainer.addSubview(deleteDataLabel)
        deleteDataLabel.snp.makeConstraints { make in
            make.top.equalTo(deleteDataContainer).offset(10)
            make.left.equalToSuperview().inset(20)
        }
    }
    
    func setupDeleteDataDesc() {
        deleteDataDescLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        deleteDataDescLabel.textColor = .darkGray
        deleteDataDescLabel.numberOfLines = 0
        deleteDataContainer.addSubview(deleteDataDescLabel)
        deleteDataDescLabel.snp.makeConstraints { make in
            make.top.equalTo(deleteDataLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupDeleteDataButton() {
        deleteDataButton.addTarget(self, action: #selector(deleteDataDidTap), for: .touchUpInside)
        deleteDataButton.layer.cornerRadius = 20
        deleteDataButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .semibold)
        deleteDataButton.setTitleColor(.white, for: .normal)
        deleteDataButton.backgroundColor = .systemRed
        deleteDataContainer.addSubview(deleteDataButton)
        deleteDataButton.snp.makeConstraints { make in
            make.top.equalTo(deleteDataDescLabel.snp.bottom).offset(20)
            make.left.right.equalTo(saveShopLocationButton)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
