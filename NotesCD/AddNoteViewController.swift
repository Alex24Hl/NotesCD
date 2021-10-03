//
//  AddNoteViewController.swift
//  NotesCD
//
//  Created by Александр Холод on 03.10.2021.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var delegate: UpdateNotesViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveNote(title: String, content: String) {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        
        let note = Note(entity: entity, insertInto: context)
        note.title = title
        note.content = content
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: UIBarButtonItem) {
        
        guard let text = titleTextField.text else { return }
        guard let content = contentTextView.text else { return }
        
        if text == "" || content == "" {
            return
        }
        
        saveNote(title: text, content: content)
        delegate.updateNotes()
        dismiss(animated: true, completion: nil)
    }
}
