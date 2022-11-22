//
//  UILabel+getLabelWidthHeight.swift
//  DebugTool
//
//  Created by pink on 2022/11/21.
//

import UIKit

public extension UILabel {
    
    /// 取得文字寬度
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - fixedHeight: 固定高度
    ///   - font: 字型大小
    /// - Returns: 文字寬度
    static func getLabelWidth(text: String, fixedHeight: CGFloat, font: UIFont) -> CGFloat {
        let boundingRect = (text as NSString).boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: fixedHeight),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [NSAttributedString.Key.font: font],
                                                           context: nil)
        return boundingRect.size.width
    }
    
    /// 取得文字高度
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - fixedWidth: 固定寬度
    ///   - font: 字型大小
    /// - Returns: 文字高度
    static func getLabelHeight(text: String, fixedWidth: CGFloat, font: UIFont) -> CGFloat {
        let boundingRect = (text as NSString).boundingRect(with: CGSize(width: fixedWidth, height: .greatestFiniteMagnitude),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [NSAttributedString.Key.font: font],
                                                           context: nil)
        return boundingRect.size.height
    }
    
}
