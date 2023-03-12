//
//  TodayMultipleAppCell.swift
//  AppStore
//
//  Created by Vladimir Kravets on 26.01.2023.
//

import UIKit


class TodayMultipleAppCell: BaseTodayCell {
    
    let categoryLabel = UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your time", font: .boldSystemFont(ofSize: 26), numberOfLines: 0)

    let multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            
            // add all actual icons in cell
            multipleAppsController.apps = todayItem.apps
            multipleAppsController.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
//        multipleAppsController.view.backgroundColor = .red
        
        
        let stackView = VerticalStackView(arrangeSubviews: [
            categoryLabel, titleLabel, multipleAppsController.view
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
