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

    
    func interfaceController(_ interfaceController: CPInterfaceController, didConnectWith window: CPWindow) {

        carplayInterefaceController = interfaceController
        carplayInterefaceController!.delegate = self
        sessionConfiguration = CPSessionConfiguration(delegate: self)
        carWindow = window
        
        var tabTemplates = [CPTemplate]()
        
        let mapitem =   MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 23.030357, longitude: 72.517845)))
        let poi = CPPointOfInterest(location: mapitem, title: "London", subtitle: "", summary: "", detailTitle: "", detailSubtitle: "", detailSummary: "", pinImage: .actions)
        
        let mapTemplate = CPPointOfInterestTemplate(title: "Hello", pointsOfInterest: [poi], selectedIndex: 0)
        mapTemplate.pointOfInterestDelegate = self
        let tabTemplate = CPTabBarTemplate(templates: [mapTemplate])
        mapTemplate.tabTitle = "Map"
        mapTemplate.tabImage = UIImage(systemName: "map")
        
 
        tabTemplates.append(baseMapTemplate)
        tabTemplates.append(FilterTemplate())
        tabTemplates.append(ChargerTemplate())
        tabTemplates.append(FavouriteTemplate())
        
//        setupMap()
//        window.rootViewController = MapViewcontroller
        self.carplayInterefaceController!.setRootTemplate(CPTabBarTemplate(templates: tabTemplates), animated: true, completion: nil)
//        self.carplayInterefaceController?.setRootTemplate(baseMapTemplate, animated: true, completion: nil)
        
    }

    func interfaceController(_ interfaceController: CPInterfaceController, didDisconnectWith window: CPWindow) {
        carplayInterefaceController = nil
        carWindow?.isHidden = true
    }
    
    
    func setupMap() {
        let pointOfInterestTemplate = CPPointOfInterestTemplate(
            title: "Hoagie Options",
            pointsOfInterest: [],
            selectedIndex: NSNotFound)
        pointOfInterestTemplate.pointOfInterestDelegate = self
        pointOfInterestTemplate.tabTitle = "Map"
        pointOfInterestTemplate.tabImage = UIImage(systemName: "car")!
        
        let tabTemplate = CPTabBarTemplate(templates: [pointOfInterestTemplate])
        
        carplayInterefaceController?.setRootTemplate(tabTemplate, animated: true, completion: { (done, error) in
            // Note: Ensure that 12 is the maximum POI locations that appear on the display.
        })
    }
    
    
    

