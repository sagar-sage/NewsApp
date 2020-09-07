//
//  CategoryCollectionViewCell.swift
//  NewsApp
//
//  Created by Websutra  on 8/25/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    override var isSelected: Bool{
      didSet{
        if self.isSelected
        {
          //This block will be executed whenever the cell’s selection state is set to true (i.e For the selected cell)
            //categoryImageView.layer.borderWidth = 4
            roundView.layer.borderWidth = 4
        }
        else
        {
          //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)
            //categoryImageView.layer.borderWidth = 1
            roundView.layer.borderWidth = 1
        }
      }
    }
}
