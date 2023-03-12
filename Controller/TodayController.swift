//
//  TodayController.swift
//  AppStore
//
//  Created by Vladimir Kravets on 23.01.2023.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    //fileprivate let cellId = "cellId"
    //fileprivate let multipleAppCellId = "multipleAppCellId"
    
    //let items = [
    //    TodayItem.init(category: "The Daily list", title: "Test-Drive These CarPlay Apps", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple),
    //
    //    TodayItem.init(category: "Life Hack", title: "Utilizing your time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize life the right way", backgroundColor: .white, cellType: .single),
    //
    //    TodayItem.init(category: "Holidats", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9664639831, green: 0.9565268159, blue: 0.7150155902, alpha: 1), cellType: .single)
    //]
    
    var items = [TodayItem]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    
    let blureVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blureVisualEffectView)
        blureVisualEffectView.fillSuperview()
        blureVisualEffectView.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9490196109, green: 0.9490197301, blue: 0.9490196109, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
    }
    
    fileprivate  func fetchData() {
        //dispatchGroup
        
        let dispatchGroup = DispatchGroup()
        
        var topFreeApps: AppGroup?
        var topSongs: AppGroup?
        
        dispatchGroup.enter()
        
        Service.shared.topFreeApps { (appGroup, error) in
            // make sure to check your errors
            
            
            if let error = error {
                print(error)
                return
            }
            topFreeApps = appGroup
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Service.shared.topSongs { (appGroup, error) in
            
            if let error = error {
                print(error)
                return
            }
            topSongs = appGroup
            dispatchGroup.leave()
        }
        
        // completion block
        dispatchGroup.notify(queue: .main) {
            // I will have acces to Apps somehow
            
            print("Finished fetching")
            self.activityIndicatorView.stopAnimating()
            
            //            topFreeApps?.feed.results
            
            self.items = [
                TodayItem.init(category: "Life Hack", title: "Utilizing your time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize life the right way", backgroundColor: .white, cellType: .single, apps: []),
                
                TodayItem.init(category: "Daily list", title: topFreeApps?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topFreeApps?.feed.results ?? []),
                
                TodayItem.init(category: "Holidats", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838810563, green: 0.9640342593, blue: 0.7226806879, alpha: 1), cellType: .single, apps: []),
                
                TodayItem.init(category: "Daily list", title: topSongs?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topSongs?.feed.results ?? []),
                
            ]
            self.collectionView.reloadData()
        }
    }
    
    var appFullscreenController: AppFullscreenController!
    
//    var topConstraint: NSLayoutConstraint?
//    var leadingConstraint: NSLayoutConstraint?
//    var widthConstraint: NSLayoutConstraint?
//    var heightConstraint: NSLayoutConstraint?
    
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        
        
        // ADD (UINavigationController) navigation controller in TodayMultipleAppsController and then changed to BackEnabledNavigationController so we make swipe!
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullscreen(indexPath: indexPath)
        }
    }
    
    fileprivate func setupSingleAppFullScreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        
        // #1 setup our pan gesture
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
        // #2 add a blue effect view
        
        // #3 not to interfere with our UITableView scrolling
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        return true
    }
    
    var appFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        
        if gesture.state == .changed {
            if translationY > 0 {
                
                let trueOffset = translationY - appFullscreenBeginOffset
                
                var scale = 1 - trueOffset / 1000
                
                scale = min(1, scale)
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
            
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
        
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        
        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        // redView.frame = startingFrame
        
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath){
        let fullscreenView = appFullscreenController.view!
        
        view.addSubview(fullscreenView)
        
        addChild(appFullscreenController)
        
        
        self.collectionView.isUserInteractionEnabled = false
        
        //        redView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    
        setupStartingCellFrame(indexPath)

        guard let startingFrame = self.startingFrame else {return}
        
        // auto layout constraint animations
        // 4 anchors
        
        //chaged anchore
        self.anchoreConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),size: .init(width: startingFrame.width, height: startingFrame.height))
        
//        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
//        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
//        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
//        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
//        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
//
//        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach ({ $0?.isActive = true})
        
        self.view.layoutIfNeeded()
    }
    
    var anchoreConstraints: AnchoredConstraints?
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.blureVisualEffectView.alpha = 1
            // redView.frame = self.view.frame
  
            // modification on anchore constrant
            self.anchoreConstraints?.top?.constant = 0
            self.anchoreConstraints?.leading?.constant = 0
            self.anchoreConstraints?.width?.constant = self.view.frame.width
            self.anchoreConstraints?.height?.constant = self.view.frame.height
            
//            self.topConstraint?.constant = 0
//            self.leadingConstraint?.constant = 0
//            self.widthConstraint?.constant = self.view.frame.width
//            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() //starts animation
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else {return}
            cell.todayCell.topConstaint.constant = 48
            cell.layoutIfNeeded()
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        //refactoring step #1
        
        setupSingleAppFullScreenController(indexPath)
        
        // #2 setup fullscreen in its starting position
        setupAppFullscreenStartingPosition(indexPath)
        
        
        //#3 begin the fullscreen animation
        beginAnimationAppFullscreen()

    }
    
    var startingFrame: CGRect?
    
    @objc func handleAppFullscreenDismissal() {

        // we are using frames for animation
        // frames are not reliable enough for animations
        
        
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            // redView.frame = self.view.frame
            
            self.blureVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            self.appFullscreenController.tableView.contentOffset = .zero
            
            // This frame code is bad
            //gesture.view?.frame = self.startingFrame ?? .zero
            
            guard let startingFrame = self.startingFrame else {return}
            
            self.anchoreConstraints?.top?.constant = startingFrame.origin.y
            self.anchoreConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoreConstraints?.width?.constant = startingFrame.width
            self.anchoreConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() //starts animation
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else {return}
            
            
//            cell.closeButton.alpha = 0
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstaint.constant = 24
            cell.layoutIfNeeded()
            
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            //animatuion is on
            self.collectionView.isUserInteractionEnabled = true
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        
        //change code for today Item
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        
        //        if let cell = cell as? TodayCell {
        //            cell.todayItem = items[indexPath.item]
        //        } else if let cell = cell as? TodayMultipleAppCell {
        //            cell.todayItem = items[indexPath.item]
        //        }
        
        return cell
    }
    // multiple app cell
    // hard coded check
    //        if indexPath.item == 0 {
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleAppCellId, for: indexPath) as! TodayMultipleAppCell
    //            cell.todayItem = items[indexPath.item]
    //            return cell
    //        }
    //
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
    ////        cell.titleLabel
    ////        cell.categoryLabel
    ////        cell.imageView
    //        cell.todayItem = items[indexPath.item]
    //        return cell
    
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        
        let collectionView = gesture.view
        
        // figure out which cell were clicking into
        
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].apps
                
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                return
            }
            
            superview = superview?.superview
        }
    }
    
    
    static let cellSize: CGFloat = 470
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
