//
//  GetLocationVC.swift
//  Halak
//
//  Created by Elattar on 3/16/21.
//  Copyright © 2021 Elattar. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class GetLocationVC: UIViewController {
    
    @IBOutlet weak var getLocation: UIButton!
    
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    let name = Notification.Name(dismissNotfiactionKey)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation.setView(corner: 12)
  
    }
    
    private func saveAddress(lat: Double, long: Double){
        SVProgressHUD.show()
        APIManagerAddAddress.addAddress(name: "", area: "", building_type: "", floor_number: "", building_name_number: "", landmark: "", apartment_number: "", phone_number: "", address_lat: lat, address_lng: long, is_default: 1) { result in
            SVProgressHUD.dismiss()
            if result.status == 201{
                print("Save Address Succesfuuly")
                UDHelper.addressID = result.data?.address?.id ?? 0
                ToastManager.shared.showToast(message: "Save Address Successfully", view: self.view, postion: .top, backgroundColor: .systemGreen)
            }else{
                print("Message: \(result.message ?? "")")
                print("Error: \(result.errors ?? [])")
                print("Save Address Failure")
            }
        }
    }

    
    @IBAction func getLocation_btn(_ sender: Any) {
        //MapVC
        let sb = UIStoryboard(name: "GetLocation", bundle: nil).instantiateViewController(withIdentifier: "MapVC") as! MapVC
        sb.modalPresentationStyle = .overFullScreen
        sb.delegate = self
        present(sb, animated: true, completion: nil)
    }
    
    @IBAction func skip_btn(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        let sb = UIStoryboard(name: "CTMain", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC")
        window.rootViewController = sb
        UIView.transition(with: window, duration: 0.5, options: .curveEaseOut, animations: nil, completion: nil)
    }
    
}

extension GetLocationVC: coordinateLocation{
    func locationCoordinate(Coordinate: CLLocationCoordinate2D) {
        GetAddress.getcurrentaddress(location: Coordinate) { (address)  in
            let lat = Coordinate.latitude
            let long = Coordinate.longitude
            UDHelper.UserCoordinates = (lat: lat, long: long)
            UDHelper.address = address ?? ""
            NotificationCenter.default.post(name: self.name, object: nil)
            print("Address: \(address)")
            self.dismiss(animated: true, completion: nil)
            
//            guard let window = UIApplication.shared.keyWindow else {return}
//            let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar")
//            window.rootViewController = sb
//            UIView.transition(with: window, duration: 1, options: .transitionFlipFromTop, animations: nil, completion: nil)
            
            if UDHelper.token != ""{
                self.saveAddress(lat: lat, long: long)
            }else{
                print("not auth to save address")
            }
            
        }
        
        
        print("Iam in Order Completion \(latitude), \(longitude)")
    }
    
}
