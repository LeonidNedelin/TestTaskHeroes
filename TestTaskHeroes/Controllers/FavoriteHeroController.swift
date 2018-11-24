//
//  FavoriteHeroController.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/22/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import UIKit

class FavoriteHeroController: UIViewController {
    
    private var favoriteHero: FavoriteHero? {
        didSet{
            favoriteHero != nil ? setupFavoriteHero() : setupNoFavoriteHero()
        }
    }
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "marvel")
        return imageView
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return view
    }()
    
    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    
    private let heroDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .mainBackground
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteHero()
    }
    
    private func setupNavItems() {
        navigationItem.title = "Favorite Hero"
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_fav_null"), style: .plain, target: self, action: #selector(resignFavoriteHero))
    }
    
    @objc private func resignFavoriteHero() {
        let alert = UIAlertController(title: "", message: "Delete favorite hero?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {[unowned self] _ in
            self.favoriteHero = nil
            let navController = self.tabBarController?.viewControllers?[0] as? UINavigationController
            let heroesController = navController?.viewControllers[0] as? HeroesController
            heroesController?.deleteFavoriteHero()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.view.tintColor = .mainBackground
        present(alert, animated: true, completion: nil)
    }
    
    private func setupFavoriteHero() {
        heroNameLabel.text = favoriteHero?.heroName
        heroDescriptionLabel.text = favoriteHero?.heroDescription
        navigationItem.rightBarButtonItem?.isEnabled = true
        guard let data = favoriteHero?.imageData else { return }
        let image = UIImage(data: data)
        heroImageView.image = image
        dividerView.isHidden = false
    }
    
    private func setupNoFavoriteHero() {
        heroNameLabel.text = favoriteHero?.heroName
        heroDescriptionLabel.text = favoriteHero?.heroDescription
        navigationItem.rightBarButtonItem?.isEnabled = false
        heroImageView.image = #imageLiteral(resourceName: "marvel")
        heroNameLabel.text = "You don't have a favorite hero..."
        dividerView.isHidden = true
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(heroImageView)
        heroImageView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, size: CGSize(width: view.frame.width, height: view.frame.width))
        
        scrollView.addSubview(dividerView)
        dividerView.anchor(top: heroImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, size: CGSize(width: 0, height: 1))
        
        scrollView.addSubview(heroNameLabel)
        heroNameLabel.anchor(top: heroImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12))
        
        scrollView.addSubview(heroDescriptionLabel)
        heroDescriptionLabel.anchor(top: heroNameLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
    }
    
    private func getFavoriteHero() {
        favoriteHero = CoreDataManager.shared.fetchFavoriteHero()
    }
}
