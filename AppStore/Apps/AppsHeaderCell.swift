//
//  AppsHeaderCell.swift
//  AppStore
//
//  Created by Vladimir Kravets on 06.12.2022.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    var app: SocialApp! {
        didSet {
            companyLabel.text = app.name
            titleLabel.text = app.tagline
            imageView.sd_setImage(with: URL(string: app.imageUrl))
        }
    }
    
    let companyLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
    let titleLabel = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
    let imageView = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = #imageLiteral(resourceName: "holiday")
        
 //       backgroundColor = .red
        companyLabel.textColor = .blue
 //       imageView.backgroundColor = .blue
        titleLabel.numberOfLines = 2
        
        let stackView = VerticalStackView(arrangeSubviews: [
            companyLabel, titleLabel, imageView
            ], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
