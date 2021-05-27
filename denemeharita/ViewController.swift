//
//  ViewController.swift
//  denemeharita
//
//  Created by erdem öden on 24.05.2021.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    var selected = MKPointAnnotation();
    let location = CLLocationManager();
    var chosenlatitude = Double();
    var chosenlongitude = Double();
    var gonderlat = Double();
    var gonderlong = Double();
    var ids = [UUID]();
    var coordinates = [CLLocationCoordinate2D]();
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(chooselocation(gesture:)))
        gesture.minimumPressDuration = 3;
        // Do any additional setup after loading the view.
        map.addGestureRecognizer(gesture);
        //getdata();
    }
    override func viewWillAppear(_ animated: Bool) {
        getdata();
    }
    @objc func gec(){
        print("merhaba")
    }
    @objc func chooselocation(gesture:UILongPressGestureRecognizer){
        if(gesture.state == .began){
            let touches = gesture.location(in: self.map);
            let coordinate = self.map.convert(touches, toCoordinateFrom: self.map)
            let anotation = MKPointAnnotation();
            anotation.coordinate = coordinate;
            chosenlatitude = coordinate.latitude;
            chosenlongitude = coordinate.longitude;
            anotation.title = "New Anotation"
            anotation.subtitle = "New Place"
            self.map.addAnnotation(anotation);
            savedata();
            
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        location.stopUpdatingLocation();
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation is MKUserLocation){
            return nil
        }
        var anotview = map.dequeueReusableAnnotationView(withIdentifier: "view")
        if(anotview == nil){
            anotview = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "view")
            anotview?.canShowCallout = true;
        }
        else{
            anotview?.annotation = annotation;
        }
        
        return anotview
        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        if(segue.identifier == "silgec"){
            if let destination = segue.destination as? secondvc{
            destination.latitude = gonderlat;
            destination.longitude = gonderlong;
                
            }
        }
    }
   
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if(view.annotation is MKUserLocation){
            print(" ");
        }
        else{
            for i in stride(from: 0, through: coordinates.count-1, by: 1){
                if(coordinates[i].latitude == view.annotation?.coordinate.latitude && coordinates[i].longitude == view.annotation?.coordinate.longitude){
                    gonderlat = coordinates[i].latitude;
                    gonderlong = coordinates[i].longitude;
                    print("merhaba");
                }
            }
            performSegue(withIdentifier: "silgec", sender: nil);
            
        }
    }
    
    func getdata(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate;
        let context = appdelegate.persistentContainer.viewContext;
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Locations");
        fetch.returnsObjectsAsFaults = false;
        do {
            let datas =  try context.fetch(fetch)
            if(datas.count > 0){
            for data in datas as! [NSManagedObject] {
                let annotation = MKPointAnnotation();
                chosenlongitude = data.value(forKey: "longitude") as! Double;
                chosenlatitude = data.value(forKey: "latitude") as! Double;
                coordinates.append(CLLocationCoordinate2D(latitude: chosenlatitude, longitude: chosenlongitude));
                let coordinate = CLLocationCoordinate2D(latitude: chosenlatitude , longitude: chosenlongitude);
                annotation.coordinate = coordinate;
                annotation.title = "New Anotation"
                annotation.subtitle = "New Place"
                self.map.addAnnotation(annotation);
            }
                
            }
            else{
                print("olmadı");
            }
        }
        catch{
        print("error");
        }
    }
    func savedata(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate;
        let context = appdelegate.persistentContainer.viewContext;
        let save = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: context);
        save.setValue(chosenlatitude, forKey: "latitude");
        save.setValue(chosenlongitude, forKey: "longitude");
        coordinates.append(CLLocationCoordinate2D(latitude: chosenlatitude, longitude: chosenlongitude));
        save.setValue(UUID(), forKey: "id");
        do{
            try context.save()
            
        }
        catch{
            print("error");
        }
    }
    

}
