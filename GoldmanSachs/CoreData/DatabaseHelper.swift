//
//  DatabaseHelper.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 20/03/22.
//

import UIKit
import CoreData

class DatabaseHelper {
    
    static let shared = DatabaseHelper()
    typealias completion = (_ status : Bool, _ error: Error?,_ message : String ,_ data: [APOD]?) -> Void
    
    func fetchFavourites(entity: String, completion: @escaping completion){
        guard let appDelegateOBJ = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegateOBJ.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        
        onClickRecords(context: context,request: request) { status, error, message, data in
            completion(status,error, message, data)
        }
    }
    
    func saveNewRecord(entity : String, dict : [String: Any]) -> Bool{
        var status = false
        // Check id is Exist
        let title = dict["title"] as? String ?? ""
        UserExist(title: title, dataDict: dict) {response, value in
            if value{
                print("Records are deleted")
            }else{
                guard let appDelegateOBJ = UIApplication.shared.delegate as? AppDelegate else {return }
                let context = appDelegateOBJ.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: entity, in: context)
                let managedOBJ = NSManagedObject(entity: entity!, insertInto: context)
                for (key, value) in dict {
                    managedOBJ.setValue(value, forKey: key)
                }
                do {
                    try context.save()
                    status = true
                } catch let err {
                    status = false
                    print(err.localizedDescription)
                }
            }
        }
        return status
    }
    
    func UserExist(title : String? ,dataDict: [String : Any], completion : @escaping (_ result: [NSFetchRequestResult],_ status : Bool) -> ()){
        var status = false
        guard let appDelegateOBJ = UIApplication.shared.delegate as? AppDelegate else { return completion([], false)}
        let context = appDelegateOBJ.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        let predicate1:NSPredicate = NSPredicate(format: "title == %@", title ?? "")
        let predicate:NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            if result.count > 0{
                DispatchQueue.main.async {
                for data in result as! [NSManagedObject]{
                        context.delete(data)
                }
                do {
                    try context.save()
                    status = true
                } catch{
                    status = false
                }
                completion(result, status)
            }
            }else {
               completion([], status)
            }
        }catch {
            
        }
    }
    
    func onClickRecords(context: NSManagedObjectContext, request: NSFetchRequest<NSFetchRequestResult>, completion: @escaping completion){
        do {
            let result = try context.fetch(request)
            if result.count > 0{
                var obj = [APOD]()
                for data in result as! [NSManagedObject] {
                    let copyright = data.value(forKey: "copyright") as? String ?? ""
                    let date = data.value(forKey: "date")  as? String ?? ""
                    let url = data.value(forKey: "url")  as? String ?? ""
                    let explanation = data.value(forKey: "explanation")  as? String ?? ""
                    let title = data.value(forKey: "title")  as? String ?? ""
                    let service_version = data.value(forKey: "service_version")  as? String ?? ""
                    let media_type = data.value(forKey: "media_type")  as? String ?? ""
                    let id = data.value(forKey: "id")  as? String ?? ""
                    let dic: [String :Any] = ["copyright": copyright, "date": date, "url": url, "id": id, "title": title, "explanation": explanation, "service_version" : service_version, "media_type": media_type] as [String : Any]
                    let data = APOD.init(data: dic)
                    obj.append(data)
                }
                completion(true, nil,"", obj)
            }else{
                completion(false, nil,"Kindly mark your favourite pictures", nil)
            }
        }catch(let error){
            completion(false, error.localizedDescription as? Error, "error",  nil)
        }
    }
    func checkSingleEntry(entryName : String) -> Bool{
        var status = false
         let appDelegateOBJ = UIApplication.shared.delegate as! AppDelegate
           
        let context = appDelegateOBJ.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        let predicate1:NSPredicate = NSPredicate(format: "title == %@", entryName)
        let predicate:NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            if result.count > 0{
                status = true
            }
        }catch {
            status = false
        }
        
        return status
    }
}
