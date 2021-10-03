//
//  NoteCell.swift
//  NotesCD
//
//  Created by Александр Холод on 03.10.2021.
//

import UIKit

class NoteCell: UITableViewCell {
    
    static let cellId = "NoteCell"
    static let height: CGFloat = 70

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
