//
//  AddViewController.swift
//  Notey
//
//  Created by Ethan Schmalz on 10/18/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{

    
    
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var colorStackView: UIStackView!
    @IBOutlet weak var brushOptions: UIStackView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var detailField: UITextView!
    @IBOutlet weak var drawView: DrawingView!
    @IBOutlet weak var typeDraw: UISegmentedControl!
    @IBOutlet weak var photoPicked: UIImageView!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var brushSizeBurron: UIButton!
    
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    
    var item: Item!
    
    @IBAction func changeWidth(_ sender: Any) {
        drawView.lineWidth = CGFloat(widthSlider.value)
    }
    
    @IBAction func pickColor(_ sender: Any) {
        if colorStackView.isHidden == false{
            widthSlider.isHidden = true
            UIView.animate(withDuration: 0.3){
                self.colorStackView.isHidden = true

            }
            self.drawView.setNeedsDisplay()
            
        } else {
            widthSlider.isHidden = true
            UIView.animate(withDuration: 0.3){
                self.colorStackView.isHidden = false

            }
            self.drawView.setNeedsDisplay()
        }
    }
    
    @IBAction func changeBrushSize(_ sender: Any) {
        if widthSlider.isHidden == false{
            colorStackView.isHidden = true
            UIView.animate(withDuration: 0.1){
                self.widthSlider.isHidden = true
            }
            self.drawView.setNeedsDisplay()
        } else {
            colorStackView.isHidden = true
            UIView.animate(withDuration: 0.1){
                self.widthSlider.isHidden = false
            }
            self.drawView.setNeedsDisplay()
        }
    }
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
                brushOptions.isHidden = false
            }else{
                detailField.isHidden = true
                photoPicked.isHidden = false
                drawView.isHidden = true
            }
        default:
            break
        }
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        drawView.undo()
    }
    
    @IBAction func redoPressed(_ sender: Any) {
        drawView.redo()
    }
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func blackPressed(_ sender: Any) {
        drawView.changeColor(color: UIColor.black)
        UIView.animate(withDuration: 0.3){
            self.colorStackView.isHidden = true
        }
        self.drawView.setNeedsDisplay()
    }

    @IBAction func yellowPressed(_ sender: Any) {
        drawView.changeColor(color: UIColor.yellow)
        UIView.animate(withDuration: 0.3){
            self.colorStackView.isHidden = true
        }
        self.drawView.setNeedsDisplay()
    }
    
    @IBAction func orangePressed(_ sender: Any) {
        drawView.changeColor(color: UIColor.orange)
        UIView.animate(withDuration: 0.3){
            self.colorStackView.isHidden = true
        }
        self.drawView.setNeedsDisplay()
    }
    
    @IBAction func greenPressed(_ sender: Any) {
        drawView.changeColor(color: UIColor.green)
        UIView.animate(withDuration: 0.3){
            self.colorStackView.isHidden = true
        }
        self.drawView.setNeedsDisplay()

    }
    
    @IBAction func bluePressed(_ sender: Any) {
        drawView.changeColor(color: UIColor.blue)
        UIView.animate(withDuration: 0.3){
            self.colorStackView.isHidden = true
        }
        self.drawView.setNeedsDisplay()

    }
    
    @IBAction func redPressed(_ sender: Any) {
        drawView.changeColor(color: UIColor.red)
        UIView.animate(withDuration: 0.3){
            self.colorStackView.isHidden = true
        }
        self.drawView.setNeedsDisplay()
    }
    
    
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
        setupButtonStyle(button: redButton, color: UIColor.red)
        setupButtonStyle(button: blackButton, color: UIColor.black)
        setupButtonStyle(button: blueButton, color: UIColor.blue)
        setupButtonStyle(button: greenButton, color: UIColor.green)
        setupButtonStyle(button: orangeButton, color: UIColor.orange)
        setupButtonStyle(button: yellowButton, color: UIColor.yellow)
        widthSlider.isHidden = true
        colorStackView.isHidden = true
        brushOptions.isHidden = true
        drawView.isHidden = true
        widthSlider.isHidden = true
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
    
    func setupButtonStyle(button : UIButton, color: UIColor){
        // Customizing Menu Button Style
        button.layer.cornerRadius = 0.6 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = color
    }
    
}
