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
    
    //let socket = SocketIOClient(socketURL: URL(string: "http://104.194.67.188:12345")!, config: [.log(true), .forcePolling(true)])
    let barrageView = BarrageView(a: 10)
    let sendTextView = SendTextView(a: 10)
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        
        SocketManager.shared.initHandler()
        
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
    
    func startLikeAnimation() {
        likeAnimation()
    }
    
    func likeAnimation() {
        var tagNumber: Int = 500000
        tagNumber+=1
        
        let image = UIImage.init(named: randomImageName())
        let imageView = UIImageView.init(image: image)
        imageView.center = CGPoint(x: -5000, y :-5000)
        imageView.tag = tagNumber
        view.addSubview(imageView)
        
        let group = groupAnimation()
        group.setValue(tagNumber, forKey: "animationName")
        imageView.layer.add(group, forKey: "wendingding")
    }
    
    func groupAnimation() -> CAAnimationGroup{
        
        let group = CAAnimationGroup.init()
        group.duration = 2.0;
        group.repeatCount = 1;
        let animation = scaleAnimation()
        let keyAnima = positionAnimatin()
        let alphaAnimation = alphaAnimatin()
        group.animations = [animation, keyAnima, alphaAnimation]
        group.delegate = self;
        return group
    }
    
    func scaleAnimation() -> CABasicAnimation {
        // 设定为缩放
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        // 动画选项设定
        animation.duration = 0.5// 动画持续时间
        //    animation.autoreverses = NO; // 动画结束时执行逆动画
        animation.isRemovedOnCompletion = false
        
        // 缩放倍数
        animation.fromValue = 0.1 // 开始时的倍率
        animation.toValue = 1.0 // 结束时的倍率
        return animation
    }
    
    func positionAnimatin() -> CAKeyframeAnimation {
        
        let keyAnima=CAKeyframeAnimation.init()
        keyAnima.keyPath="position"
        
        //1.1告诉系统要执行什么动画
        //创建一条路径
        let path = CGMutablePath()
        
        //设置一个圆的路径
        //    CGPathAddEllipseInRect(path, NULL, CGRectMake(150, 100, 100, 100));
        
        path.move(to: CGPoint(x: 333, y: 600))
        let controlX = Int((arc4random() % (100 + 1))) - 50
        let controlY = Int((arc4random() % (130 + 1))) + 50
        let entX = Int((arc4random() % (100 + 1))) - 50
        
        //CGPathAddQuadCurveToPoint(path, nil, CGFloat(200 - controlX), CGFloat(200 - controlY), CGFloat(200 + entX), 200 - 260)
        path.addQuadCurve(to: CGPoint(x: CGFloat(333 - controlX), y: CGFloat(200 - controlY)), control: CGPoint(x: CGFloat(200 + entX), y:200 - 260))
        
        keyAnima.path=path;
        //有create就一定要有release, ARC自动管理
        //        CGPathRelease(path);
        //1.2设置动画执行完毕后，不删除动画
        keyAnima.isRemovedOnCompletion = false
        //1.3设置保存动画的最新状态
        keyAnima.fillMode=kCAFillModeForwards
        //1.4设置动画执行的时间
        keyAnima.duration=2.0
        //1.5设置动画的节奏
        keyAnima.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        return keyAnima
    }
    
    func alphaAnimatin() -> CABasicAnimation {
        
        let alphaAnimation = CABasicAnimation.init(keyPath: "opacity")
        
        // 动画选项设定
        alphaAnimation.duration = 1.5 // 动画持续时间
        alphaAnimation.isRemovedOnCompletion = false
        
        alphaAnimation.fromValue = 1.0
        alphaAnimation.toValue = 0.1
        alphaAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        alphaAnimation.beginTime = 0.5
        
        return alphaAnimation
    }
    func randomImageName() -> String {
        
        let number = Int(arc4random() % (4 + 1));
        var randomImageName: String
        switch (number) {
        case 1:
            randomImageName = "bHeart"
            break;
        case 2:
            randomImageName = "gHeart"
            break;
        case 3:
            randomImageName = "rHeart"
            break;
        case 4:
            randomImageName = "yHeart"
            break;
        default:
            randomImageName = "bHeart"
            break;
        }
        return randomImageName
    }
}

