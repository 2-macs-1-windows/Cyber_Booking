//
//  ReservarHardwareViewController.swift
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

class ReservarHardwareViewController: UIViewController {

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
    
    // Botón de reservar
    @IBAction func didTapButton() {
        showAlert()
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
        
        // USAR LOS SWITCH TAL VEZ
        fechaInicioPicker.preferredDatePickerStyle = .wheels
        fechaInicioTextField.inputView = fechaInicioPicker
        fechaInicioTextField.inputAccessoryView = createToolbar()
        
        fechaFinPicker.preferredDatePickerStyle = .wheels
        fechaFinTextField.inputView = fechaFinPicker
        fechaFinTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        // formato de la fecha
        let dateFormatter = DateFormatter()
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
        
        return hardware[row].name
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
        
        hardwareTextField.text = hardware[row].name
        hardwareTextField.resignFirstResponder()
        
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
}
