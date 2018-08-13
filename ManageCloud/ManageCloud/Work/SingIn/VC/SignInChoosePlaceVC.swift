//
//  SignInChoosePlaceVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh
import PKHUD

let SignPlaceTCellID = "SignPlaceTCellID"

let searchbarHeight: CGFloat = 46.0

class SignInChoosePlaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate {
    
    var location: CLLocation!
    // 位置所属 区域
    var district: String = ""
    // POI 数据 页码
    var page: Int = 1

    
    var search: AMapSearchAPI!
    
    let classifyCode: String = "010000|020000|050000|060000|070000|080000|090000|100000|110000|120000|120100|120301|120203|120201|130000|140000|150000|160000|170000|180000|190000"
    
    var selectedBlock:((_ POI:AMapPOI) -> ())?
    
    var pois: [AMapPOI] = [AMapPOI]()
    
    
    
    lazy var searchBar: MCSearchBar = {
       let bar = Bundle.main.loadNibNamed("MCSearchBar", owner: nil, options: nil)?.first as! MCSearchBar
        bar.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: searchbarHeight)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapSearch))
        bar.addGestureRecognizer(tap)
        return bar
    }()
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: searchbarHeight, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH - searchbarHeight))
        table.register(UINib.init(nibName: "SignPlaceTCell", bundle: nil), forCellReuseIdentifier: SignPlaceTCellID)
        table.estimatedRowHeight = 100.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            self?.loadData(false)
        })
        return table
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchBar.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: searchbarHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Method
    
    fileprivate func initUI() {
        title = "选择地点"
        view.addSubview(searchBar)
        view.addSubview(Table)
        loadData(true)
    }
    
    
    
    @objc fileprivate func loadData(_ isShowHUD: Bool) {
        if isShowHUD{
            HUD.show(.labeledProgress(title:nil, subtitle: "加载中"), onView: view)
        }
        search = AMapSearchAPI()
        search.delegate = self
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))
        request.radius = 500
        /* 0-距离排序；1-综合排序, 默认0 */
        request.sortrule = 1
        request.page = page
        page += 1
        request.requireExtension = true
        request.offset = 50
        request.types = classifyCode
        search.aMapPOIAroundSearch(request)
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        HUD.hide()
        if response.pois.count == 0 {
            Table.mj_footer.endRefreshingWithNoMoreData()
        }
        else{
            pois += response.pois
            Table.reloadData()
            Table.mj_footer.endRefreshing()
        }
    }
    
    
    @objc fileprivate func tapSearch() {
        let vc = SignInPlaceSearchVC()
        vc.selectedBlock = {[weak self] (POI) in
            self?.selectedBlock!(POI)
            self?.navigationController?.popViewController(animated: false)
            self?.navigationController?.popViewController(animated: false)
        }
        vc.location = location
        vc.district = district
        navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK:- UITableView Delegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SignPlaceTCellID, for: indexPath) as! SignPlaceTCell
        cell.selectionStyle = .none
        let model = pois[indexPath.row]
        cell.Address.text = model.address
        cell.companyName.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let poi = pois[indexPath.row]
        selectedBlock!(poi)
        navigationController?.popViewController()
    }
    

}
