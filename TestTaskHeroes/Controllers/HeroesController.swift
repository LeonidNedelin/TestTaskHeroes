//
//  HeroesController.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/22/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import UIKit

class HeroesController: UIViewController {
    
    private var heroes = [Hero]()
    private var favoriteHeroId = ""
    private let numberOfItemsPerPage = "5"
    private let tableView = PagingTableView()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
    }()
    
    private let noHeroesLabel: UILabel = {
        let label = UILabel()
        label.text = "No Heroes..."
        label.textColor = .mainLightBlue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        setupTableView()
        setupRefreshControll()
        getHeroes()
        getFavoriteHeroId()
    }
    
    private func setupNavItems() {
        navigationItem.title = "Heroes"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pagingDelegate = self
        tableView.backgroundColor = .mainBackground
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(HeroCell.self, forCellReuseIdentifier: HeroCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    private func setupRefreshControll() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        self.tableView.refreshControl = refreshControl
        
    }
    
    @objc private func handleRefresh() {
        self.tableView.reset()
        getHeroes()
    }
    
    private func getHeroes() {
        if currentReachabilityStatus == .notReachable {
            let alert = UIAlertController(title: "Please check your internet connection", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {[unowned self] _ in
                self.tableView.refreshControl?.endRefreshing()
            }))
            alert.view.tintColor = .mainBackground
            present(alert, animated: true, completion: nil)
            return
        }
        activityIndicatorView.startAnimating()
        APIManager.shared.getHeroes(limit: numberOfItemsPerPage) {[unowned self] (heroes) in
            self.tableView.refreshControl?.endRefreshing()
            self.activityIndicatorView.stopAnimating()
            self.heroes = heroes
            self.tableView.reloadData()
        }
    }
    
    private func getHeroesWith(page: Int) {
        guard let limitItems = Int(numberOfItemsPerPage) else { return }
        let offset = String(describing: limitItems * page)
        APIManager.shared.getHeroes(offset: offset, limit: numberOfItemsPerPage) {[unowned self] (heroes)  in
            self.heroes.append(contentsOf: heroes)
            self.tableView.isLoading = false
        }
    }
    
    private func getFavoriteHeroId() {
        let favoriteHero = CoreDataManager.shared.fetchFavoriteHero()
        favoriteHeroId = favoriteHero?.id ?? ""
    }
    
    func deleteFavoriteHero() {
        CoreDataManager.shared.deleteFavoriteHero()
        favoriteHeroId = ""
        tableView.reloadData()
    }
}

extension HeroesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseIdentifier, for: indexPath) as? HeroCell else { return HeroCell() }
        cell.hero = heroes[indexPath.row]
        cell.delegate = self
        if heroes[indexPath.row].id == favoriteHeroId {
            cell.setFavorite()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
}

extension HeroesController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return activityIndicatorView.isAnimating ? activityIndicatorView : noHeroesLabel
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if heroes.isEmpty {
            return tableView.frame.height
        } else {
            return 0
        }
    }
}

extension HeroesController: PagingTableViewDelegate {
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        tableView.isLoading = true
        getHeroesWith(page: page)
    }
}

extension HeroesController: HeroCellDelegate {
    func setFavorite(hero: Hero, image: UIImage) {
        CoreDataManager.shared.deleteFavoriteHero()
        CoreDataManager.shared.saveFavorite(hero: hero, image: image)
        favoriteHeroId = hero.id
        tableView.reloadData()
    }
    
    func resignFavorite() {
        deleteFavoriteHero()
    }
}
