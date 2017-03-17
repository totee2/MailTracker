//
//  ItemViewController.swift
//  Mail tracker
//
//  Created by Antonia Schmidt-Lademann on 06/11/2016.
//  Copyright © 2016 Antonia Schmidt-Lademann. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var sentControl: SentControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    /* this value is either passed by 'ItemTableViewController' in 'prepareForSegue(_:sender:)'
     or constructed as part of adding a new item
     */
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        
        nameTextField.delegate = self
        imagePickerController.delegate = self
        
        if let item = item{
            navigationItem.title = item.name
            nameTextField.text = item.name
            photoImageView.image = item.photo
            sentControl.messageStatus = item.sent
        }
        
        //Enable the Save button only if the text field has a valid Meal name
        checkValidMealName()
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func checkValidMealName(){
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the origninal
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = selectedImage
        //Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    
    // This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as AnyObject? === saveButton {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let sent = sentControl.messageStatus
            let date = NSDate(timeIntervalSinceNow: 0)
            //Set the item to be passed to ItemTableViewController after the unwind segue
            item = Item(name: name, photo: photo, sent: sent, sentDate: date)
        }
    }
    
    
    // MARK: Actions
    
    
    @IBAction func takePic(_sender: UITapGestureRecognizer){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        //let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera", message: "Sorry, no camera, no good girl stuff", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library

        //only allow photos to be picked, not taken
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //imagePickerController.modalPresentationStyle = .popover
        // Make sure ViewController is notified when the user picks an image.
        //imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        //imagePickerController.popoverPresentationController?.photoImageView = sender
    }

}

