//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Ethan Schmalz on 10/2/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var nameField: UITextField!
    @IBOutlet var detailField: UITextView!
    
    @IBOutlet weak var drawView: DrawableView!
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    var item: Item!
    var row: Int = 0
    
    @IBAction func cancelNoteViewController(_ segue: UIStoryboardSegue) {
        self.performSegue(withIdentifier: "cancelNoteViewController", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func saveNote(_ sender: UIBarButtonItem) {
//        self.performSegue(withIdentifier: "saveChanges", sender: self)
//        self.dismiss(animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            detailField.isHidden = true
            loadDrawing()
        }else{
            drawView.isHidden = true
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.name = nameField.text ?? ""
        item.details = detailField.text ?? ""
        if item.drawing{
            saveDrawing()
        }
        
    }
    
    func saveDrawing(){
        let img = drawView.createImage()
        let data = UIImagePNGRepresentation(img)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: item.uuid)
        userDefaults.synchronize()
    }
    
    func loadDrawing(){
        if let data = UserDefaults.standard.data(forKey: item.uuid),let image = UIImage(data: data){
            let drawingView = UIImageView.init(image: image)
            drawView.addSubview(drawingView)
            
        }
    }
}
