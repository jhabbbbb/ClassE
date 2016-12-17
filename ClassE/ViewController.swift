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

class ViewController: UIViewController, SendTextViewDelegate, CAAnimationDelegate {
    
    let barrageView = BarrageView(style: .white)
    let sendTextView = SendTextView(style: .normal)
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        SocketManager.shared.initHandler()
        
        view.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.text = "Artifficial Neural Networks"
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(8)
            make.top.equalTo(view).offset(38)
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(375)
            make.height.equalTo(281.25)
        }
        showPPT()
        
        view.addSubview(barrageView)
        barrageView.snp.makeConstraints {
            make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(20)
            make.right.equalTo(self.view)
            make.height.equalTo(567)
        }
        
        view.addSubview(sendTextView)
        sendTextView.delegate = self
        sendTextView.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.width.equalTo(375)
            make.height.equalTo(48)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func startLikeAnimation() {
        barrageView.likeAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPPT() {
        let timer = Timer.scheduledTimer(timeInterval: 2, target:self,selector: #selector(showPage), userInfo:nil, repeats:true)
    }
    
    func showPage() {
        let timeStamp = Int(Date().timeIntervalSince1970)%31 + 1
        if timeStamp < 10 {
            imageView.image = UIImage(named: "annintro.00\(timeStamp)")
        } else {
            imageView.image = UIImage(named: "annintro.0\(timeStamp)")
        }
    }

    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 0.5, animations: {
            self.sendTextView.frame.origin.y = 619-keyboardHeight
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.frame.origin.y = 64
        })
    }
    
    func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sendTextView.frame.origin.y = 619
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.frame.origin.y = 192.875
        })
    }
}

