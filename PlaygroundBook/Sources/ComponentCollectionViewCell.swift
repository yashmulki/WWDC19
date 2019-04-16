//
//  ComponentCollectionViewCell.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-15.
//

import UIKit

class ComponentCollectionViewCell: UICollectionViewCell {
    
    private var label: UILabel
    private var imageView: UIImageView
    
    private var componentName = ""
    private var componentImageName = ""
    
    func setup(name: String, image: String) {
        // Update views
        componentName = name
        componentImageName = image
        
        label.text = componentName
        imageView.image = UIImage(named: componentImageName)
    }
    
     override init(frame: CGRect) {
        label = UILabel(frame: CGRect(x: 0, y: 90, width: 130, height: 44))
        imageView = UIImageView(frame: CGRect(x: 30, y: 10, width: 80, height: 80))
        imageView.backgroundColor = UIColor.clear
        label.text = "Default"
        label.textColor = UIColor.black
        label.textAlignment = .center
        super.init(frame: frame)
        self.addSubview(label)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
