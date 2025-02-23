//
//  RecipeCell.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by kjs on 2024/06/13.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 이미지뷰의 크기를 조정
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 100),
            recipeImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
