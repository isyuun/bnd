//
//  Global2.swift
//  PetTip
//
//  Created by isyuun on 2024/5/9.
//

import UIKit
import AlamofireImage

class Global2: Global {
    static func setPetImage(imageView: UIImageView, pet: Pet) {
        guard let petTypCd = pet.petTypCd else { return }
        var named = "profile_default"
        switch petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        if let petImgAddr = pet.petRprsImgAddr {
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][petImgAddr:\(petImgAddr)]")
            imageView.af.setImage(
                withURL: URL(string: petImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: MyPet) {
        guard let petTypCd = pet.petTypCd else { return }
        var named = "profile_default"
        switch petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        if let petImgAddr = pet.petRprsImgAddr {
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][petImgAddr:\(petImgAddr)]")
            imageView.af.setImage(
                withURL: URL(string: petImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: DailyLifePetList) {
        guard let petTypCd = pet.petTypCd else { return }
        var named = "profile_default"
        switch petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        if let petImgAddr = pet.petImg {
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][petImgAddr:\(petImgAddr)]")
            imageView.af.setImage(
                withURL: URL(string: petImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: MyPetDetailData) {
        let petTypCd = pet.petTypCd
        var named = "profile_default"
        switch petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        if let petImgAddr = pet.petRprsImgAddr {
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][petImgAddr:\(petImgAddr)]")
            imageView.af.setImage(
                withURL: URL(string: petImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: CmntList) {
        guard let petTypCd = pet.petTypCd else { return }
        var named = "profile_default"
        switch petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        if let petImgAddr = pet.petImg {
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][petImgAddr:\(petImgAddr)]")
            imageView.af.setImage(
                withURL: URL(string: petImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, petTypCd: String, petImgAddr: String? = nil) {
        var named = "profile_default"
        switch petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        if let petImgAddr = petImgAddr {
            NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][petTypCd:\(petTypCd)][named:\(named)][petImgAddr:\(petImgAddr)]")
            imageView.af.setImage(
                withURL: URL(string: petImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, petTypCd: String) {
        setPetImage(imageView: imageView, petTypCd: petTypCd, petImgAddr: nil)
    }
}
