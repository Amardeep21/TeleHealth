//
//  GlobalConstant.swift
//  Iroid
//
//  Created by iroid on 30/03/18.
//  Copyright © 2018 iroidiroid. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
var isOnCallScreen = false
var isFromAppdelegatePushNotifcation = false
var currentLatitude = ""
var currentLongitude = ""
let POST_METHOD_CALL = true
let GET_METHOD_CALL = false
var uesrRole = Int()
var showPromptToTherapist = false
var messageAlert = ""
var token = String()

let PRIVACY_URL = "http://juthoor.co/privacy"
let ARABIC_PRIVACY_URL = "http://juthoor.co/privacy?lang=ar"

let PRIVACY_URL_THERPIST = "http://juthoor.co/privacy/therapist"
let ARABIC_PRIVACY_URL_THERPIST = "http://juthoor.co/privacy/therapist?lang=ar"

let PRIVACY_URL_CLIENT = "http://juthoor.co/privacy/client"
let ARABIC_PRIVACY_URL_CLIENT = "http://juthoor.co/privacy/client?lang=ar"

let TERMS_URL_THERPIST = "http://juthoor.co/terms/therapist"
let ARABIC_TERMS_URL_THERPIST = "http://juthoor.co/terms/therapist?lang=ar"


let TERMS_URL_CLIENT = "http://juthoor.co/terms/client"
let ARABIC_TERMS_URL_CLIENT = "http://juthoor.co/terms/client?lang=ar"


let TERMS_URL = "http://juthoor.co/terms"
let ARABIC_TERMS_URL = "http://juthoor.co/terms?lang=ar"


let FAQ_URL = "http://juthoor.co/faq"
let ARABIC_FAQ_URL = "http://juthoor.co/faq?lang=ar"

let ABOUT_US_URL = "http://juthoor.co/about"
let ARABIC_ABOUT_US_URL = "http://juthoor.co/about?lang=ar"


//Productoin
let BASE_URL = "https://juthoor.co/api/v1/"
let SOCKET_URL = "https://juthoor.co:5138"
let PAYMENT_CALL_BACK_URL = "http://juthoor.co/payment/callback"

//Development
//let BASE_URL = "http://13.233.208.36/telehealth/api/v1/"
//let SOCKET_URL = "http://13.233.208.36:5137"
//let PAYMENT_CALL_BACK_URL = "http://13.233.208.36/telehealth/payment/callback"



//let PRIVACY_URL = "http://13.233.208.36/telehealth/privacy"
//let TERMS_URL = "http://13.233.208.36/telehealth/terms"
//let FAQ_URL = "http://13.233.208.36/telehealth/faq"
//let ABOUT_US_URL = "http://13.233.208.36/telehealth/about"



let KEY = "bbC2H19lkVbQDfakxcrtNMQdd0FloLyw" // length == 32
let IV = "gqLOHUioQ0QjhuvI" // length == 16

var checkUpdateCall = false
let MAX_DURATION = 3600
let INDIVIDUAL_COUNSELLING = 1
let COUPLE_COUNSELLING  = 2
let TEENAGE_COUNSELLING = 3
let FAMILY_COUNSELLING  = 3

let MALE_VALUE = 1
let FEMALE_VALUE = 0

let MARRIED = 1
let UNMARRIED = 0

let YES_VALUE = 1
let NO_VALUE = 0
var isAlreadyCheckedVersion = false
let INDIVIDUAL = "Individual"
let COUPLE = "Couple"
let FAMILY = "Family"

