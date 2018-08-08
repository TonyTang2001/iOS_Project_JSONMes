//
//  ContainerViewController.swift
//  MTDoc180806
//
//  Created by 唐子轩 on 2018/8/7.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var original : CGFloat = 0
    
    
    @IBOutlet weak var inputAndSendStack: UIStackView!
    
    @IBOutlet weak var inputTF: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shift inputAndSendStack when Keyboard Pops up
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
        
        //Dismiss Keyboard after Tapping Elsewhere
        original = bottomConstraint.constant    //set original bottom value for Dismiss Action
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        inputTF.resignFirstResponder()
        
        bottomConstraint.constant = original
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        bottomConstraint.constant = keyboardHeight + 8
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            }
    }
    
    @IBAction func SendAction(_ sender: UIButton) {
    }
    
}
