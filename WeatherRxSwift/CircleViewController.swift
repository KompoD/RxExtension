//
//  CircleViewController.swift
//  WeatherRxSwift
//
//  Created by Nikita Merkel on 02.10.2017.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//
import ChameleonFramework
import UIKit
import RxCocoa
import RxSwift

class CircleViewController: UIViewController {

    var circleView: UIView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = Variable(1)
        let b = Variable(2)
        
        let c = Observable.combineLatest(a.asObservable(), b.asObservable()) {$0 + $1}
            .filter { $0 >= 0 }
            .map { "\($0) is positive" }
        c.subscribe(onNext: { print($0) })
        .addDisposableTo(disposeBag)
        
        setup()
    }
    
    func setup() {
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)))
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.center = view.center
        circleView.backgroundColor = UIColor.green
        view.addSubview(circleView)
        
        let circleViewModel = CircleViewModel()
        // Связываем центральную точку CircleView с centerObservable
        circleView
            .rx.observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVar)
            .addDisposableTo(disposeBag)
        
        // Подписываемся на backgroundObservable, чтобы получать новые цвета от ViewModel.
        circleViewModel.backgroundObservable
            .subscribe(onNext: { [weak self] backgroundColor in
                UIView.animate(withDuration: 0.1) {
                    self?.circleView.backgroundColor = backgroundColor
                    // Пробуем получить дополнительный цвет для данного фонового
                    let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                    // Если он отличается от него
                    if viewBackgroundColor != backgroundColor {
                        // Назначим его фоновым для view
                        // Нам всего лишь нужен другой цвет, чтобы разглядеть окружность в представлении
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(recognizer:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    func circleMoved(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
}
