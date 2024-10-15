//
//  ToastConfig.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 14/10/24.
//

import UIKit

struct ToastMessageConfig {
    // MARK: - Properties
    public static var shared = ToastMessageConfig()
    public var messageColor = UIColor.white
    public var messageFont = UIFont.systemFont(ofSize: 14)
    public var sizeBox: CGFloat = 40
    public var backgrounColors: [ToastMessage.TypeToast: UIColor] = [:]
    
    // MARK: - Init
    init() {
        for type in ToastMessage.TypeToast.allCases {
            switch type {
            case .info:
                backgrounColors[type] = .yellow
            case .error:
                backgrounColors[type] = .red
            case .success:
                backgrounColors[type] = .darkGray
            }
        }
    }
}
