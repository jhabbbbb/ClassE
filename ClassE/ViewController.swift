//
//  ViewController.swift
//  ClassE
//
//  Created by JinHongxu on 2016/12/14.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

import UIKit
import SocketIO
import SnapKit

class ViewController: UIViewController {
    
    //let socket = SocketIOClient(socketURL: URL(string: "http://104.194.67.188:12345")!, config: [.log(true), .forcePolling(true)])
    let barrageView = BarrageView(a: 10)
    let sendTextView = SendTextView(a: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketManager.shared.initHandler()
        view.addSubview(barrageView)
        barrageView.snp.makeConstraints {
            make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(20)
            make.right.equalTo(self.view)
            make.height.equalTo(567)
        }
        
        view.addSubview(sendTextView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        sendTextView.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.width.equalTo(375)
            make.height.equalTo(48)
        }
        // Do any additional setup after loading the view, typically from a nib.
//        socket.on("connect") {data, ack in
//            print("socket connected")
//            self.statusLabel.text = "连接成功"
//        }
//
//        
//        socket.on("messageS2C"){
//            data, ack in
//            print(data)
//            let dict = data[0] as! Dictionary<String, String>
//            let message = dict["message"] ?? "A Message From No Man's Sky"
//            //print(message)
//            let label: UILabel = UILabel(frame: CGRect(x: 375, y: Int(arc4random()%600)/30*30, width: 100, height: 30))
//            label.text = message
//            self.view.addSubview(label)
//            UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
//                label.frame.origin.x -= 475
//            }, completion: { flag in
//                label.removeFromSuperview()
//            })
//        }
//        
//        socket.connect()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 0.5, animations: {
            self.sendTextView.frame.origin.y = 619-keyboardHeight
        })
    }
    
    func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sendTextView.frame.origin.y = 619
        })
    }

}

