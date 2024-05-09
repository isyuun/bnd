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
        var named = "profile_default"
        switch pet.petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][pet:\(pet)][named:\(named)]")
        if let petRprsImgAddr = pet.petRprsImgAddr {
            imageView.af.setImage(
                withURL: URL(string: petRprsImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: MyPet) {
        var named = "profile_default"
        switch pet.petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][pet:\(pet)][named:\(named)]")
        if let petRprsImgAddr = pet.petRprsImgAddr {
            imageView.af.setImage(
                withURL: URL(string: petRprsImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: DailyLifePetList) {
        var named = "profile_default"
        switch pet.petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][pet:\(pet)][named:\(named)]")
        if let petRprsImgAddr = pet.petImg {
            imageView.af.setImage(
                withURL: URL(string: petRprsImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: MyPetDetailData) {
        var named = "profile_default"
        switch pet.petTypCD {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][pet:\(pet)][named:\(named)]")
        if let petRprsImgAddr = pet.petRprsImgAddr {
            imageView.af.setImage(
                withURL: URL(string: petRprsImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }

    static func setPetImage(imageView: UIImageView, pet: CmntList) {
        var named = "profile_default"
        switch pet.petTypCd {
        case "002":
            named = "cat-profile2"
            break
        default:
            break
        }
        NSLog("[LOG][W][(\(#fileID):\(#line))::\(#function)][imageView:\(imageView)][pet:\(pet)][named:\(named)]")
        if let petRprsImgAddr = pet.petImg {
            imageView.af.setImage(
                withURL: URL(string: petRprsImgAddr)!,
                placeholderImage: UIImage(named: named)!,
                filter: AspectScaledToFillSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = UIImage(named: named)
        }
    }
}
