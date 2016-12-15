//
//  BarrageView.swift
//  ClassE
//
//  Created by JinHongxu on 2016/12/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//


import UIKit
import SocketIO
import SnapKit

class BarrageView: UIView, SocketManagerDelegate {
    
    let statusLabel = UILabel()
    let reconnectButton = UIButton()
    
    convenience init(a: Int) {
        self.init()
        SocketManager.shared.delegate = self
        
        self.addSubview(statusLabel)
        self.addSubview(reconnectButton)
        
        statusLabel.text = "正在连接弹幕服务器..."
        statusLabel.snp.makeConstraints {
            make in
            make.bottom.equalTo(self).offset(-8)
            make.left.equalTo(self).offset(8)
            make.width.equalTo(200)
            make.height.equalTo(16)
        }
        
        reconnectButton.setImage(UIImage(named: "ic_refresh") , for: .normal)
        reconnectButton.addTarget(self, action: #selector(connectSocket), for: .touchUpInside)
        reconnectButton.snp.makeConstraints{
            make in
            make.top.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
    }
    
    func connectSocket() {
        self.statusLabel.text = "正在连接弹幕服务器..."
        self.statusLabel.alpha = 1
        SocketManager.shared.reconnect()
    }
    
    func SocketDidConnect() {
        print("socket connected")
        self.statusLabel.text = "弹幕服务器连接成功"
        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveLinear, animations: {
            self.statusLabel.alpha = 0
        }, completion: nil)
    }
    
    func SocketDidReciveMessage(message: String) {
        let label: UILabel = UILabel(frame: CGRect(x: 375, y: Int(arc4random()%530)/25*25, width: 100, height: 25))
        label.text = message
        label.sizeToFit()
        self.addSubview(label)
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
            label.frame.origin.x -= label.frame.size.width+375
        }, completion: { flag in
            label.removeFromSuperview()
        })
    }
}
