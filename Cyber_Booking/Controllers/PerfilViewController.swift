//
//  PerfilViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

import UIKit

class PerfilViewController: UIViewController {
    
    // Textos
        @IBOutlet weak var userName: UILabel!
        
        @IBOutlet weak var numEspacios: UILabel!
        @IBOutlet weak var numHw: UILabel!
        @IBOutlet weak var numSw: UILabel!
        
        // Sacar el id del usuario como appDelegate.user_id
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Estructura para guardar el nombre del usuario
        struct UserData:Codable {
            var name: String
            var numReserveHw: Int
            var numReserveSw: Int
            var numReserveSpace: Int
        }
        
         // Obtener el usuario
         func fetchUsuario() async throws->UserData{
             
             let urlString = "http://127.0.0.1:8000/userData?id=\(await appDelegate.user_id)"
             let baseURL = URL(string: urlString)!
             
             let (data, response) = try await URLSession.shared.data(from: baseURL)

             guard let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 else {
             
                 throw ReservaError.itemNotFound
             }
             let jsonDecoder = JSONDecoder()
             do{
             
                 let usuarioData = try jsonDecoder.decode(UserData.self, from: data)
                 print(usuarioData)
                 return usuarioData
             }catch let jsonError as NSError{
                 print("JSON decode failed: \(jsonError)")
                 throw ReservaError.decodeError
             }
             
         }
    
    let userLog = "http://127.0.0.1:8000/logoutApp"
    
    struct answer: Codable {
        var msg: String
        var id: Int?
    }
    
    func logout() async throws->answer{
        let insertURL = URL(string: userLog)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["id": appDelegate.user_id])
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
    
    override func viewDidLoad() {
        
        Task {
            do {
                let usuario = try await fetchUsuario()
                
                userName.text = usuario.name
                numEspacios.text = String(usuario.numReserveSpace)
                numHw.text = String(usuario.numReserveHw)
                numSw.text = String(usuario.numReserveSw)
                
            } catch {
                print(error)
            }
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    

    @IBAction func logoutFunc(_ sender: Any) {
        Task{
            do{
                let is_logIn = try await logout()
                
                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainPage") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated:true, completion:nil)
                
            }catch let jsonError as NSError{
                print("JSON decode failed: \(jsonError)")
                let alert = UIAlertController(title: "Error de conexión", message: "No fue posible obtener la lista de usuarios", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                
                self.present(alert, animated: true, completion: nil)            }
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
