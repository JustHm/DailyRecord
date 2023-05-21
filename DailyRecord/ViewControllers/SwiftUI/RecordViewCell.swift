//
//  RecordTableViewCell.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/18.
//

import UIKit
import SwiftUI

final class RecordViewCell: UITableViewCell {
    
    init(title: String, date: Date) {
        super.init(style: .default, reuseIdentifier: "RecordCell")
        
        let vc = UIHostingController(rootView: RecordCell(title: title, date: date))
        contentView.addSubview(vc.view)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
