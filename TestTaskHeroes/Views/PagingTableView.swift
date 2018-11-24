//
//  PagingTableView.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/23/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import UIKit

@objc protocol PagingTableViewDelegate {
    func paginate(_ tableView: PagingTableView, to page: Int)
}

class PagingTableView: UITableView {
    
    private var loadingView: UIView!
    private var indicator: UIActivityIndicatorView!
    var page: Int = 0
    var previousItemCount: Int = 0
    
    var currentPage: Int {
        get {
            return page
        }
    }
    
    weak var pagingDelegate: PagingTableViewDelegate? {
        didSet {
            pagingDelegate?.paginate(self, to: page)
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? showLoading() : hideLoading()
        }
    }
    
    func reset() {
        page = 0
        previousItemCount = 0
    }
    
    private func paginate(_ tableView: PagingTableView, forIndexAt indexPath: IndexPath) {
        let itemCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) ?? 0
        guard indexPath.row == itemCount - 1 else { return }
        guard previousItemCount != itemCount else { return }
        page += 1
        previousItemCount = itemCount
        pagingDelegate?.paginate(self, to: page)
    }
    
    private func showLoading() {
        if loadingView == nil {
            createLoadingView()
        }
        tableFooterView = loadingView
    }
    
    private func hideLoading() {
        reloadData()
        tableFooterView = nil
    }
    
    private func createLoadingView() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 90))
        setupIndicator()
        tableFooterView = loadingView
    }
    
    private func setupIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor.lightGray
        indicator.startAnimating()
        loadingView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
    }
    
    override open func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        paginate(self, forIndexAt: indexPath)
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}

