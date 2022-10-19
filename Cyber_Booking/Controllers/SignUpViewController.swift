//
//  SignUpViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

import UIKit

class SignUpViewController: UIViewController {
    let baseString = "http://20.89.70.3:8000/registrarUsApp"
    let userListURL = "http://20.89.70.3:8000/getUsuariosApp"
    let sendEmail = "http://20.89.70.3:8000/enviarMail"
    
    let code:Int = Int.random(in: 100000..<999999)
    
    struct answer: Codable {
        var msg: String

    }
    
    // Outlet del ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nombre_U: UITextField!
    @IBOutlet weak var apellido_U: UITextField!
    @IBOutlet weak var correo_U: UITextField!
    @IBOutlet weak var telefono_U: UITextField!
    @IBOutlet weak var password_U2: UITextField!
    @IBOutlet weak var password_U: UITextField!
    @IBOutlet weak var aceptaPoliticas: UISwitch!
    
    var is_validPass:Bool = false
    var is_passMatch:Bool = false
    var is_validTel:Bool = false
    var is_regEmail:Bool = false
    var is_validNamAp:Bool = false
    
    struct emailCheck: Codable {
        var msg: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerForKeyboardNotifications()
    }
    
    //------------Verificar nombre y apellido -------------
    func verificarNomAp() {
        let validName = "^[a-zA-ZÀ-ÿñÑ]+$"
        
        if(nombre_U.text?.range(of: validName, options: .regularExpression) == nil || apellido_U.text?.range(of: validName, options: .regularExpression) == nil){
            
            is_validNamAp = false

        } else {
            
            is_validNamAp = true
        }
    }
    
    func emailPattern()->Bool{
        let pat = "^[a-zA-Z0-9]+(?:[.][a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:[.][a-zA-Z0-9]+)*$"
        
        if (correo_U.text?.range(of: pat, options: .regularExpression) == nil){
            
            return false
            
        } else {
            
            return true
        }
        
    }
    
    func enviarCorreo() async throws->answer{
        let insertURL = URL(string: sendEmail)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["email":correo_U.text, "code":String(code)])
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
    
    
    func getTodosUsuarios() async throws->emailCheck{
        let insertURL = URL(string: userListURL)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["email":correo_U.text])
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
    
    func verificarTel() {
        let validTel = "^[0-9]+$"
        
        if(telefono_U.text?.range(of: validTel, options: .regularExpression) == nil){
            
            is_validTel = false
        } else {
            is_validTel = true
        }
    }
    
    
    func verifyEmail() {
        
        Task{
            do{
                let is_registered = try await getTodosUsuarios()
                
                if is_registered.msg == "registrado"{
                    is_regEmail = true
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
    
     func verificaPassword() {
         
        let validPass = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?¿!¡@$ %^&*-_]).{10,}$"
        
        if(password_U.text?.range(of: validPass, options: .regularExpression) == nil){
    
            is_validPass = false
            
        } else {
            is_validPass = true
        }
        
        
     }
    
    func checkMatchingPass(){
        
        if(password_U.text != password_U2.text){
            let alert = UIAlertController(title: "Verifique las contraseñas", message: "Las contraseñas no coiniciden", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
                is_passMatch = false

        } else {
            is_passMatch = true
        }
    }
    
    
    @IBAction func checkEmailTextField(_ sender: UITextField) {
        verifyEmail()
    }
    
    // Verificación de campos
    
    @IBAction func verificarYmandar(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        verifyEmail()
        verificaPassword()
        checkMatchingPass()
        verificarNomAp()
        verificarTel()
        
        if(nombre_U.text == "" ||
           apellido_U.text == "" ||
           correo_U.text == "" ||
           telefono_U.text == "" ||
           password_U.text == "" ||
           password_U2.text == "" ){
            
            let alert = UIAlertController(title: "Campos vacíos", message: "Es necesario llenar todos los campos", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
        } else if  !is_validNamAp{
            let alert = UIAlertController(title: "Caracteres inválidos", message: "El nombre y el apellido deben contener solo letras", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }else if (!aceptaPoliticas.isOn){
            let alert = UIAlertController(title: "Términos y condiciones", message: "Favor de aceptar los términos y condiciones", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Hecho", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
        } else if (!is_passMatch){
            let alert = UIAlertController(title: "Verifique las contraseñas", message: "Las contraseñas no coiniciden", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
        } else if (!is_validTel){
            let alert = UIAlertController(title: "Verifique su teléfono", message: "El número de teléfono debe contener solo dígitos", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
        } else if (!is_validPass){
            let alert = UIAlertController(title: "Verifique su contraseña", message: "Debe tener por lo menos 10 caracteres de longitud, incluir 1 mayúscula, 1 minúscula, 1 número y un caracter especial (#?¿!¡@$ %^&*-_)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if is_regEmail{
            let alert = UIAlertController(title: "Correo ya registrado", message: "Favor de iniciar sesión", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
        } else if !emailPattern(){
            let alert = UIAlertController(title: "Correo inválido", message: "Revise la dirección de correo", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            // registrar usuario
            let newUser = User(name: nombre_U.text ?? "no", last_name: apellido_U.text ?? "no", email: correo_U.text ?? "no@no.com", phone: Int(String(telefono_U.text ?? "1111111")) ?? 0, is_admin: false, is_superadmin: false, password: password_U.text ?? "12345", verified_email: false, is_Tec: false, date_created: "", is_active: true)
            

            Task{
                do{
                    let ans = try await enviarCorreo()
                    
                    if ans.msg == "Ended process"{
                        let storyboard = UIStoryboard(name:"Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "verificaCorreo") as UIViewController
                        
                        let siguientePantalla = vc as! VerificationViewController
                        
                        siguientePantalla.user = newUser
                        siguientePantalla.code2verify = code
                        siguientePantalla.email = correo_U.text ?? " "
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Intente de nuevo", message: "No se pudo crear el usuario", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                    }

                    
                }catch{
                    let alert = UIAlertController(title: "Intente de nuevo", message: "No se pudo crear el usuario", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                    
                }
                
                sender.isUserInteractionEnabled = true
            }
            
        }
        
        sender.isUserInteractionEnabled = true
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        
    }
     */

}
