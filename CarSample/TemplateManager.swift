//
//  TemplateManager.swift
//  CarSample
//
//  Created by MAC240 on 20/10/21.
//

import Foundation
import CarPlay
import os

class TemplateManager: NSObject, CPInterfaceControllerDelegate,CPSessionConfigurationDelegate, CPMapTemplateDelegate, CPPointOfInterestTemplateDelegate {
  
    
    static let shared = TemplateManager()
    let Viewcontroller = ViewController()
    public private(set) var baseMapTemplate = CPMapTemplate()
    
    let MapViewcontroller = MKMapViewController()
    
    private var carplayInterefaceController: CPInterfaceController?
    private var carWindow: UIWindow?
    var sessionConfiguration: CPSessionConfiguration!
    
    
    override init() {
        super.init()
     
    }

    
    func interfaceController(_ interfaceController: CPInterfaceController, didConnectWith window: CPWindow? = nil) {

        carplayInterefaceController = interfaceController
        carplayInterefaceController!.delegate = self
        sessionConfiguration = CPSessionConfiguration(delegate: self)
        carWindow = window
        
        var tabTemplates = [CPTemplate]()
       
 
        tabTemplates.append(MapTemplate())
        tabTemplates.append(FilterTemplate())
        tabTemplates.append(ChargerTemplate())
        tabTemplates.append(FavouriteTemplate())

        self.carplayInterefaceController!.setRootTemplate(CPTabBarTemplate(templates: tabTemplates), animated: true, completion: nil)
        
    }

    func interfaceController(_ interfaceController: CPInterfaceController, didDisconnectWith window: CPWindow) {
        carplayInterefaceController = nil
        carWindow?.isHidden = true
    }
    
 
    func pointOfInterestTemplate(_ pointOfInterestTemplate: CPPointOfInterestTemplate, didChangeMapRegion region: MKCoordinateRegion) {
        print("printed")
    }
    
    
    
    private func MapTemplate() -> CPPointOfInterestTemplate {
        let mapitem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 23.030357, longitude: 72.517845)))
        let mapitem1 = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 21.764473, longitude: 72.151932)))
        
        let poi = CPPointOfInterest(location: mapitem, title: "Cove Road", subtitle: "5003.9 mi away", summary: "", detailTitle: "Cove Road", detailSubtitle: "San Francisco", detailSummary: "Available $4" , pinImage: UIImage(named: "charging-station"))
        
        let button = CPTextButton(title: "Details", textStyle: .normal, handler: { (button) in
//            MemoryLogger.shared.appendEvent("Order tapped \(place).")
//            self.showOrderTemplate(place: place)
            self.showDetailTemplate()
        })
        poi.primaryButton = button
        
