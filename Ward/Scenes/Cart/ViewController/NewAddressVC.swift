//
//  NewAddressVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/17/21.
//

import UIKit
import MapKit
import SVProgressHUD

class NewAddressVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var addressType_tf: UITextField!
    @IBOutlet weak var area_tf: UITextField!
    @IBOutlet weak var buildingType_tf: UITextField!
    @IBOutlet weak var buildingName_tf: UITextField!
    @IBOutlet weak var floorNo_tf: UITextField!
    @IBOutlet weak var apartmentNo_tf: UITextField!
    @IBOutlet weak var landmark_tf: UITextField!
    @IBOutlet weak var phoneNO_tf: UITextField!
    
    var isAddAddress: Bool = false
    var location: CLLocationCoordinate2D?
    var addressName: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView(){
        
        
        if isAddAddress{
            
            let myLocation = MKPointAnnotation()
            myLocation.coordinate = CLLocationCoordinate2D(latitude: location?.latitude ?? 0.0 , longitude: location?.longitude ?? 0.0)
            mapView.addAnnotation(myLocation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            self.address_lbl.text = addressName
            
        }else{
            let lat = UDHelper.UserCoordinates.lat
            let long = UDHelper.UserCoordinates.long
            let address = UDHelper.address
            
            let myLocation = MKPointAnnotation()
            myLocation.coordinate = CLLocationCoordinate2D(latitude: lat , longitude: long)
            mapView.addAnnotation(myLocation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            self.address_lbl.text = address
        }
        
    }
    
    private func saveAddress(){
        
        guard let addressType = addressType_tf.text, !addressType.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        
        guard let area = area_tf.text, !area.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        guard let buildingType = buildingType_tf.text, !buildingType.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        guard let buildingName = buildingName_tf.text, !buildingName.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        guard let floorNo = floorNo_tf.text, !floorNo.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        guard let apartmentNo = apartmentNo_tf.text, !apartmentNo.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        guard let landmark = landmark_tf.text, !landmark.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        guard let phoneNO = phoneNO_tf.text, !phoneNO.isEmpty else {
            ToastManager.shared.showToast(message: "Please enter the data", view: self.view, postion: .top, backgroundColor: .systemRed)
            return
        }
        
        var lat: Double = 0.0
        var long: Double = 0.0
        
        if isAddAddress{
            lat = location?.latitude ?? 0.0
            long = location?.longitude ?? 0.0
        }else{
            lat = UDHelper.UserCoordinates.lat
            long = UDHelper.UserCoordinates.long
        }
        
        
        SVProgressHUD.show()
        APIManagerAddAddress.addAddress(name: addressType, area: area, building_type: buildingType, floor_number: floorNo, building_name_number: buildingName, landmark: landmark, apartment_number: apartmentNo, phone_number: phoneNO, address_lat: lat, address_lng: long, is_default: 0) { result in
            SVProgressHUD.dismiss()
            if result.status == 201{
                print("Save Address Succesfuuly")
                UDHelper.addressID = result.data?.address?.id ?? 0
                ToastManager.shared.showToast(message: "Save Address Successfully", view: self.view, postion: .top, backgroundColor: .systemGreen)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    
                    if self.isAddAddress{
                        for vc in self.navigationController!.viewControllers {
                            if let myViewCont = vc as? AddressesVC
                            {
                                self.navigationController?.popToViewController(myViewCont, animated: true)
                            }
                        }
                    }else{
                        for vc in self.navigationController!.viewControllers {
                            if let myViewCont = vc as? CartDetailesSecStepVC
                            {
                                myViewCont.user_address_exist = true
                                self.navigationController?.popToViewController(myViewCont, animated: true)
                            }
                        }
                    }
                }
            }else{
                print("Message: \(result.message ?? "")")
                print("Error: \(result.errors ?? [])")
                print("Save Address Failure")
            }
        }
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAddresTapped(_ sender: Any) {
        saveAddress()
    }
    
    
}

//MARK:- Make Annotaion ->>

extension NewAddressVC{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
}
