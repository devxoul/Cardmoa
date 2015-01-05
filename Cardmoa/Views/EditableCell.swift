//
//  EditableCell.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class EditableCell: UITableViewCell {

    weak var delegate: EditableCellDelegate?
    var textField: UITextField!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None

        self.textField = UITextField(frame: self.contentView.bounds)
        self.textField.font = UIFont.systemFontOfSize(15)
        self.textField.clearButtonMode = .WhileEditing
        self.textField.addTarget(self, action: "textFieldTextDidChange", forControlEvents: .EditingChanged)
        self.contentView.addSubview(self.textField)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.frame = CGRect(
            x: 15,
            y: 0,
            width: CGRectGetWidth(self.bounds) - 20,
            height: CGRectGetHeight(self.bounds)
        )
    }

    func textFieldTextDidChange() {
        self.delegate?.editableCellTextDidChange?(self)
    }

}

@objc protocol EditableCellDelegate: NSObjectProtocol {
    optional func editableCellTextDidChange(cell: EditableCell)
}
