//
//  MovableBottomButton.swift
//  Unsplash
//
//  Created by 장기화 on 9/21/23.
//

import UIKit
import RxSwift
import RxKeyboard

class MovableBottomButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? UIColor.systemTeal : UIColor.systemGray3
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.set()
    }
    
    private func set() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func setBottomButtonMove(title: String, initialEnable: Bool, view: UIView, bag: DisposeBag) -> MovableBottomButton {
    let button = MovableBottomButton()
    button.setTitle(title, for: .normal)
    button.isEnabled = initialEnable
    
    let notchHeight = 100
    let homeHeight = 60
    
    view.addSubview(button)
    button.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        if UIDevice.current.hasNotch {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(-40)
            $0.height.equalTo(notchHeight)
        } else {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(homeHeight)
        }
        button.contentVerticalAlignment = .top
        button.contentEdgeInsets.top = 22
    }
    
    RxKeyboard.instance.visibleHeight
        .drive(onNext: { keyboardVisibleHeight in
            button.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                
                switch keyboardVisibleHeight {
                case 0:
                    if UIDevice.current.hasNotch {
                        $0.height.equalTo(notchHeight)
                        $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(-40)
                    } else {
                        $0.bottom.equalTo(view).inset(keyboardVisibleHeight - view.safeAreaInsets.bottom)
                        $0.height.equalTo(homeHeight)
                    }
                    
                default:
                    if UIDevice.current.hasNotch {
                        $0.height.equalTo(notchHeight)
                        $0.bottom.equalTo(view).inset(keyboardVisibleHeight - view.safeAreaInsets.bottom)
                    } else {
                        $0.bottom.equalTo(view).inset(keyboardVisibleHeight - view.safeAreaInsets.bottom)
                        $0.height.equalTo(homeHeight)
                    }
                }
            }
            view.layoutIfNeeded()
        }).disposed(by: bag)
    return button
}
