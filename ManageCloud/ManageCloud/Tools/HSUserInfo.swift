//
//  HSUserInfo.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class HSUserInfo: NSObject, HandyJSON, Codable {
    
    /*
    "OID": 15,
    "ACCOUNTNAME": "123",
    "EIOID": 5,
    "EITID": "0002",
    "EINAME": "123",
    "PASSWORD": "202cb962ac59075b964b07152d234b70",
    "Visible": 1,
    "DTID": "BM100201",
    "DOID": "10",
    "DNAME": "营销一部",
    "DepartmentType": "销售",
    "poid": 3,
    "GNAME": "营销部长",
    "CompanyOid": "0",
    "PC": "是"
    */
    
    //用户编号
    var OID: String? = ""
    //登陆账户名
    var ACCOUNTNAME: String? = ""
    //人员编号
    var EIOID: String? = ""
    //员工号
    var EITID: String? = ""
    //人员名称
    var EINAME: String? = ""
    //密码
    var PASSWORD: String? = ""
    //是否可用
    var Visible: String? = ""
    //部门编号
    var DTID: String? = ""
    //部门序号 
    var DOID: String? = ""
    //部门名称
    var DNAME: String? = ""
    //部门类型
    var DepartmentType: String? = ""
    //岗位编号
    var poid: String? = ""
    //岗位名称
    var GNAME: String? = ""
    //企业编号
    var CompanyOid: String? = ""
    //所属公司
    var SuoSuGongSiName: String? = ""
    //是否开放PC端权限
    var PC: String? = ""
    
    required override init() {
        
    }
    
    
}
