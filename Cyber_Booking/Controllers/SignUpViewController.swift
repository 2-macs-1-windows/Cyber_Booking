//
//  SignUpViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // Outlet del ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerForKeyboardNotifications()
    }
    
    
    // función que cierra el teclado al apretar "intro"
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    // Código de Scroll Views
    func registerForKeyboardNotifications() {
        // keyboardWasShown función que va a ser invocada cuando este evento suceda
        
            // cuando se muestra el teclado keyboardDidShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        // cuando se esconde el teclado keyboardWillHideNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(_ notification: NSNotification) {
        // cuando se prende el teclado
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }

        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size

        //let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        //scrollView.contentInset = contentInsets
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom:keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        // lo del ojo clínico
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
