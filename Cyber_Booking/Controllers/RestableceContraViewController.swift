//
//  RestableceContraViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 12/10/22.
//

import UIKit

class RestableceContraViewController: UIViewController {
    
    var email:String = ""
    let sendEmail = "http://127.0.0.1:8000/recurperarContra"
    
    @IBOutlet weak var contraTxtField: UITextField!
    @IBOutlet weak var verifContraTxtField: UITextField!
    
    var is_validPass:Bool = false
    var is_passMatch:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func verificaPassword() {
        
       let validPass = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?¿!¡@$ %^&*-_]).{10,}$"
       
       if(contraTxtField.text?.range(of: validPass, options: .regularExpression) == nil){
   
           is_validPass = false
           
       } else {
           is_validPass = true
       }
       
       
    }
   
   func checkMatchingPass(){
       
       if(contraTxtField.text != verifContraTxtField.text){
           let alert = UIAlertController(title: "Verifique las contraseñas", message: "Las contraseñas no coiniciden", preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
           
           self.present(alert, animated: true, completion: nil)
               is_passMatch = false

       } else {
           is_passMatch = true
       }
   }
    
    func cambiarContra() async throws{
        
        let insertURL = URL(string: sendEmail)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["correo":email, "contra":contraTxtField.text ?? ""])
        request.httpBody = jsonData
        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw ReservaError.itemNotFound}
        
        
    }
    
    
    @IBAction func cambioContra(_ sender: UIButton) {
        
        verificaPassword()
        checkMatchingPass()
        
        if contraTxtField.text == "" || verifContraTxtField.text == ""{
            let alert = UIAlertController(title: "Campos vacíos", message: "Favor de llenar todos los campos", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if !is_validPass {
            let alert = UIAlertController(title: "Verifique su contraseña", message: "Debe tener por lo menos 10 caracteres de longitud, incluir 1 mayúscula, 1 minúscula, 1 número y un caracter especial (#?¿!¡@$ %^&*-_)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if !is_passMatch{
            let alert = UIAlertController(title: "Verifique las contraseñas", message: "Las contraseñas no coiniciden", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Task{
                do{
                    try await cambiarContra()
                    
                    let alert = UIAlertController(title: "Cambio exitoso", message: "Su contraseña ha sido cambiada con éxito", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    let storyboard = UIStoryboard(name:"Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "login_") as UIViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated:true, completion:nil)

                    
                }catch{
                    let alert = UIAlertController(title: "Intente de nuevo", message: "No fue posible cambiar la contraseña", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
        }
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
