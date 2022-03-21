//
//  HomeTableViewCell.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
//

import UIKit
import AVFoundation
import AVKit
protocol favouriteProtocol {
    func didPressButtonFor(_ user: APOD)
}

class HomeTableViewCell: UITableViewCell {
    
    var player = AVPlayer()
    var avpController = AVPlayerViewController()

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var astonomyImage: CustomImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var copyRightlbl: UILabel!
    
    @IBOutlet weak var favouriteBtn: UIButton!
    var delegate :favouriteProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var configure : APOD?{
        didSet{
            favouriteBtn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            backView.dropShadow()
            backView.backgroundColor = .secondarySystemBackground
            videoView.backgroundColor = .secondarySystemBackground
            self.titleLbl.text = configure?.title
            self.dateLbl.text = configure?.date
            DispatchQueue.main.async {
                if let media = self.configure?.media_type {
                    if media == "video"{
                        self.videoView.isHidden = false
                        self.astonomyImage.isHidden = true
                        if let url = self.configure?.url{self.triggerAvPlayer(urlString: url)}
                    }else {
                        self.astonomyImage.isHidden = false
                        self.videoView.isHidden = true
                        if let url = self.configure?.url{self.astonomyImage.loadImage(with: url)}
                        else{self.astonomyImage.image = UIImage(named: "default")}}
                }else{
                    self.astonomyImage.isHidden = false
                        self.videoView.isHidden = true
                    self.astonomyImage.image = UIImage(named: "default")}
            }
            self.descLbl.text = configure?.explanation
            if let copyright = configure?.copyright {
                self.copyRightlbl.text = "copyright by :- \(copyright)"
            }else{self.copyRightlbl.text = ""}
            DispatchQueue.main.async {
                if let value: Bool? = DatabaseHelper.shared.checkSingleEntry(entryName: self.configure?.title ?? ""){
                    if value == true{self.setImage(name: "check")}else {self.setImage(name: "uncheck")}
                }else {self.setImage(name: "uncheck")}
            }
        }
    }
    
    func triggerAvPlayer (urlString : String){
        if let url = URL(string: urlString){
            self.player = AVPlayer(url: url)
            avpController.player = player
            avpController.view.frame.size.height = videoView.frame.size.height
            avpController.view.frame.size.width = videoView.frame.size.width
            self.videoView.addSubview(avpController.view)
        }
    }
    
    var favourite : APOD?{
        didSet{
            favouriteBtn.addTarget(self, action: #selector(favouriteConfig), for: .touchUpInside)
            backView.dropShadow()
            backView.backgroundColor = .secondarySystemBackground
            videoView.backgroundColor = .secondarySystemBackground
            self.titleLbl.text = favourite?.title
            self.dateLbl.text = favourite?.date
            DispatchQueue.main.async {
                if let media = self.favourite?.media_type {
                    if media == "video"{
                        self.videoView.isHidden = false
                        self.astonomyImage.isHidden = true
                        if let url = self.favourite?.url{self.triggerAvPlayer(urlString: url)}else {self.astonomyImage.image = UIImage(named: "default")}
                    }else {
                        self.astonomyImage.isHidden = false
                        self.videoView.isHidden = true
                        if let url = self.favourite?.url{self.astonomyImage.loadImage(with: url)}
                        else{self.astonomyImage.image = UIImage(named: "default")}}
                }else{self.astonomyImage.isHidden = false
                    self.videoView.isHidden = true
                    self.astonomyImage.image = UIImage(named: "default")}
            }
            self.descLbl.text = favourite?.explanation
            if let copyright = favourite?.copyright {
                if !copyright.isEmpty{
                    self.copyRightlbl.text = "copyright by :- \(copyright)"
                }else{self.copyRightlbl.text = ""}
                
            }else{self.copyRightlbl.text = ""}
            DispatchQueue.main.async {
                self.setImage(name: "check")
            }
        }
    }
    
    func setImage(name: String ){
        self.favouriteBtn.setImage(UIImage(named: name), for: .normal)
        self.favouriteBtn.imageView?.contentMode = .scaleAspectFit
       // self.favouriteBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    @objc func buttonPressed() {
        if let data = self.configure{
            delegate?.didPressButtonFor(data)
        }
    }
    @objc func favouriteConfig(){
        if let data = self.favourite{
            delegate?.didPressButtonFor(data)
        }
    }
}
extension UIView{
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 2
        layer.cornerRadius = 8
    }
}
