//
//  BlogListScreen.swift
//  telehealth
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class BlogListScreen: UIViewController {
    
    @IBOutlet weak var blogListTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var blogItems : Observable<[BlogsModel]>!
    let disposeBag = DisposeBag()
    var blogArray = [BlogsModel]()
    var metaData:MetaDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializedDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)

        if(blogArray.count > 0){
          self.loadBlogList()
        }
        setupSessionTableViewSelectMethod()
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initializedDetails(){
        blogListTableView.register(UINib(nibName: "BlogTableViewCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
        self.getBlogs()
        blogListTableView.rx
               .willDisplayCell
               .subscribe(onNext: { cell, indexPath in
                  if(self.blogArray.count - 1 == indexPath.row){
                         if(self.metaData.has_more_pages!){
                             self.getBlogs()
                         }
                     }
                  })
               .disposed(by: disposeBag)
    }
    
    func getBlogs(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = self.loadMoreUrl()
            BlogServices.shared.getBlogData(url:url,success: { (statusCode, blogModel) in
                Utility.hideIndicator()
                if(self.metaData == nil){
                    self.blogArray = []
                    self.blogArray.append(contentsOf: (blogModel.data!))
                }else{
                    self.blogArray.append(contentsOf: (blogModel.data)!)
                }
                self.blogItems = Observable.just((self.blogArray))
                self.metaData = blogModel.meta
                 self.loadBlogList()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func loadMoreUrl() -> String{
        var url = String()
        if(self.metaData == nil){
            url = "\(BLOGS)?page=1"
        }else{
            let urlArray = (metaData.next_page_url)?.split(separator: "/")
            
            url = "\(urlArray?.last ?? "")"
        }
        return url
    }
    
    func loadBlogList(){
        blogListTableView.dataSource = nil
        blogItems.bind(to: blogListTableView.rx.items(cellIdentifier: "BlogCell", cellType:BlogTableViewCell.self)){(row,item,cell) in
            cell.blogTitleLabel.text = item.title
            Utility.setImage(item.media, imageView: cell.blogImageView)
            cell.dateLabel.text = Utility.UTCToLocal(date: (item.publishAt)!, fromFormat: YYYY_MM_DDHHMM, toFormat: MMMM_DD_YYYY)
            cell.durationLabel.text = "\(item.duration ?? "") read"
        }.disposed(by: disposeBag)
    }
    
    func setupSessionTableViewSelectMethod(){
        self.blogListTableView.rx.modelSelected(BlogsModel.self)
            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
            .subscribe(onNext: {
                item in
                    let storyBoard = UIStoryboard(name: "Blog", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "BlogDetailScreen") as! BlogDetailScreen
                    control.blogId = item.id!
                    self.navigationController?.pushViewController(control, animated: true)
            }).disposed(by: disposeBag)
    }
    
}
