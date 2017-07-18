//
//  ViewController.swift
//  memme-app
//
//  Created by Rishabh on 24/04/1939 Saka.
//  Copyright © 1939 Saka rishi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextFeild: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        saveButton.isEnabled = (imagePickerView.image != nil) ? true : false
        
        
        
    }
    @IBOutlet weak var camraButton: UIBarButtonItem!
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func pickImage(_ source:UIImagePickerControllerSourceType)  {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = false
        controller.sourceType = source
        present(controller, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func pickFromCamara(_ sender: Any) {
        pickImage(UIImagePickerControllerSourceType.camera)
    }
    @IBAction func pickAnImage(_ sender: Any) {
        pickImage(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
        saveButton.isEnabled = true
    }
    
    
    
    func textFieldAttributes(_ textInput:UITextField,defaultText:String){
        let memmeTextAttributes:[String:Any] = [
            
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,NSStrokeWidthAttributeName:-3.0
            
        ]
        
        textInput.text = defaultText
        textInput.defaultTextAttributes = memmeTextAttributes
        textInput.delegate = self
        textInput.textAlignment = .center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        camraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        textFieldAttributes(topTextField, defaultText: "TOP")
        textFieldAttributes(bottomTextFeild, defaultText: "BOTTOM")
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTextField.text == "TOP" || bottomTextFeild.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ////////// keyboard part ////////
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextFeild.isFirstResponder && view.frame.origin.y == 0.0{
            
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextFeild.isFirstResponder {
            
            view.frame.origin.y = 0
        }
    }
    
    ///////// save memme //////////
    
    
    struct Meme {
        var topText:String
        var bottomText:String
        var originalImage:UIImage
        var memed:UIImage
        
    }
    
    func shareShafely(memedImage:UIImage) {
        if imagePickerView.image != nil && topTextField.text != nil && bottomTextFeild.text != nil {
            
            let top = topTextField.text!
            let bottom = bottomTextFeild.text!
            let image = imagePickerView.image!
            
            let meme = Meme(topText: top, bottomText:bottom, originalImage: image, memed: memedImage)
            
        }
    }
    
    func generateMemedImage() -> UIImage {
        toolBarVisible(false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBarVisible(true)
        return memedImage
    }
    
    func toolBarVisible(_ visible: Bool){
        navBar.isHidden = visible
        toolBar.isHidden = visible
    }
    
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        let memeToShare = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.shareShafely(memedImage: memeToShare)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextFeild.text = "BOTTOM"
        dismiss(animated: true, completion: {})
        saveButton.isEnabled = false
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
