//
//  LocationViewModel.swift
//  MyLocation
//
//  Created by Mohammed Ibrahim on 12/4/22.
//

import CoreData
import UIKit

struct LocationViewModel{
    //MARK: - Properties
    var data = Box([Location]())
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userdefaults = UserDefaults.standard
    
    
    //MARK: - Init
    init(){
        loadData()
    }
    
    //MARK: - Methods
    func getLocation(_ row : Int) -> String {
        return "lat : \(data.value[row].lat) / lon :  \(data.value[row].lon)"
    }
    
    func getTime(_ row : Int) -> String {
        if let date = data.value[row].date {
            return "\(date)"
        }
        return "\(Date.now)"
    }
    
    func getCount() -> Int {
        return data.value.count
    }
    
    func checkInterval() -> Bool {
        var diff = 0.0
        if let lastUpdate = userdefaults.date(forKey: Keys.LastUpdatedTime) {
            diff  = minutesBetweenDates(lastUpdate, Date.now)
            print("\(diff)")
            if diff > 10 {
                return true
            }
            else {
                return false
            }
        }
        else
        {
            setLastUpdate()
            return false
        }
    }
    
    func setLastUpdate(){
        userdefaults.set(date: Date.now, forKey: Keys.LastUpdatedTime)
    }
    
    
    func loadData(){
        let request : NSFetchRequest<Location>  = Location.fetchRequest()
        do{
            data.value = try context.fetch(request)
            print("Fetching Done")
        }
        catch{
            print("Error in load data\(error)")
        }
    }
    
    func saveData(location : LocationModel){
        do{
            let newLocation = Location(context: self.context)
            newLocation.lat = location.lat
            newLocation.lon = location.lon
            newLocation.date = Date.now
            try context.save()
            loadData()
        }
        catch{
            print("Error in save data\(error)")
        }
    }
    
    func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60
        return CGFloat(newDateMinutes - oldDateMinutes)
    }
}


 //MARK: - UserDefaults
extension UserDefaults {
    func set(date: Date?, forKey key: String){
        self.set(date, forKey: key)
    }
    
    func date(forKey key: String) -> Date? {
        return self.value(forKey: key) as? Date
    }
}


