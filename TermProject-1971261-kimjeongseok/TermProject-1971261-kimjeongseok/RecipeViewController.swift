//
//  RecipeViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by kjs on 2024/06/13.
//

//
//  RecipeViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by kjs on 2024/06/13.
//

import UIKit
import Foundation
import FirebaseFirestore

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recipes: [Recipe] = []
    let apiKey = "319ff540f05b450ba354"
    var isSearching = false
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
    }

    @IBAction func btnPress(_ sender: Any) {
        let nameQuery = searchBar.text ?? ""
        let typeQuery = getSelectedType()
        if typeQuery == "공개됨" {
            fetchPublicRecipes(nameQuery: nameQuery)
        } else {
            fetchRecipes(nameQuery: nameQuery, typeQuery: typeQuery)
        }
    }
    
    func getSelectedType() -> String? {
        let index = typeSegmentedControl.selectedSegmentIndex
        if index == 5 {
            return "공개됨"
        }
        else if index == 4 {
            return nil // '선택안함'인 경우
        }
        else if index == 2 {
            return "국"
        }
        else {
            // 요리 종류를 제대로 반환하기 위해 제목을 그대로 반환
            return typeSegmentedControl.titleForSegment(at: index)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let nameQuery = searchBar.text ?? ""
        let typeQuery = getSelectedType()
        if typeQuery == "공개됨" {
            fetchPublicRecipes(nameQuery: nameQuery)
        } else {
            fetchRecipes(nameQuery: nameQuery, typeQuery: typeQuery)
        }
    }

    func fetchRecipes(nameQuery: String, typeQuery: String?) {
        //api 호출 url
        var urlString = "http://openapi.foodsafetykorea.go.kr/api/\(apiKey)/COOKRCP01/json/1/100"
        
        var parameters: [String] = []
        if let typeQuery = typeQuery {
            //음식 분류
            parameters.append("/RCP_PAT2=\(typeQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        }
        else {
            var tmp: String = searchBar.text ?? ""
            //음식 이름
            parameters.append("/RCP_NM=\(tmp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        }
        
        if !parameters.isEmpty {
            urlString += parameters.joined(separator: "&")
        }
        
        //print("Request URL: \(urlString)") // 디버그 출력 추가

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RecipeResponse.self, from: data)
                var filteredRecipes = response.COOKRCP01.row
                
                // 검색어 필터링
                
                DispatchQueue.main.async {
                    if !nameQuery.isEmpty {
                        filteredRecipes = filteredRecipes.filter { $0.RCP_NM.contains(nameQuery) }
                    }
                    //데이터 저장
                    self.recipes = filteredRecipes
                    self.isSearching = true
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        task.resume()
    }

    func fetchPublicRecipes(nameQuery: String) {
        db.collection("publicRecipes").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching public recipes: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.recipes = []
                self.isSearching = true
                self.tableView.reloadData()
                return
            }
            
            var fetchedRecipes = documents.compactMap { document -> Recipe? in
                var data = document.data()
                data["id"] = document.documentID
                return Recipe(document: data)
            }
            
            //검색어로 필터링
            if !nameQuery.isEmpty {
                fetchedRecipes = fetchedRecipes.filter { $0.RCP_NM.contains(nameQuery) }
            }
            
            DispatchQueue.main.async {
                self.recipes = fetchedRecipes
                self.isSearching = true
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return recipes.isEmpty ? 1 : recipes.count
        } else {
            return 0 // 초기 상태에서는 아무것도 표시하지 않음
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recipes.isEmpty { //검색결과가 없을 때
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
            cell.textLabel?.text = "검색 결과가 없습니다"
            cell.detailTextLabel?.text = ""
            cell.imageView?.image = nil
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
            let recipe = recipes[indexPath.row]
            cell.textLabel?.text = recipe.RCP_NM
            cell.detailTextLabel?.text = recipe.RCP_PAT2
            
            // 썸네일 이미지 로드
            if let imageUrlString = recipe.ATT_FILE_NO_MAIN, let imageUrl = URL(string: imageUrlString) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: data)
                            cell.setNeedsLayout()
                        }
                    }
                }
            } else {
                cell.imageView?.image = nil
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !recipes.isEmpty {
            let selectedRecipe = recipes[indexPath.row]
            performSegue(withIdentifier: "toRecipeDetail", sender: selectedRecipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetail" {
            if let destinationVC = segue.destination as? RecipeDetailViewController, let recipe = sender as? Recipe {
                destinationVC.recipe = recipe
            }
        }
    }
}
