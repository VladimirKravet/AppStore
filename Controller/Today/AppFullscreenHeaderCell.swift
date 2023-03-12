//
//  AppFullscreenHeaderCell.swift
//  AppStore
//
//  Created by Vladimir Kravets on 24.01.2023.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
//   lazy var closeButton: UIButton = {
//        
//        let button = UIButton(type: .system)
//        button.setImage(.remove, for: .normal)
//        return button
//        }()
                         
            
                         
           override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
               
            // use to active button !
            contentView.isUserInteractionEnabled = true
            
            addSubview(todayCell)
            todayCell.fillSuperview()
            
//            addSubview(closeButton)
//            closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 44, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 80))
            
            
            
        }
                         
                         required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
                         }
