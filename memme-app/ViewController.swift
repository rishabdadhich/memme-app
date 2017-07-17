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
        topTextField.defaultTextAttributes = memmeTextAttributes
        bottomTextFeild.defaultTextAttributes = memmeTextAttributes
        topTextField.isHidden = false
        topTextField.textAlignment = NSTextAlignment.center
        topTextField.delegate = self
        bottomTextFeild.isHidden = false
        bottomTextFeild.textAlignment = NSTextAlignment.center
        bottomTextFeild.delegate = self
        topTextField.text = "TOP"
        bottomTextFeild.text = "BOTTOM"
        saveButton.isEnabled = (imagePickerView.image != nil) ? true : false
        
    }
    @IBOutlet weak var camraButton: UIBarButtonItem!
  
    
    
    override func viewWillAppear(_ animated: Bool) {
    camraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pickFromCamara(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = false
        controller.sourceType = .camera
        
        present(controller, animated: true, completion: nil)
    }
    @IBAction func pickAnImage(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = false
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
        saveButton.isEnabled = true
    }
    
    /////// text part ///////
    let memmeTextAttributes:[String:Any] = [
    
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,NSStrokeWidthAttributeName:-3.0
    
    ]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
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
        
        view.frame.origin.y = 0 
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
//        self.navigationController?.isToolbarHidden = true
//        self.navigationController?.isNavigationBarHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBarVisible(true)
//        self .navigationController?.isNavigationBarHidden = false
//        self.navigationController?.isToolbarHidden = false
        return memedImage
    }
    
    func toolBarVisible(_ visible: Bool){
        if !visible {
            navBar.isHidden = true    // removed self
            toolBar.isHidden = true // typo on var for toolbar // removed self
        } else {
            navBar.isHidden = false   // removed self
            toolBar.isHidden = false  // removed self
        }
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
        dismiss(animated: true, completion: {}) // removed self
        saveButton.isEnabled = false
    }
    
}
