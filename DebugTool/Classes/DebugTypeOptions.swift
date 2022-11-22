//
//  DebugTypeOptions.swift
//  DebugTool
//
//  Created by pink on 2022/11/21.
//

import Foundation

/// 偵錯類型的選項集合
public struct DebugTypeOptions: OptionSet {
    
    public let rawValue: Int
    public init(rawValue: Int){
        self.rawValue = rawValue
    }
    
    public static let custom = DebugTypeOptions(rawValue: 1 << 0)
    public static let userEvent = DebugTypeOptions(rawValue: 1 << 1)
    public static let apiSend = DebugTypeOptions(rawValue: 1 << 2)
    public static let apiTime = DebugTypeOptions(rawValue: 1 << 3)
    public static let all: DebugTypeOptions = [.custom, .userEvent, .apiSend, .apiTime]
    
    /// 取出每個選項是否包含在內
    public func getIsContainOptions() -> [Bool]{
        var result: [Bool] = []
        result.append(self.contains(.custom))
        result.append(self.contains(.userEvent))
        result.append(self.contains(.apiSend))
        result.append(self.contains(.apiTime))
        return result
    }
    
    /// MessageType轉換成Options
    public static func messageTypeToOptions(messageType: DebugMessageType) -> DebugTypeOptions{
        switch messageType {
        case .custom:
            return [.custom]
        case .userEvent:
            return [.userEvent]
        case .apiSend:
            return [.apiSend]
        case .apiTime:
            return [.apiTime]
        }
    }
}
