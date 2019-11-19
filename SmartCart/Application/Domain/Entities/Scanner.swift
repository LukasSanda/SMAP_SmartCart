//
//  Scanner.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import AVFoundation
import UIKit

internal class Scanner: NSObject {
    
    // MARK: - Properties
    
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession?
    private let eanHandler: (_ code: String) -> Void
    
    private var metaObjectTypes: [AVMetadataObject.ObjectType] {
        return [.code128, .code39, .code39Mod43, .code93, .ean13, .ean8, .interleaved2of5, .itf14, .pdf417, .upce]
    }
    
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
    
    internal func scannerDelegate(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        requestCaptureSessionStopRunning()
        
        guard
            let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = readableObject.stringValue else {
                return
        }
        
        self.eanHandler(code)
    }
}

// MARK: - Helpers
private extension Scanner {
    func createCaptureSession() -> AVCaptureSession? {
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
                metadataOutput.metadataObjectTypes = self.metaObjectTypes
            }
            
        } catch let error {
            logger.logError(message: error.localizedDescription)
            return nil
        }
        
        return session
    }
    
    func createPreviewLayer(withSession session: AVCaptureSession, view: UIView) ->AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }
}
