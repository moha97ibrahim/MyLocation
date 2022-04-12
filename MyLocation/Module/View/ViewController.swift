//
//  ViewController.swift
//  MyLocation
//
//  Created by Mohammed Ibrahim on 12/4/22.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let locationViewModel = LocationViewModel()
    let locationManager = CLLocationManager()
    var locationData = [Location]()
    static let shared = ViewController()
    
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initLocation()
        initTableView()
        
    }
    
    
    //MARK: - Methods
    func initLocation(){
        let status = locationManager.authorizationStatus
        
        if(status == .denied || status == .notDetermined || status == .restricted) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.startMonitoringSignificantLocationChanges()
        startUpdatingLocation()
        
    }
    
    func initTableView(){
        tableView.dataSource = self
        tableView.register(UINib(nibName: Keys.CellNibName, bundle: nil), forCellReuseIdentifier: Keys.CellIdentitfier)
        tableView.separatorStyle = .none
        self.locationViewModel.data.bind{ data in
            self.locationData = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("data updated")
            }
            
        }
    }
    
    
    func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocationI(){
        locationManager.stopUpdatingLocation()
    }
    
    func startMonitoringSignificantLocationChanges(){
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges(){
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func restartMonitoring(){
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
}


//MARK: - UITableViewDataSource
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationViewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.CellIdentitfier, for: indexPath) as! LocationTableViewCell
        cell.locationLabel.text = locationViewModel.getLocation(indexPath.row)
        cell.timeLabel.text = locationViewModel.getTime(indexPath.row)
        return cell
    }
}

//MARK: - CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        if locationViewModel.checkInterval(){
            locationViewModel.setLastUpdate()
            locationViewModel.saveData(location: LocationModel(lat: lat , lon: lon))
        }
    }
}

