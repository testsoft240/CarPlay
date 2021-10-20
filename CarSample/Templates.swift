//
//  Templates.swift
//  CarSample
//
//  Created by MAC240 on 20/10/21.
//

import Foundation
import CarPlay

extension CPGridTemplate {
    
    private typealias GridButton = (title: String, imageName: String)
    
    static func favouriteGridTemplate(compatibleWith traitCollection: UITraitCollection, _buttonHandler: @escaping (CPGridButton) -> Void) -> CPGridTemplate {
        let buttons = [
            GridButton(title: "Parks", imageName: "gridParks"),
            GridButton(title: "Beaches", imageName: "gridBeaches"),
            GridButton(title: "Presents", imageName: "gridPresents"),
            GridButton(title: "Desserts", imageName: "gridDesserts")
        ]
        
        let gridTemplate = CPGridTemplate(title: "Favourites", gridButtons: buttons.map {(button) -> CPGridButton in
            return CPGridButton(titleVariants: [button.title], image: UIImage(named: button.imageName, in: Bundle.main, compatibleWith: traitCollection) ?? UIImage(), handler: _buttonHandler)
            
        })
        return gridTemplate
    }
}


extension CPListTemplate {

    static func searchResultsListTemplate(compatibleWith traitCollection: UITraitCollection,
                                          title: String,
                                          interfaceController: CPInterfaceController?) -> CPListTemplate {

        let item = CPListItem(text: "Jupiter Rd",
                              detailText: "1 Jupiter Rd",
                              image: UIImage(named: "grid\(title)", in: Bundle.main, compatibleWith: traitCollection),
                              accessoryImage: nil,
                              accessoryType: .disclosureIndicator)
        
        item.handler = { item, completion in
            /// In your application, you might extract the destination the user selected rather than navigate to the same place every time :
            // guard let destination = item.userInfo as? MKMapItem else { completionHandler(); return }
            interfaceController?.popToRootTemplate(animated: true) {_, _ in
//                TemplateManager.shared.beginNavigation()
            }
        }
        
        let section = CPListSection(items: [item])
        let listTemplate = CPListTemplate(title: title, sections: [section])
        return listTemplate
    }
}
