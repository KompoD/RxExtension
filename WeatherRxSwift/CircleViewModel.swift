//
//  CircleViewModel.swift
//  WeatherRxSwift
//
//  Created by Nikita Merkel on 02.10.2017.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

import ChameleonFramework
import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {
    var centerVar = Variable<CGPoint?>(.zero)
    var backgroundObservable: Observable<UIColor>!
    
    init() {
        setup()
    }
    
    func setup() {
        backgroundObservable = centerVar.asObservable()
            .map { center in
                guard let center = center else { return UIColor.flatten(.black)()}
                
                let green: CGFloat = CGFloat(arc4random_uniform(255))
                let blue: CGFloat = CGFloat(arc4random_uniform(255))
                let red: CGFloat = CGFloat(arc4random_uniform(255))
                
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
                
        }
    }
}
