//
//  PdfViewerViewController.swift
//  telehealth
//
//  Created by Apple on 25/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import PDFKit

class PdfViewerViewController: UIViewController {
    @IBOutlet weak var pdfView: UIView!
    var pdfUrl = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let pdfView = PDFView(frame: self.pdfView.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.pdfView.addSubview(pdfView)
        self.pdfView.backgroundColor = UIColor.clear
        pdfView.contentMode = .scaleAspectFit
        // Fit content in PDFView.
        pdfView.autoScales = true
        
        // Load Sample.pdf file from app bundle.
        
        pdfView.document = PDFDocument(url: URL(string: pdfUrl)!)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   

}
