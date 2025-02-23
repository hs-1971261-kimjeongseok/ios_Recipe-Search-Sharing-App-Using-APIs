//
//  RecipeDetailViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by kjs on 2024/06/13.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var recipe: Recipe?
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // 커스텀 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        // 썸네일 이미지 설정
        if let imageUrlString = recipe?.ATT_FILE_NO_MAIN, let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let recipe = recipe else { return }
        
        let recipeData: [String: Any] = [
            "RCP_SEQ": recipe.RCP_SEQ,
            "RCP_NM": recipe.RCP_NM,
            "RCP_WAY2": recipe.RCP_WAY2,
            "RCP_PAT2": recipe.RCP_PAT2,
            "INFO_WGT": recipe.INFO_WGT ?? "",
            "INFO_ENG": recipe.INFO_ENG ?? "",
            "INFO_CAR": recipe.INFO_CAR ?? "",
            "INFO_PRO": recipe.INFO_PRO ?? "",
            "INFO_FAT": recipe.INFO_FAT ?? "",
            "INFO_NA": recipe.INFO_NA ?? "",
            "HASH_TAG": recipe.HASH_TAG ?? "",
            "ATT_FILE_NO_MAIN": recipe.ATT_FILE_NO_MAIN ?? "",
            "ATT_FILE_NO_MK": recipe.ATT_FILE_NO_MK ?? "",
            "RCP_PARTS_DTLS": recipe.RCP_PARTS_DTLS,
            "MANUAL01": recipe.MANUAL01 ?? "",
            "MANUAL_IMG01": recipe.MANUAL_IMG01 ?? "",
            "MANUAL02": recipe.MANUAL02 ?? "",
            "MANUAL_IMG02": recipe.MANUAL_IMG02 ?? "",
            "MANUAL03": recipe.MANUAL03 ?? "",
            "MANUAL_IMG03": recipe.MANUAL_IMG03 ?? "",
            "MANUAL04": recipe.MANUAL04 ?? "",
            "MANUAL_IMG04": recipe.MANUAL_IMG04 ?? "",
            "MANUAL05": recipe.MANUAL05 ?? "",
            "MANUAL_IMG05": recipe.MANUAL_IMG05 ?? "",
            "MANUAL06": recipe.MANUAL06 ?? "",
            "MANUAL_IMG06": recipe.MANUAL_IMG06 ?? "",
            "MANUAL07": recipe.MANUAL07 ?? "",
            "MANUAL_IMG07": recipe.MANUAL_IMG07 ?? "",
            "MANUAL08": recipe.MANUAL08 ?? "",
            "MANUAL_IMG08": recipe.MANUAL_IMG08 ?? "",
            "MANUAL09": recipe.MANUAL09 ?? "",
            "MANUAL_IMG09": recipe.MANUAL_IMG09 ?? "",
            "MANUAL10": recipe.MANUAL10 ?? "",
            "MANUAL_IMG10": recipe.MANUAL_IMG10 ?? "",
            "MANUAL11": recipe.MANUAL11 ?? "",
            "MANUAL_IMG11": recipe.MANUAL_IMG11 ?? "",
            "MANUAL12": recipe.MANUAL12 ?? "",
            "MANUAL_IMG12": recipe.MANUAL_IMG12 ?? "",
            "MANUAL13": recipe.MANUAL13 ?? "",
            "MANUAL_IMG13": recipe.MANUAL_IMG13 ?? "",
            "MANUAL14": recipe.MANUAL14 ?? "",
            "MANUAL_IMG14": recipe.MANUAL_IMG14 ?? "",
            "MANUAL15": recipe.MANUAL15 ?? "",
            "MANUAL_IMG15": recipe.MANUAL_IMG15 ?? "",
            "MANUAL16": recipe.MANUAL16 ?? "",
            "MANUAL_IMG16": recipe.MANUAL_IMG16 ?? "",
            "MANUAL17": recipe.MANUAL17 ?? "",
            "MANUAL_IMG17": recipe.MANUAL_IMG17 ?? "",
            "MANUAL18": recipe.MANUAL18 ?? "",
            "MANUAL_IMG18": recipe.MANUAL_IMG18 ?? "",
            "MANUAL19": recipe.MANUAL19 ?? "",
            "MANUAL_IMG19": recipe.MANUAL_IMG19 ?? "",
            "MANUAL20": recipe.MANUAL20 ?? "",
            "MANUAL_IMG20": recipe.MANUAL_IMG20 ?? "",
            "RCP_NA_TIP": recipe.RCP_NA_TIP ?? "",
            "userID": Auth.auth().currentUser?.uid
        ]
        
        db.collection("recipes").document(recipe.RCP_SEQ).setData(recipeData) { error in
            if let error = error {
                print("Error saving recipe: \(error)")
            } else {
                print("Recipe successfully saved!")
                let alert = UIAlertController(title: "저장 완료", message: "레시피가 저장되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6 // 예제에서는 6개 섹션으로 구분
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // 메뉴명
        case 1:
            return 1 // 재료정보
        case 2:
            return 20 // 만드는 법
        case 3:
            return 1 // 나트륨 저감 조리법 TIP
        case 4:
            return 1 // 기타 정보
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "메뉴명"
        case 1:
            return "재료정보"
        case 2:
            return "만드는 법"
        case 3:
            return "저감 조리법 TIP"
        case 4:
            return "기타 정보"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipe = recipe else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0 // 텍스트가 잘리지 않도록 설정

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = recipe.RCP_NM
        case 1:
            cell.textLabel?.text = recipe.RCP_PARTS_DTLS
        case 2:
            let manualSteps = [
                recipe.MANUAL01, recipe.MANUAL02, recipe.MANUAL03, recipe.MANUAL04, recipe.MANUAL05,
                recipe.MANUAL06, recipe.MANUAL07, recipe.MANUAL08, recipe.MANUAL09, recipe.MANUAL10,
                recipe.MANUAL11, recipe.MANUAL12, recipe.MANUAL13, recipe.MANUAL14, recipe.MANUAL15,
                recipe.MANUAL16, recipe.MANUAL17, recipe.MANUAL18, recipe.MANUAL19, recipe.MANUAL20
            ]
            cell.textLabel?.text = manualSteps[indexPath.row]
        case 3:
            cell.textLabel?.text = recipe.RCP_NA_TIP
        case 4:
            cell.textLabel?.text = """
            열량: \(recipe.INFO_ENG ?? "N/A") kcal
            탄수화물: \(recipe.INFO_CAR ?? "N/A") g
            단백질: \(recipe.INFO_PRO ?? "N/A") g
            지방: \(recipe.INFO_FAT ?? "N/A") g
            나트륨: \(recipe.INFO_NA ?? "N/A") mg
            """
        default:
            cell.textLabel?.text = ""
        }

        return cell
    }
}
