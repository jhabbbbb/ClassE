//
//  SendTextView.swift
//  ClassE
//
//  Created by JinHongxu on 2016/12/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum SendTextViewStyle {
    case normal
}

protocol SendTextViewDelegate {
    func startLikeAnimation()
}

class SendTextView: UIView, UIAlertViewDelegate, UITextFieldDelegate {
    let textField = UITextField()
    let sendButton = UIButton()
    let cancelButton = UIButton()
    let likeButton = UIButton()
    var delegate: SendTextViewDelegate?
    var likeCount = 0
    convenience init(style: SendTextViewStyle = .normal) {
        self.init()
        
        self.backgroundColor = UIColor.lightGray
        self.addSubview(textField)
        self.addSubview(sendButton)
        self.addSubview(cancelButton)
        self.addSubview(likeButton)
        cancelButton.setImage(UIImage(named: "ic_clear"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.snp.makeConstraints {
            make in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "说点什么吧..."
        textField.returnKeyType = .send
        textField.delegate = self
        textField.snp.makeConstraints {
            make in
            make.left.equalTo(cancelButton.snp.right)
            make.width.equalTo(240)
            make.centerY.equalTo(self)
        }
        
        likeButton.setImage(UIImage(named: "ic_thumb_up"), for: .normal)
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        likeButton.snp.makeConstraints {
            make in
            make.right.equalTo(self).offset(-8)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        sendButton.setImage(UIImage(named: "ic_send"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.snp.makeConstraints {
            make in
            make.right.equalTo(likeButton.snp.left).offset(-4)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
    }
    
    func sendMessage() {
        if let message = textField.text, message != "" {
            SocketManager.shared.emit(message: message)
            self.endEditing(true)
            textField.text = ""
        } else {
            let alert = UIAlertView(title: "发送内容不能为空哦", message: "", delegate: self, cancelButtonTitle: "好的")
            alert.show()
        }
    }
    
    func cancel() {
        self.endEditing(true)
    }
    
    func like() {
        self.endEditing(true)
        self.delegate?.startLikeAnimation()
        if likeCount % 5 == 0 {
            SocketManager.shared.emit(message: "like")
        }
        likeCount += 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
}
