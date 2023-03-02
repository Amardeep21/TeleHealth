//
//  OnBoardingCollectionModel.swift
//  telehealth
//
//  Created by Apple on 30/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper
struct OnBoardingModel {
    var imageName : String?
    var title :  String?
    var message: String?
}

class TimeInfo: Mappable{
    required init?(map: Map) {}
    
    init( isSelected:Bool,time:String) {
        self.isSelected = isSelected
        self.time = time
    }
    
    func setvalue(isSelected: Bool){
        self.isSelected = isSelected
    }
    func mapping(map: Map) {
        isSelected <- map["isSelected"]
        time <- map["time"]
    }
    var isSelected : Bool? = false
    var time : String?
}


class WeekNameInfo: Mappable{
    required init?(map: Map) {}
    
    init( isSelected:Bool,timeArray:[AvailableSessionsData],weekNameTitle: String) {
        self.isSelected = isSelected
        self.timeArray = timeArray
        self.weekNameTitle = weekNameTitle
    }
    
    func setvalue(isSelected:Bool){
        self.isSelected = isSelected
    }
    
    
    func mapping(map: Map) {
        isSelected <- map["isSelected"]
        timeArray <- map["timeArray"]
        weekNameTitle <- map["weekNameTitle"]
    }
    
    var isSelected : Bool? = false
    var timeArray : [AvailableSessionsData]? = []
    var weekNameTitle: String?
}
