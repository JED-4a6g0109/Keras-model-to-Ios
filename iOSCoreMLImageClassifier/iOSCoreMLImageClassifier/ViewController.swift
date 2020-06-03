//
//  ViewController.swift
//  iOSCoreMLImageClassifier
//
//  Created by Anupam Chugh on 25/09/19.
//  Copyright © 2019 Anupam Chugh. All rights reserved.
//

import UIKit
import CoreML

enum Animal {
    case apple
    case apricot
    case banana
    case cantaloup
    case carmbula
    case cherry
    case corn
    case ginger
    case strawberry
    case tomato
    case watermelon
}


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var modelOutputLabel: UILabel!
    private let model = xx()
    @IBOutlet weak var imageView: UIImageView!
    private let trainedImageSize = CGSize(width: 64, height: 64)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func takePhotoClicked(_ sender: Any) {
    
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func predict(image: UIImage) -> Animal? {
        do {
            if let resizedImage = resize(image: image, newSize: trainedImageSize), let pixelBuffer = resizedImage.toCVPixelBuffer() {
                let prediction = try model.prediction(image: pixelBuffer)
                let value = prediction.output[0].intValue
                print(prediction.output)
                print(value)
                if prediction.output[0].intValue == 1{
                    return .apple
                }
                else if prediction.output[1].intValue == 1{
                    return .apricot
                }
                else if prediction.output[2].intValue == 1{
                    return .banana
                }
                else if prediction.output[3].intValue == 1{
                    return .cantaloup
                }
                else if prediction.output[4].intValue == 1{
                    return .carmbula
                }
                else if prediction.output[5].intValue == 1{
                    return .cherry
                }
                else if prediction.output[6].intValue == 1{
                    return .corn
                }
                else if prediction.output[7].intValue == 1{
                    return .ginger
                }
                else if prediction.output[8].intValue == 1{
                    return .strawberry
                }
                else if prediction.output[9].intValue == 1{
                    return .tomato
                }
                else if prediction.output[10].intValue == 1{
                    return .watermelon
                }

            }
        } catch {
            print("Error while doing predictions: \(error)")
        }

        return nil
    }

    func resize(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let animal = self.predict(image: image)
                
                self.imageView.image = image
                

                if let animal = animal{
                    if animal == .apple{
                        self.modelOutputLabel.text = "我知道他是蘋果"
                    }
                    else if animal == .apricot{
                        self.modelOutputLabel.text = "我知道他是杏仁"
                    }
                    else if animal == .banana{
                        self.modelOutputLabel.text = "我知道他是香蕉"
                    }
                    else if animal == .cantaloup{
                        self.modelOutputLabel.text = "我知道他是柳丁"
                    }
                    else if animal == .carmbula{
                        self.modelOutputLabel.text = "我知道他是楊桃"
                    }
                    else if animal == .cherry{
                        self.modelOutputLabel.text = "我知道他是櫻桃"
                    }
                    else if animal == .corn{
                        self.modelOutputLabel.text = "我知道他是玉米"
                    }
                    else if animal == .ginger{
                        self.modelOutputLabel.text = "我知道他是薑"
                    }
                    else if animal == .strawberry{
                        self.modelOutputLabel.text = "我知道他是草莓"
                    }
                    else if animal == .tomato{
                        self.modelOutputLabel.text = "我知道他是番茄"
                    }
                    else if animal == .watermelon{
                        self.modelOutputLabel.text = "我知道他是西瓜"
                    }
                }
                else{
                    self.modelOutputLabel.text = "我不知道這是殺小"
                }
            }
        }
    }
}

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}

