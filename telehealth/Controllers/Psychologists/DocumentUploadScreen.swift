//
//  DocumentUploadScreen.swift
//  telehealth
//
//  Created by iroid on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol selectedDocumentDelegate: class {
    func getSelectedDocumentData(DocumentData:NSDictionary)
}
class DocumentUploadScreen: UIViewController,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var documentDictionary = NSDictionary()
    var docData = Data()
    var docType = String()
    var delegate:selectedDocumentDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "TITLE_OF_DOCUMENT"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    
    @IBAction func onAttachment(_ sender: UIButton) {
        uploadDocumentOptionAlert(controller: self)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        if titleTextField.text == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_DOCUMENAT_TITLE"))
            return
        }
        else if(docData.count == 0){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_SELECT_DOCUMENT"))
            return
        }
        else{
            let uuid = UUID().uuidString
            documentDictionary = ["documentImage":docData,"title":titleTextField.text!,"uuid":uuid,"mimeType":docType]
            self.delegate?.getSelectedDocumentData(DocumentData: documentDictionary)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func onCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func uploadDocumentOptionAlert(controller: UIViewController) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "GALLERY"), style: .default, handler: { (_) in
        self.getImage(fromSourceType: .photoLibrary)
    }))
    
    alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CAMERA"), style: .default, handler: { (_) in
        self.getImage(fromSourceType: .camera)
    }))
    
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "DOCUMENT"), style: .default, handler: { (_) in
        self.getDocument()
    }))
    
    alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .destructive, handler: { (_) in
        print("User click Dismiss button")
    }))
    
    self.present(alert, animated: true, completion: {
        print("completion block")
    })
}
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//            self?.documentImage = image
            self!.docData = image.jpegData(compressionQuality: 0.5)!
            self!.docType = "image/jpeg"
            //Setting image to your image view
            //            self?.profileImageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getDocument(){
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage)], in: .import)
        documentPickerController.delegate = self
        documentPickerController.modalPresentationStyle = .fullScreen
        present(documentPickerController, animated: true, completion: nil)
    }
}
extension DocumentUploadScreen :UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        //Get document url
        print(urls.first!)
        self.docType = "application/pdf"
        do{
        docData = try Data.init(contentsOf: urls.first!)
        }catch{}
//        let fileUrl = URL(fileURLWithPath: filePath)
//        let path = "~/file.txt"
//        let expandedPath = urls.first.stringByExpandingTildeInPath
//        let data: NSData? = NSData(contentsOfFile: expandedPath)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}
extension UIImage {
    var jpeg: Data? { jpegData(compressionQuality: 0.5) }  // QUALITY min = 0 / max = 1
    var png: Data? { pngData() }
}
