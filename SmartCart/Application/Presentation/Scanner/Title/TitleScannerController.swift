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
    
    private var imagePicker: UIImagePickerController?
    private let button = UIButton()
    
    private let presenter: TitleScannerPresenter
    
    // MARK: - Initialization
    
    internal init(presenter: TitleScannerPresenter) {
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
        view.backgroundColor = .white
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        self.imagePicker = vc
        
        self.view.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension TitleScannerController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicker = imagePicker else { return }
        imagePicker.view.removeFromSuperview()
        
        guard let image = info[.originalImage] as? UIImage, let finalIamge = image.fixedOrientation() else { return }
        recognizeTextInImage(finalIamge)
    }
    
    func recognizeTextInImage(_ image: UIImage) {
        let vision = Vision.vision()
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["cs", "en"]
        options.modelType = .sparse
        let textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                logger.logError(message: error?.localizedDescription ?? "")
                return
            }
            
            self.dismiss(animated: true) {
                self.presenter.didRecognizeText(result.text)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
