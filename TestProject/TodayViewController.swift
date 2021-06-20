//
//  TodayViewController.swift
//  TestProject
//
//  Created by Mihailo Jovanovic on 18.6.21..
//

import UIKit
import CoreLocation
import FirebaseFirestore

class TodayViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var db: Firestore?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Today"
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
         //Start Firestore setup
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // End Firestore setup
        db = Firestore.firestore()
    }
    
    private func updateUI(with model: FiveWeatherModel) {
        DispatchQueue.main.async {
            self.weatherImage.image = UtilityHelper.unwrapImage(with: model.list[0].weather[0].icon)
            self.cityLabel.text = "\(model.city.name), \(model.city.country)"
            self.temperatureLabel.text = "\(String(round(model.list[0].main.temp))) °C "
            self.weatherLabel.text = model.list[0].weather[0].main
            self.humidityLabel.text = String(model.list[0].main.humidity)
            self.rainLabel.text = String(model.list[0].pop)
            self.pressureLabel.text = "\(String(model.list[0].main.pressure)) hPa" 
            self.windLabel.text = "\(String(round(model.list[0].wind.speed))) km/h"
            self.directionLabel.text = model.city.country
        }
    }
    
    @IBAction func shareButtonDidPressed(_ sender: Any) {
        let currentTemperature = "\(cityLabel.text!) \(temperatureLabel.text!)"
        let activityViewController =
            UIActivityViewController(activityItems: [currentTemperature],
                                     applicationActivities: nil)

        present(activityViewController, animated: true)
    }
    
    func sendFirestoreData(with model: FiveWeatherModel) {
        var ref: DocumentReference? = nil
        guard let db = db else { return }
        ref = db.collection("weather").addDocument(data: [
            "city": "\(model.city.name), \(model.city.country)",
            "temperature": model.list[0].main.temp,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}

extension TodayViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loaderViewController = LoadingViewController()
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            presentLoader(loader: loaderViewController)
            WeatherData.shared.getWeatherData(longitude: lon, latitude: lat) { [weak self] weatherModel, error in
                guard let self = self else { return }
                self.hideLoader(loader: loaderViewController)
                
                if let error = error {
                    self.presentOKAlert(message: error.errorDescription)
                } else {
                    guard let weatherModel = weatherModel else { return }
                    self.updateUI(with: weatherModel)
                    self.sendFirestoreData(with: weatherModel)
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentOKAlert(message: error.localizedDescription)
    }
}
