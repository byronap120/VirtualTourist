//
//  LocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 6/19/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Foundation

class LocationsMapViewController: UIViewController , MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var pinList: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        getPinList()
        addMapAnnotations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoAlbum" {
            let photoAlbumViewController = segue.destination as! PhotoAlbumViewController
            let pin = sender as! Pin
            photoAlbumViewController.pin = pin
        }
    }
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer? = nil) {
        guard let location = sender?.location(in: mapView) else { return }
        addLocationOnMapView(location: location)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let location = sender?.location(in: mapView) else { return }
        addLocationOnMapView(location: location)
    }
    
    private func addLocationOnMapView(location: CGPoint){
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        savePin(coordinate: coordinate)
    }
    
    private func addMapAnnotations() {
        var annotations = [CustomPin]()
        for pin in pinList {
            let annotation = createCustomAnotationFrom(pin: pin)
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    private func createCustomAnotationFrom(pin: Pin) -> CustomPin {
        let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let annotation = CustomPin()
        annotation.pin = pin
        annotation.coordinate = coordinate
        return annotation
    }
    
    private func getPinList(){
        guard let managedContext = getManagedContext() else{
            return
        }
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            pinList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    private func savePin(coordinate: CLLocationCoordinate2D){
        guard let managedContext = getManagedContext() else{
            return
        }
        
        let pin = Pin(context: managedContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        pin.currentPage = 0
        
        do {
            try managedContext.save()
            mapView.addAnnotation(createCustomAnotationFrom(pin: pin))
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let customPin = view.annotation as? CustomPin
        self.performSegue(withIdentifier: "showPhotoAlbum", sender: customPin?.pin)
    }
    
    
}

