//
//  secondViewController.swift
//  artbook
//
//  Created by Turan Çabuk on 14.07.2022.
//

import UIKit
import CoreData

class secondViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    

    var chosenPainting = ""
    var chosenPaintingId : UUID?
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var artistTextfield: UITextField!
    @IBOutlet weak var yearTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if chosenPainting != ""{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            let idString = chosenPaintingId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "name") as? String{
                        nameTextfield.text = name
                    }
                    if let artist = result.value(forKey: "artist") as? String{
                        artistTextfield.text = artist
                    }
                    if let year = result.value(forKey: "year") as? Int{
                        yearTextfield.text = String(year)
                    }
                    if let imageData = result.value(forKey: "image") as? Data{
                        let image = UIImage(data: imageData)
                        imageView.image = image
                    }
                    
                        
                }
            }catch{
                
            }
        }
        
        //Recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageSelect))
        imageView.addGestureRecognizer(imageTapGestureRecognizer)

    
    
    
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @objc func imageSelect(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info [.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        saveData.setValue(nameTextfield.text, forKey: "name")
        saveData.setValue(artistTextfield.text, forKey: "artist")
        saveData.setValue(UUID(), forKey: "id")
        if let year = Int(yearTextfield.text!){
            saveData.setValue(year, forKey: "year")
        }
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        saveData.setValue(data, forKey: "image")
        
        
        do{
            try context.save()
            print("succes")
        }catch{
            print("error!")
        }
        self.navigationController?.popViewController(animated: true)
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
    }
    
}
