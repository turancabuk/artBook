//
//  secondViewController.swift
//  artbook
//
//  Created by Turan Çabuk on 14.07.2022.
//

import UIKit
import CoreData

class secondViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var artistTextfield: UITextField!
    @IBOutlet weak var yearTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            print("succes!")
        }catch{
            print("error!")
        }
    
    }
    
}
