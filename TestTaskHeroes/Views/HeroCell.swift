//
//  HeroCell.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/22/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import UIKit
import SDWebImage

protocol HeroCellDelegate {
    func setFavorite(hero: Hero, image: UIImage)
    func resignFavorite()
}

class HeroCell: UITableViewCell {
    
    var delegate: HeroCellDelegate?
    
    static let reuseIdentifier = String(describing: HeroCell.self)
    
    var hero: Hero? {
        didSet{
            guard let hero = hero else { return }
            nameLabel.text = hero.name
            descriptionLabel.text = hero.description
            let imageUrl = URL(string: hero.imageUrl)
            heroImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "marvel"))
            likeButton.isSelected = false
        }
    }
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .mainLightBlue
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_fav_null").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_fav_act").withRenderingMode(.alwaysOriginal), for: .selected)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 3
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .mainBackground
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        
        addSubview(heroImageView)
        heroImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 0), size: CGSize(width: 70, height: 70))
        
        addSubview(likeButton)
        likeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 6), size: CGSize(width: 30, height: 30))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: heroImageView.topAnchor, leading: heroImageView.trailingAnchor, bottom: nil, trailing: likeButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 6), size: CGSize(width: 0, height: 24))
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nameLabel.bottomAnchor, leading: heroImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 2, left: 12, bottom: 2, right: 6))
        
        
        addSubview(dividerView)
        dividerView.anchor(top: nil, leading: heroImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
    }
    
    func setFavorite() {
        likeButton.isSelected = true
    }
    
    @objc private func didTapLikeButton() {
        likeButton.isSelected = !likeButton.isSelected
        guard let hero = hero else { return }
        if likeButton.isSelected {
            delegate?.setFavorite(hero: hero, image: heroImageView.image ?? #imageLiteral(resourceName: "marvel"))
        } else {
            delegate?.resignFavorite()
        }
    }
}
