//
//  ViewController.swift
//  WeatherRxSwift
//
//  Created by Nikita Merkel on 22.09.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    let cities = ["New York", "Amsterdam", "Moscow", "Berlin", "Praga", "Polska"]
    var shownCities: [String] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.refreshControl = refreshControl
        tableView.backgroundView = refreshControl
        setupSearchBar()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("lol")
        refreshControl.endRefreshing()
    }
    
    func setupSearchBar() {
        
        let progress = SVProgressHUD()
        
        let indicator = ActivityIndicator()
        indicator.asObservable()
            .bind(to: progress.rx.isAnimating)
            .addDisposableTo(disposeBag)
        
        /*var allCites: Variable<[CiteModel?]> = Variable([])
        var searchQuery: Variable<String> = Variable("")
        var shownCites: Observable<[CiteModel?]> = Observable .combineLatest(allCites.asObservable(), searchQuery.asObservable()) {
            allCites, query in
            return allCites.map { cites in cites.filter { $0.cite.containsString(query) } }
        }*/
        
        searchBar
            .rx.text
            .orEmpty
            .filter { $0.characters.count > 0 }
            .flatMap { query -> Observable<[String]> in
                return Observable.just(self.cities.filter { $0.hasPrefix(query) })
                    .trackActivity(indicator)
            }
            .subscribe(onNext: { [unowned self] filteredCities in
                self.shownCities = filteredCities
                //self.shownCities = self.cities.filter { $0.hasPrefix(query) }
                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("Clicked")
    }
}
