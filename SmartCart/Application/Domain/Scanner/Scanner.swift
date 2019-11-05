//
//  Scanner.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import AVFoundation
import UIKit

// https://medium.com/programming-with-swift/how-to-read-a-barcode-or-qrcode-with-swift-programming-with-swift-10d4315141d2
internal class Scanner: NSObject {
    
    // MARK: - Properties
    
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession?
    private let eanHandler: (_ code: String) -> Void
    
    // MARK: - Initialization
    
    internal init(withViewController controller: UIViewController, view: UIView, eanHandler: @escaping (String) -> Void) {
        self.viewController = controller
        self.eanHandler = eanHandler
        super.init()
        
        if let captureSession = createCaptureSession() {
            self.captureSession = captureSession
            let previewLayer = createPreviewLayer(withSession: captureSession, view: view)
            view.layer.addSublayer(previewLayer)
        }
    }
    
    // MARK: - Methods
    
    internal func requestCaptureSessionStartRunning() {
        guard let captureSession = captureSession, !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    
    internal func requestCaptureSessionStopRunning() {
        guard let captureSession = captureSession, captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    private func createCaptureSession() -> AVCaptureSession? {
        let session = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: device)
            let metadataOutput = AVCaptureMetadataOutput()
            
            guard session.canAddInput(deviceInput) else {
                return nil
            }
            
            session.addInput(deviceInput)
            
            guard session.canAddOutput(metadataOutput) else {
                return nil
            }
            
            session.addOutput(metadataOutput)
            
            if let viewController = self.viewController as? AVCaptureMetadataOutputObjectsDelegate {
                metadataOutput.setMetadataObjectsDelegate(viewController, queue: .main)
                metadataOutput.metadataObjectTypes = self.metaObjectTypes()
            }
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
        return session
    }
    
    private func createPreviewLayer(withSession session: AVCaptureSession, view: UIView) ->AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }
    
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [
            .code128,
            .code39,
            .code39Mod43,
            .code93,
            .ean13,
            .ean8,
            .interleaved2of5,
            .itf14,
            .pdf417,
            .upce]
    }
}
