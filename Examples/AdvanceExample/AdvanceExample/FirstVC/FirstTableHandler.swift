//
//  FirstTableHandler.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import DrawerViewController
import UIKit

protocol FirstTableHandlerDelegate: class {
    func firstTableHandler(_ firstTableHandler: FirstTableHandler, didSelectCity city: City)
}

final class FirstTableHandler: DrawerScrollContentHandler {
    
    unowned let viewModel: FirstViewModel
    
    weak var delegate: FirstTableHandlerDelegate?
    
    init(viewModel: FirstViewModel,
         targetScrollView: UIScrollView? = nil,
         drawer: DrawerViewController? = nil) {
        self.viewModel = viewModel
        super.init(targetScrollView: targetScrollView, drawer: drawer)
    }
}

extension FirstTableHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as! FirstTableViewCell
        cell.selectionStyle = .none
        
        cell.cityLabel.text = viewModel.cities[indexPath.row].title
        cell.descriptionLabel.text = viewModel.cities[indexPath.row].description
        
        return cell
    }
}

extension FirstTableHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FirstViewController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = viewModel.city(at: indexPath.row) else {
            return
        }
        
        delegate?.firstTableHandler(self, didSelectCity: city)
    }
}
