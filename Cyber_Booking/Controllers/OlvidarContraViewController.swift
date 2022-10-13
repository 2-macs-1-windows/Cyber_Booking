//
//  OlvidarContraViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 24/09/22.
//

import UIKit

class OlvidarContraViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var correoTxtField: UITextField!
    @IBOutlet weak var codigoTxtField: UITextField!
    
    var code:Int = Int.random(in: 100000..<999999)
    var is_regEmail:Bool = false
    
    let userListURL = "http://127.0.0.1:8000/getUsuariosApp"
    let sendEmail = "http://127.0.0.1:8000/enviarMail"
    
    struct emailCheck: Codable {
        var msg: String
    }
    
    struct answer: Codable {
        var msg: String

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
    
    func getTodosUsuarios() async throws->emailCheck{
        let insertURL = URL(string: userListURL)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["email":correoTxtField.text])
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw ReservaError.itemNotFound}
        
        let jsonDecoder = JSONDecoder()
        do{
        
            let reservas = try jsonDecoder.decode(emailCheck.self, from: data)
            
            return reservas
            
        }catch let jsonError as NSError{
            
            print("JSON decode failed: \(jsonError)")
            throw ReservaError.decodeError
        }
        
    }
    
    
    func enviarCorreo() async throws->answer{
        
        let insertURL = URL(string: sendEmail)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["email":correoTxtField.text, "code":String(code)])
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
    
    
    @IBAction func sendEmail(_ sender: UIButton) {
        Task{
            do{
                let is_registered = try await getTodosUsuarios()
                
                if is_registered.msg == "registrado"{
                    is_regEmail = true
                    
                    if is_regEmail{
                        Task{
                            do{
                                let ans = try await enviarCorreo()
                                
                                if ans.msg == "Ended process"{
                                    let alert = UIAlertController(title: "Revise su correo", message: "Un código fue enviado a su dirección de correo", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                } else {
                                    let alert = UIAlertController(title: "Intente nuevamente", message: "No fue posible enviar el correo", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }

                                
                            }catch{
                                let alert = UIAlertController(title: "Intente de nuevo", message: "No fue posible enviar el correo", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                                
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                        }
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Usuario no encontrado", message: "Su correo no se encuentra registrado", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    is_regEmail = false
                }
                
            }catch let jsonError as NSError{
                print("JSON decode failed: \(jsonError)")
                let alert = UIAlertController(title: "Error de conexión", message: "No fue posible obtener la lista de usuarios", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                
                self.present(alert, animated: true, completion: nil)            }
        }
        
        
    }
    
    
    @IBAction func verifCode(_ sender: UIButton) {
        
        print(code)
        if codigoTxtField.text == String(code){
            
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "restContra") as UIViewController
            
            let siguientePantalla = vc as! RestableceContraViewController
            
            siguientePantalla.email = correoTxtField.text ?? " "
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let alert = UIAlertController(title: "Código incorrecto", message: "Verifique el código ingresado", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
        }
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
