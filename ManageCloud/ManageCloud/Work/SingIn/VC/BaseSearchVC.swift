//
//  SignInSearchVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class BaseSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tipsLBH: CGFloat = 48

    lazy var searchView: SignInSearchView = {
        let search = Bundle.main.loadNibNamed("SignInSearchView", owner: nil, options: nil)?.first as! SignInSearchView
        search.cancelBtn.rac_signal(for: .touchUpInside).take(until: self.rac_willDeallocSignal()).subscribeNext({ (x) in
            self.navigationController?.popViewController()
        })
        return search
    }()
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: KStatusBarH + KNaviBarH + tipsLBH, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH - tipsLBH ))
        table.estimatedRowHeight = 100
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.keyboardDismissMode = .onDrag
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchView.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: KStatusBarH + KNaviBarH + tipsLBH)
    }
    
    fileprivate func fullScreen() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(searchView)
        view.addSubview(Table)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    
    
    

}