//        poi.primaryButton?.title = "Details"
//        poi.secondaryButton?.title = "Detail"
        let poi1 = CPPointOfInterest(location: mapitem1, title: "CP QA UK IES OCPP TEST", subtitle: "5022.83 mi away", summary: "", detailTitle: "", detailSubtitle: "", detailSummary: "", pinImage: UIImage(named: "charging-station"))
        let mapTemplate = CPPointOfInterestTemplate(title: "EV Stations", pointsOfInterest: [poi, poi1], selectedIndex: NSNotFound)
   
        mapTemplate.tabTitle = "Map"
        mapTemplate.tabImage = UIImage(systemName: "map")
        mapTemplate.pointOfInterestDelegate = self
    
        return mapTemplate
    }
   
    func pointOfInterestTemplate(_ pointOfInterestTemplate: CPPointOfInterestTemplate, didSelectPointOfInterest pointOfInterest: CPPointOfInterest) {
        print("Point of interest \(pointOfInterest.title)")
//        showDetailTemplate()
    }
    
    func showDetailTemplate() {
        let cpinfo = CPInformationItem(title: "Starbucks cove Road Services, Hampsire", detail: "GU51 2SH")
        let cpinfo1 = CPInformationItem(title: "Cost", detail: "$0.4/kwh (Parking Charges may apply)")
        
        let chargeButton = CPTextButton(title: "Start Charge", textStyle: .confirm) { (btn) in
            print("charging")
        }
        
        let stopchargeButton = CPTextButton(title: "Stop Charge", textStyle: .cancel) { (btn) in
            print("charging")
        }
      
        let detailTemplate = CPInformationTemplate(title: "Cove Road", layout: .twoColumn, items: [cpinfo,cpinfo1], actions: [chargeButton,stopchargeButton])
        carplayInterefaceController?.pushTemplate(detailTemplate, animated: true) { (_, _) in }
    }
    
    private func FilterTemplate() -> CPGridTemplate {
        let gridTemp = CPGridTemplate.favouriteGridTemplate(compatibleWith: Viewcontroller.traitCollection) { (btn) in
            self.showListTemplate(title: btn.titleVariants.first ?? "Favorites")
        }
        carplayInterefaceController?.pushTemplate(gridTemp, animated: true) { (_, _) in }
        let cpinfo = CPInformationItem(title: "Distance", detail: "Less than 10 miles")
               let cpinfo1 = CPInformationItem(title: "Status", detail: "Availale")
               let cpinfo2 = CPInformationItem(title: "Current Type", detail: "DC")
               let cpinfo3 = CPInformationItem(title: "Networks", detail: "Instvolt")
               let template = CPInformationTemplate(title: "", layout: .twoColumn, items: [cpinfo,cpinfo1,cpinfo2,cpinfo3], actions: [])
        gridTemp.tabTitle = "Filters"
        gridTemp.tabImage = UIImage(systemName: "line.horizontal.3.decrease.circle")
        return gridTemp
    }
    
    private func ChargerTemplate() -> CPListTemplate {
        let reggae = CPListItem(text: "COVE ROAD", detailText: "5358.44 mi away")
        
        reggae.handler = { item, completion in
            self.showDetailTemplate()
        }
        
        let jazz = CPListItem(text: "KEITH", detailText: "8.02 mi away")
        let alternative = CPListItem(text: "CASTLEBAY", detailText: "4993.53 mi away")
        let hipHop = CPListItem(text: "ARKLESTON", detailText: "5022.83 mi away")
        let songCharts = CPListItem(text: "UNIVERSE", detailText: "5033.18 mi away")
      
//        songCharts.handler = { item, completion in
//            AppleMusicAPIController.sharedController.searchSongCharts(completion: { items in
//                if let items = items {
//                    MemoryLogger.shared.appendEvent("Chart count \(items.count).")
//                    if items.count > 1 {
//                        self.createListFromCharts(charts: items)
//                    } else if let firstSet = items.first?.data {
//                        self.currentQueue = firstSet
//                        AppleMusicAPIController.playWithItems(items: firstSet.compactMap({ (song) -> String in
//                            return song.identifier
//                        }))
//                    }
//                } else {
//                    MemoryLogger.shared.appendEvent("Song count 0.")
//                }
//                completion()
//            })
//        }
        let template = CPListTemplate(title: "Charger", sections: [CPListSection(items: [reggae, jazz, alternative, hipHop, songCharts])])
        template.tabImage = UIImage(systemName: "bolt.fill.batteryblock")
        return template
    }
    
    private func FavouriteTemplate() -> CPListTemplate {
//        let reggae = CPListItem(text: "Reggae", detailText: "Relax and feel good.")
//        let jazz = CPListItem(text: "Jazz", detailText: "How about some smooth jazz.")
//        let alternative = CPListItem(text: "Alternative", detailText: "Catch a vibe.")
//        let hipHop = CPListItem(text: "Hip-Hop", detailText: "Play the latest jams.")
        let jazz = CPListItem(text: "KEITH", detailText: "8.02 mi away")
        
        jazz.handler = { item, completion in
            self.showDetailTemplate()
        }
        
        let alternative = CPListItem(text: "CASTLEBAY", detailText: "4993.53 mi away")
        
//        let songCharts = CPListItem(text: "Check the Top Song Charts", detailText: "See what's trending.")
//        songCharts.setImage(UIImage(systemName: "chart.bar.fill")!)
//        songCharts.handler = { item, completion in
//            AppleMusicAPIController.sharedController.searchSongCharts(completion: { items in
//                if let items = items {
//                    MemoryLogger.shared.appendEvent("Chart count \(items.count).")
//                    if items.count > 1 {
//                        self.createListFromCharts(charts: items)
//                    } else if let firstSet = items.first?.data {
//                        self.currentQueue = firstSet
//                        AppleMusicAPIController.playWithItems(items: firstSet.compactMap({ (song) -> String in
//                            return song.identifier
//                        }))
//                    }
//                } else {
//                    MemoryLogger.shared.appendEvent("Song count 0.")
//                }
//                completion()
//            })
//        }
        
    
        
        let template = CPListTemplate(title: "Favourites", sections: [CPListSection(items: [jazz, alternative])])
        template.tabImage = UIImage(systemName: "heart")
        return template
    }
    
    
    func showGridTemplate() {

        let gridTemp = CPGridTemplate.favouriteGridTemplate(compatibleWith: Viewcontroller.traitCollection) { (btn) in
            self.showListTemplate(title: btn.titleVariants.first ?? "Favorites")
        }
        carplayInterefaceController?.pushTemplate(gridTemp, animated: true) { (_, _) in }
    }

    func showListTemplate(title: String) {
        let listTemplate = CPListTemplate.searchResultsListTemplate(
            compatibleWith: Viewcontroller.traitCollection,
            title: title,
            interfaceController: carplayInterefaceController)
        carplayInterefaceController?.pushTemplate(listTemplate, animated: true) { (_, _) in }
    }
    
    
}
