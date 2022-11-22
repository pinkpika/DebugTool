//
//  DebugAlertManager.swift
//  DebugTool
//
//  Created by pink on 2022/11/21.
//

import UIKit

/// 偵錯彈窗管理者
class DebugAlertManager {
    
    /// 偵錯類型的選項集合(預設開啟.custom, .userEvent, .apiSend)
    var debugTypeOptions: DebugTypeOptions = [.custom, .userEvent, .apiSend] {
        didSet {
            UserDefaults.standard.set("\(debugTypeOptions.rawValue)", forKey: optionsKeys)
        }
    }
    
    /// 提示視窗顯示時間(秒)
    var toastShowTime = 5
    
    /// 提示視窗顯示時間 的 文字
    var toastShowTimeLabel = UILabel()
    
    private var optionsKeys = "DebugAlertManager_optionsKeys"
    
    init() {
        if let str = UserDefaults.standard.string(forKey: optionsKeys),
           let ops = Int(str) {
            debugTypeOptions = DebugTypeOptions(rawValue: ops)
        }
    }
    
    /// 顯示彈窗
    func presentAlert() {
        
        //建立內容View
        let contentView = UIView()
        
        //設定1：設定"偵錯類型"
        let debugTypeLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: 250, height: 30))
        debugTypeLabel.text = "1. 偵錯類型："
        debugTypeLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        contentView.addSubview(debugTypeLabel)
        let allName = DebugMessageType.allCases.map{ $0.getTypeName() }
        let allIsChecked = debugTypeOptions.getIsContainOptions()
        let allSelector = [#selector(handleCheckboxForCustom),
                           #selector(handleCheckboxForUserEvent),
                           #selector(handleCheckboxForApiSend),
                           #selector(handleCheckboxForApiTime)]
        for (index, oneSelector) in allSelector.enumerated(){
            let checkbox = CheckBox(frame: CGRect(x: 10, y: 30 + index*30, width: 20, height: 20))
            checkbox.isChecked = allIsChecked.indices.contains(index) ? allIsChecked[index] : false
            checkbox.addTarget(self, action: oneSelector, for: .valueChanged)
            contentView.addSubview(checkbox)
            guard allName.indices.contains(index) else { continue }
            let label = UILabel.init(frame: CGRect(x: 10 + 25, y: 30 + index*30, width: 90, height: 20))
            label.text = allName[index]
            label.font = UIFont.systemFont(ofSize: CGFloat(14))
            contentView.addSubview(label)
        }
        
        let debugTypeHeight: Double = Double(30 + 30 * allName.count)
        
        //設定2：設定"提示視窗顯示時間"
        self.toastShowTimeLabel = UILabel.init(frame: CGRect(x: 10, y: debugTypeHeight, width: 250, height: 30))
        self.toastShowTimeLabel.text = "2. 提示視窗顯示時間：\(toastShowTime) 秒"
        self.toastShowTimeLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        contentView.addSubview(self.toastShowTimeLabel)
        let toastShowTimeSlider = UISlider(frame: CGRect(x: 10, y: debugTypeHeight + 20, width: 300, height: 60))
        toastShowTimeSlider.minimumValue = 1
        toastShowTimeSlider.maximumValue = 60
        toastShowTimeSlider.value = Float(toastShowTime)
        toastShowTimeSlider.isContinuous = false
        toastShowTimeSlider.tintColor = UIColor.red
        toastShowTimeSlider.addTarget(self, action: #selector(handleToastShowTimeSlider), for: UIControl.Event.allEvents)
        contentView.addSubview(toastShowTimeSlider)
        
        let showTimeHeight: Double = Double(30 + 60)
        
        //建立彈窗
        let alertController = UIAlertController(title: "[詳細設定]", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        contentView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        contentView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: debugTypeHeight + showTimeHeight).isActive = true
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: debugTypeHeight + showTimeHeight + 100).isActive = true
        
        let confirmAction = UIAlertAction(title: "確認", style: .destructive, handler: nil)
        alertController.addAction(confirmAction)
        
        let oKeyWindow = UIApplication.shared.windows.first {
            return (($0 is DebugTool) == false)
        }
        oKeyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    /// CheckBox事件(ForCustom)
    @objc private func handleCheckboxForCustom(_ sender: CheckBox) {
        debugTypeOptions = debugTypeOptions.symmetricDifference([.custom])
    }
    
    /// CheckBox事件(ForUserEvent)
    @objc private func handleCheckboxForUserEvent(_ sender: CheckBox) {
        debugTypeOptions = debugTypeOptions.symmetricDifference([.userEvent])
    }
    
    /// CheckBox事件(ForApiSend)
    @objc private func handleCheckboxForApiSend(_ sender: CheckBox) {
        debugTypeOptions = debugTypeOptions.symmetricDifference([.apiSend])
    }
    
    /// CheckBox事件(ForApiTime)
    @objc private func handleCheckboxForApiTime(_ sender: CheckBox) {
        debugTypeOptions = debugTypeOptions.symmetricDifference([.apiTime])
    }
    
    /// 滑桿事件(提示視窗顯示時間)
    ///
    /// - Parameter sender: UISlider
    @objc private func handleToastShowTimeSlider(sender: UISlider) {
        let newTime = Int(sender.value)
        self.toastShowTimeLabel.text = "2. 提示視窗顯示時間：\(newTime) 秒"
        self.toastShowTime = newTime
    }
}
