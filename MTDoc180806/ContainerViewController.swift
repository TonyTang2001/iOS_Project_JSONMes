//
//  ContainerViewController.swift
//  MTDoc180806
//
//  Created by 唐子轩 on 2018/8/7.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit
import Alamofire

class ContainerViewController: UIViewController {

    var original : CGFloat = 0
    
    var MessageListTableViewController : MessageListTableViewController!
    var messageNum = 0
    
    @IBOutlet weak var inputAndSendStack: UIStackView!
    
    @IBOutlet weak var inputTF: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        messageNum = messagenum + 1
        
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
        
//        //http://39.104.90.230/webChat/?from=Mike&&to=tony&&content=TONYwoerzi&&type=textMes
//        let fromForUrl = "Tony"
//        let toForUrl = "Mike"
//        let contentForUrl = inputTF.text
//        let typeForUrl = "textMes"
//        var url = "http://39.104.90.230/webChat/?from=" + fromForUrl + "&&to=" + toForUrl
//        url += "&&content=" + contentForUrl! + "&&type=" + typeForUrl
//        print(url)
//        Alamofire.request(url)
//        
        
        // prepare json data
//        let dateToday = Date()
//        let calendar = Calendar.current
        
//        //convert dateToday to String
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//        let dateTodayString = dateFormatter.string(from: dateToday)
//
////        print(inputTF.text)
//        let json: [String : Any] = ["from": "tony","to": "mike","type": "textMes","content": inputTF.text ?? "nil","time": 143433,"date": dateTodayString ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        // create post request
//        let url = URL(string: "http://39.104.90.230/webChat/?from=Mike&&to=tony&&content=TONYwoerzi&&type=textMes")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
//        }
//
//        task.resume()
    }
    
    @IBAction func inputTFReturnKeyAction(_ sender: Any) {
        
        let fromForUrl = "Tony"
        let toForUrl = "Mike"
        let contentForUrl = inputTF.text
        let typeForUrl = "textMes"
        var url = "http://39.104.90.230/webChat/?from=" + fromForUrl + "&&to=" + toForUrl
        url += "&&content=" + contentForUrl! + "&&type=" + typeForUrl
        print(url)
        Alamofire.request(url).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")           // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
            
        inputTF.text = ""
        
    }
}
