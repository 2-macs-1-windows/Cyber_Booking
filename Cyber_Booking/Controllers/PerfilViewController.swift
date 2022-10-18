//
//  PerfilViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

import UIKit
import Charts

class PerfilViewController: UIViewController, ChartViewDelegate {
    
    // Chart
    @IBOutlet weak var pieChart: PieChartView!
    
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
             
             let urlString = "http://20.89.70.3:8000/userData?id=\(appDelegate.user_id)"
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
    
    let userLog = "http://20.89.70.3:8000/logoutApp"
    
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
    
    // Chart
    func setUpPieChart(_ usuario:UserData) {
        pieChart.chartDescription.enabled = true
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
        pieChart.rotationEnabled = false
        pieChart.isUserInteractionEnabled = false
        
        var entries: [PieChartDataEntry] = Array()
        
        entries.append(PieChartDataEntry(value: Double(usuario.numReserveSpace), data: "Espacios"))
        entries.append(PieChartDataEntry(value: Double(usuario.numReserveHw), data: "Hardware"))
        entries.append(PieChartDataEntry(value: Double(usuario.numReserveSw), data: "Software"))
        
        print(entries)
        
        let dataSet = PieChartDataSet(entries: entries, label: "Reservaciones hechas")
        
        dataSet.colors = [.green, .red, .blue]
        
        let data = PieChartData(dataSet: dataSet)
        
        let l = pieChart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        // chartView.legend = l
               
       let pFormatter = NumberFormatter()
       pFormatter.numberStyle = .percent
       pFormatter.maximumFractionDigits = 1
       pFormatter.multiplier = 1
       pFormatter.percentSymbol = " %"
       data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
       
       data.setValueFont(.systemFont(ofSize: 20, weight: .bold))
       data.setValueTextColor(.white)
       
       pieChart.data = data
        
    }
    
    override func viewDidLoad() {
        
        Task {
            do {
                let usuario = try await fetchUsuario()
                // updateUI(with: usuario) FALTA
                
                userName.text = usuario.name
                numEspacios.text = String(usuario.numReserveSpace)
                numHw.text = String(usuario.numReserveHw)
                numSw.text = String(usuario.numReserveSw)
                
                setUpPieChart(usuario)
                
            } catch {
                print(error)
            }
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    /*
    func updateUI(with reservas:ReservasSpaces){
        DispatchQueue.main.async {
            self.reservasSpaces = reservas
            self.tableView.reloadData()
        }
    }
     */
    

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
