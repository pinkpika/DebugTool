//
//  ViewController.swift
//  DemoDebugTool
//
//  Created by pink on 2022/11/21.
//

import UIKit
import DebugTool

class ViewController: UIViewController {

    @IBAction func clickCustomEvent(_ sender: Any) {
        SceneDelegate.debugTool?.addToast("客製化訊息: 123")
    }
    
    @IBAction func clickUserEventEvent(_ sender: Any) {
        SceneDelegate.debugTool?.addToast("使用者訊息: 點擊了A按鈕", .userEvent)
    }
    
    @IBAction func clickApiSendEvent(_ sender: Any) {
        SceneDelegate.debugTool?.addToast("Api發送事件: 發送了OOXX的請求", .apiSend)
    }
    
    @IBAction func clickApiTimeEvent(_ sender: Any) {
        SceneDelegate.debugTool?.addToast("Api花費時間: 花費了0000ms", .apiTime)
    }
}

