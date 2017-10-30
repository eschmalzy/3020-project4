//
//  AddViewController.swift
//  Notey
//
//  Created by Ethan Schmalz on 10/18/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{

    @IBOutlet var nameField: UITextField!
    @IBOutlet var detailField: UITextView!
    @IBOutlet weak var drawView: DrawableView!
    @IBOutlet weak var typeDraw: UISegmentedControl!
    @IBOutlet weak var photoPicked: UIImageView!
    
    @IBAction func takePicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        }else{
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Put that image on the screen in the image view
        drawView.isHidden = true
        detailField.isHidden = true
        photoPicked.isHidden = false
        photoPicked.image = image
        item.picture = true
        typeDraw.selectedSegmentIndex = 1
        // Take image picker off the screen -
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleControl(_ sender: Any) {
        switch typeDraw.selectedSegmentIndex{
        case 0:
            detailField.isHidden = false
            drawView.isHidden = true
            photoPicked.isHidden = true
        case 1:
            if !item.picture{
                detailField.isHidden = true
                photoPicked.isHidden = true
                drawView.isHidden = false
            }else{
                detailField.isHidden = true
                photoPicked.isHidden = false
                drawView.isHidden = true
            }
        default:
            break
        }
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    var item: Item!

    @IBAction func cancelAddViewController(_ segue: UIStoryboardSegue) {
        self.performSegue(withIdentifier: "cancelAddViewController", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveNote(_ sender: Any) {
        self.performSegue(withIdentifier: "saveNote", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.isHidden = true
        photoPicked.isHidden = true
        drawView.isUserInteractionEnabled = true
        typeDraw.tintColor = UIColor(red: 1.00, green: 0.2, blue: 0.18, alpha: 1.0)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        detailField.text = item.details
        if item.drawing{
            typeDraw.selectedSegmentIndex = 1
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        item.name = nameField.text ?? ""
        item.details = detailField.text
        if typeDraw.selectedSegmentIndex == 1 {
            saveDrawing()
            item.details = "Picture"
        }
        
    }
    
    func saveDrawing(){
        if !item.picture{
            item.drawing = true
            let img = drawView.createImage()
            let data = UIImagePNGRepresentation(img)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: item.uuid)
            userDefaults.synchronize()
        }else {
            let data = UIImagePNGRepresentation(photoPicked.image!)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: item.uuid)
            userDefaults.synchronize()
        }
    }
    
}
