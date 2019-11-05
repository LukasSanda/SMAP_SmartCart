//
//  ScannerViewController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class ScannerViewController: UIViewController {

    // MARK: - Properties
    
    private var scanner: Scanner?
    private let overlayView = UIView()
    
    // MARK: - Intialization
    
    internal init() {
        super.init(nibName: nil, bundle: nil)
        self.scanner = Scanner(withViewController: self, view: self.view, eanHandler: handleScannedCode(_:))
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Methods
    
    func handleScannedCode(_ code: String) {
        print(code)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}

private extension ScannerViewController {
    func setup() {
        // Overlay frame
        setupScanOverlay()
    }
    
    func setupScanOverlay() {
        overlayView.backgroundColor = .clear
        overlayView.layer.borderColor = UIColor.green.cgColor
        overlayView.layer.borderWidth = 2
        view.addSubview(overlayView)
        
        overlayView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().inset(32)
            make.height.equalTo(150)
        }
    }
}
