//
//  HomeViewModel.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
//

import Foundation

class HomeViewModel{
    
    static let shared = HomeViewModel()
    
    func onClickParsing(url : String , completion: @escaping (_ status : Bool?, _ failure : Error?, _ model : [APOD]?)-> Void){
        NetworkLayer.shared.parsingJsonUrl(url: url) { status, failure, message,model in
            completion (status, failure, model)
        }
    }
}
