//
//  SignUpViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBAction func back2Login(_ sender: UIButton) {
        
         let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "login") as! loginViewController
        
        nextViewController.modalPresentationStyle = .fullScreen
        // self es la vista 1, sobre ella presenta "siguienteVista"
        self.present(nextViewController, animated:true, completion:nil)
        
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
