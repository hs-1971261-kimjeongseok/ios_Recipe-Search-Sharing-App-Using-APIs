//
//  ListViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by b2u on 2024/05/23.
//

import UIKit
import FirebaseFirestore
import Foundation
import FirebaseAuth

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //add recipe 버튼 클릭 시
    @IBAction func addRecipe(_ sender: Any) {
        let emptyRecipe = Recipe.emptyRecipe()
        performSegue(withIdentifier: "showDetail", sender: (emptyRecipe, true))
    }
    
    var searchQuery: String?
    var tmp: Bool = false
    var recipes: [Recipe] = []
    var publicRecipes: [Recipe] = []
    var allRecipes: [(Recipe, Bool)] = []  // (Recipe, isPublic)
    var filteredRecipes: [(Recipe, Bool)] = []
    let db = Firestore.firestore()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let query = searchQuery {
            searchBar.text = query
        }

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("RecipeDataChanged"), object: nil)

        loadPublicRecipes()
    }

    @objc func reloadData() {
        loadPublicRecipes()
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        searchQuery = ""
    }

    func loadPublicRecipes() { //내가 공개한 레시피
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print(userId)
        db.collection("publicRecipes").whereField("userID", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting public recipes: \(error)")
            } else {
                self.publicRecipes = snapshot?.documents.compactMap { document -> Recipe? in
                    var data = document.data()
                    data["id"] = document.documentID
                    return Recipe(document: data)
                } ?? []
                self.loadRecipes()
            }
        }
    }

    func loadRecipes() { // 내가 저장한 레시피
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("recipes").whereField("userID", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting recipes: \(error)")
            } else {
                self.recipes = snapshot?.documents.compactMap { document -> Recipe? in
                    var data = document.data()
                    data["id"] = document.documentID
                    return Recipe(document: data)
                } ?? []
                self.combineRecipes()
                self.search(searchText: self.searchBar.text ?? "")
            }
        }
    }

    func combineRecipes() {
        allRecipes = []
        for recipe in publicRecipes {
            allRecipes.append((recipe, true))
        }
        for recipe in recipes {
            allRecipes.append((recipe, false))
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let (recipe, isPublic) = filteredRecipes[indexPath.row]
        
        if isPublic {
            cell.backgroundColor = UIColor.lightGray // Public recipes have a different background color
            cell.textLabel?.text = "\(recipe.RCP_NM) - 게시됨"
        } else {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.text = recipe.RCP_NM
        }
        
        cell.detailTextLabel?.text = recipe.RCP_PAT2
        
        // 썸네일 이미지 로드
        if let imageUrlString = recipe.ATT_FILE_NO_MAIN, let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        cell.setNeedsLayout() // 레이아웃 업데이트
                    }
                }
            }
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }

    //레시피가 담긴 셀 터치 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let (recipe, isPublic) = filteredRecipes[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: (recipe, isPublic))
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText: searchText)
    }

    func search(searchText: String) {
        if searchText.isEmpty {
            filteredRecipes = allRecipes
        } else {
            filteredRecipes = allRecipes.filter { $0.0.RCP_NM.contains(searchText) }
        }
        tableView.reloadData()
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let detailVC = segue.destination as? ListDetailViewController {
            if let (recipe, isPublic) = sender as? (Recipe, Bool) {
                detailVC.isPublic = isPublic
                detailVC.recipe = recipe
            }
            detailVC.listViewController = self
            detailVC.isModalInPresentation = true
            if let searchQuery = searchQuery, !searchQuery.isEmpty {
                detailVC.searchQuery = searchQuery
            }
        }
    }
}
