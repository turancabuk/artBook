//
//  ViewController.swift
//  artbook
//
//  Created by Turan Çabuk on 14.07.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var nameArray = [String]()
    var idArray = [UUID]()
   
    

   
    @IBOutlet weak var tableVİew: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVİew.delegate = self
        tableVİew.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        
        getData()
   
   
    }
    func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String{
                    self.nameArray.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                }
                self.tableVİew.reloadData()
            }
        }catch{
            
        }
        
        
        
        
    }
    @objc func addButton (){
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell ()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
   
}

