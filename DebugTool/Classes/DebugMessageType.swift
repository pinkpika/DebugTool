//
//  DebugMessageType.swift
//  DebugTool
//
//  Created by pink on 2022/11/21.
//

import UIKit

/// 偵錯訊息類型
public enum DebugMessageType: CaseIterable{
    
    public static var allCases: [DebugMessageType] = [.custom(UIColor.clear), .userEvent, .apiSend, .apiTime]
    
    case custom(_ toastColor: UIColor)
    case userEvent
    case apiSend
    case apiTime
    
    /// 取得提示視窗顏色
    public func getToastColor() -> UIColor{
        switch self {
            case .custom(let toastColor):
                return toastColor
            case .userEvent:
                return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.8048552531)
            case .apiSend:
                return #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0.7957127109)
            case .apiTime:
                return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0.8044358704)
        }
    }
    
    /// 取得類型名稱
    public func getTypeName() -> String{
        switch self {
            case .custom(_):
                return "客製化訊息"
            case .userEvent:
                return "使用者事件"
            case .apiSend:
                return "Api發送事件"
            case .apiTime:
                return "Api花費時間"
        }
    }
}
