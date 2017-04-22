//
//  ViewController.swift
//  ScrollingChildController
//
//  Created by Riko Schmidt on 22/04/17.
//
//

import UIKit

class ProfileCell: UITableViewCell {
    
}

class ProfileController: UIViewController {
    let tableView = UITableView()
    let profileHeaderView = UIView()
    let stickySegmentHeader = UIView()
    let segmentControl = UISegmentedControl()
    let containerCell = UITableViewCell(style: .default, reuseIdentifier: "ContainerCell")
    var feedController: FeedController?
    var historyController: HistoryController?
    
    struct Constants {
        static let StickyHeaderViewHeight: CGFloat = 60
        static let ProfileHeaderViewHeight: CGFloat = 200
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        title = "Profile"
        
        setupViews()
        addConstraints()
        addFeedControllerAsChild()
    }
    
    private func setupViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.yellow
        view.addSubview(tableView)
        
        profileHeaderView.backgroundColor = UIColor.green
        profileHeaderView.frame.size.height = Constants.ProfileHeaderViewHeight
        tableView.tableHeaderView = profileHeaderView
        
        stickySegmentHeader.backgroundColor = UIColor.blue
        segmentControl.backgroundColor = UIColor.white
        segmentControl.insertSegment(withTitle: "Feed", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "History", at: 1, animated: false)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlDidChangeValue), for: .valueChanged)
        stickySegmentHeader.addSubview(segmentControl)
        
        containerCell.contentView.backgroundColor = UIColor.purple
        containerCell.selectionStyle = .none
        
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 260, left: 0, bottom: 0, right: 0)
    }
    
    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
        
        guard let feedController = feedController else { return }
        feedController.view.removeFromSuperview()
        feedController.removeFromParentViewController()
        
        addChildViewController(feedController)
        containerCell.contentView.addSubview(feedController.view)
        
        feedController.view.frame = containerCell.bounds
        feedController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        feedController.didMove(toParentViewController: self)
    }
    
    private func addHistoryControllerAsChild() {
        if historyController == nil {
            historyController = HistoryController()
        }
        
        guard let historyController = historyController else { return }
        historyController.view.removeFromSuperview()
        historyController.removeFromParentViewController()
        
        addChildViewController(historyController)
        containerCell.contentView.addSubview(historyController.view)
        
        historyController.view.frame = containerCell.bounds
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

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return containerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight = view.frame.size.height
        
        if let navigationBarHeight = navigationController?.navigationBar.frame.size.height {
            cellHeight -= navigationBarHeight
        }
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return stickySegmentHeader
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return Constants.StickyHeaderViewHeight
        default:
            return 0
        }
    }
}
