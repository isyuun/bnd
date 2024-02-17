//
//  ImageViewController.swift
//  PetTip
//
//  Created by carebiz on 2/16/24.
//

import UIKit
import AlamofireImage

class ImageViewController: CommonViewController {
 
    @IBOutlet weak var sv_image: UIScrollView!
 
    private var iv_image: UIImageView?
    
    private var image: UIImage?
    private var strUrl: String?
    
    @IBAction func onClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iv = UIImageView(frame: sv_image.bounds)
        iv.contentMode = .scaleAspectFit
        sv_image.addSubview(iv)
        
        iv_image = iv
        
        sv_image.contentSize = iv.bounds.size
        sv_image.delegate = self
        sv_image.maximumZoomScale = 3.0
        sv_image.minimumZoomScale = 1.0
        
        if image != nil {
            iv.image = image
            
        } else if strUrl != nil {
            iv.af.setImage(
                withURL: URL(string: strUrl!)!,
                filter: AspectScaledToFitSizeFilter(size: iv.frame.size)
            )
        }
    }
    
    public func initialize(image: UIImage?, strUrl: String?) {
        self.image = image
        self.strUrl = strUrl
    }
}





extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iv_image
    }
}
