//
//  RunViewController.swift
//  Vitals
//
//  Created by Mariecor Maranoc on 11/19/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class RunViewController: UIViewController {
    
    
    
    @IBOutlet weak var launchPromptStackView: UIStackView!
    
    @IBOutlet weak var dataStackView: UIStackView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var paceLabel: UILabel!
    
    
    
    var run: Run?
    
    
    
    private let locationManager = LocationManager.shared
    
    private var seconds = 0
    
    private var timer: Timer?
    
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    var locationList: [CLLocation] = []
    
    
    
    private func startRun() {
        
        launchPromptStackView.isHidden = true
        
        dataStackView.isHidden = false
        
        startButton.isHidden = true
        
        stopButton.isHidden = false
        
        
        
        seconds = 0
        
        distance = Measurement(value: 0, unit: UnitLength.meters)
        
        locationList.removeAll()
        
        updateDisplay()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            self.eachSecond()
            
        }
        
        startLocationUpdates()
        
    }
    
    
    
    private func stopRun() {
        
        launchPromptStackView.isHidden = false
        
        dataStackView.isHidden = true
        
        startButton.isHidden = false
        
        stopButton.isHidden = true
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
    
    private func saveRun() {
        
        let newRun = Run(context: DataStack.context)
        
        newRun.distance = distance.value
        
        newRun.duration = Int16(seconds)
        
        newRun.date = Date() as NSDate as Date
        
        
        
        for location in locationList {
            
            let locationObject = Location(context: DataStack.context)
            
            locationObject.timestamp = location.timestamp as NSDate as Date
            
            locationObject.latitude = location.coordinate.latitude
            
            locationObject.longitude = location.coordinate.longitude
            
            newRun.addToLocations(locationObject)
            
        }
        
        
        
        DataStack.saveContext()
        
        
        
        run = newRun
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataStackView.isHidden = true
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
    
    func eachSecond() {
        
        seconds += 1
        
        updateDisplay()
        
    }
    
    
    
    private func updateDisplay() {
        
        let formattedDistance = Format.distance(distance)
        
        let formattedTime = Format.time(seconds)
        
        let formattedPace = Format.pace(distance: distance,
                                        
                                        seconds: seconds,
                                        
                                        outputUnit: UnitSpeed.milesPerMin)
        
        
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        
        timeLabel.text = "Time:  \(formattedTime)"
        
        paceLabel.text = "Pace:  \(formattedPace)"
        
    }
    
    
    
    private func startLocationUpdates() {
        
        locationManager.delegate = self
        
        locationManager.activityType = .fitness
        
        locationManager.distanceFilter = 10
        
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    @IBAction func startTapped() {
        
        startRun()
        
    }
    
    
    
    @IBAction func stopTapped() {
        
        let alertController = UIAlertController(title: "Run Complete!",
                                                
                                                message: "Record Your Run?",
                                                
                                                preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            
            self.stopRun()
            
            self.saveRun()
            
            self.performSegue(withIdentifier: .details, sender: nil)
            
        })
        
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            
            self.stopRun()
            
            _ = self.navigationController?.popToRootViewController(animated: true)
            
        })
        
        
        
        present(alertController, animated: true)
        
    }
    
    
    
}

extension RunViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case details = "RunDetailsViewController"
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
            
        case .details:
            
            let destination = segue.destination as! RunDetailsViewController
            
            destination.run = run
            
        }
        
    }
    
}

extension RunViewController: CLLocationManagerDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for newLocation in locations {
            
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                
                let delta = newLocation.distance(from: lastLocation)
                
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
            }
            
            
            
            locationList.append(newLocation)
            
        }
        
    }
    
}

extension RunViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let polyline = overlay as? MKPolyline else {
            
            return MKOverlayRenderer(overlay: overlay)
            
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        
        renderer.strokeColor = .green
        
        renderer.lineWidth = 2
        
        return renderer
        
    }
    
}
