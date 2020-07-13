//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 7/6/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let titleErrorMessage = "Error"
    private var arePhotosFromNetwork = false
    private var photosUrlList: [PhotoUrl] = []
    private var photos: [Photo] = []
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateMapViewLocation()
        FlickrAPI.getListOfPhotosUrl(latitude: String(pin.latitude), longitude: String(pin.longitude),
                                     page: "1", completionHandler: photosUrlResponseHandler(photos:error:))
    }
    
    private func photosUrlResponseHandler(photos: [PhotoUrl], error: String?) {
        if (error != nil) {
            showAlertMessage(title: titleErrorMessage, message: error!)
            return
        }
        photosUrlList = photos
        collectionView.reloadData()
        arePhotosFromNetwork = true
    }
    
    private func updateMapViewLocation(){
        let location = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        var region: MKCoordinateRegion = self.mapView.region
        region.center = location
        region.span.longitudeDelta /= 8.0
        region.span.latitudeDelta /= 8.0
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arePhotosFromNetwork ? photosUrlList.count : photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.progressIndicator.startAnimating()
        
        
        return cell
    }
    
}
