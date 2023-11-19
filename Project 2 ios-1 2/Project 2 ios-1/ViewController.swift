//
//  ViewController.swift
//  Project 2 ios-1
//
//  Created by Athul Tony on 2023-04-11.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var tempSwitch: UISwitch!
    
    
    
    
    //MARK: - properties
    private var locationManager = CLLocationManager()
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var serviceCall = Network()
    private let loadingVc = LoadingViewController()
    private var isCelsius = true
    private var storedWeatherResponse: WeatherResponse?
    private var isSearching = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displaySampleImageForDemo()
        searchTextField.delegate = self
        serviceCall.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    //display keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if textField == searchTextField {
            if textField.text != "" {
                serviceCall.fetchWeather(query: textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        return true
    }
    
    
    private func displaySampleImageForDemo() {
        if #available(iOS 15.0, *) {
            let config = UIImage.SymbolConfiguration(paletteColors: [
                .black, .black, .black
                
            ])
            weatherConditionImage.preferredSymbolConfiguration = config
        } else {
            // Fallback on earlier versions
        }
        
        
        weatherConditionImage.image = UIImage(systemName: "sun.max")
    }
    

    @IBAction func onLocationTapped(_ sender: UIButton) {
        searchTextField.text = ""
        
        if let lat = self.latitude, let lon = self.longitude {
            serviceCall.fetchWeather(latitude: lat, longitude: lon)
        }else {
            locationManager.requestLocation()
        }
        
        
    }
    
    @IBAction func onSearchTapped(_ sender: UIButton) {
        if searchTextField.text != "" {
            serviceCall.fetchWeather(query: searchTextField.text!)
        }
    }
    
    
   @IBAction func onSwitchChange(_ sender: UISwitch) {
       isCelsius = sender.isOn
       guard let weatherResponse = storedWeatherResponse else { return }
       response(weatherResponse)
    }
    
}


extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat=location.coordinate.latitude
            let lon=location.coordinate.longitude
            self.latitude = lat
            self.longitude = lon
            if !isSearching {
                isSearching = true
                serviceCall.fetchWeather(latitude: lat, longitude: lon)
            }
            
        }
        
    }
    
    func locationManager(_  manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            // The user has granted permission.
            locationManager.startUpdatingLocation()
        } else {
            // The user has denied permission.
            print("The user has denied location permission.")
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           // Handle errors here
           print("Location manager failed with error: \(error.localizedDescription)")
       }
    
}


//Network calls
extension ViewController: WeatherNetworkProtocol {
    
    func response(_ weatherResponse: WeatherResponse) {
        locationManager.stopUpdatingLocation()
        storedWeatherResponse =  weatherResponse
        let code = weatherResponse.current.condition.code
        print("ConditionName:- \(weatherResponse.current.condition.conditionName)")
        DispatchQueue.main.async {
            self.locationLabel.text = weatherResponse.location.name
            self.temperatureLabel.text = "\(self.isCelsius ? weatherResponse.current.temp_c : weatherResponse.current.temp_f)"
            self.lblDegree.text = "\(self.isCelsius ? "C" : "F")"
            self.weatherConditionImage.image = UIImage(systemName: weatherResponse.current.condition.conditionName)
        }
        
    }
    
    func errorResponse(_ error: Errors) {
        print("An error occurred:- \(error.localizedDescription)")
    }
    
    func loadingStatus(_ isLoading: Bool) {
        
        print("IsLoading...... \(isLoading)")
        
        if isLoading {
            self.loadingVc.modalPresentationStyle = .custom
            self.loadingVc.show()
        }else {
            self.loadingVc.dismissLoading()
        }
    }
    
    
}