let ENGLISH_LANG_CODE         =              "en"
let ARABIC_LANG_CODE         =              "ar"
let AUTHENTICATION_DICTIONARY = "auth"
let DEVICE_UNIQUE_IDETIFICATION : String = UIDevice.current.identifierForVendor!.uuidString
let APP_SECURITY                           = "app_seccurity"
let APPLICATION_NAME                     =      "Juthoor"
let APLLICATION_JSON                     =      "application/json"
let API_ID_VALUE                         =      "f63ab8e4dc88fcda0826a2f695bfd7ba"
let API_SECRET_VALUE                     =      "1c4a417ce28bb18256ca150e4e8d3c6f"
let PIN_SET                        =      "pin_set"
let CONFIRM_PIN_SET                        =      "confirm_pin_set"
let CART_PRODUCTS                        =      "cart_products"
let USER_DETAILS                         =      "user_details"
let musicPlayDataSave                    =      "musicPlayDataSave"
let PRODUCT_DETAILS                      =      "product_details"
let SUB_CATEGORY_DETAILS                 =      "sub_category_details"
let IS_LOGIN                             =      "is_login"
let IS_GUEST_USER                        =      "is_guest_user"
let CATEGORY                             =      "category"
let ACCEPT                               =      "Accept"
let AccessTokenn                         =      "AccessTokenn"
let CITY_NAME                            =      "city"
let COUNTRY_NAME                         =      "country"
let PHONE_CODE                           =      "phonecode"
let CV                                   =      "cv"
let LICENSE_NUMBER                       =      "licenseNumber"
let CERTIFICATES                         =      "certificates"
let KEYWORD                              =      "keyword"
let ACCESS_TOKEN                         =      "accessToken"
let AUTH                                 =      "auth"
let AUTHORIZATION                        =      "Authorization"
let DEVICE_TOKEN                         =      "DeviceToken"
let DEVICE_ID                            =      "deviceId"
let DEVICE_TYPE                          =      "DeviceType"
let SECRET                               =      "secret"
let FIRSTNAME                            =      "firstName"
let LAST_NAME                            =      "lastname"
let FULLNAME                             =       "fullName"
let EMAIL                                =       "email"
let COUNSELLING_TYPE                     =      "counsellingType"
let GENDER                              =           "gender"
let RELEATIONSHIP                       =           "relationship"
let IS_COUNSELLING_BEFORE               =           "isCounsellingBefore"
let CHECK_CURRENT_PASSWORD                 =      "checkCurrentPassword"
let ROLE                                 =       "role"
let ABOUT_ME                            =         "aboutme"
let CODE                                 =       "code"
let SOCIAL_PROVIDER                     =       "socialProvider"
let MOBILE                               =       "mobile"
let PHONENUMBER                          =       "phoneNumber"
let DATEOFBIRTH                          =       "dateOfBirth"
let PEOFILEIMAGE                         =       "profileImage"
let SUCCESS                              =       "success"
let FLAG                                 =        "flag"
let MESSAGE                              =       "message"
let PHOTOS                               =       "photo"
let FRIEND_SHIP_STATUS                   =       "friendShipStatus"
let STATUS                               =       "status"
let COMMAND                              =       "command"
let USERNAME                             =       "username"
let IS_INVITE                            =       "isInvite"
let SOCIAL_ID                            =       "socialId"
let PROFILE                              =       "profile"
let PHONE_NUMBER                         =       "phone_num"
let PASSWORD                             =       "password"
let RATING                               =       "rating"
let CONTENT                              =       "content"
let YYYY_MM_DDHHMMSS  =   "yyyy-MM-dd HH:mm:ss"

let YYYY_MM  =   "yyyy-MM"
let YYYY_MM_DD  =   "yyyy-MM-dd"
let YYYY_MM_DDHHMM  =   "yyyy-MM-dd HH:mm"
let YYYY_MM_DDAMPM  =   "yyyy-MM-dd hh:mma"
let MMMM_DD_YYYY        =   "MMMM dd, yyyy"
let MMM_DD_YYYY        =   "MMM dd, yyyy"
let FCM_TOKEN = "firebaseToken"

