//
//  Common.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwifterSwift
import BFKit
import PKHUD


func COLOR(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor
{
    return RGBA(r: red, g: green, b: blue, a: 1.0)
}

func COLORONE(value: CGFloat) -> UIColor {
    return COLOR(red: value, green: value, blue: value)
}

func RGBA(r red:CGFloat, g green:CGFloat, b blue:CGFloat, a alpha:CGFloat) -> UIColor
{
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

func LoadImage(_ imageName: String) -> UIImage {
    return UIImage.init(named: imageName)!
}

func HexColor(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func paramDic() -> [String: Any]
{
    return HSInstance.share.getInfoByDictionary()
}

let DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

/** Window */
let MainWindow : UIWindow = UIApplication.shared.keyWindow!

let Version9_ORLater: Bool = {
    if #available(iOS 9.0, *) {
        return true
    }
    return false
}()


/** 是不是IPX */
let KIsiPhoneX : Bool = {
    let selector = NSSelectorFromString("currentMode")
    let IphoneXSize = CGSize.init(width: 1125, height: 2436)
    return UIScreen.instancesRespond(to: selector) ? IphoneXSize.equalTo(UIScreen.main.currentMode!.size) : false
}()

let kRegFont : FontName = .pingFangSCRegular
let kMedFont : FontName = .pingFangSCMedium
let kSemFont : FontName = .pingFangSCSemiBold

//输出行数
func DPrint<T>(_ message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):line:\(lineNumber)]- \(message)")
    
    #endif
}

func ViewRadius(V view:UIView, R radius:CGFloat){
    view.layer.cornerRadius = radius
    view.layer.masksToBounds = true
}

/** 数值 */
let KWidth: CGFloat = UIScreen.main.bounds.width
let KHeight: CGFloat = UIScreen.main.bounds.height
let KTabBarH: CGFloat = 49.0
let KStatusBarH: CGFloat = KIsiPhoneX ? 44: 20
let KNaviBarH : CGFloat = 44.0

/** 颜色 */
let BorderColor: UIColor = {
    return COLOR(red: 215, green: 215, blue: 215)
}()
let BgColor: UIColor = {
    return COLOR(red: 238, green: 238, blue: 238)
}()
let HolderColor: UIColor = {
    return COLOR(red: 153, green: 153, blue: 153)
}()
let DeepDarkTitleColor: UIColor = {
    return COLOR(red: 51, green: 51, blue: 51)
}()
let DarkTitleColor: UIColor = {
    return COLOR(red: 68, green: 68, blue: 74)
}()
let DarkGrayTitleColor: UIColor = {
    return COLOR(red: 109, green: 109, blue: 114)
}()
let GrayTitleColor: UIColor = {
    return COLOR(red: 152, green: 152, blue: 156)
}()
let BlueColor: UIColor = {
    return COLOR(red: 57, green: 152, blue: 245)
}()

let NetObserve: NetworkReachabilityManager = {
    return AppDelegate.share().netObserver
}()





// 发布地址
//let MCURL: String = "http://118.190.160.100:8889"
//测试地址
let MCURL: String = "http://60.212.41.219:8889"

//let MCURL: String = "http://60.212.41.219:8888"


func BASE_URL( suffix: String) -> (String)
{
    return MCURL + suffix
}

func MyOid() -> (String){
    return (HSInstance.share.userInfo?.EIOID)!
}

func MyTid() -> (String){
    return (HSInstance.share.userInfo?.EITID)!
}

func MyDOid() -> (String){
    return (HSInstance.share.userInfo?.DOID)!
}

func MyName() -> (String){
    return (HSInstance.share.userInfo?.ACCOUNTNAME)!
}

func MyEINAME() -> (String){
    return (HSInstance.share.userInfo?.EINAME)!
}

func CusH5URL() ->(String){
    return "http://192.168.0.188:8020/yt_app/views/customerInfo/customerList/customerList.html?EIOID=\(MyOid())&EITID=\(MyTid())&ACCOUNTNAME=\(MyName())"
//    return "http://118.190.160.100:9494/views/customerInfo/customerList/customerList.html?EIOID=\(MyOid())&EITID=\(MyTid())&ACCOUNTNAME=\(MyName())"

}

//头像占位
let avatarFemale: String = "imgFemale"
let avatarMale: String = "imgMale"

//图片占位
let imgHolder: String = "imgPlaceHolder"


//SDK Key
//高德
let amapAPIKey = "059934574aa449563c42700d60c31a2a"

// MARK: - NetWork



//登录
let LoginIn: String = "/api/Login"
//选人列表
let SailPersonList: String = "/api/SellClient/GetEmployeList"

let PersonList: String = "/api/PersonList/GetCommonPersonList"

//自动更新
let CheckUpdate = "/api/Login/update"

/// 公告列表 
let GetGongGaoListURL = "/api/GongGao/GetGongGaoList"

/// 公告详情
let GetGongGaoURL = "/api/GongGao/GetGongGao"
///公告邮件读取
let GongGaoReadFileURL = "/api/GongGao/GongGaoReadFile"



//首页
//邮件红点
let newEmailCount = "/api/AppHome/MailCount"
//工作区轮播公告
let homeGongGao = "/api/AppHome/TOPGongGao"
//获取下属人员列表
let subPersonList = "/api/AppHome/getPersonSUBList"
//home页显示工作日志
let HomeLogList: String = "/api/WorkLog/GetWorkLog"
//home也显示下属工作日志
let HomeSubLogList: String = "/api/WorkLog/GetSubWorkLog"
//home获取3条指挥信息
let GetReceiveTop3CommandList:String = "/api/Command/GetTOP3ReceiveCommandList"
//获取权限
let GetPersonAuthority = "/api/AppHome/getPersonAuthority"
//home关键人员窗体
let GetKeyPersonList = "/api/AppHome/GetHingePersonList"
//指挥选人列表
let CommandPersonList = "/api/AppHome/GetPersonAuthorityList"



