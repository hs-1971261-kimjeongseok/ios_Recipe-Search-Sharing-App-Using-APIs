//
//  MapViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by b2u on 2024/05/23.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setInitialLocation()
    }

    @IBAction func zoomOut(_ sender: Any) {
        let region = mapView.region
        let span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * 2, longitudeDelta: region.span.longitudeDelta * 2)
        let newRegion = MKCoordinateRegion(center: region.center, span: span)
        mapView.setRegion(newRegion, animated: true)
    }

    @IBAction func zoomIn(_ sender: Any) {
        let region = mapView.region
        let span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta / 2, longitudeDelta: region.span.longitudeDelta / 2)
        let newRegion = MKCoordinateRegion(center: region.center, span: span)
        mapView.setRegion(newRegion, animated: true)
    }

    @IBAction func backClicked(_ sender: Any) {
        do {
                try Auth.auth().signOut()
                    self.dismiss(animated: true, completion: nil)
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
    }

    func setInitialLocation() {
        let initialCoordinate = CLLocationCoordinate2D(latitude: 37.554722, longitude: 126.970833)
        let region = MKCoordinateRegion(center: initialCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        searchNearbyParks(at: location.coordinate)
        
        locationManager.stopUpdatingLocation()
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.region.center
        searchNearbyParks(at: center)
    }

    func searchNearbyParks(at coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "park"
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.mapView.removeAnnotations(self.mapView.annotations)

            for item in response.mapItems {
                if item.pointOfInterestCategory == .park {
                    self.addMarker(at: item.placemark.coordinate, title: item.name ?? "Park")
                }
            }
        }
    }

    func addMarker(at coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = ParkAnnotation(title: title, coordinate: coordinate)
        mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ParkAnnotation else { return nil }

        let identifier = "parkAnnotation"
        var view: ParkAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ParkAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = ParkAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
        }

        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation as? ParkAnnotation else { return }

            // UITabBarController를 통해 ListViewController로 전환
            if let tabBarController = self.tabBarController,
               let viewControllers = tabBarController.viewControllers {
                for vc in viewControllers {
                    if let listViewController = vc as? ListViewController {
                        
                        if(listViewController.tmp){
                            listViewController.reloadData()
                        }
                        
                        tabBarController.selectedViewController = listViewController
                    }
                }
            }
        }
}
