//
//  DebugTool.swift
//  DebugTool
//
//  Created by pink on 2022/11/21.
//

import UIKit

/// 偵錯工具
open class DebugTool: UIWindow {
    
    // MARK: - 私有成員
    
    /// 彈窗管理者
    private let debugAlertManager = DebugAlertManager()
    
    /// 所有提示視窗View
    private var allToast: [UIView] = []
    
    /// 單行提示視窗高度
    private var toastHeight: CGFloat = 40.0
    
    /// 提示視窗之間的間距
    private var toastSpace: CGFloat = 5.0
    
    /// Window的寬高
    private let windowWidthHeight: CGFloat = 50.0
    
    // MARK: - 初始化
    
    /// 初始化
    public init(point: CGPoint, toastHeight: CGFloat = 40, toastSpace: CGFloat = 5) {
        self.toastHeight = toastHeight
        self.toastSpace = toastSpace
        super.init(frame: CGRect(x: point.x, y: point.y, width: windowWidthHeight, height: windowWidthHeight))
        initWindow(frame: CGRect(x: point.x, y: point.y, width: windowWidthHeight, height: windowWidthHeight))
    }
    
    /// 初始化(For ios13 SceneDelegate)
    @available(iOS 13.0, *)
    public init(windowScene: UIWindowScene, point: CGPoint) {
        super.init(windowScene: windowScene)
        initWindow(frame: CGRect(x: point.x, y: point.y, width: windowWidthHeight, height: windowWidthHeight))
    }
    
    /// 初始化(禁止使用Xib)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化Window
    /// - Parameter frame: frame
    private func initWindow(frame: CGRect){
        
        //設定圖片與視窗層級
        let appleView = DebugImageView()
        windowLevel = UIWindow.Level.alert + 1
        let vc = UIViewController()
        vc.view = appleView
        rootViewController = vc
        self.frame = frame
        
        //觸控事件
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        pan.delaysTouchesBegan = true
        addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tap)
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(longTapGesture))
        addGestureRecognizer(longGes)
    }
    
    // MARK: - 公開方法
    
    /// 顯示偵錯Window
    public func show(){
        self.isHidden = false
        
        // ios13 以上會出現一層預設影子View，需要把它clipsToBounds關閉，會放在這是因為在初始化時抓不到
        if let dropShadowView = subviews.first?.subviews.first {
            dropShadowView.clipsToBounds = false
        }
    }
    
    /// 新增提示視窗(支援多行)
    ///
    /// - Parameters:
    ///   - message: 訊息
    ///   - messageType: 訊息類別
    public func addToast(_ message: String, _ messageType: DebugMessageType = .custom(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6012741191)) ){
        
        //如果目前不偵錯該項目則跳出
        let options = DebugTypeOptions.messageTypeToOptions(messageType: messageType)
        guard debugAlertManager.debugTypeOptions.contains(options) else{
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            //取得提示視窗
            guard let toast = self.getToast(message: message, messageType: messageType) else{
                return
            }
            self.rootViewController?.view.addSubview(toast)
            self.allToast.append(toast)
            
            //上移動畫
            self.allToastMoveUp(movingY: toast.frame.height)
            
            //淡出淡入動畫
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                toast.alpha = 1.0
            }, completion: {
                _ in
                UIView.animate(withDuration: 0.3, delay: Double(self.debugAlertManager.toastShowTime), options: UIView.AnimationOptions.curveEaseOut, animations: {
                    toast.alpha = 0.0
                }, completion: {
                    [weak toast] _ in
                    guard let strongLabel = toast else { return }
                    strongLabel.removeFromSuperview()
                    self.allToast.remove(at: 0)
                })
            })
        }
    }

    // MARK: - 私有方法(手勢)
    
    /// 拖移事件
    ///
    /// - Parameter pan: 拖移手勢
    @objc private func handlePanGesture(pan: UIPanGestureRecognizer){
        let oKeyWindow = UIApplication.shared.windows.first {
            return (($0 is Self) == false)
        }
        guard let keyWindow = oKeyWindow else {
            return
        }
        
        var keyWindowTop: CGFloat = 20.0
        var keyWindowBottom: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            keyWindowTop = CGFloat(keyWindow.safeAreaInsets.top)
            keyWindowBottom = CGFloat(keyWindow.safeAreaInsets.bottom)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 4.0, options: .curveEaseIn, animations: {
            let translation = pan.translation(in: keyWindow)
            let originalCenter = self.center
            let newCenter = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
            if ( newCenter.x - self.frame.width / 2.0 ) > 0 &&
                ( newCenter.x + self.frame.width / 2.0 ) < keyWindow.frame.width &&
                ( newCenter.y - self.frame.height / 2.0 ) > keyWindowTop &&
                ( newCenter.y + self.frame.height / 2.0 ) < keyWindow.frame.height - keyWindowBottom {
                self.center = newCenter
            }
            pan.setTranslation(CGPoint.zero, in: oKeyWindow)
        }, completion: nil)
    }
    
    /// 點擊事件
    ///
    /// - Parameter tap: 點擊手勢
    @objc private func handleTapGesture(tap: UITapGestureRecognizer) {
        debugAlertManager.presentAlert()
    }
    
    /// 長壓事件
    @objc private func longTapGesture(tap: UITapGestureRecognizer) {
        isHidden = true
    }
    
    // MARK: - 私有方法(其他)
    
    /// 取得提示視窗
    ///
    /// - Parameters:
    ///   - message: 訊息
    ///   - messageType: 訊息類別
    /// - Returns: 提示視窗View
    private func getToast(message: String, messageType: DebugMessageType) -> UIPaddingLabel?{
        let oKeyWindow = UIApplication.shared.windows.first {
            return (($0 is Self) == false)
        }
        guard let keyWindow = oKeyWindow else {
            return nil
        }
        
        //建立提示視窗
        let padding: CGFloat = 10.0
        let titleWidth = UILabel.getLabelWidth(text: message, fixedHeight: self.toastHeight, font: UIFont.systemFont(ofSize: CGFloat(13))) + padding * 2.0
        let maxTitleWidth = keyWindow.frame.width - 50
        var titleLabel = UIPaddingLabel()
        
        //如果titleWidth超過最大的標題寬度，則設定成多行Label
        if titleWidth > maxTitleWidth {
            let fixedWidth = maxTitleWidth - padding * 2.0
            let titleHeight = UILabel.getLabelHeight(text: message, fixedWidth: fixedWidth, font: UIFont.systemFont(ofSize: CGFloat(13))) + padding * 2.0
            titleLabel = UIPaddingLabel(frame: CGRect(x: 0, y: 0, width: maxTitleWidth, height: titleHeight))
            titleLabel.numberOfLines = 0
        }
        else {
            titleLabel = UIPaddingLabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: self.toastHeight))
            titleLabel.textAlignment = .center
        }
        titleLabel.paddingTop = padding
        titleLabel.paddingLeft = padding
        titleLabel.paddingRight = padding
        titleLabel.paddingBottom = padding
        
        //設定風格
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        titleLabel.textColor = UIColor.white
        titleLabel.text = message
        titleLabel.backgroundColor = messageType.getToastColor()
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
        titleLabel.alpha = 0
        return titleLabel
    }
    
    /// 所有提示視窗上移一格
    private func allToastMoveUp(movingY: CGFloat){
        for oneToast in allToast{
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                oneToast.frame = CGRect(x: oneToast.frame.origin.x, y: oneToast.frame.origin.y - movingY - self.toastSpace, width: oneToast.frame.width, height: oneToast.frame.height)
            }, completion: nil)
        }
    }
}
