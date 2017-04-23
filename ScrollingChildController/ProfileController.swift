//
//  ViewController.swift
//  ScrollingChildController
//
//  Created by Riko Schmidt on 22/04/17.
//
//

import UIKit

class ProfileController: UIViewController {
    let containerView = UIView()
    let profileHeaderView = UIView()
    let profileHeaderViewTitle = UILabel()
    let stickySegmentHeader = UIView()
    let segmentControl = UISegmentedControl()
    var feedController: FeedController?
    var historyController: HistoryController?
    
    
    struct Constants {
        static let StickyHeaderViewHeight: CGFloat = 60
        static let ProfileHeaderViewHeight: CGFloat = 200
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        title = "Profile"
        automaticallyAdjustsScrollViewInsets = false
        
        setupViews()
        addConstraints()
        addFeedControllerAsChild()
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        view.addSubview(profileHeaderView)
        view.addSubview(stickySegmentHeader)
        
        profileHeaderView.backgroundColor = UIColor.green
        profileHeaderView.isUserInteractionEnabled = true
        let viewWidth = view.frame.size.width
        profileHeaderView.frame = CGRect(x: 0, y: 64, width: viewWidth, height: Constants.ProfileHeaderViewHeight)
        profileHeaderViewTitle.text = "Header"
        profileHeaderView.addSubview(profileHeaderViewTitle)

        stickySegmentHeader.backgroundColor = UIColor.blue
        stickySegmentHeader.isUserInteractionEnabled = true
        stickySegmentHeader.frame = CGRect(x: 0, y: 64 + Constants.ProfileHeaderViewHeight, width: viewWidth, height: Constants.StickyHeaderViewHeight)
        
        segmentControl.backgroundColor = UIColor.white
        segmentControl.insertSegment(withTitle: "Feed", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "History", at: 1, animated: false)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlDidChangeValue), for: .valueChanged)
        stickySegmentHeader.addSubview(segmentControl)
    }
    
    private func addConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        profileHeaderViewTitle.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderViewTitle.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor).isActive = true
        profileHeaderViewTitle.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor).isActive = true

        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: stickySegmentHeader.topAnchor, constant: 10).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: stickySegmentHeader.bottomAnchor, constant: -10).isActive = true
        segmentControl.leftAnchor.constraint(equalTo: stickySegmentHeader.leftAnchor, constant: 10).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: stickySegmentHeader.rightAnchor, constant: -10).isActive = true
    }
    
    private func addFeedControllerAsChild() {
        if feedController == nil {
            feedController = FeedController()
        }

        if let historyController = historyController {
            historyController.view.removeFromSuperview()
            historyController.removeFromParentViewController()
        }

        guard let feedController = feedController else { return }
        
        feedController.tableView.contentInset.top = 64 + Constants.ProfileHeaderViewHeight + Constants.StickyHeaderViewHeight
        feedController.tableView.contentOffset.y = -64 - Constants.ProfileHeaderViewHeight - Constants.StickyHeaderViewHeight
        feedController.tableView.showsVerticalScrollIndicator = false
        
        feedController.didScroll = { scrollView in
            let contentOffsetY = scrollView.contentOffset.y
            let contentInsetTop = scrollView.contentInset.top
            let realContentOffset = contentOffsetY + contentInsetTop
            
            self.profileHeaderView.frame.origin.y = -realContentOffset + 64
            
            let newStickHeaderPositionY = -realContentOffset + 64 + Constants.ProfileHeaderViewHeight
            
            if newStickHeaderPositionY > 64 {
                self.stickySegmentHeader.frame.origin.y = newStickHeaderPositionY
            }else {
                self.stickySegmentHeader.frame.origin.y = 64
            }
//
//            
//            print("Content Offset :\(contentOffsetY) Content Inset: \(contentInsetTop) Real Content Offset Y \(realContentOffset)")
        }
        addChildViewController(feedController)
        containerView.addSubview(feedController.view)
        
        feedController.view.frame = containerView.bounds
        feedController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        feedController.didMove(toParentViewController: self)
    }
    
    private func addHistoryControllerAsChild() {
        if historyController == nil {
            historyController = HistoryController()
        }

        if let feedController = feedController {
            feedController.view.removeFromSuperview()
            feedController.removeFromParentViewController()
        }

        guard let historyController = historyController else { return }
        historyController.tableView.contentInset.top = 64 + Constants.ProfileHeaderViewHeight + Constants.StickyHeaderViewHeight
        historyController.tableView.contentOffset.y = -64 - Constants.ProfileHeaderViewHeight - Constants.StickyHeaderViewHeight
        historyController.tableView.showsVerticalScrollIndicator = false

        historyController.didScroll = { scrollView in
            let contentOffsetY = scrollView.contentOffset.y
            let contentInsetTop = scrollView.contentInset.top
            let realContentOffset = contentOffsetY + contentInsetTop
            
            self.profileHeaderView.frame.origin.y = -realContentOffset + 64
            
            let newStickHeaderPositionY = -realContentOffset + 64 + Constants.ProfileHeaderViewHeight
            
            if newStickHeaderPositionY > 64 {
                self.stickySegmentHeader.frame.origin.y = newStickHeaderPositionY
            }else {
                self.stickySegmentHeader.frame.origin.y = 64
            }
        }
        
        addChildViewController(historyController)
        containerView.addSubview(historyController.view)
        
        historyController.view.frame = containerView.bounds
        historyController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        historyController.didMove(toParentViewController: self)
    }
    
    func segmentControlDidChangeValue(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            addFeedControllerAsChild()
        case 1:
            addHistoryControllerAsChild()
        default:
            print("Out of range")
        }
    }
}
