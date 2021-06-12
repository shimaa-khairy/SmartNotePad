//
//  NotesTableViewCell.swift
//  SmartNotepad
//
//  Created by shimaa_khairy on 6/1/21.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteBody: UILabel!
    @IBOutlet weak var nearestLabel: UILabel!
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var locImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(note:NoteModel){
        noteTitle.text = note.title ?? ""
        noteBody.text = note.body ?? ""
        noteImage.isHidden = note.imageString == nil ?  true : false
        locImage.isHidden = note.location == nil ? true : false
        nearestLabel.text = note.nearest == 1 ? "Nearest" : ""
    }

}
