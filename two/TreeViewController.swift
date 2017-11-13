//
//  TreeViewController.swift
//  two
//
//  Created by shuji on 2017/10/12.
//  Copyright © 2017年 shuji. All rights reserved.
//

import UIKit

let APIKey = "47cc43c58bf9d0b3b2b6592ae8d4d757"
class TreeViewController: UIViewController,MAMapViewDelegate {

    var mapView:MAMapView?
    var customUserLocationView: MAAnnotationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.shared().apiKey = APIKey
        // Do any additional setup after loading the view.
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        
        self.title = "微头条"
        self.view.backgroundColor = UIColor.purple
        mapView!.showsUserLocation = true
    
        mapView!.customizeUserLocationAccuracyCircleRepresentation = true
        
        mapView!.userTrackingMode = MAUserTrackingMode.follow
        
        mapView!.distanceFilter = 10.0
        mapView!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
       
        
        self.view.addSubview(mapView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAUserLocation.self) {
            let pointReuseIndetifier = "userLocationStyleReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.image = UIImage.init(named: "userPosition")
            
            self.customUserLocationView = annotationView
            
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(_ mapView:MAMapView!, rendererFor overlay:MAOverlay) -> MAOverlayRenderer! {
        if(overlay.isEqual(mapView.userLocationAccuracyCircle)) {
            let circleRender = MACircleRenderer.init(circle:mapView.userLocationAccuracyCircle)
            circleRender?.lineWidth = 2.0
            circleRender?.strokeColor = UIColor.lightGray
            circleRender?.fillColor = UIColor.red.withAlphaComponent(0.3)
            return circleRender
        }
        
        return nil
    }
    
    func mapView(_ mapView:MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation:Bool ) {
        if(!updatingLocation && self.customUserLocationView != nil) {
            UIView.animate(withDuration: 0.1, animations: {
                let degree = userLocation.heading.trueHeading - Double(self.mapView!.rotationDegree)
                let radian = (degree * Double.pi) / 180.0
                self.customUserLocationView.transform = CGAffineTransform.init(rotationAngle: CGFloat(radian))
            })
        }
    }    
    
 
    
    
}
