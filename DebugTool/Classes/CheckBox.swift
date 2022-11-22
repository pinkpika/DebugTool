//
//  CheckBox.swift
//  DebugTool
//
//  Created by pink on 2022/11/21.
//

import UIKit

/// CheckBox
open class CheckBox: UIControl {
    
    /// 選取樣式
    public enum MarkStyle {
        /// ■
        case square
        /// ●
        case circle
        /// ✓
        case tick
    }
    
    /// 外框樣式
    public enum BorderStyle {
        /// ▢
        case square
        /// ■
        case roundedSquare(radius: CGFloat)
        /// ◯
        case rounded
    }
    
    /// 是否被勾選
    public var isChecked: Bool = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    /// 選取樣式
    public var markStyle: MarkStyle = .square
    
    /// 外框樣式
    public var borderStyle: BorderStyle = .roundedSquare(radius: 3)
    
    /// 外框寬度
    public var borderWidth: CGFloat = 1.75
    
    /// 未被選取的外框顏色
    public var uncheckedBorderColor: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    
    /// 被選取的外框顏色
    public var checkedBorderColor: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    
    /// 被選取的標記顏色
    public var checkMarkColor: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    
    /// 擴增的點擊範圍
    public var increasedTouchInset: CGFloat = 5
    
    private var useHapticFeedback: Bool = true
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
    }
    
    /// 開始點擊
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        self.feedbackGenerator?.prepare()
    }
    
    /// 結束點擊
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isChecked = !isChecked
        self.sendActions(for: .valueChanged)
        if useHapticFeedback {
            self.feedbackGenerator?.impactOccurred()
            self.feedbackGenerator = nil
        }
    }
    
    open override func draw(_ rect: CGRect) {
        
        //畫出外框樣式
        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        context.setStrokeColor(self.isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
        context.setLineWidth(borderWidth)
        var shapePath: UIBezierPath!
        switch self.borderStyle {
        case .square:
            shapePath = UIBezierPath(rect: newRect)
        case .roundedSquare(let radius):
            shapePath = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        case .rounded:
            shapePath = UIBezierPath.init(ovalIn: newRect)
        }
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        
        //畫出選取樣式
        if isChecked {
            switch self.markStyle {
            case .square:
                self.drawInnerSquare(frame: newRect)
            case .circle:
                self.drawCircle(frame: newRect)
            case .tick:
                self.drawCheckMark(frame: newRect)
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setNeedsDisplay()
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchInset, left: -increasedTouchInset, bottom: -increasedTouchInset, right: -increasedTouchInset)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}

// MARK: - CheckBox(繪圖相關)
extension CheckBox{
    
    /// 選取畫勾勾
    func drawCheckMark(frame: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        checkMarkColor.setFill()
        bezierPath.fill()
    }
    
    /// 選取畫圈圈
    func drawCircle(frame: CGRect) {
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5), y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5), width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5), height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)))
        checkMarkColor.setFill()
        ovalPath.fill()
    }
    
    /// 選取畫方塊
    func drawInnerSquare(frame: CGRect) {
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        let padding = self.bounds.width * 0.3
        let innerRect = frame.inset(by: .init(top: padding, left: padding, bottom: padding, right: padding))
        let rectanglePath = UIBezierPath.init(roundedRect: innerRect, cornerRadius: 0)
        checkMarkColor.setFill()
        rectanglePath.fill()
    }
}

