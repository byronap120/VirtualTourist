//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 7/6/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let titleErrorMessage = "Error"
    private let coreDataErrorMessage = "Core Data error: "
    private let alertMessageTitle = "Alert"
    private let alertMessage = "No Images for this location"
    private let numberOfCellsPortrait: CGFloat = 3.0
    private let numberOfCellsLandscape: CGFloat = 6.0
    private let minimunSpace: CGFloat = 1.0
    private let dimensionSpace: CGFloat = 6.0
    private var arePhotosFromNetwork = false
    private var photosUrlList: [PhotoUrl] = []
    private var photos: [Photo] = []
    var pin: Pin!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateFlowLayoutDimensions(size: view.frame.size, numberOfCells: numberOfCellsPortrait)
        updateMapViewLocation()
        getLocalPhotos()
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
    
    private func getLocalPhotos(){
        guard let managedContext = getManagedContext() else{
            return
        }
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        do {
            let photos = try managedContext.fetch(fetchRequest)
            if photos.isEmpty {
                getPhotosFromNetwork(page: 0)
            } else {
                self.photos = photos
                self.collectionView.reloadData()
            }
        } catch let error as NSError {
            print(coreDataErrorMessage + error.localizedDescription)
        }
    }
    
    private func getPhotosFromNetwork(page: Int) {
        FlickrAPI.getListOfPhotosUrl(latitude: String(pin.latitude), longitude: String(pin.longitude),page: page, completionHandler: photosUrlResponseHandler(photoUrlList:error:))
    }
    
    private func photosUrlResponseHandler(photoUrlList: [PhotoUrl], error: String?) {
        if (error != nil) {
            showAlertMessage(title: titleErrorMessage, message: error!)
            return
        }
        
        if(photoUrlList.count == 0) {
            showAlertMessage(title: alertMessageTitle, message: alertMessage)
            return
        }
        
        photosUrlList = photoUrlList
        arePhotosFromNetwork = true
        collectionView.reloadData()
    }
    
    private func saveNewPhoto(url: String, data: Data){
        guard let managedContext = getManagedContext() else{
            return
        }
        
        let photo = Photo(context: managedContext)
        photo.url = url
        photo.image = data
        photo.pin = pin
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(coreDataErrorMessage + error.localizedDescription)
        }
    }
    
    private func showIndicatorOnCell(cell: PhotoCollectionViewCell , show: Bool){
        if(show) {
            cell.progressIndicator.startAnimating()
            cell.progressIndicator.isHidden = false
        } else {
            cell.progressIndicator.stopAnimating()
            cell.progressIndicator.isHidden = true
        }
    }
    
    private func updateFlowLayoutDimensions(size: CGSize, numberOfCells: CGFloat){
        let dimension = (size.width - dimensionSpace) / numberOfCells
        flowLayout?.minimumInteritemSpacing = minimunSpace
        flowLayout?.minimumLineSpacing = minimunSpace
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arePhotosFromNetwork ? photosUrlList.count : photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoCollectionViewCell
        showIndicatorOnCell(cell: cell, show: true)
        if(arePhotosFromNetwork) {            
            let photoUrl = photosUrlList[indexPath.item].url
            FlickrAPI.getImageDataFromUrl(imageUrl: photoUrl) { (image: UIImage, imageData: Data) in
                cell.imageView.image = image
                self.saveNewPhoto(url: photoUrl, data: imageData)
                self.showIndicatorOnCell(cell: cell, show: false)
            }
        } else {
            let photo = photos[indexPath.item]
            cell.imageView.image = UIImage(data: photo.image!)
            showIndicatorOnCell(cell: cell, show: false)
        }
        
        return cell
    }
    
    
    
}
