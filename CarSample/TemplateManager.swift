//
//  TemplateManager.swift
//  CarSample
//
//  Created by MAC240 on 20/10/21.
//

import Foundation
import CarPlay
import os

class TemplateManager: NSObject, CPInterfaceControllerDelegate,CPSessionConfigurationDelegate, CPMapTemplateDelegate {
    
    static let shared = TemplateManager()
    let Viewcontroller = ViewController()
    public private(set) var baseMapTemplate = CPMapTemplate()
    
    let MapViewcontroller = MKMapViewController()
    
    private var carplayInterefaceController: CPInterfaceController?
    private var carWindow: UIWindow?
    var sessionConfiguration: CPSessionConfiguration!
    
    
    override init() {
        super.init()
        sessionConfiguration = CPSessionConfiguration(delegate: self)
    }

    
    func interfaceController(_ interfaceController: CPInterfaceController, didConnectWith window: CPWindow) {

        carplayInterefaceController = interfaceController
        carplayInterefaceController!.delegate = self
        

        carWindow = window

        //Creating the tab sections
        let tabFav = CPListItem(text: "Favorites", detailText: "Subtitle For Favourites")
        let tabRecent = CPListItem(text: "Most Recent", detailText: "Subtitle For Most Recent")
        let tabHistory = CPListItem(text: "History", detailText: "Subtitle For History")
        let tabSearch = CPListItem(text: "Search", detailText: "Subtitle For Search")
        
        //adding the above tabs in section
        let sectionItemsA = CPListSection(items: [tabFav,tabRecent,tabHistory,tabSearch])
    
      
        tabFav.handler = { listItem, completion in
            TemplateManager.shared.showGridTemplate()
        }
        
     
        let sectionItemsB = CPListSection(items: [tabFav,tabHistory])
        
        let listTemplate = CPListTemplate(title: "", sections: [sectionItemsA])
        let listTemplateA = CPListTemplate(title: "", sections: [sectionItemsB])
        let listTemplateB = CPListTemplate(title: "", sections: [sectionItemsA])
        let listTemplateC = CPListTemplate(title: "", sections: [sectionItemsB])
        
        //Creating Tabs
        let tabA: CPListTemplate = listTemplate
        tabA.tabSystemItem = .favorites
        tabA.showsTabBadge = false
        
        let tabB  = listTemplateA
        tabB.tabSystemItem = .mostRecent
        tabB.showsTabBadge = true
        
        
        let tabC: CPListTemplate = listTemplateB
        tabC.tabSystemItem = .history
        tabC.showsTabBadge = false
        
        let tabD: CPListTemplate = listTemplateC
        tabD.tabSystemItem = .search
        tabD.showsTabBadge = false
    
    
        let tabBarTemplate = CPTabBarTemplate(templates: [tabA,tabB,tabC,tabD])

        let mapTemplate = CPMapTemplate.coastalRoadsMapTemplate(compatibleWith: MapViewcontroller.traitCollection, zoomInAction: {
//            self.mapViewController.zoomIn()
        }, zoomOutAction: {
//            self.mapViewController.zoomOut()
        })

        mapTemplate.mapDelegate = self
        baseMapTemplate = mapTemplate
        
     
        window.rootViewController = MapViewcontroller
        interfaceController.setRootTemplate(baseMapTemplate, animated: true) { (_, _) in }
        
        
    }

    func interfaceController(_ interfaceController: CPInterfaceController, didDisconnectWith window: CPWindow) {
        carplayInterefaceController = nil
        carWindow?.isHidden = true
    }

    func showGridTemplate() {
        let gridTemplate = CPGridTemplate.favouriteGridTemplate(compatibleWith: Viewcontroller.traitCollection){
            button in self.showListTemplate(title: button.titleVariants.first ?? "Favorites")
        }
        carplayInterefaceController?.pushTemplate(gridTemplate, animated: true, completion: { (_, _) in
        })
    }
    
    func showListTemplate(title: String){
        let listTemplate = CPListTemplate.searchResultsListTemplate(compatibleWith: Viewcontroller.traitCollection, title: title, interfaceController: carplayInterefaceController)
        carplayInterefaceController?.pushTemplate(listTemplate, animated: true, completion: { (_ , _ ) in })
    }
    
}