let HHMMA           =   "hh:mma"
let HHMM        =   "HH:mm"
let APPOINTMENT_DATE = "appointmentDate"
let SESSION = "session"
let SERVICES = "services"
let TIMEZONE                             =       "timezone"
let CURRENTPASSWORD                      =       "currentPassword"
let CONFORMPASSWORD                      =       "confirmPassword"
let NEWPASSWORD                          =       "newPassword"
let CONFIRMNEWPASSWORD                   =       "confirmNewPassword"
let FAVORITES_STORES                     =       "favoriteStores"
let TAG                                  =       "tag"
let USER_ID                              =       "userID"
let USER_IDD                             =       "userId"
let DAILY_MOTIVATION                     =       "dailyMotivation"
let DATA                                 =       "data"
let COLOR                                =       "color"
let SPEAKER                              =       "speaker"
let QUOTE                                =       "quote"
let SERVER_DATE_FORMATE                  =       "yyyy-MM-dd HH:mm:ss"
let LATITUDE                             =       "latitude"
let LONGITUTE                            =       "longitude"
let LOCATIONCOORDINATES                  =       "locationCoordinates"
let NAME                                 =       "name"
let POST_ID                              =       "post_id"
let ALBUM_ID                             =       "albumId"
let PSYCHOLOGIST_ID                      =       "psychologistId"
let CATEGORY_ID                          =       "categoryId"
let STORE_IMAGE                          =       "storeImage"
let IMAGE                                =       "image"
let TITLE                                =       "title"
let WRITTEN_BY                           =       "writtenBy"
let PLAY_LIST                            =       "playlist"
let AUDIO                                =       "audio"
let SUB_TITLE                            =       "subTitle"
let ID                                   =       "id"
let STORE_TTPE_ID                        =       "storeTypeId"
let SPECIALS                             =       "specials"
let MY_FRIENDS_CHECKED_IN                =       "myFriendsCheckedIn"
let SPECIAL                              =       "special"
let DAY_OF_WEEK                          =       "dayOfTheWeek"
let CURRENT_PAGE                         =       "currentPage"
let DISTANCE                             =       "distanceUnit"
let LAST_PAGE                            =       "lastPage"
let HAS_MORE_PAGES                       =       "hasMorePages"
let PER_PAGE                             =       "perPage"
let TOTAL                                =       "total"
let SEARCH_DISTANCE                      =       "searchDistance"
let TOKEN                                =       "token"
let META                                 =       "meta"
let MONDAY                               =        "monday"
let TUESDAY                              =        "tuesday"
let WEDNESDAY                            =        "wednesday"
let THURSDAY                             =        "thursday"
let FRIDAY                               =        "friday"
let SATURDAY                             =        "saturday"
let SUNDAY                               =        "sunday"
let DESCRIPTION_ONE                      =        "descriptionOne"
let DESCRIPTION_TWO                      =        "descriptionTwo"
let HEADLINE_ONE                         =        "headlineOne"
let HEADLINE_TWO                         =        "headlineTwo"
let TOTAL_CHECK_INS                      =        "totalCheckIns"
let TOP_BAR                              =        "topBar"
let CURRENTLY_CHECKED_IN_AT              =        "currentlyCheckedInAt"
let STORE_TYPE_NAME                      =        "storeTypeName"
let WAITING_TIME                         =        "waitingTime"
let IS_FAVORITE                          =        "isFavorite"
let CROWD_SIZE                           =        "crowdSize"
let WAIT_TIME                            =        "waitTime"
let HAS_CHECKED_IN                       =        "hasCheckedIn"
let STORE_ID                             =         "storeId"
let PUT                                  =         "Put"
let STORE_NAME                           =         "storeName"
let SEARCH_SERVICE                       =         "searchService"
let STORE_SERVICE                        =         "storeService"
let STORE                                =         "store"
let REFRESH_TOKEN                        =         "refreshToken"
let REFRESSH_TOKENN                      =          "refresh_token"
let DATE                                 =          "date"
let LOCATION_NAME                        =         "locationName"
let APP_VERSION                          =         "appVersion"
let FORCE_UPDATE_VERSION                 =         "forceUpdateVersion"
let PLATFORM                             =         "platform"
let LINK                                 =         "link"
let LOG_OUT_NOTIFICATION                 =         "LOG_OUT_NOTIFICATION"
let UPDATE_TAB_BAR                       =         "UPDATE_TAB_BAR"
let VIEWED_SECONDS                       =         "viewedSeconds"
let ON_GOING                             =         "Ongoing"
let SORT_BY                              =         "sortby"
let FILTER_BY                            =         "filterby"
let IS_FAVOURITE                         =         "isFavourite"
let IS_SAVED                             =         "isSaved"
let IS_SUBSCRIPTION_RUNNING              =         "isSubscriptionRunning"
let LANGUAGE                             =          "language"
let UPCOMMING_SELECED                    =          1
let PAST_SELECED                         =          2
let TYPE                                 =         "type"

let TWELVEAM = "12:00AM"
let ONEAM = "01:00AM"
let TWOAM = "02:00AM"
let THREEAM = "03:00AM"
let FOURAM = "04:00AM"
let FIVEAM = "05:00AM"
let SIXAM = "06:00AM"
let SEVENAM =   "07:00AM"
let EIGHTAM =   "08:00AM"
let NINEAM =   "09:00AM"
let TENAM =   "10:00AM"
let ELEVENAM =   "11:00AM"
let TWELVEPM =   "12:00PM"
let ONEPM =   "01:00PM"
let TWOPM =   "02:00PM"
let THREEPM =   "03:00PM"
let FOURPM =   "04:00PM"
let FIVEPM =   "05:00PM"
let SIXPM =   "06:00PM"
let SEVENPM =   "07:00PM"
let EIGHTPM =   "08:00PM"
let NINEPM =   "09:00PM"
let TENPM =   "10:00PM"
let ELEVENPM =   "11:00PM"

/* Google Client id */
let CLIENT_ID = "764453402647-dnqlitae3655illnv7uq1p8ugfgb4jk4.apps.googleusercontent.com"





