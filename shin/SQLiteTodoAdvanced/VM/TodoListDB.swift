//
//  TodoListDB.swift
//  SQLiteTodoAdvanced
//
//  Created by 신나라 on 5/10/24.
//

import Foundation
import SQLite3
import UIKit

protocol QueryModelProtocol {
    func itemDownloaded(items: [TodoList])
}


//self.todoText = todoText
//self.insertDate = insertDate
//self.compleDate = compleDate
//self.status = status
//self.seq = seq

class TodoListDB{
    var db: OpaquePointer?
    var todoList: [TodoList] = []
    var delegate: QueryModelProtocol!
    
    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "todoList.sqlite")
        
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK{
            print("error opening database")
        }
        
        // Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todoList (id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, insertdate TEXT, compledate TEXT, status INTEGER, seq INTEGER)", nil, nil, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table :\(errMsg)")
        }
    }
    
    // todo insert
    // insertdate : 입력날짜
    // compledate : 완료된 날짜 => 처음 insert 시에는 compledate는 널값 처리
    func insertDB(text: String, insertdate: String, compledate: String, status: Int) -> Bool{
        var stmt: OpaquePointer?
        var newSeq: Int32 = 0
        
        let query = "SELECT MAX(seq) FROM todoList"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                let currentSeq = sqlite3_column_int(stmt, 0) //현재 seq
                newSeq = currentSeq + 1     // 새로운 seq 값
                print("newSeq값 : \(newSeq)")
            }
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO todoList (text, insertdate, compledate, status, seq) VALUES (?,?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, text, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, insertdate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, compledate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 4, Int32(status))
        sqlite3_bind_int(stmt, 5, newSeq)
      
        print("여기까지 왔다.")
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("해냄!!!")
            return true
        }else{
            return false
        }
    }
    
    // 조회
    func queryDB(){
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM todoList order by seq"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errMsg)")
            return
        }

        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = Int(sqlite3_column_int(stmt, 0))
            let text = String(cString: sqlite3_column_text(stmt, 1))
            let insertdate = String(cString: sqlite3_column_text(stmt, 2))
            let compledate = String(cString: sqlite3_column_text(stmt, 3))
            let status = Int(sqlite3_column_int(stmt, 4))
            let seq = Int(sqlite3_column_int(stmt, 5))
            
            todoList.append(TodoList(todoText: text, insertDate: insertdate, compleDate: compledate, status: status, seq: seq))
        }
        self.delegate.itemDownloaded(items: todoList)
    }
    
    
    // 삭제
    func deleteDB(id: Int) -> Bool{
//        var stmt: OpaquePointer?
//        let queryString = "DELETE FROM address WHERE sid = ?"
//
//        sqlite3_prepare(db, queryString, -1, &stmt, nil)
//
//        sqlite3_bind_int(stmt, 1, Int32(id))
//
//        if sqlite3_step(stmt) == SQLITE_DONE{
//            return true
//        }else{
//            return false
//        }
        
    return true
    }
    
    // 수정
    func updateDB(id: Int, text: String, status: Int, seq: Int) -> Bool{
//        var stmt: OpaquePointer?
//        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
//
//        let queryString = "UPDATE address SET sname = ?, sphone = ?, saddress = ?, srelation = ?, simage = ? WHERE sid = ?"
//
//        sqlite3_prepare(db, queryString, -1, &stmt, nil)
//
//        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 2, phone, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 3, address, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 4, relation, -1, SQLITE_TRANSIENT)
//
//        let imageData = image.jpegData(compressionQuality: 0.4)! as NSData
//        sqlite3_bind_blob(stmt, 5, imageData.bytes, Int32(imageData.length), SQLITE_TRANSIENT)
//
//        sqlite3_bind_int(stmt, 6, Int32(id))
//
//        if sqlite3_step(stmt) == SQLITE_DONE{
//            return true
//        }else{
//            return false
//        }
        return true
    }
}
