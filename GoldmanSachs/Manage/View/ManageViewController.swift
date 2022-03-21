//
//  ManageViewController.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 20/03/22.
//

import UIKit

class ManageViewController: UIViewController {

    var dataArray = [APOD]()
    @IBOutlet weak var manageTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        addTapped()
    }
    
    func layoutView(){
        self.title = "Favourite List"
    }
    
    func configureTable(){
        DispatchQueue.main.async {
            self.manageTable.register(UINib(nibName: CellConstant.homeCell, bundle: nil), forCellReuseIdentifier:CellConstant.homeCell)
            self.manageTable.separatorColor = UIColor.clear
            self.manageTable.delegate = self
            self.manageTable.dataSource = self
            self.manageTable.backgroundColor = .clear
            self.manageTable.reloadData()
        }
    }
    
    func addTapped(){
        DatabaseHelper.shared.fetchFavourites(entity: "Favourite") { status, error, message, data in
            if status{
                if let data = data{
                    self.dataArray = data
                    self.configureTable()
                }
            }
            else {
            }
        }
    }
}

extension ManageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstant.homeCell, for: indexPath) as! HomeTableViewCell
        cell.favourite = dataArray[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension ManageViewController: favouriteProtocol {
    func didPressButtonFor(_ user: APOD) {
        // Delete entry from CoreData.
        DatabaseHelper.shared.UserExist(title: user.title, dataDict: [:]) { result, status in
            print(status)
        }
        dataArray.removeAll{$0.title == user.title}
        self.manageTable.reloadData()
    }
}
