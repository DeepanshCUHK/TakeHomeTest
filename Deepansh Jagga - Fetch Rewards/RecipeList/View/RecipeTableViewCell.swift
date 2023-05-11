//
//  RecipeTableViewCell.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    fileprivate var recipeIdLabel = UIButton()
    fileprivate var recipeImageView = UIImageView()
    fileprivate var recipeNameLabel = UILabel()

    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else { return }
            // add default placeholder image
            recipeImageView.load(url: URL(string: recipe.recipeImage ?? "https://news.aut.ac.nz/__data/assets/image/0006/92328/placeholder-image10.jpg")! , placeholder: UIImage(named: "placeholder"))
            recipeNameLabel.text = recipe.recipeName
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        let boxView = UIView.init(frame: CGRect(x : 12 , y : 0, width :UIScreen.main.bounds.size.width - 12*2, height : self.contentView.frame.size.height))
        self.contentView.backgroundColor = UIColor.clear
        boxView.backgroundColor = UIColor.white
        self.contentView.addSubview(boxView)
        boxView.layer.cornerRadius = 2.0;
        
        // recipe name
        recipeNameLabel = UILabel(frame:CGRect(x:100 , y:5 , width: 150 , height: 90) )
        boxView.addSubview(recipeNameLabel)
        recipeNameLabel.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        recipeNameLabel.numberOfLines = 0
        recipeNameLabel.lineBreakMode = .byWordWrapping
        recipeNameLabel.tintColor = UIColor.black
        
        // recipe imageView
        recipeImageView = UIImageView(frame:CGRect(x:0 , y:5 , width: 90 , height: 90) )
        boxView.addSubview(recipeImageView)
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 14
        recipeImageView.layer.masksToBounds = true
        
        // recipe id
        recipeIdLabel = UIButton(frame:CGRect(x:boxView.frame.size.width - 90 , y:34 , width: 80 , height: 32))
        boxView.addSubview(recipeIdLabel)
        recipeIdLabel.setTitle("", for: UIControl.State.normal)
        recipeIdLabel.titleLabel?.textColor = UIColor.white
        recipeIdLabel.backgroundColor = UIColor.init(red: 0/255.0, green: 152/255.0, blue: 152/255.0, alpha: 1.0)
        recipeIdLabel.layer.cornerRadius = 2.0
        recipeIdLabel.isEnabled = true
    }
    
    // default placeholder image for wrapping nil values
    // load cache image
    func setupRecipeImage(image: String?) {
        recipeImageView.load(url: URL(string: image ?? "https://news.aut.ac.nz/__data/assets/image/0006/92328/placeholder-image10.jpg")! , placeholder: UIImage(named: "placeholder"))
    }
    
    func setupRecipeName(recipeName: String?) {
        recipeNameLabel.text = recipeName
    }
    
    func setupRecipeId(recipeId: String?) {
        recipeIdLabel.setTitle(recipeId, for: .normal)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
