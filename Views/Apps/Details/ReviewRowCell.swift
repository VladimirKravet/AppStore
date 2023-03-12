//
//  ReviewRowCell.swift
//  AppStore
//
//  Created by Vladimir Kravets on 04.01.2023.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    let reviewLabel = UILabel(text: "Review & Rating", font: .boldSystemFont(ofSize: 24))
    let reviewController = ReviewsController()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(reviewLabel)
        addSubview(reviewController.view)
        reviewLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        reviewController.view.anchor(top: reviewLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
