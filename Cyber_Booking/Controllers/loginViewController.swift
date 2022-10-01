//
//  loginViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

import UIKit

class loginViewController: UIViewController {

    // iniciar sesión 
    @IBAction func Back2Home(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        
        nextViewController.modalPresentationStyle = .fullScreen
        // self es la vista 1, sobre ella presenta "siguienteVista"
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // función que cierra el teclado al apretar "intro"
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
