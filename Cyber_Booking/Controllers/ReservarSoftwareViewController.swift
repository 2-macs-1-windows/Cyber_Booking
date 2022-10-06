//
//  ReservarSoftwareViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 25/09/22.
//

/*
 TODO
 - Alerta después de apretar el botón
 - Arreglar los pickers
 */

import UIKit

class ReservarSoftwareViewController: UIViewController {
    
    // Controladores
    var reservaControlador = ReservaSwController()

    // --- TextField outlets ---
    @IBOutlet weak var softwareTextField: UITextField!
    // @IBOutlet weak var duracionTextField: UITextField!
    @IBOutlet weak var fechaInicioTextField: UITextField!
    @IBOutlet weak var fechaFinTextField: UITextField!
    
    // --- lista de opciones ---
    var software = [Software]()
    
    // --- PickerViews de las opciones ---
    var softwarePickerView = UIPickerView()
    
    let fechaInicioPicker = UIDatePicker()
    let fechaFinPicker = UIDatePicker()
    
    // Para crear nueva reserva
    var fechaInicio = ""
    var fechaFin = ""
    var serviceId = "1"
    
    // Botón de reservar
    @IBAction func didTapButton() {
                
        // nueva reserva
        var reservaNueva = ReserveSw(serviceId: serviceId, booking_start: fechaInicio, booking_end: fechaFin)
        
        Task{
            do{
                try await reservaControlador.insertReserva(nuevareserva: reservaNueva)
                // self.updateUI()
                showAlert()
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
        softwareTextField.inputView = softwarePickerView
        
        // obtener las opciones internamente
        softwarePickerView.delegate = self
        softwarePickerView.dataSource = self
        
        // software
        let url = URL(string: "http://127.0.0.1:8000/api/software/")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
              if error == nil {
            do {
                self.software = try JSONDecoder().decode([Software].self, from: data!)
            } catch {
                print("Parse error")
            }
        }
        }.resume()
        
        
        // --- Agregar tag a los pickerView ---
        fechaInicioPicker.tag = 1
        fechaFinPicker.tag = 2
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
        
        // USAR LOS SWITCH TAL VEZ
        fechaInicioPicker.preferredDatePickerStyle = .inline
        fechaInicioTextField.inputView = fechaInicioPicker
        fechaInicioTextField.inputAccessoryView = createToolbar()
        
        fechaFinPicker.preferredDatePickerStyle = .inline
        fechaFinTextField.inputView = fechaFinPicker
        fechaFinTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        // formato de la fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        fechaInicio = dateFormatter.string(from: fechaInicioPicker.date) + "Z"
        fechaFin = dateFormatter.string(from: fechaFinPicker.date) + "Z"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // USAR LOS SWITCH
        
        self.fechaInicioTextField.text = dateFormatter.string(from: fechaInicioPicker.date)
        self.view.endEditing(true)
        
        self.fechaFinTextField.text = dateFormatter.string(from: fechaFinPicker.date)
        self.view.endEditing(true)
    }

}

// extension UIPickerViewDelegate
extension ReservarSoftwareViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Número de componentes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de renglones
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return software.count
        
        // va a regresar dependiendo del tag el número de row
        /*
        switch pickerView.tag {
        case 1:
            return software.count
        default:
            return 1
        }
         */
    }
    
    // Obtener las opciones para el pickView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return software[row].name
        /*
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            return software[row]
        default:
            return "Data not found"
        }
         */
    }
    
    // Que hacer con la opción selecionada
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        softwareTextField.text = software[row].name
        softwareTextField.resignFirstResponder()
        
        /*
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            softwareTextField.text = software[row]
            softwareTextField.resignFirstResponder()
        default:
            return
        }
         */
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
