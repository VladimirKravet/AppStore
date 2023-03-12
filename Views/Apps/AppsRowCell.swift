//
//  AppsRowCell.swift
//  AppStore
//
//  Created by Vladimir Kravets on 04.12.2022.
//

import UIKit



class AppsRowCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            companyLabel.text = app.name
            nameLabel.text = app.name
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }
    
    let imageView = UIImageView(cornerRadius: 8)
    
    let nameLabel = UILabel(text: "App name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "Company name", font: .systemFont(ofSize: 13))
    
    let getButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .red
        
        imageView.backgroundColor = .purple
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.constrainHeight(64)
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(80)
        getButton.constrainHeight(32)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 32/2
        //let vericalSubView = UIStackView(arrangedSubviews: [nameLabel, getButton])
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangeSubviews: [nameLabel, companyLabel], spacing: 4), getButton])
    addSubview(stackView)
        stackView.spacing = 16
        
        stackView.alignment = .center
        
        stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
