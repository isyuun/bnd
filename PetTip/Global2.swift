//
//  Global2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit
import AlamofireImage

class Global2: Global {

    static func setPetImage(imageView: UIImageView, petTypCd: String?, petImgAddr: String? = nil) {
        var named = "profile_default"
        switch petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        var imageUrl = petImgAddr
        // NSLog("[LOG][W][IMG][ST][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][imageUrl:\(imageUrl)]")
        if let petImgAddr = petImgAddr, let range = petImgAddr.range(of: "://") {
            let scheme = petImgAddr[..<range.upperBound] // "https://"
            let restOfUrl = petImgAddr[range.upperBound...] // 나머지 부분
            let modifiedRestOfUrl = restOfUrl.replacingOccurrences(of: "//", with: "/")
            imageUrl = scheme + modifiedRestOfUrl
        }
        // NSLog("[LOG][W][IMG][ST][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][imageUrl:\(imageUrl)]")
        if let imageUrl = imageUrl {
            if let url = URL(string: imageUrl) {
                imageView.af.setImage(
                    withURL: url,
                    placeholderImage: UIImage(named: named),
                    filter: AspectScaledToFillSizeFilter(size: imageView.frame.size),
                    // runImageTransitionIfCached: false,
                    completion: { response in
                        switch response.result {
                        case .success(let image):
                            NSLog("[LOG][W][IMG][OK][(\(#fileID):\(#line))::\(#function)][image:\(image)][petImgAddr:\(imageUrl)]")
                        case .failure(let error):
                            NSLog("[LOG][W][IMG][NG][(\(#fileID):\(#line))::\(#function)][error:\(error)][petImgAddr:\(imageUrl)]")
                        }
                    })
            }
        } else {
            imageView.image = UIImage(named: named)
        }
    }
}
