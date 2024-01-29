//
//  UIImage.swift
//  PetTip
//
//  Created by carebiz on 12/1/23.
//

import UIKit

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func imageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineThickness: CGFloat, side: Side) -> UIImage {
        var xPosition = 0.0
        var yPosition = 0.0
        var imgWidth = 2.0
        var imgHeight = 2.0
        switch side {
            case .top:
                xPosition = 0.0
                yPosition = 0.0
                imgWidth = size.width
                imgHeight = lineThickness
            case .bottom:
                xPosition = 0.0
                yPosition = size.height - lineThickness
                imgWidth = size.width
                imgHeight = lineThickness
            case .left:
                xPosition = 0.0
                yPosition = 0.0
                imgWidth = lineThickness
                imgHeight = size.height
            case .right:
                xPosition = size.width - lineThickness
                yPosition = 0.0
                imgWidth = lineThickness
                imgHeight = size.height
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: xPosition, y: yPosition, width: imgWidth, height: imgHeight))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    enum Side: String {
        case top, left, right, bottom
    }
    
    func resizeImageForUpload(maxWidth: Int = 1920, maxHeight: Int = 1080) -> UIImage {
        let originWidth = Int(self.size.width)
        let originHeight = Int(self.size.height)
        
        var isRequireResize = false
        if originWidth > originHeight {
            if originWidth > maxWidth {
                isRequireResize = true
            }
        } else {
            if originHeight > maxHeight {
                isRequireResize = true
            }
        }
        
        var width = 0
        var height = 0
        if isRequireResize {
            if originWidth > originHeight {
                let resizeRatio = Float(maxWidth) / Float(originWidth)
                width = Int(Float(originWidth) * resizeRatio)
                height = Int(Float(originHeight) * resizeRatio)
                
            } else {
                let resizeRatio = Float(maxHeight) / Float(originHeight)
                width = Int(Float(originWidth) * resizeRatio)
                height = Int(Float(originHeight) * resizeRatio)
            }

            let opaque = true
            var newImage: UIImage
            if #available(iOS 10.0, *) {
                let renderFormat = UIGraphicsImageRendererFormat.default()
                renderFormat.opaque = opaque
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
                newImage = renderer.image {
                    (context) in
                    self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                    self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                    newImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
            
            return newImage
            
        } else {
            return self
        }
    }
    
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension
                    height = dimension / aspectRatio
                } else {                                        // Portrait image
                    height = dimension
                    width = dimension * aspectRatio
                }

        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        return newImage
    }
}
