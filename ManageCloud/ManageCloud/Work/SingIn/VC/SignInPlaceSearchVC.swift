//
//  SignInPlaceSearchVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh

class SignInPlaceSearchVC: BaseSearchVC, AMapSearchDelegate {
    //搜索内容
    var searchText: String = ""
    
    var location: CLLocation!
    // 位置所属 区域
    var district: String = ""
    // POI 数据 页码
    var page: Int = 1
    
    var search: AMapSearchAPI!
    
    let classifyCode: String = "010000|020000|050000|060000|070000|080000|090000|100000|110000|120000|120100|120301|120203|120201|130000|140000|150000|160000|170000|180000|190000"
    
    var selectedBlock:((_ POI:AMapPOI) -> ())?
    
    var pois: [AMapPOI] = [AMapPOI]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Table.register(UINib.init(nibName: "SignPlaceTCell", bundle: nil), forCellReuseIdentifier: SignPlaceTCellID)
        loadData()
        Table.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            self?.loadData()
        })
        searchView.searchField.rac_textSignal().take(until: self.rac_willDeallocSignal()).subscribeNext { [weak self](text) in
            self?.page = 1
            self?.pois = [AMapPOI]()
            self?.Table.reloadData()
            if let search = text {
                self?.searchText = search as String
                if (self?.searchText.isEmpty)!{
                    return
                }
                self?.loadData()
            }
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Method
    @objc fileprivate func loadData() {
        search = AMapSearchAPI()
        search.delegate = self
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))
        request.keywords = searchText
        request.radius = 500
        /* 0-距离排序；1-综合排序, 默认0 */
        request.sortrule = 0
        request.page = page
        page += 1
        request.requireExtension = true
        request.offset = 50
        request.types = classifyCode
        search.aMapPOIAroundSearch(request)
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        var filterData = [AMapPOI]()
        for poi in response.pois{
            if poi.address.contains(searchText) || poi.name.contains(searchText){
                filterData.append(poi)
            }
        }
        if filterData.count == 0 {
            Table.mj_footer.endRefreshingWithNoMoreData()
        }
        else{
            pois += filterData
            Table.reloadData()
            Table.mj_footer.endRefreshing()
        }
    }
    
    //MARK:- UITableView Delegate / DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SignPlaceTCellID, for: indexPath) as! SignPlaceTCell
        cell.selectionStyle = .none
        let model = pois[indexPath.row]
        cell.Address.text = model.address
        cell.companyName.text = model.name
        cell.highLightText = searchText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchView.count = String(pois.count)
        return pois.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        let poi = pois[indexPath.row]
        selectedBlock!(poi)
    }
    
}
