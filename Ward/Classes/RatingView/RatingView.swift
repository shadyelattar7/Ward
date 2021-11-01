//
//  RatingView.swift
//  PizzaWorld
//
//  Created by Shadi Elattar on 7/18/21.
//

import Foundation
import UIKit


class RatingView: UIView{
    //MARK:- UI Private Configurations
    private let maximumRating = 5
    
    
    //MARK:- UI Public Configurations
    var rating = 5
    
    lazy var ratingStackview: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.spacing = 2
        return stackview
    }()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
      //  ConfigurasWithRating(rating: 3)
    }
    
    private func setupUI(){
        self.addSubview(ratingStackview)
        ratingStackview.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0 , height: 0)
    }
    
    
     func ConfigurasWithRating(rating: Int, style: Style = .full){
        
        switch style{
        
        case .full:
            //Add filled stars
            if rating > 0 {
                for _ in 1...rating{
                    let image = generateStarView(.filled)
                    ratingStackview.addArrangedSubview(image)
                }
            }
            
            //Add nonfilled stars
            let nonFilledCount = maximumRating - rating
            if nonFilledCount > 0 {
                for _ in 1...nonFilledCount{
                    let image = generateStarView(.nonFilled)
                    ratingStackview.addArrangedSubview(image)
                }
            }
        case .compact:
            let image = generateStarView(.filled)
            ratingStackview.addArrangedSubview(image)
        }
        
        

    }
    
    private func generateStarView(_ type: StarType) -> UIImageView{
        let starImage: UIImage
        switch type{
        case .filled:
            starImage = #imageLiteral(resourceName: "FilledStar")
        case .nonFilled:
            starImage = #imageLiteral(resourceName: "noFilledStar")
        }
        
        let image = UIImageView(image: starImage)
        image.widthAnchor.constraint(equalToConstant: 10).isActive = true
        return image
    }
    
    enum StarType{
        case filled
        case nonFilled
    }
    
    enum Style{
        case full
        case compact
    }
}
