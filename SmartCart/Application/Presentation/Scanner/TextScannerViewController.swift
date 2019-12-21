//
//  TextScannerViewController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 13/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

internal class TextScannerViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private var imagePicker: UIImagePickerController!
    private let button = UIButton()
    
    // MARK: - Initialization
    
    internal init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        button.setTitle("Photo", for: .normal)
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    func test() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        //navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func recognition(image: UIImage) {
        let vision = Vision.vision()
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["en", "cs"]
        let textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                // ...
                return
            }
            
            let resultText = result.text
            print(resultText)
            
            //          for block in result.blocks {
            //              let blockText = block.text
            //              let blockConfidence = block.confidence
            //              let blockLanguages = block.recognizedLanguages
            //              let blockCornerPoints = block.cornerPoints
            //              let blockFrame = block.frame
            //              for line in block.lines {
            //                  let lineText = line.text
            //                  let lineConfidence = line.confidence
            //                  let lineLanguages = line.recognizedLanguages
            //                  let lineCornerPoints = line.cornerPoints
            //                  let lineFrame = line.frame
            //                  for element in line.elements {
            //                      let elementText = element.text
            //                      let elementConfidence = element.confidence
            //                      let elementLanguages = element.recognizedLanguages
            //                      let elementCornerPoints = element.cornerPoints
            //                      let elementFrame = element.frame
            //                  }
            //              }
            //          }
        }
    }
}

extension TextScannerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        recognition(image: image)
    }
}

private extension TextScannerViewController {
    func setup() {
        view.backgroundColor = .white
    }
}
