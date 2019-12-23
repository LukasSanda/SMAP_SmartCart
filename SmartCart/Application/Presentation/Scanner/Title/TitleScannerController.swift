//
//  TitleScannerController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 13/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

internal class TitleScannerController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private var imagePicker: UIImagePickerController!
    private let button = UIButton()
    
    private let presenter: TitleScannerPresenter
    
    // MARK: - Initialization
    
    internal init(presenter: TitleScannerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIImagePickerControllerDelegate
extension TitleScannerController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        recognizeTextInImage(image)
    }
    
    func recognizeTextInImage(_ image: UIImage) {
        let vision = Vision.vision()
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["en", "cs"]
        let textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                logger.logError(message: error?.localizedDescription ?? "")
                return
            }
            
            self.presenter.didRecognizeText(result.text)
        }
    }
}

// MARK: - Action Selectors
private extension TitleScannerController {
    @objc
    func takePhoto() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        //navigationController?.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Setup View Appereance
private extension TitleScannerController {
    func setup() {
        view.backgroundColor = .white
        
        button.setTitle("Photo", for: .normal)
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
