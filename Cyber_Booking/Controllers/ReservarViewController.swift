//
//  ReservarViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

/*
 TODO
 - Alerta después de apretar el botón
 */

import UIKit

class ReservarViewController: UIViewController {
    
    struct answer: Codable {
        var msg: String

    }
    
    // Sacar el id del usuario como appDelegate.user_id
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Controladores
    var reservaControlador = ReservaSpacesController()
    
    // --- TextField outlets ---
    @IBOutlet weak var salonTextField: UITextField!
    @IBOutlet weak var horaFinTextField: UITextField!
    // @IBOutlet weak var duracionTextField: UITextField!
    @IBOutlet weak var horaInicioTextField: UITextField!
    
    
    // --- lista de opciones ---
    var salones = [Space]()
    // let duraciones = ["1 hora", "2 horas", "3 horas", "4 horas"]
    
    // --- PickerViews de las opciones ---
    var salonPickerView = UIPickerView()
    // var duracionPickerView = UIPickerView()
    let horaInicioPicker = UIDatePicker()
    let horaFinPicker = UIDatePicker()
    
    // para crear nueva reserva
    var horaInicio = ""
    var horaFin = ""
    var service_id = "1"
    
    // Botón de reservar
    @IBAction func didTapButton() {
        // nueva reserva
        let reservaNueva = ReserveSpace(service_id: service_id, booking_start: horaInicio, booking_end: horaFin)
        
        // Insertar la nueva reserva en el servidor
        Task{
            do{
                let ans = try await reservaControlador.insertReserva(nuevareserva: reservaNueva)
                
                print(ans.msg)
                
                if ans.msg == "reservado" {
                    showAlert()
                    
                    try await enviarCorreo()
                    // self.updateUI()
                } else {
                    let alert = UIAlertController(title: "Horario ocupado", message: "Favor de seleccionar otro rango de horario", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel))
                    
                    present(alert, animated: true)
                }
                
            }catch{
                displayError(ReservaError.itemNotFound, title: "No se puede insertar la reserva")
            }
        }
    }
    
    // mostrar alerta
    func showAlert() {
        let alert = UIAlertController(title: "Reservación registrada", message: "Se guardo la información de tu reservación", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Hecho", style: .cancel))
        
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fecha y hora
        createDatepicker()
        
        // tomar las opciones del pickView en el textField visualmente
        salonTextField.inputView = salonPickerView
        // duracionTextField.inputView = duracionPickerView
        
        // obtener las opciones internamente
        salonPickerView.delegate = self
        salonPickerView.dataSource = self
        
        // duracionPickerView.delegate = self
        // duracionPickerView.dataSource = self
        
        // salones
        let url = URL(string: "http://20.89.70.3:8000/api/spaces/")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
              if error == nil {
            do {
                self.salones = try JSONDecoder().decode([Space].self, from: data!)
            } catch {
                print("Parse error")
            }
        }
        }.resume()
        
        // --- Agregar tag a los pickerView ---
        salonPickerView.tag = 1
        // duracionPickerView.tag = 2
    }
    
    // Enviar correo
    func enviarCorreo() async throws->answer{
        let insertURL = URL(string: "http://20.89.70.3:8000/emailSP")!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["user_id":appDelegate.user_id])
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

    // --- Fecha y hora ---
    func createToolbar() -> UIToolbar {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func createDatepicker() {
        horaInicioPicker.datePickerMode = .time
        horaInicioPicker.preferredDatePickerStyle = .wheels
        horaInicioTextField.inputView = horaInicioPicker
        horaInicioTextField.inputAccessoryView = createToolbar()
        
        horaFinPicker.datePickerMode = .time
        horaFinPicker.preferredDatePickerStyle = .wheels
        horaFinTextField.inputView = horaFinPicker
        horaFinTextField.inputAccessoryView = createToolbar()
        
    }
    
    @objc func donePressed() {
        // TODO formato de la hora :(
        
        // formato de la fecha para Django
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // para crear nueva reserva
        horaInicio = dateFormatter.string(from: horaInicioPicker.date)
        horaFin = dateFormatter.string(from: horaFinPicker.date)
        
        // print(dateFormatter.string(from: horaInicioPicker.date) + "Z")
        // print(dateFormatter.string(from: horaFinPicker.date) + "Z")
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        
        self.horaInicioTextField.text = dateFormatter.string(from: horaInicioPicker.date)
        self.view.endEditing(true)
        
        self.horaFinTextField.text = dateFormatter.string(from: horaFinPicker.date)
        self.view.endEditing(true)
        
    }
}

// extension UIPickerViewDelegate
extension ReservarViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Número de componentes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de renglones
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // va a regresar dependiendo del tag el número de row
        switch pickerView.tag {
        case 1:
            return salones.count
        // case 2:
            //return duraciones.count
        default:
            return 1
        }
    }
    
    // Obtener las opciones para el pickView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            return salones[row].name
        // case 2:
            // return duraciones[row]
        default:
            return "Data not found"
        }
    }
    
    // Que hacer con la opción selecionada
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            salonTextField.text = salones[row].name
            
            service_id = String(row + 1)
            salonTextField.resignFirstResponder()
        //case 2:
            //duracionTextField.text = duraciones[row]
            //duracionTextField.resignFirstResponder()
        default:
            return
        }
    }
    
    // Alerta de error
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
