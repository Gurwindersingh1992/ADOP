//
//  ViewController.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: View All Properties.
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTbl: UITableView!
    var modelArray : [APOD]?
    var searching = false
    var searchApodArray : [APOD]?
    
    //MARK: Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        onClickJsonData()
        configureSearchBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if modelArray?.count ?? 0 > 0 {
            configureTable()
        }
    }
    
    //MARK: View All Methods.
    func configureSearchBar(){
        DispatchQueue.main.async {
            self.searchBar.delegate = self
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            self.view.addGestureRecognizer(tap)
        }
    }
    
    
    
    func configureTable(){
        DispatchQueue.main.async {
            self.homeTbl.register(UINib(nibName: CellConstant.homeCell, bundle: nil), forCellReuseIdentifier:CellConstant.homeCell)
            self.homeTbl.separatorColor = UIColor.clear
            self.homeTbl.delegate = self
            self.homeTbl.dataSource = self
            self.homeTbl.backgroundColor = .clear
            self.homeTbl.reloadData()
        }
    }
    
    func layoutView(){
        self.title = "Collection"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "favourite", style: .plain, target: self, action: #selector(addTapped))

    }
    
    func onClickJsonData(){
        HomeViewModel.shared.onClickParsing(url: "\(GlobalUrl.baseUrl)\(MyUrls.dateKey)") { [weak self] status, error, response in
            if let _ = status{
                self?.modelArray = response
                self?.searchApodArray = self?.modelArray
                self?.configureTable()
            }else {
                self?.onClickAlert(message: error?.localizedDescription ?? "Something went wrong")
            }
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @objc func addTapped(){
        DatabaseHelper.shared.fetchFavourites(entity: "Favourite") {[weak self] status, error, message, data in
            if status{
                let manageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageViewController") as! ManageViewController
                       self?.navigationController?.pushViewController(manageVC, animated: true)
            }
            else {
                self?.onClickAlert(message: message)
            }
        }
    }
    
    func onClickAlert(message : String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Favourite", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")}))
            self.present(alert, animated: true, completion: nil)
        }}}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return modelArray?.count ?? 0
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstant.homeCell, for: indexPath) as! HomeTableViewCell
            cell.configure = modelArray?[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension HomeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0{
            searching = true
            modelArray = searchText.isEmpty ? modelArray : searchApodArray?.filter({(dataString: APOD) -> Bool in
                return dataString.title?.lowercased().range(of: searchText.lowercased(), options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            homeTbl.setContentOffset(.zero, animated: true)
        }else {
            searching = false
             modelArray = searchApodArray
        }
        homeTbl.reloadData()
    }
       
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        homeTbl.reloadData()
    }
}
extension HomeViewController : favouriteProtocol{
    func didPressButtonFor(_ user: APOD) {
        homeTbl.reloadData()
        let id = "\(user.id)"
        let title = user.title ?? ""
        let copyright = user.copyright ?? ""
        let url = user.url ?? ""
        let explanation = user.explanation ?? ""
        let date = user.date ?? ""
        let hdurl = user.hdurl ?? ""
        let mediaType = user.media_type ?? ""
        let serviceVersion = user.service_version ?? ""
        
        let dict: [String: Any] = ["title": title,
                    "id": id,
                    "copyright": copyright,
                    "url": url,
                    "explanation": explanation,
                    "date": date,
                    "hdurl": hdurl,
                    "media_type": mediaType,
                    "service_version": serviceVersion,
        ]
       let status = DatabaseHelper.shared.saveNewRecord(entity: "Favourite", dict: dict)
        print("Data updated successfullt \(status)")
    }
}
