//
//  TemplateManager.swift
//  CarSample
//
//  Created by MAC240 on 20/10/21.
//

import Foundation
import CarPlay
import os

class TemplateManager: NSObject, CPInterfaceControllerDelegate,CPSessionConfigurationDelegate {
    
    static let shared = TemplateManager()
    let mapViewController = MapViewController()
    
    private var carplayInterefaceController: CPInterfaceController?
    private var carWindow: UIWindow?
    
    func showGridTemplate() {
        let gridTemplate = CPGridTemplate.favouriteGridTemplate(compatibleWith: mapViewController.traitCollection){
            button in self.showListTemplate(title: button.titleVariants.first ?? "Favorites")
        }
        carplayInterefaceController?.pushTemplate(gridTemplate, animated: true, completion: { (_, _) in
        })
    }
    
    func showListTemplate(title: String){
        let listTemplate = CPListTemplate.searchResultsListTemplate(compatibleWith: mapViewController.traitCollection, title: title, interfaceController: carplayInterefaceController)
        carplayInterefaceController?.pushTemplate(listTemplate, animated: true, completion: { (_ , _ ) in })
    }
    
}
