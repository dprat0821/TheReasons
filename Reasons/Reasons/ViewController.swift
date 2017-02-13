//
//  ViewController.swift
//  Reasons
//
//  Created by Daniel Pan on 11/02/2017.
//  Copyright © 2017 geekmouse. All rights reserved.
//

import Cocoa

extension IndexSet{
    static func make(_ id: Int) -> IndexSet{
        return IndexSet(integer: id)
        //return NSIndexSet(index: id) as IndexSet
    }
}


class ViewController: NSViewController,NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var btPlay: NSButton!
    @IBOutlet weak var tbMenu: NSTableView!
    @IBOutlet weak var lbTitle: NSTextField!
    @IBOutlet weak var lbText: NSTextField!
    @IBOutlet weak var stAnswer: NSStackView!
    @IBOutlet weak var txAnswer: NSTextField!
    @IBOutlet weak var btAnswer: NSButton!
    
    
    var itemNow: Item = managerData.items[0]
    
    @IBAction func onClickPlay(_ sender: Any) {
        if managerBGM.isPlaying {
            managerBGM.isPlaying = false
            btPlay.image = NSImage(named: "iconPlay")
        }
        else{
            managerBGM.isPlaying = true
            btPlay.image = NSImage(named: "iconPause")
        }
    }
    
    
    
    @IBAction func onSubmitAnswer(_ sender: Any) {
        if itemNow.isPassed  {
            select(IndexSet.make(managerData.next().id))
        }
        else{   // No yet passed
            let attemptResult = managerData.attempt(itemNow, with: txAnswer.stringValue)
            managerData.save()
            if attemptResult{   // Right answer
                txAnswer.stringValue = ""
                txAnswer.placeholderString = itemNow.tip
                tbMenu.reloadData()
                delay(0.5){
                    self.select(IndexSet.make(self.itemNow.id))
                }
            }
            else{
                txAnswer.stringValue = ""
                if let tip = itemNow.tip{
                    txAnswer.placeholderString = "Try again: \(tip) "
                }
                else{
                    txAnswer.placeholderString = "Try again"
                }
                
            }
        }
        
        
    }
    
    func reloadRight() {
        //
        if itemNow.id <= managerData.latestItemId {// Already answered
            txAnswer.isHidden = true
            txAnswer.placeholderString = itemNow.tip
            btAnswer.title = "NEXT"
            lbTitle.stringValue = "Reason \(itemNow.idDisplay)"
            lbText.stringValue = itemNow.reason
        }
        else{
            txAnswer.isHidden = false
            txAnswer.placeholderString = itemNow.tip
            btAnswer.title = "SUBMIT"
            lbTitle.stringValue = "Question \(itemNow.idDisplay)"
            lbText.stringValue = itemNow.question
        }
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int{
        return managerData.items.count
    }
    
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        
        
        let item = managerData.items[row]
        
        if let cell = tableView.make(withIdentifier: "item", owner: nil) as? NSTableCellView {
            if row <= managerData.latestItemId {
                cell.textField?.stringValue = "\(item.idDisplay). \(item.reason)"
                cell.imageView?.image = NSImage(named: "iconHeart")
            }
            else if row == managerData.latestItemId + 1{
                cell.textField?.stringValue = "\(item.idDisplay). \(item.question)"
                cell.imageView?.image = NSImage(named: "iconQuestion")
                
            }
            else{
                cell.textField?.stringValue = "\(item.idDisplay). ???"
                cell.imageView?.image = nil
            }
            return cell
        }
        else{
            return nil
        }
    }
    
    public func tableView(_ tableView: NSTableView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, row: Int, mouseLocation: NSPoint) -> String{
        let item = managerData.items[row]
        if row <= managerData.latestItemId {
            return "\(item.id). \(item.question)"
        }
        else{
            return "Answer all previous questions correctly to unlock this item"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbMenu.delegate = self
        tbMenu.dataSource = self
        
        //let startSelectedItemId = min(managerData.latestItemId + 1, managerData.items.count - 1)
        itemNow = managerData.next()
        managerBGM.isPlaying = true
        btPlay.image = NSImage(named: "iconPause")
        
        tbMenu.reloadData()
        delay(0.5){
            self.select(IndexSet.make(self.itemNow.id))
        }
    }
    
    
    func select(_ id:IndexSet) {
        if let selectedId = id.first {
            if selectedId <= managerData.latestItemId + 1{
                itemNow = managerData.items[selectedId]
                if !tbMenu.selectedRowIndexes.contains(selectedId){
                    tbMenu.selectRowIndexes(IndexSet.make(selectedId), byExtendingSelection: false)
                }

                reloadRight()
            }
            else{
                tbMenu.selectRowIndexes(IndexSet.make(managerData.latestItemId + 1), byExtendingSelection: false)
            }
        }
        
        //itemNow = managerData.items[id.first!]
        //self.tbMenu.selectRowIndexes(id, byExtendingSelection: false)
        
    }
    
//    public func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int){
//        if row == managerData.items.count - 1 { //Last row
//            self.select(IndexSet.make(itemNow.id))
//        }
//    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        select(tbMenu.selectedRowIndexes)
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

