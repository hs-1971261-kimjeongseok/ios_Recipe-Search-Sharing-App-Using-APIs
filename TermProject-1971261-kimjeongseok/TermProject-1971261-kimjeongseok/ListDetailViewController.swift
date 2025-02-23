//
//  ListDetailViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by b2u on 2024/05/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ListDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var isPublic: Bool = false
    var searchQuery: String?
    var listViewController: ListViewController?
    var recipe: Recipe?
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let currentUserId = Auth.auth().currentUser?.uid
    var editableFields: [String?] = []
    var thumbnailURL: String?
    var isUploadingThumbnail = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RecipeDetailCell", bundle: nil), forCellReuseIdentifier: "RecipeDetailCell")

        // 썸네일 이미지 탭 제스처 추가
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped))
        thumbNail.isUserInteractionEnabled = true
        thumbNail.addGestureRecognizer(tapGestureRecognizer)

        // Initialize editableFields with recipe details
        if let recipe = recipe {
            editableFields = [
                recipe.RCP_NM,
                recipe.RCP_PARTS_DTLS,
                recipe.MANUAL01, recipe.MANUAL02, recipe.MANUAL03, recipe.MANUAL04, recipe.MANUAL05,
                recipe.MANUAL06, recipe.MANUAL07, recipe.MANUAL08, recipe.MANUAL09, recipe.MANUAL10,
                recipe.MANUAL11, recipe.MANUAL12, recipe.MANUAL13, recipe.MANUAL14, recipe.MANUAL15,
                recipe.MANUAL16, recipe.MANUAL17, recipe.MANUAL18, recipe.MANUAL19, recipe.MANUAL20,
                recipe.RCP_NA_TIP
            ]
            thumbnailURL = recipe.ATT_FILE_NO_MAIN
        } else {
            editableFields = Array(repeating: "", count: 23)
        }
        enableEditing()

        // 썸네일 이미지 설정
        if let imageUrlString = recipe?.ATT_FILE_NO_MAIN, let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.thumbNail.image = UIImage(data: data)
                    }
                }
            }
        }

        // 초기 버튼 상태 설정
        updateSaveButtonState()
    }
    
    func enableEditing() {
        tableView.isUserInteractionEnabled = true
        deleteButton.isHidden = false
    }
    
    func disableEditing() {
        tableView.isUserInteractionEnabled = false
        deleteButton.isHidden = true
    }

    @objc func thumbnailTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            thumbNail.image = selectedImage
            isUploadingThumbnail = true
            updateSaveButtonState()
            uploadThumbnailImage(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadThumbnailImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let imagePath = "thumbnails/\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child(imagePath)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "No error description")")
                self.isUploadingThumbnail = false
                self.updateSaveButtonState()
                return
            }

            storageRef.downloadURL { url, error in
                self.isUploadingThumbnail = false
                if let downloadURL = url {
                    self.thumbnailURL = downloadURL.absoluteString
                }
                self.updateSaveButtonState()
            }
        }
    }
    //이미지가 업로드되는 동안에는 저장 버튼을 누를 수 없음
    func updateSaveButtonState() {
        saveButton.isEnabled = !isUploadingThumbnail && thumbnailURL != nil
    }



    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let recipe = recipe else { return }
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        var updatedRecipe = recipe
        updatedRecipe.RCP_NM = editableFields[0] ?? ""
        updatedRecipe.RCP_PARTS_DTLS = editableFields[1] ?? ""
        updatedRecipe.MANUAL01 = editableFields[2]
        updatedRecipe.MANUAL02 = editableFields[3]
        updatedRecipe.MANUAL03 = editableFields[4]
        updatedRecipe.MANUAL04 = editableFields[5]
        updatedRecipe.MANUAL05 = editableFields[6]
        updatedRecipe.MANUAL06 = editableFields[7]
        updatedRecipe.MANUAL07 = editableFields[8]
        updatedRecipe.MANUAL08 = editableFields[9]
        updatedRecipe.MANUAL09 = editableFields[10]
        updatedRecipe.MANUAL10 = editableFields[11]
        updatedRecipe.MANUAL11 = editableFields[12]
        updatedRecipe.MANUAL12 = editableFields[13]
        updatedRecipe.MANUAL13 = editableFields[14]
        updatedRecipe.MANUAL14 = editableFields[15]
        updatedRecipe.MANUAL15 = editableFields[16]
        updatedRecipe.MANUAL16 = editableFields[17]
        updatedRecipe.MANUAL17 = editableFields[18]
        updatedRecipe.MANUAL18 = editableFields[19]
        updatedRecipe.MANUAL19 = editableFields[20]
        updatedRecipe.MANUAL20 = editableFields[21]
        updatedRecipe.RCP_NA_TIP = editableFields[22]
        updatedRecipe.ATT_FILE_NO_MAIN = thumbnailURL
        print(thumbnailURL)

        let recipeData: [String: Any] = [
            "userID": user.uid,
            "RCP_SEQ": updatedRecipe.RCP_SEQ,
            "RCP_NM": updatedRecipe.RCP_NM,
            "RCP_WAY2": updatedRecipe.RCP_WAY2,
            "RCP_PAT2": updatedRecipe.RCP_PAT2,
            "INFO_WGT": updatedRecipe.INFO_WGT ?? "",
            "INFO_ENG": updatedRecipe.INFO_ENG ?? "",
            "INFO_CAR": updatedRecipe.INFO_CAR ?? "",
            "INFO_PRO": updatedRecipe.INFO_PRO ?? "",
            "INFO_FAT": updatedRecipe.INFO_FAT ?? "",
            "INFO_NA": updatedRecipe.INFO_NA ?? "",
            "HASH_TAG": updatedRecipe.HASH_TAG ?? "",
            "ATT_FILE_NO_MAIN": updatedRecipe.ATT_FILE_NO_MAIN ?? "",
            "ATT_FILE_NO_MK": updatedRecipe.ATT_FILE_NO_MK ?? "",
            "RCP_PARTS_DTLS": updatedRecipe.RCP_PARTS_DTLS,
            "MANUAL01": updatedRecipe.MANUAL01 ?? "",
            "MANUAL_IMG01": updatedRecipe.MANUAL_IMG01 ?? "",
            "MANUAL02": updatedRecipe.MANUAL02 ?? "",
            "MANUAL_IMG02": updatedRecipe.MANUAL_IMG02 ?? "",
            "MANUAL03": updatedRecipe.MANUAL03 ?? "",
            "MANUAL_IMG03": updatedRecipe.MANUAL_IMG03 ?? "",
            "MANUAL04": updatedRecipe.MANUAL04 ?? "",
            "MANUAL_IMG04": updatedRecipe.MANUAL_IMG04 ?? "",
            "MANUAL05": updatedRecipe.MANUAL05 ?? "",
            "MANUAL_IMG05": updatedRecipe.MANUAL_IMG05 ?? "",
            "MANUAL06": updatedRecipe.MANUAL06 ?? "",
            "MANUAL_IMG06": updatedRecipe.MANUAL_IMG06 ?? "",
            "MANUAL07": updatedRecipe.MANUAL07 ?? "",
            "MANUAL_IMG07": updatedRecipe.MANUAL_IMG07 ?? "",
            "MANUAL08": updatedRecipe.MANUAL08 ?? "",
            "MANUAL_IMG08": updatedRecipe.MANUAL_IMG08 ?? "",
            "MANUAL09": updatedRecipe.MANUAL09 ?? "",
            "MANUAL_IMG09": updatedRecipe.MANUAL_IMG09 ?? "",
            "MANUAL10": updatedRecipe.MANUAL10 ?? "",
            "MANUAL_IMG10": updatedRecipe.MANUAL_IMG10 ?? "",
            "MANUAL11": updatedRecipe.MANUAL11 ?? "",
            "MANUAL_IMG11": updatedRecipe.MANUAL_IMG11 ?? "",
            "MANUAL12": updatedRecipe.MANUAL12 ?? "",
            "MANUAL_IMG12": updatedRecipe.MANUAL_IMG12 ?? "",
            "MANUAL13": updatedRecipe.MANUAL13 ?? "",
            "MANUAL_IMG13": updatedRecipe.MANUAL_IMG13 ?? "",
            "MANUAL14": updatedRecipe.MANUAL14 ?? "",
            "MANUAL_IMG14": updatedRecipe.MANUAL_IMG14 ?? "",
            "MANUAL15": updatedRecipe.MANUAL15 ?? "",
            "MANUAL_IMG15": updatedRecipe.MANUAL_IMG15 ?? "",
            "MANUAL16": updatedRecipe.MANUAL16 ?? "",
            "MANUAL_IMG16": updatedRecipe.MANUAL_IMG16 ?? "",
            "MANUAL17": updatedRecipe.MANUAL17 ?? "",
            "MANUAL_IMG17": updatedRecipe.MANUAL_IMG17 ?? "",
            "MANUAL18": updatedRecipe.MANUAL18 ?? "",
            "MANUAL_IMG18": updatedRecipe.MANUAL_IMG18 ?? "",
            "MANUAL19": updatedRecipe.MANUAL19 ?? "",
            "MANUAL_IMG19": updatedRecipe.MANUAL_IMG19 ?? "",
            "MANUAL20": updatedRecipe.MANUAL20 ?? "",
            "MANUAL_IMG20": updatedRecipe.MANUAL_IMG20 ?? "",
            "RCP_NA_TIP": updatedRecipe.RCP_NA_TIP ?? "",
        ]

        // Save the updated recipe to Firestore
        db.collection("publicRecipes").document(recipe.RCP_SEQ).setData(recipeData) { error in
            if let error = error {
                print("Error saving recipe: \(error)")
                let alert = UIAlertController(title: "Error", message: "Error saving recipe: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                print("Recipe successfully saved!")
                let alert = UIAlertController(title: "저장 완료", message: "레시피가 저장되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                self.listViewController?.reloadData()
            }
        }
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let recipe = recipe else { return }

        let collection = isPublic ? "publicRecipes" : "recipes"
        db.collection(collection).document(recipe.RCP_SEQ).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
                let alert = UIAlertController(title: "Error", message: "Error deleting recipe: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("RecipeDataChanged"), object: nil)
                self.dismiss(animated: true, completion: nil)
                self.listViewController?.reloadData()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailCell", for: indexPath) as! RecipeDetailCell
        cell.textField.delegate = self

        // Assign unique tag values based on section and row
        let tagValue = indexPath.section * 100 + indexPath.row
        cell.textField.tag = tagValue

        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "메뉴명"
            cell.textField.text = editableFields[0]
        case 1:
            cell.titleLabel.text = "재료정보"
            cell.textField.text = editableFields[1]
        case 2:
            let manualTitles = [
                "만드는 법 1", "만드는 법 2", "만드는 법 3", "만드는 법 4", "만드는 법 5",
                "만드는 법 6", "만드는 법 7", "만드는 법 8", "만드는 법 9", "만드는 법 10",
                "만드는 법 11", "만드는 법 12", "만드는 법 13", "만드는 법 14", "만드는 법 15",
                "만드는 법 16", "만드는 법 17", "만드는 법 18", "만드는 법 19", "만드는 법 20"
            ]
            cell.titleLabel.text = manualTitles[indexPath.row]
            cell.textField.text = editableFields[2 + indexPath.row]
        case 3:
            cell.titleLabel.text = "저감 조리법 TIP"
            cell.textField.text = editableFields[22]
        case 4:
            cell.titleLabel.text = "기타 정보"
            cell.textField.text = """
            열량: \(recipe?.INFO_ENG ?? "N/A") kcal
            탄수화물: \(recipe?.INFO_CAR ?? "N/A") g
            단백질: \(recipe?.INFO_PRO ?? "N/A") g
            지방: \(recipe?.INFO_FAT ?? "N/A") g
            나트륨: \(recipe?.INFO_NA ?? "N/A") mg
            """
            cell.textField.isUserInteractionEnabled = false
        default:
            cell.titleLabel.text = ""
            cell.textField.text = ""
        }

        return cell
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Extract section and row from tag value
        let section = textField.tag / 100
        let row = textField.tag % 100
        
        switch section {
        case 0:
            editableFields[0] = textField.text
        case 1:
            editableFields[1] = textField.text
        case 2:
            editableFields[2 + row] = textField.text
        case 3:
            editableFields[22] = textField.text
        case 4:
            // 기타 정보는 사용자가 편집하지 못하므로 여기서 처리하지 않음
            break
        default:
            break
        }
    }
}
