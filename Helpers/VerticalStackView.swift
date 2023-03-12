//
//  VerticalStackView.swift
//  AppStore
//
//  Created by Vladimir Kravets on 30.11.2022.
//

import UIKit

class VerticalStackView: UIStackView {

    init(arrangeSubviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        
        // add all aobjects in subview
        arrangeSubviews.forEach({addArrangedSubview($0)})
        
        self.spacing = spacing
        self.axis = .vertical
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
