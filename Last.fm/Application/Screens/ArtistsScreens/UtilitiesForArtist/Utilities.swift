//
//  Utilities.swift
//  Last.fm
//
//  Created by Tong Yi on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

let context = CIContext(options: nil)

func blurImage(image: UIImage?) -> CGImage? {
    guard let image = image else { return nil }
    let inputImage = CIImage(image: image)
    guard let filter = CIFilter(name: "CIGaussianBlur") else { return nil }
    filter.setValue(inputImage, forKey: kCIInputImageKey)
    filter.setValue(5, forKey: kCIInputRadiusKey)
    guard let outputCIImage = filter.outputImage else { return nil }
    let rect = CGRect(origin: CGPoint.zero, size: image.size)
    let cgImage = context.createCGImage(outputCIImage, from: rect)
    return cgImage
}

func accuracyFloat(number: String) -> String {
    guard let num = Int(number), num > 1000 else { return number }
    
    var stringOfNumber = ""
    
    if num > 1000000000 {
        stringOfNumber = String(format: "%.1fB", Double(num) / 1000000000.0)
    } else if num > 1000000 {
        stringOfNumber = String(format: "%.1fM", Double(num) / 1000000.0)
    } else if num > 1000 {
        stringOfNumber = String(format: "%.1fM", Double(num) / 1000000.0)
    }
    
    return stringOfNumber
}
