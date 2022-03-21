//
//  Constants.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
//

import Foundation
import UIKit

var isInternetActive : Bool!

var yesterday : String?{
    let formater = DateFormatter()
    formater.dateFormat = "YYYY-MM-dd"
    let value =  formater.string(from: Date().yesterday)
    return value
}

var fewDaysBefore : String?{
    let formater = DateFormatter()
    formater.dateFormat = "YYYY-MM-dd"
   let value = formater.string(from: Date().dayBefore)
    return value
}

struct ApiConstant {
    static let error = "Something went wrong"
    static let networkUnavailable = "Network Unavailable"
}

struct MyUrls {
    static let myKey = "K0ABiLFtoc6EyQDDXjNlZbL2xeguHXHguBaIH8M7"
    static let dateKey = "api_key=\(myKey)&start_date=\(fewDaysBefore ?? "")&end_date=\(yesterday ?? "")"
}


struct GlobalUrl{
    static let baseUrl = "https://api.nasa.gov/planetary/apod?"
}
struct CellConstant{
    static let homeCell = "HomeTableViewCell"
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -10, to: self)!
    }
}
