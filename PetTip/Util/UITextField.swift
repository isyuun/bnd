//
//  UITextField.swift
//  PetTip
//
//  Created by carebiz on 12/3/23.
//

import UIKit

extension UITextField {
    func initLeftIconIncludeTextField(iconImg: UIImage) {
        let leftView = UIView(frame: CGRectMake(0, 0, 35, 20))
        let imageView = UIImageView(frame: CGRectMake(14, 0, 18, 18))
        imageView.image = iconImg
        leftView.addSubview(imageView)
        self.leftView = leftView
        self.leftViewMode = .always
    }

    func resolveHashTags() {
        // turn string in to NSString
        let nsText = NSString(string: self.text!)

        // this needs to be an array of NSString.  String does not work.
        let words = nsText.components(separatedBy: CharacterSet(charactersIn: "#ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_").inverted)

        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString()
        attrString.mutableString.setString(self.text!) // FIX TO-BE
        // attrString.setAttributedString(self.attributedText!) // FIX AS-IS

        // tag each word if it has a hashtag
        for word in words {
            if word.count < 3 {
                continue
            }

            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("#") {

                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange: NSRange = nsText.range(of: word as String)

                // drop the hashtag
                let stringifiedWord = word.dropFirst()
                // if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                //     // hashtag contains a number, like "#1"
                //     // so don't make it clickable
                // } else {
                //     // set a link for when the user clicks on this word.
                //     // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                //     // note:  since it's a URL now, the color is set to the project's tint color
                //     attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                // }
                attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
            }
        }

        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        self.attributedText = attrString
    }
}

@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
