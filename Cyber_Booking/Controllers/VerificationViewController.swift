//
//  VerificationViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

import UIKit


class VerificationViewController: UIViewController{

    var code2verify:Int = 0
    let sendEmail = "http://127.0.0.1:8000/enviarMail"
    var email:String = " "

    
    @IBOutlet weak var codeTextF: UITextField!
    
    struct answer: Codable {
        var msg: String
    }
    
    
    func enviarCorreo() async throws->answer{
        let insertURL = URL(string: sendEmail)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["email":email, "code":String(code2verify)])
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw ReservaError.itemNotFound}
        
        let jsonDecoder = JSONDecoder()
        do{
        
            let reservas = try jsonDecoder.decode(answer.self, from: data)
            
            return reservas
            
        }catch let jsonError as NSError{
            
            print("JSON decode failed: \(jsonError)")
            throw ReservaError.decodeError
        }
        
    }
    
    // función que cierra el teclado al apretar "intro"
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func reenviarCodigo(_ sender: UIButton) {
        
        code2verify = Int.random(in: 100000..<999999)
        
        Task{
            do{
                let ans = try await enviarCorreo()
                
                if ans.msg == "Ended process"{
                    let alert = UIAlertController(title: "Correo enviado", message: "Verifique el código en su correo", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                } else {
                    let alert = UIAlertController(title: "Intente de nuevo", message: "No fue posible enviar el correo", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                }

                
            }catch{
                let alert = UIAlertController(title: "Intente de nuevo", message: "No se pudo crear el usuario", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                
            }
        }
        
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        
        
        if String(code2verify) == codeTextF.text && codeTextF.text != ""{
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "confView") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            
            let alert = UIAlertController(title: "Verifique en su correo", message: "El código no corresponde", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Hecho", style: .cancel, handler:  nil))
        }
        
    }

}