//    func showGridTemplate() {
//        let gridTemplate = CPGridTemplate.favouriteGridTemplate(compatibleWith: Viewcontroller.traitCollection){
//            button in self.showListTemplate(title: button.titleVariants.first ?? "Favorites")
//        }
//        carplayInterefaceController?.pushTemplate(gridTemplate, animated: true, completion: { (_, _) in
//        })
//    }
//
//    func showListTemplate(title: String){
//        let listTemplate = CPListTemplate.searchResultsListTemplate(compatibleWith: Viewcontroller.traitCollection, title: title, interfaceController: carplayInterefaceController)
//        carplayInterefaceController?.pushTemplate(listTemplate, animated: true, completion: { (_ , _ ) in })
//    }
    
    private func MapTemplate() -> CPPointOfInterestTemplate {
        let mapitem =   MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 23.030357, longitude: 72.517845)))
        let poi = CPPointOfInterest(location: mapitem, title: "London", subtitle: "", summary: "", detailTitle: "", detailSubtitle: "", detailSummary: "", pinImage: .actions)
        let mapTemplate = CPPointOfInterestTemplate(title: "Hello", pointsOfInterest: [poi], selectedIndex: 0)
        mapTemplate.tabTitle = "Map"
        mapTemplate.tabImage = UIImage(systemName: "map")
        mapTemplate.pointOfInterestDelegate = self
        return mapTemplate
    }
    
    func pointOfInterestTemplate(_ pointOfInterestTemplate: CPPointOfInterestTemplate, didChangeMapRegion region: MKCoordinateRegion) {
        print("printed")
    }
    
    
    // MARK: - CPMapTemplate creation
    func createMapTemplate() -> CPMapTemplate {
        // Create the default CPMapTemplate objcet (you may subclass this at your leasure)
        let mapTemplate = CPMapTemplate()
    
        let zoomInButton = CPMapButton { _ in
//            zoomInAction()
        }
        zoomInButton.isHidden = false
        zoomInButton.isEnabled = true
        zoomInButton.image = UIImage(named: "ZoomIn", in: Bundle.main, compatibleWith: MapViewcontroller.traitCollection)

        let zoomOutButton = CPMapButton { _ in
//            zoomOutAction()
        }
        zoomOutButton.isHidden = false
        zoomOutButton.isEnabled = true
        zoomOutButton.image = UIImage(named: "ZoomOut", in: Bundle.main, compatibleWith: MapViewcontroller.traitCollection)

        mapTemplate.mapButtons = [zoomInButton, zoomOutButton]
        mapTemplate.automaticallyHidesNavigationBar = false
        
        return mapTemplate
    }
    
    
    private func FilterTemplate() -> CPListTemplate {
        let reggae = CPListItem(text: "Reggae", detailText: "Relax and feel good.")
        reggae.setImage(UIImage(systemName: "sun.max")!)
   
        
        let jazz = CPListItem(text: "Jazz", detailText: "How about some smooth jazz.")
        jazz.setImage(UIImage(systemName: "music.note.house")!)
      
        
        let alternative = CPListItem(text: "Alternative", detailText: "Catch a vibe.")
        alternative.setImage(UIImage(systemName: "guitars.fill")!)
      
        
        let hipHop = CPListItem(text: "Hip-Hop", detailText: "Play the latest jams.")
        hipHop.setImage(UIImage(systemName: "music.mic")!)
      
        
        let songCharts = CPListItem(text: "Check the Top Song Charts", detailText: "See what's trending.")
        songCharts.setImage(UIImage(systemName: "chart.bar.fill")!)
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
        let template = CPListTemplate(title: "Filter", sections: [CPListSection(items: [reggae, jazz, alternative, hipHop, songCharts])])
        template.tabImage = UIImage(systemName: "line.horizontal.3.decrease.circle")
        return template
    }
    
    private func ChargerTemplate() -> CPListTemplate {
        let reggae = CPListItem(text: "Reggae", detailText: "Relax and feel good.")
        reggae.setImage(UIImage(systemName: "sun.max")!)
   
        
        let jazz = CPListItem(text: "Jazz", detailText: "How about some smooth jazz.")
        jazz.setImage(UIImage(systemName: "music.note.house")!)
      
        
        let alternative = CPListItem(text: "Alternative", detailText: "Catch a vibe.")
        alternative.setImage(UIImage(systemName: "guitars.fill")!)
      
        
        let hipHop = CPListItem(text: "Hip-Hop", detailText: "Play the latest jams.")
        hipHop.setImage(UIImage(systemName: "music.mic")!)
      
        
        let songCharts = CPListItem(text: "Check the Top Song Charts", detailText: "See what's trending.")
        songCharts.setImage(UIImage(systemName: "chart.bar.fill")!)
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
        let reggae = CPListItem(text: "Reggae", detailText: "Relax and feel good.")
        reggae.setImage(UIImage(systemName: "sun.max")!)
   
        
        let jazz = CPListItem(text: "Jazz", detailText: "How about some smooth jazz.")
        jazz.setImage(UIImage(systemName: "music.note.house")!)
      
        
        let alternative = CPListItem(text: "Alternative", detailText: "Catch a vibe.")
        alternative.setImage(UIImage(systemName: "guitars.fill")!)
      
        
        let hipHop = CPListItem(text: "Hip-Hop", detailText: "Play the latest jams.")
        hipHop.setImage(UIImage(systemName: "music.mic")!)
      
        
        let songCharts = CPListItem(text: "Check the Top Song Charts", detailText: "See what's trending.")
        songCharts.setImage(UIImage(systemName: "chart.bar.fill")!)
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
        let template = CPListTemplate(title: "Favourites", sections: [CPListSection(items: [reggae, jazz, alternative, hipHop, songCharts])])
        template.tabImage = UIImage(systemName: "heart")
        return template
    }
    
    
}
