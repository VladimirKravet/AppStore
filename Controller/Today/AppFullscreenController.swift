//
//  AppFullscreenController.swift
//  AppStore
//
//  Created by Vladimir Kravets on 24.01.2023.
//

import UIKit

class AppFullscreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dismissHandler: (() ->())?
    var todayItem: TodayItem?
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        // Animation of floatingContainerView
        // refactoring code 
        let translationY = -90 - UIApplication.shared.statusBarFrame.height
        let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations:  {
            
        
            self.floatingContainerView.transform = transform
//            if scrollView.contentOffset.y > 100 {
//
//                self.floatingContainerView.transform = .init(translationX: 0, y: translationY)
//
//            } else {
//                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations:  {
//                    self.floatingContainerView.transform = .identity
//                })
//            }
        })
        
        
    }
    
    
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        // tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        //more space between status bar and text
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        setupCloseButton()
        
        setupFloatingControls()
    }
    
    let floatingContainerView = UIView()
    
    @objc fileprivate func handleTap() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = .init(translationX: 0, y: -90)
        })
        
    }
    
    fileprivate func setupFloatingControls() {
        
        floatingContainerView.clipsToBounds = true
        //   floatingContainerView.layer.masksToBounds = true
        floatingContainerView.layer.cornerRadius = 16
        view.addSubview(floatingContainerView)
        
        //  let bottomPadding = UIApplication.shared.statusBarFrame.height
        
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: 90))
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        // add our subviews
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.constrainHeight(68)
        imageView.constrainWidth(68)
        
        let getButton = UIButton(title: "Get")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainWidth(80)
        getButton.constrainHeight(32)
        
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangeSubviews: [
                UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 16)),
                UILabel(text: "Utilizing your Item", font: .systemFont(ofSize: 14)),
            ]),
            getButton,
        ], customSpacing: 16)
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    lazy var closeButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(.remove, for: .normal)
        return button
    }()
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = AppFullscreenHeaderCell()
            //            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            print("Close")
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.todayCell.backgroundView = nil
            headerCell.clipsToBounds = true
            
            //           headerCell.todayCell.todayItem = todayItem
            return headerCell
            //            hack
            //            let cell = UITableViewCell()
            //            let todayCell = TodayCell()
            //            cell.addSubview(todayCell)
            //            todayCell.centerInSuperview(size: .init(width: 250, height: 250))
            //            return cell
        }
        
        
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return UITableView.automaticDimension
        //        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let header = TodayCell()
    //        return header
    //    }
    //
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 450
    //    }
}
