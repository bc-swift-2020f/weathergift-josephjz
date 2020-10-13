//  LocationListViewController .swift
//  The Weather Gift App
//
//  Created by Jennifer Joseph
//
//  App built with Professor Gallaugher's Swift for iOS App Development Textbook Chapter 6

import UIKit
import GooglePlaces

// WILL THIS STILL SHOW IN GITHUB 

// changed class ViewController name from ViewController to
class LocationListViewController: UIViewController {
    
    // @IBOutlet for Table View -- drag over from Table View NOT Table View Cell
    @IBOutlet weak var tableView: UITableView!
    
    
    // @IBOutlets for Bar Buttons
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    // creates empty array with elements of type WeatherLocation structs from WeatherLocation.swift file
    var weatherLocations: [WeatherLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate weatherLocations array -- create 3 WeatherLocation variables and append them to array declared in class
        // when you type WeatherLocation( XCode will fill in all the variable types defined in struct
        var weatherLocation = WeatherLocation(name: "Chestnut Hill, MA", latitude: 0, longitude: 0)
        weatherLocations.append(weatherLocation)
        
        weatherLocation = WeatherLocation(name: "Lilongwe, Malawi", latitude: 0, longitude: 0)
        weatherLocations.append(weatherLocation)
        
        weatherLocation = WeatherLocation(name: "Buenos Aires, Argentina", latitude: 0, longitude: 0)
        weatherLocations.append(weatherLocation)
        
        
        // REMEMBER: if you use a Table View, MUST ALSO SET delegate and data source to self
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    // @IBActions for Bar Buttons
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        // check if table view is in editing mode
        if tableView.isEditing {
            // body of if block does the opposite of else block -- write else first then opposite of everything here!
            // note: animated value is still true
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
            
        } else {
            // Set tableView.isEditing to True (animated value is also true
            tableView.setEditing(true, animated: true)
            
            // Set Title of Edit button to "Done" using sender as button that was pressed (aka Edit button)
            sender.title = "Done"
            
            // disable Add bar button
            addBarButton.isEnabled = false
        }
        
    }
    
    @IBAction func addLocationPressed(_ sender: UIBarButtonItem) {
        
        // from Google Place Autocomplete
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
}



// Table View Methods in an Extension
// make sure to add delegate and data source after :, and then "add protocol stubs" when stop sign shows up
extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // numberOfRowsInSection returns value, aka count of Data Source array
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // where we configure our cell
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        
        //  accesses Subtitle text in Cell in Table View
        cell.detailTextLabel?.text = "Latitutde:\(weatherLocations[indexPath.row].latitude)  Longitude:\(weatherLocations[indexPath.row].longitude)"
        
        return cell
    }
    
    
    
    // Following 2 tableView functions are for MOVING and DELETING functionalities
    
    // Move
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Move data by...
        //      deleting data from source indexPath.row,
        //      and inserting that data at destination indexPath.row
        
        // NOTE: need a copy of source data because we are going to delete it first
        let itemToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    
    // Delete (also works for Insert)
    // asks the data source to commit the insertion or deletion of a specified row in the receiver
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // pass index value of element to remove as argument --- this removes element from array
            weatherLocations.remove(at: indexPath.row)
            // this removes row from table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}



// from Google Place Autocomplete
extension LocationListViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    
    
    // using a nil coalescing operator here, ??, for the case that the place you're searching for does not have a name
    // remember how ?? work --> if place.name is NOT nil, then unwrap the String literal and use it in place.name
    // if it is nil, then use the string to the right of ??
    let newLocation = WeatherLocation(name: place.name ?? "Unknown Place", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    
    // appends newLocation to list
    weatherLocations.append(newLocation)
    
    // if you forget this line, the new update wont show!
    tableView.reloadData()
    
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}

