//
//  Extensions.swift
//  WeatherRxSwift
//
//  Created by Nikita Merkel on 06.10.2017.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

extension Reactive where Base: SVProgressHUD {
    /*public var isAnimating: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event){
            case .next(let value):
                if value {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            case .error(let error):
                let error = "Binding error to UI:\(error)"
                print(error)
            case .completed:
                break
            }
        }
    }*/
    
    public var isAnimating: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { indicator, active in
            if active {
                indicator
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
