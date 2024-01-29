//
//  CALayer.swift
//  PetTip
//
//  Created by carebiz on 12/2/23.
//

import QuartzCore
import UIKit

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
    
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                border.name = "bottomBorder"
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
    
    func removeBorder(_ arr_edge: [UIRectEdge]) {
        for edge in arr_edge {
            switch edge {
            case UIRectEdge.bottom:
                if let sublayers = self.sublayers {
                    for i in 0..<sublayers.count {
                        if sublayers[i].name == "bottomBorder" {
                            sublayers[i].removeFromSuperlayer()
                            break
                        }
                    }
                }
                break
            default:
                break
            }
        }
    }
}
