//
//  Cyber_BookingTests.swift
//  Cyber_BookingTests
//
//  Created by Victoria Estefania Vazquez Morales on 9/10/22.
//

import XCTest
@testable import Cyber_Booking // importar tu app

final class Cyber_BookingTests: XCTestCase {
    
    var sut:loginViewController!
    var userId:Int = -1
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //Instanciar el viewController donde se hace la prueba
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
        sut = storyboard.instantiateViewController(withIdentifier: "login_") as? loginViewController
                
        sut.loadViewIfNeeded()
        
        setValues()
        
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogin() async throws{
        // Se prueba que el usuario pueda iniciar sesión
        
        let expectation = XCTestExpectation(description: "User loged in")
        
        // given
        
        //when
        
        do{
            let ans = try await sut.sendLoginData()
            print(ans.msg)
            
            if ans.msg == "Accesado"{
                expectation.fulfill()
                userId = ans.id ?? -1
            }
            
        }catch{
            XCTFail()
        }
        
        wait(for: [expectation], timeout: 5.0)
        print("------------ \(userId) ----------")
        
        //then
        XCTAssertTrue(userId != -1)
        // si el userId es diferente de -1, es que se obtuvo el id del usuario que hace login y es un entero >= 0
        
    }
    
    func setValues(){
        sut.correoTextField.text! = "a01654095@tec.mx" // Credenciales incorrectas
        sut.passTextField.text! = "adminAdmin#1"
        
        //sut.correoTextField.text! = "admin@admin.com" // Credenciales correctas
        //sut.passTextField.text! = "adminAdmin#1"
    }
    
    func getId()->Int{
        return appDelegate.user_id
    }
    
    
}
