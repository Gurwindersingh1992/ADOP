//
//  NetworkLayer.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
//

import Foundation

class NetworkLayer{
    
    static let shared = NetworkLayer()
    
    var sessionForCache : URLSession{
    URLCache.shared.memoryCapacity = 512 * 1024 * 1024
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: config)
        return session
    }
    
    var session : URLSession{
    URLCache.shared.memoryCapacity = 512 * 1024 * 1024
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config)
        return session
}
    
    func parsingJsonUrl(url : String, completion: @escaping (_ status : Bool?, _ failure : Error?, _ message: String? , _ model : [APOD]?)-> Void){
        var actualSession : URLSession?
        guard let url = URL(string: url) else {return completion (false, nil,"",nil)}
        if isInternetActive{actualSession = session}else {actualSession = sessionForCache}
        let dataTask = actualSession?.dataTask(with: url) { data, response, error in
                guard let data = data , error == nil else{return completion (false, nil,"",nil)}
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                                                            data, options: [])
                    var apod = Array<APOD>()
                    if let param = jsonResponse  as? [[String: Any]]{
                        for obj in param{
                            let data = APOD.init(data: obj)
                            apod.append(data)
                        }
                    }
                    completion(true, nil,"", apod)
                }catch (let error){
                    completion(false, error.localizedDescription as? Error,"", nil)
                }
            };dataTask?.resume()
   }
}
