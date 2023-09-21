//
//  UIDevice.swift
//  Unsplash
//
//  Created by 장기화 on 9/21/23.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool { // 노치는 true, 홈버튼은 false
        let bottom = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .last { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
