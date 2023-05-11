//
//  RecipeListViewController.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//

import Foundation
import UIKit

class RecipeListViewController: UIViewController {

    private var myTableView: UITableView!
    var recipes = [Recipe]()
    let activityIndicatorView = UIActivityIndicatorView()
    var activityIndicatorSubView = UIView()
    private let viewModel = RecipeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title  = "Dessert Recipes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.setupTableView()
        
        getRecipes()
    }
    
    func getRecipes(){
        
        showActivityIndicator()
        
        // Hard code recipe category to "Dessert"
        viewModel.getRecipes(category: "Dessert") { [weak self] in
            self?.recipes = (self?.viewModel.recipes)!
            
            self?.myTableView.reloadData()
            
            self?.hideActivityIndicator()
        }
    }
    
    func setupTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    // MARK: Activity Indicator method
    func showActivityIndicator(){
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .black
        activityIndicatorSubView.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        activityIndicatorSubView.isOpaque = true
        view.addSubview(activityIndicatorSubView)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator(){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
        activityIndicatorSubView.removeFromSuperview()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
// implement UITableView data source and deleagate
extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecipeTableViewCell {
                cell.setupRecipeImage(image: self.recipes[indexPath.row].recipeImage)
                cell.setupRecipeName(recipeName: self.recipes[indexPath.row].recipeName)
                cell.setupRecipeId(recipeId: self.recipes[indexPath.row].recipeId)
                return cell
            }
        fatalError("error in dequeing cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = self.recipes[indexPath.row]
        let recipeDetailsController = RecipeDetailViewController(recipeId: recipe.recipeId ?? "53049", recipeName: recipe.recipeName ?? "")
        navigationController?.pushViewController(recipeDetailsController, animated: true)
    }
    
    // fix row height to 100
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
