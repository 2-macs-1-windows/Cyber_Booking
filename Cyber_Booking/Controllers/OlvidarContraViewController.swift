//
//  OlvidarContraViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 24/09/22.
//

import UIKit

class OlvidarContraViewController: UIViewController {
    
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
