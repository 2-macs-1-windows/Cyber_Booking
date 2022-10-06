//
//  ReservarHardwareViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 25/09/22.
//


import UIKit

class ReservarHardwareViewController: UIViewController {

    // Controladores
    var reservaControlador = ReservaHwController()
    
    // --- TextField outlets ---
    @IBOutlet weak var hardwareTextField: UITextField!
    // @IBOutlet weak var duracionTextField: UITextField!
    @IBOutlet weak var fechaInicioTextField: UITextField!
    @IBOutlet weak var fechaFinTextField: UITextField!
    
    // --- lista de opciones ---
    var hardware = [Hardware]()
    
    // --- PickerViews de las opciones ---
    var hardwarePickerView = UIPickerView()
    
    let fechaInicioPicker = UIDatePicker()
    let fechaFinPicker = UIDatePicker()
    
    // Para crear nueva reserva
    var fechaInicio = ""
    var fechaFin = ""
    var service_id = "1"
    
    // Botón de reservar
    @IBAction func didTapButton() {
        
        // nueva reserva
        let reservaNueva = ReserveHw(service_id: service_id, booking_start: fechaInicio, booking_end: fechaFin)
        
        // Insertar la nueva reserva en el servidor
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
        hardwareTextField.inputView = hardwarePickerView
        
        // obtener las opciones internamente
        hardwarePickerView.delegate = self
        hardwarePickerView.dataSource = self
        
        // hardwares
        let url = URL(string: "http://127.0.0.1:8000/api/hardware/")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
              if error == nil {
            do {
                self.hardware = try JSONDecoder().decode([Hardware].self, from: data!)
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
        
        // Mostrar los Datepicker como calendario y asignar la opción en textField
        fechaInicioPicker.preferredDatePickerStyle = .inline
        fechaInicioTextField.inputView = fechaInicioPicker
        fechaInicioTextField.inputAccessoryView = createToolbar()
        
        fechaFinPicker.preferredDatePickerStyle = .inline
        fechaFinTextField.inputView = fechaFinPicker
        fechaFinTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        // formato de la fecha para Django
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
extension ReservarHardwareViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Número de componentes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de renglones
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return hardware.count

    }
    
    // Obtener las opciones para el pickView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return hardware[row].name
    }
    
    // Que hacer con la opción selecionada
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        hardwareTextField.text = hardware[row].name
        
        // asignar el service_id como el row para la nueva reserva
        service_id = String(row + 1)
        
        hardwareTextField.resignFirstResponder()
        
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
