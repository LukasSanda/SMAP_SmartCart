//
//  BarcodeScannerController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

internal class BarcodeScannerController: UIViewController {

    // MARK: - Private Properties
    
    private var scanner: Scanner?
    private let overlayView = UIView()
    private let cancelButton = UIButton()
    private let presenter: BarcodeScannerPresenter
    
    // MARK: - Intialization
    
    internal init(presenter: BarcodeScannerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let scanner = scanner else { return }
        scanner.requestCaptureSessionStartRunning()
        view.bringSubviewToFront(overlayView)
        view.bringSubviewToFront(cancelButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        self.scanner = Scanner(withViewController: self, view: self.view, eanHandler: handleScannedCode(_:))
    }
}

// MARK: - Actions
private extension BarcodeScannerController {
    func handleScannedCode(_ code: String) {
        self.dismiss(animated: true) {
            self.presenter.checkCode(code)
        }
    }
    
    @objc
    func buttonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension BarcodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}

// MARK: - Setup View Appereance
private extension BarcodeScannerController {
    func setup() {
        // Overlay frame
        overlayView.backgroundColor = .clear
        overlayView.layer.borderColor = UIColor.primaryColor.cgColor
        overlayView.layer.borderWidth = 2
        view.addSubview(overlayView)
        
        overlayView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().inset(32)
            make.height.equalTo(150)
        }
        
        cancelButton.layer.cornerRadius = 25
        cancelButton.backgroundColor = .primaryColor
        cancelButton.tintColor = .secondaryColor
        cancelButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: .normal)
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}