/// 个人信息设置
let PersonInfoURL = "/api/PersonInfo/PersonInfo"
///【个人信息】更新当前用户的姓名
let UpdatePersonNameURL = "/api/PersonInfo/UpdatePersonName"
///【个人信息】更新当前用户的头像
let UpdatePersonPhotoURL = "/api/PersonInfo/UpdatePersonPhoto"
///【个人信息】更新当前用户的部门
let UpdatePersonDepartmentYURL = "/api/PersonInfo/UpdatePersonDepartment"
///【个人信息】更新当前用户的简介
let UpdatePersonDescrURL = "/api/PersonInfo/UpdatePersonDescr"
/// 登录接口:改变密码
let changepwdURL = "/api/Login/changepwd"

/// 邮件列表
let EmailListURL:String = "/api/Mail/GetMailList"
/// 邮件详情
let GetMailURL:String = "/api/Mail/GetMail"
/// 邮件发送
let SubmitMailURL:String = "/api/Mail/SubmitMail"
/// 邮件删除
let DeleteMailURL:String = "/api/Mail/DeleteMail"
/// 附件上传
let MailUpdateFileURL:String = "/api/Mail/MailUpdateFile"
/// 读取邮件附件信息，返回邮件byte[]数组
let MailReadFileURL:String = "/api/Mail/MailReadFile"

// MARK: - 签到
//签到操作
let SignIn: String = "/api/Sign/SubmitSign"
//获取某人某日签到列表
let PerDaySignList: String = "/api/Sign/GetPersonSignList"
//获取某人所有签到列表
let AllDaySignList: String = "/api/Sign/GetPersonAllSignList"
//获取可查阅的签到人员列表
let SignPersonList: String = "/api/Sign/GetPersonListSign"

let SignUpLoad: String = "/api/Sign/SignUpdateFile"

let SignDownLoad: String = "/api/Sign/SignReadFile"


//显示我发的工作日志
let SendWorkLog:String = "/api/WorkLog/GetSendWorkLog"


//收到的工作日志
let ReceiveWorkLog:String = "/api/WorkLog/GetReceiveWorkLog"

//发（添加）工作日志 上传附件功能暂时没有
let AddWorkLog:String = "/api/WorkLog/AddWorkLog"

//home页显示工作日志
let GetWorkLog:String = "/api/WorkLog/GetWorkLog"

//工作日志详情显示
let WorkLogDisplay:String = "/api/WorkLog/GetWorkLogDisplay"

//回复
let AddWorkLogReback:String = "/api/WorkLog/AddWorkLogReback"


//【11:指挥公共信息】添加指挥信息
let SubmitCommand:String = "/api/Command/SubmitCommand"

//【11:指挥公共信息】获取指挥详细信息
let GetCommand:String = "/api/Command/GetCommand"

//【11:指挥公共信息】获取接收的指挥信息列表
let GetReceiveCommandList:String = "/api/Command/GetReceiveCommandList"

//【11:指挥公共信息】获取我发送的指挥信息列表
let GetSendCommandList:String = "/api/Command/GetSendCommandList"

//【11:指挥公共信息】添加指挥回复信息
let SubmitCommandReply:String = "/api/Command/SubmitCommandReply"


//WorkLogUpdateFile
let WorkLogUpdateFile:String = "/api/WorkLog/WorkLogUpdateFile"

//WorkLogReadFile
let WorkLogReadFile:String = "/api/WorkLog/WorkLogReadFile"


// MARK: - 自定义表单
//用户可获取的工作流模板
let WorkFlowList = "/api/Initiate"

//请求工作流控件
let WorkGetFrom = "/api/Initiate/GetInitiateForm"

//保存表单
let saveForm = "/api/Initiate/SubmitInitiate"

//修改表单
let modifyForm = "/api/Initiate/UpdateInitiate"

//获取审批流程
let GetFlowStep = "/api/NewApproval/AddSpNext"


/// 审批列表
let ApprovalListURL = "/api/NewApproval/ApprovalList"
/// 已审批列表
let ApprovedListURL = "/api/NewApproval/ApprovedList"
/// 我的工作流
let MyWorkFlowListURL = "/api/NewApproval/WorkFlowList"

/// 查询日报表列表
let DailyReportListURL = "/api/Finance/DailyReportList"

/// 查询日报表合计信息
let DailyReporTotalURL = "/api/Finance/DailyReporTotal"

/// 查询日报中账户信息
let DailyReporAccountURL = "/api/Finance/DailyReporAccount"

/// 查询账户列表数据
let BankAccountListURL = "/api/Finance/BankAccountList"

/// 查询收入周报数据
let inWeekReportListURL = "/api/Finance/InWeekReportList"

/// 查询收入周报合计信息
let inWeelReporTotalURL = "/api/Finance/InWeelReporTotal"

/// 查询支出周报数据
let OutWeekReportListURL = "/api/Finance/OutWeekReportList"

/// 查询支出周报合计信息  
let OutWeelReporTotalURL = "/api/Finance/OutWeelReporTotal"


/// 查询支出周报详细信息
let OutWeekReportDetailsURL = "/api/Finance/OutWeekReportDetails"

/// 查询支出周报详细信息中的合计信息
let OutWeelDetailsotalURL = "/api/Finance/OutWeelDetailsotal"




