//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Ethan Schmalz on 10/2/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController, UITextFieldDelegate, MFMessageComposeViewControllerDelegate{
    @IBOutlet var nameField: UITextField!
    @IBOutlet var detailField: UITextView!
    
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var photoSaved: UIImageView!
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
        }else if item.picture{
            detailField.isHidden = true
            drawView.isHidden = true
            photoSaved.isHidden = false
            loadPicture()
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.name = nameField.text ?? ""
        item.details = detailField.text ?? ""
        
        
    }
    
    @IBAction func sendNote(_ sender: Any) {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self

        if MFMessageComposeViewController.canSendText(){
            print("Can Text")
            
            if item.drawing{
                if let data = UserDefaults.standard.data(forKey: item.uuid), let image = UIImage(data: data){
                    let imageDataDrawing = UIImageJPEGRepresentation(image, 1.0)
                    messageComposeVC.addAttachmentData(imageDataDrawing!, typeIdentifier: "image/jpeg", filename: "myImage.jpeg")
                    self.present(messageComposeVC, animated: false, completion: nil)
                }
            }
            else if item.picture{
                let imageDataPicture = UIImageJPEGRepresentation(photoSaved.image!, 1.0)
                messageComposeVC.addAttachmentData(imageDataPicture!, typeIdentifier: "image/jpeg", filename: "mypicture.jpeg")
                self.present(messageComposeVC, animated: false, completion: nil)
            }
            else {
                messageComposeVC.body = item.details
                self.present(messageComposeVC, animated: false, completion: nil)
            }
        } else {
            print("Can't Text")
        }
        
        

    }
    
    func loadDrawing(){
        if let data = UserDefaults.standard.data(forKey: item.uuid),let image = UIImage(data: data){
            let drawingView = UIImageView.init(image: image)
            drawView.addSubview(drawingView)
        }
    }
    
    func loadPicture(){
        if let data = UserDefaults.standard.data(forKey: item.uuid),let image = UIImage(data: data){
            photoSaved.image = image
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResult.cancelled:
            print("Message was cancelled")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed:
            print("Message failed")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent:
            print("Message was sent")
            controller.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
}
