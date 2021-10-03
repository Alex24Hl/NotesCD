//
//  NoteDetailViewController.swift
//  NotesCD
//
//  Created by Александр Холод on 03.10.2021.
//

import UIKit

class NoteDetailViewController: UIViewController {
    var note: Note?
        
    @IBOutlet weak private var  contentTextView: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = note?.title
        contentTextView.text = note?.content
        
    }

}
