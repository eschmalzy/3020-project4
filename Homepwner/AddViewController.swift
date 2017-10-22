//
//  AddViewController.swift
//  Notey
//
//  Created by Ethan Schmalz on 10/18/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var nameField: UITextField!
    @IBOutlet var detailField: UITextView!
    @IBOutlet weak var drawView: DrawableView!
    @IBOutlet weak var typeDraw: UISegmentedControl!
    
    @IBAction func toggleControl(_ sender: Any) {
        switch typeDraw.selectedSegmentIndex{
        case 0:
            detailField.isHidden = false
            drawView.isHidden = true
        case 1:
            detailField.isHidden = true
            drawView.isHidden = false
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
            item.drawing = true
            saveDrawing()
            item.details = "Picture"
        }
        
    }
    
    func saveDrawing(){
        let img = drawView.createImage()
        let data = UIImagePNGRepresentation(img)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: item.uuid)
        userDefaults.synchronize()
    }
    
}
