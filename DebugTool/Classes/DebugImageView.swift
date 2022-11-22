//
//  DebugImageView.swift
//  DebugTool
//
//  Created by pink on 2022/11/21.
//

import UIKit

/// 偵錯圖片View
class DebugImageView: UIView {
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        //  大小倍率
        let scale:Double = 2.8
        //  green 底色
        let appleLogo = CGRect(x: 0, y: 0, width: 16.3 * scale, height: 20.0 * scale)
        let backgroundView = UIView(frame: appleLogo)
        addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor(red: 95/255, green: 179/255, blue: 71/255, alpha: 1)
        //  yellow 底色
        let yellow2 = CGRect(x: 0, y: 7.691 * scale, width: 16.3001 * scale, height: 2.4694 * scale)
        let yellowView = UIView(frame: yellow2)
        yellowView.backgroundColor = UIColor(red: 243/255, green: 197/255, blue: 46/255, alpha: 1)
        backgroundView.addSubview(yellowView)
        //  orange 底色
        let orange3 = CGRect(x: 0, y: 10.16 * scale, width: 16.3001 * scale, height: 2.3283 * scale)
        let orangeView = UIView(frame: orange3)
        orangeView.backgroundColor = UIColor(red: 234/255, green: 127/255, blue: 38/255, alpha: 1)
        backgroundView.addSubview(orangeView)
        //  red 底色
        let red04 = CGRect(x: 0, y: 12.488 * scale, width: 16.3 * scale, height: 2.3814 * scale)
        let redView = UIView(frame: red04)
        redView.backgroundColor = UIColor(red: 212/255, green: 58/255, blue: 60/255, alpha: 1)
        backgroundView.addSubview(redView)
        //  purple 底色
        let purple05 = CGRect(x: 0, y: 14.87 * scale, width: 16.3 * scale, height: 2.4165 * scale)
        let purpleView = UIView(frame: purple05)
        purpleView.backgroundColor = UIColor(red: 141/255, green: 58/255, blue: 142/255, alpha: 1)
        backgroundView.addSubview(purpleView)
        //  blue 底色
        let blue06 = CGRect(x: 0, y: 17.286 * scale, width: 16.3 * scale, height: 2.7139 * scale)
        let blueView = UIView(frame: blue06)
        blueView.backgroundColor = UIColor(red: 20/255, green: 147/255, blue: 204/255, alpha: 1)
        backgroundView.addSubview(blueView)
        //  apple 葉子形狀
        let leafPath = UIBezierPath()
        leafPath.move(to: CGPoint(x: 12.134 * scale, y: 0))
        leafPath.addQuadCurve(to: CGPoint(x: 8.123 * scale, y: 4.598 * scale), controlPoint: CGPoint(x: 8.901 * scale, y: 0.917 * scale))
        leafPath.addQuadCurve(to: CGPoint(x: 12.134 * scale, y: 0), controlPoint: CGPoint(x: 11.544 * scale, y: 3.905 * scale))
        leafPath.close()
        //  apple 本體形狀
        let apPath = UIBezierPath()
        apPath.move(to: CGPoint(x: 15.769 * scale, y: 6.81 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 8.902 * scale,   y: 5.593 * scale), controlPoint: CGPoint(x: 13.912 * scale, y: 3.402 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 7.564 * scale,   y: 5.58 * scale), controlPoint: CGPoint(x: 8.173 * scale, y: 5.699 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 1.34 * scale,   y: 6.634 * scale), controlPoint: CGPoint(x: 3.515 * scale, y: 3.72 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 0,   y: 10.929 * scale), controlPoint: CGPoint(x: 0, y: 8.193 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 4.301 * scale,   y: 19.762 * scale), controlPoint: CGPoint(x: 0.082 * scale, y: 16.947 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 6.002 * scale,   y: 19.841 * scale), controlPoint: CGPoint(x: 5.036 * scale, y: 20.206 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 10.717 * scale,   y: 19.76 * scale), controlPoint: CGPoint(x: 8.378 * scale, y: 18.666 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 12.759 * scale,   y: 19.743 * scale), controlPoint: CGPoint(x: 12.038 * scale, y: 20.13 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 16.275 * scale,   y: 14.738 * scale), controlPoint: CGPoint(x: 14.57 * scale, y: 18.988 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 13.572 * scale,   y: 10.663 * scale), controlPoint: CGPoint(x: 13.572 * scale, y: 13.776 * scale))
        apPath.addQuadCurve(to: CGPoint(x: 15.769 * scale, y: 6.81 * scale), controlPoint: CGPoint(x: 13.383 * scale, y: 8.257 * scale))
        apPath.close()
        //合併
        leafPath.append(apPath)
        let appleShape = CAShapeLayer()
        appleShape.path = leafPath.cgPath
        //遮罩
        backgroundView.layer.mask = appleShape
        backgroundView.center = center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
