//
//  SwitchBarVM.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2021/12/1.
//

import SwiftUI
class SwitchBarVM : ObservableObject, Identifiable {
    @Published var switchType:SwitchType
    @Published var isHidden  = false
    @Published var isOn:Bool = false
    @Published var processing = false
    
    private let switchOperator:SwitchProvider
    
    init(switchType:SwitchType) {
        self.switchType = switchType
        self.switchOperator = switchType.switchOperator()
    }
    
    func refreshStatus() {
        isOn = self.switchOperator.currentStatus()
        isHidden = !self.switchOperator.isVisable()
    }
    
    func doSwitch(isOn:Bool) {
        processing = true
        Task {
            let success = await switchOperator.operationSwitch(isOn: isOn)
            DispatchQueue.main.async { [self] in
                if success {
                    self.isOn = isOn
                }
                self.processing = false
            }
        }
    }
}