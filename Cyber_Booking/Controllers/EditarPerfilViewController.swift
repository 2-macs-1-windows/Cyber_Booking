//
//  EditarPerfilViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 6/10/22.
//

import UIKit

class EditarPerfilViewController: UIViewController {
    
    // Sacar el id del usuario como appDelegate.user_id
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nombreTxtField: UITextField!
    @IBOutlet weak var apellidoTxtField: UITextField!
    @IBOutlet weak var telefonoTxtField: UITextField!
    @IBOutlet weak var contraTxtField: UITextField!
    @IBOutlet weak var confContraTxtField: UITextField!
    
    var is_validPass:Bool = false
    var is_passMatch:Bool = false
    var is_validTel:Bool = false
    var is_validNamAp:Bool = false
    
    struct usuario:Codable{
        var name:String
        var last_name:String
        var phone:Int
        var contra:String? = ""
        var id:Int?
    }
    
    struct answer: Codable {
        var msg: String
        var id: Int?
    }
    
    //------------Verificar nombre y apellido -------------
    func verificarNomAp() {
        let validName = "^[a-zA-ZÀ-ÿñÑ]+$"
        
        if(nombreTxtField.text?.range(of: validName, options: .regularExpression) == nil || apellidoTxtField.text?.range(of: validName, options: .regularExpression) == nil){
            
            is_validNamAp = false

        } else {
            
            is_validNamAp = true
        }
    }
    
    //------------Verificar match de passwords -------------
    func checkMatchingPass(){
        
        if(contraTxtField.text != confContraTxtField.text){
            let alert = UIAlertController(title: "Verifique las contraseñas", message: "Las contraseñas no coiniciden", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
                is_passMatch = false

        } else {
            is_passMatch = true
        }
    }
    
    //------------Verificar password valido -------------
    func verificaPassword() {
        
       let validPass = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?¿!¡@$ %^&*-_]).{10,}$"
       
       if(contraTxtField.text?.range(of: validPass, options: .regularExpression) == nil){
   
           is_validPass = false
           
       } else {
           is_validPass = true
       }
       
       
   }
    
    //------------ Verificar teléfono -------------
    func verificarTel() {
        let validTel = "^[0-9]+$"
        
        if(telefonoTxtField.text?.range(of: validTel, options: .regularExpression) == nil){
            let alert = UIAlertController(title: "Verifique su teléfono", message: "El número de teléfono debe contener solo dígitos", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            is_validTel = false
        } else {
            is_validTel = true
        }
    }
    
    //------------ Obtener datos del usuario -------------
    func getUserData() async throws->usuario{
        let urlString = "http://20.89.70.3:8000/getUser?id=\( appDelegate.user_id)"
        
        let baseURL = URL(string: urlString)!
        
        let (data, response) = try await URLSession.shared.data(from: baseURL)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
        
            throw ReservaError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        do{
        
            let user = try jsonDecoder.decode(usuario.self, from: data)
            
            return user
        }catch let jsonError as NSError{
            print("JSON decode failed: \(jsonError)")
            throw ReservaError.decodeError
        }
        
    }
    
    //------------ Actualizar datos del usuario -------------
    func setUserInfo() async throws->answer{
        var setUser = "http://20.89.70.3:8000/editUser"
        let insertURL = URL(string: setUser)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(usuario(name: nombreTxtField.text ?? "", last_name: apellidoTxtField.text ?? "", phone: Int(telefonoTxtField.text ?? "0") ?? 0,contra: contraTxtField.text ?? "", id: appDelegate.user_id))
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
        
        Task{
            do{
                let user = try await getUserData()
                
                nombreTxtField.text = user.name
                apellidoTxtField.text = user.last_name
                telefonoTxtField.text = String(user.phone)
                
            }catch let jsonError as NSError{
                print("JSON decode failed: \(jsonError)")
                let alert = UIAlertController(title: "Error de conexión", message: "No fue posible conectar con el servidor", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                
                self.present(alert, animated: true, completion: nil)            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func guardarCambios(_ sender: UIButton) {
        
        verificarTel()
        checkMatchingPass()
        verificarNomAp()
        verificarNomAp()
        
        if contraTxtField.text != "" && confContraTxtField.text != ""{
            verificaPassword()
        } else {
            is_validPass = true
            is_passMatch = true
            
            contraTxtField.text = ""
            confContraTxtField.text = ""
        }
        
        
        //******Poner verif de nombres 
        
        if nombreTxtField.text == "" ||
            apellidoTxtField.text == "" ||
            telefonoTxtField.text == ""{
            
            let alert = UIAlertController(title: "Campos vacíos", message: "El nombre, el apellido y el teléfono son campos obligatorios", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if  !is_validNamAp{
            let alert = UIAlertController(title: "Caracteres inválidos", message: "El nombre y el apellido deben contener solo letras", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if !is_validTel{
            let alert = UIAlertController(title: "Teléfono inválido", message: "El número de teléfono debe contener solo dígitos", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if !is_validPass{
            let alert = UIAlertController(title: "Verifique su contraseña", message: "Debe tener por lo menos 10 caracteres de longitud, incluir 1 mayúscula, 1 minúscula, 1 número y un caracter especial (#?¿!¡@$ %^&*-_)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if !is_passMatch{
            let alert = UIAlertController(title: "Verifique las contraseñas", message: "Las contraseñas no coinciden", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            Task{
                do{
                    let ans = try await setUserInfo()
                    
                    if ans.msg == "cambio realizado"{
                        let alert = UIAlertController(title: "Cambios guardados", message: "Sus cambios han sido registrados", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }catch let jsonError as NSError{
                    print("JSON decode failed: \(jsonError)")
                    let alert = UIAlertController(title: "Error de conexión", message: "No fue posible conectar con el servidor", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                    
                    self.present(alert, animated: true, completion: nil)            }
            }
        }
        
    }
    
    
    func eliminarUsuario() async throws->answer{
        let setUser = "http://20.89.70.3:8000/noUserApp"
        let insertURL = URL(string: setUser)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["id":appDelegate.user_id])
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
    
    
    func showAlert(){

        let alert = UIAlertController(title: "Borrar cuenta", message: "¿Está seguro de que desea borrar su cuenta?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: { _ in
        
        }))

        alert.addAction(UIAlertAction(title: "Borrar", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in

            
            Task{
                do{
                    let eliminado = try await self.eliminarUsuario()
                    
                    if eliminado.msg == "usuario eliminado"{
                        
                        let storyboard = UIStoryboard(name:"Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MainPage") as UIViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated:true, completion:nil)
                    }
                
                    
                }catch let jsonError as NSError{
                    print("JSON decode failed: \(jsonError)")
                    let alert = UIAlertController(title: "Error de conexión", message: "No fue posible eliminar el usuario", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                    
                    self.present(alert, animated: true, completion: nil)            }
            }
            
        }))
    
        self.present(alert, animated: false, completion: nil)

    }
    
    @IBAction func borrarCuenta(_ sender: UIButton) {
        showAlert()
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
