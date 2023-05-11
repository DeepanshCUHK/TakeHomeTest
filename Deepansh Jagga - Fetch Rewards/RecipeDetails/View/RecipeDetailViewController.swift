//
//  RecipeDetailTableViewController.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//

import Foundation
import UIKit

class RecipeDetailViewController: UIViewController {
    
    // scroll view inside the view
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // add stack view inside scrollview to align elements
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let recipeNameLabel: UILabel = {
        let view = UILabel()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = UIColor.systemGray6
        view.tintColor = .black
        view.text = "-"
        return view
    }()
    
    private let recipeImageView: UIImageView = {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let recipeIdLabel: UILabel = {
        let view = UILabel()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = UIColor.systemGray6
        return view
    }()
    
    private let instructionsHeaderLabel: UILabel = {
        let view = UILabel()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = UIColor.systemGray3
        view.text = "Instructions"
        view.font = UIFont.systemFont(ofSize: 20.0)
        return view
    }()
    
    private let ingredientsHeaderLabel: UILabel = {
        let view = UILabel()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = UIColor.systemGray3
        view.text = "Ingredients"
        view.font = UIFont.systemFont(ofSize: 20.0)
        return view
    }()
    
    private let instructionsLabel: UITextView = {
        let view = UITextView()
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    private let ingredientsLabel: UITextView = {
        let view = UITextView()
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    let activityIndicatorView = UIActivityIndicatorView()
    var activityIndicatorSubView = UIView()

    private let viewModel = RecipeDetailViewModel()
    
    var recipeId: String
    var recipeName: String

    // init controller using recipe id and recipe name
    init(recipeId: String, recipeName: String) {
        self.recipeName = recipeName
        self.recipeId = recipeId
        super.init(nibName: nil, bundle: nil)
        getRecipeDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.recipeName
        self.navigationController?.navigationBar.topItem?.title = self.recipeName
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = self.recipeName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        view.backgroundColor = .white
        setupScrollView()
    }
    
    // fetch recipe details using the recipe id
    func getRecipeDetail() {
        showActivityIndicator()
        
        viewModel.getRecipeDetails(id: recipeId) { [weak self] in
            self?.instructionsLabel.text = self?.viewModel.recipeDetails?.getInstructionsText()
            self?.setupRecipeImage(image: self?.viewModel.recipeDetails?.strMealThumb)
            self?.getIngredients()
            self?.hideActivityIndicator()
        }
    }
    
    private func setupScrollView() {
        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
    
        scrollView.addSubview(scrollStackViewContainer)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        configureContainerView()
    }
    
    private func configureContainerView() {
        // recipe name
        recipeNameLabel.text =  "Recipe Name: \(self.recipeName)"
        recipeNameLabel.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        recipeNameLabel.numberOfLines = 0
        recipeNameLabel.lineBreakMode = .byWordWrapping
        recipeNameLabel.tintColor = UIColor.black

        // recipe imageView
        recipeImageView.contentMode = .scaleAspectFit
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 14
        recipeImageView.layer.masksToBounds = true
        
        // recipe id
        recipeIdLabel.text = "Recipe Id: \(self.recipeId)"
        recipeIdLabel.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        recipeIdLabel.numberOfLines = 0
        recipeIdLabel.lineBreakMode = .byWordWrapping
        recipeIdLabel.tintColor = UIColor.black
        recipeIdLabel.layer.cornerRadius = 2.0
        
        // instructions Header text view
        instructionsHeaderLabel.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 24))
        instructionsHeaderLabel.tintColor = UIColor.black
        instructionsHeaderLabel.layer.cornerRadius = 2.0
        
        // instructions text view
        instructionsLabel.text = "No instructions"
        instructionsLabel.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        instructionsLabel.tintColor = UIColor.black
        instructionsLabel.layer.cornerRadius = 2.0
        instructionsLabel.isScrollEnabled = true
        instructionsLabel.isEditable = false
        instructionsLabel.isUserInteractionEnabled = true
        
        // ingredients Header text view
        ingredientsHeaderLabel.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 24))
        ingredientsHeaderLabel.tintColor = UIColor.black
        ingredientsHeaderLabel.layer.cornerRadius = 2.0
        
        // ingredients text view
        ingredientsLabel.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        ingredientsLabel.tintColor = UIColor.black
        ingredientsLabel.layer.cornerRadius = 2.0
        ingredientsLabel.isEditable = false
        ingredientsLabel.isUserInteractionEnabled = true
        ingredientsLabel.isScrollEnabled = true

        // add views in stack
        scrollStackViewContainer.addArrangedSubview(recipeImageView)
        scrollStackViewContainer.addArrangedSubview(recipeNameLabel)
        scrollStackViewContainer.addArrangedSubview(recipeIdLabel)
        scrollStackViewContainer.addArrangedSubview(instructionsHeaderLabel)
        scrollStackViewContainer.addArrangedSubview(instructionsLabel)
        scrollStackViewContainer.addArrangedSubview(ingredientsHeaderLabel)
        scrollStackViewContainer.addArrangedSubview(ingredientsLabel)
    }
    
    func concatIngredients(measure: String?, ing: String?){
        guard measure != nil else {return}
        guard (measure != "" && measure != " ") else {return}
        ingredientsLabel.text += measure!
        guard ing != nil else {return}
        ingredientsLabel.text += " \(ing!)\n"
    }
    
    // handle null value for measurements and ingredients
    func getIngredients(){
       ingredientsLabel.text = ""
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure1, ing: viewModel.recipeDetails?.strIngredient1)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure2, ing: viewModel.recipeDetails?.strIngredient2)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure3, ing: viewModel.recipeDetails?.strIngredient3)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure4, ing: viewModel.recipeDetails?.strIngredient4)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure5, ing: viewModel.recipeDetails?.strIngredient5)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure6, ing: viewModel.recipeDetails?.strIngredient6)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure7, ing: viewModel.recipeDetails?.strIngredient7)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure8, ing: viewModel.recipeDetails?.strIngredient8)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure9, ing: viewModel.recipeDetails?.strIngredient9)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure10, ing: viewModel.recipeDetails?.strIngredient10)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure11, ing: viewModel.recipeDetails?.strIngredient11)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure12, ing: viewModel.recipeDetails?.strIngredient12)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure13, ing: viewModel.recipeDetails?.strIngredient13)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure14, ing: viewModel.recipeDetails?.strIngredient14)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure15, ing: viewModel.recipeDetails?.strIngredient15)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure16, ing: viewModel.recipeDetails?.strIngredient16)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure17, ing: viewModel.recipeDetails?.strIngredient17)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure18, ing: viewModel.recipeDetails?.strIngredient18)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure19, ing: viewModel.recipeDetails?.strIngredient19)
       concatIngredients(measure: viewModel.recipeDetails?.strMeasure20, ing: viewModel.recipeDetails?.strIngredient20)
       if ingredientsLabel.text != "" {
           ingredientsLabel.text.removeLast()
       }
    }
    
    // default placeholder image for wrapping nil values
    // load cache image
    func setupRecipeImage(image: String?) {
        recipeImageView.load(url: URL(string: image ?? "https://news.aut.ac.nz/__data/assets/image/0006/92328/placeholder-image10.jpg")! , placeholder: UIImage(named: "placeholder"))
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
