//
//  secondvc.swift
//  denemeharita
//
//  Created by erdem öden on 26.05.2021.
//

import UIKit
import CoreData
class secondvc: UIViewController {
    var longitude = Double();
    var latitude = Double();
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func silbut(_ sender: Any) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate;
        let context = appdelegate.persistentContainer.viewContext;
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName:"Locations");
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format:"latitude == \(latitude) AND longitude == \(longitude)");
        do{
            let datas = try context.fetch(fetch)
            if(datas.count > 0){
            for data in datas as! [NSManagedObject]{
                context.delete(data)
                print("sil");
                performSegue(withIdentifier: "geridon", sender: nil)
                do{
                    try context.save()
                    
                }
                catch{
                    print("error");
                }
            }
                
            }
            else{
                print("orospu çocuğu");
            }
                
        }
        catch{
            print("error");
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
