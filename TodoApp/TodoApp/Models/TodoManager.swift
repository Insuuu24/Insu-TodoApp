//
//  TodoManager.swift
//  TodoApp
//
//  Created by Insu on 2023/08/09.
//

import UIKit

class TodoManager {
    static let shared = TodoManager() // 싱글톤 인스턴스 생성
    private init() {} // private initializer를 사용하여 외부에서 인스턴스화되지 않도록 함
    
    var todoItems: [TodoItem] = [] // TodoItem 목록
    var completedItems: [TodoItem] = []
}

