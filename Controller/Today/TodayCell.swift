//
//  TodayCell.swift
//  AppStore
//
//  Created by Vladimir Kravets on 23.01.2023.
//

import UIKit

class TodayCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
          
        }
    }
    
    let categoryLabel = UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your time", font: .boldSystemFont(ofSize: 26))
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))
    
    let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize life the right way", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    
    var topConstaint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
//        clipsToBounds = true
        layer.cornerRadius = 16
        
        //        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        //        imageView.centerInSuperview(size: .init(width: 200, height: 200))
        imageView.clipsToBounds = true
        
        // Add imageView inside UIView to make descriptionLabel visible
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 240, height: 240))
        
        let stackView = VerticalStackView(arrangeSubviews: [
            categoryLabel, titleLabel, imageContainerView, descriptionLabel
        ], spacing: 8)
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24) )
        //     stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        self.topConstaint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        topConstaint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
