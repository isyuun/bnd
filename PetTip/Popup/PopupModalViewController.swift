//
//  PopupModalViewController2.swift
//  popOver
//
//  Created by carebiz on 12/27/23.
//

import UIKit

public protocol PopupModalDelegate: AnyObject {
    func didTapPopupCancel()
    func didTapPopupOK()
}

extension PopupModalDelegate where Self: CommonViewController {
    
    func popupShow(contentView: CommonPopupView, wSideMargin: Int, type: PopupLayoutType = .center, isTapCancel : Bool = true) {
        if (popupBgView == nil) {
            popupBgView = UIControl()
            popupBgView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.view.addSubview(popupBgView)
            
            popupBgView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popupBgView.topAnchor.constraint(equalTo: self.view.topAnchor),
                popupBgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                popupBgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                popupBgView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        } else {
            popupBgView.isHidden = false        
        }
        
        PopupModalViewController.present(parent: self, delegate: self, contentView: contentView, wSideMargin: wSideMargin, type: type, isTapCancel: isTapCancel)
    }
}

enum PopupLayoutType {
    case center
    case bottom
}

class PopupModalViewController: CommonViewController {
    private static func create(delegate: PopupModalDelegate, contentView: CommonPopupView, wSideMargin: Int, type: PopupLayoutType, isTapCancel: Bool) -> PopupModalViewController {
        let view = PopupModalViewController(delegate: delegate, contentView: contentView, wSideMargin: wSideMargin, type: type.self, isTapCancel: isTapCancel.self)
        return view
    }
    
    @discardableResult
    static public func present(parent: UIViewController, delegate: PopupModalDelegate, contentView: CommonPopupView, wSideMargin: Int, type: PopupLayoutType, isTapCancel: Bool) -> PopupModalViewController {
        let view = PopupModalViewController.create(delegate: delegate, contentView: contentView, wSideMargin: wSideMargin, type: type, isTapCancel: isTapCancel)
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .coverVertical
        view.view.backgroundColor = UIColor.clear
        parent.present(view, animated: true)
        
        return view
    }
    
    public weak var delegate: PopupModalDelegate?
    public var contentView: CommonPopupView!
    public var wSideMargin: Int!
    public var type: PopupLayoutType!
    public var isTapCancel: Bool!
    
    public init(delegate: PopupModalDelegate, contentView: CommonPopupView, wSideMargin: Int, type: PopupLayoutType, isTapCancel: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.contentView = contentView
        self.wSideMargin = wSideMargin
        self.type = type
        self.isTapCancel = isTapCancel
        
        contentView.parentViewController = self
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        
        hideKeyboardWhenTappedAround()
    }
    
    @objc private func bgViewTap(_ sender: Any) {
        self.delegate?.didTapPopupCancel()
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        self.delegate?.didTapPopupCancel()
    }
    
    private func setupViews() {
        let bgView = UIControl()
        bgView.backgroundColor = UIColor.clear
        if isTapCancel { bgView.addTarget(self, action: #selector(bgViewTap(_:)), for: .touchUpInside) }
        self.view.addSubview(bgView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if self.type == .center {
            contentView.layer.cornerRadius = 20
            contentView.layer.masksToBounds = true
            
            NSLayoutConstraint.activate([
                contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: CGFloat(wSideMargin)),
                contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-wSideMargin))
            ])
        } else if self.type == .bottom {
            NSLayoutConstraint.activate([
                contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: CGFloat(wSideMargin)),
                contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-wSideMargin))
            ])
        }
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        self.view.frame.size.height -= keyboardFrame.height
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        self.view.frame.size.height += keyboardFrame.height
    }
}
