//
//  AppDelegate3.swift
//  PetTip
//
//  Created by isyuun on 2024/5/20.
//

import UIKit

// @UIApplicationMain
class AppDelegate3: AppDelegate2 {

    let operationQueue = OperationQueue()

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // AppDelegate2의 didFinishLaunchingWithOptions 호출
        let didFinishLaunching = super.application(application, didFinishLaunchingWithOptions: launchOptions)

        // 추가 초기화 작업을 비동기적으로 호출
        DispatchQueue.main.async {
            self.addNewOperationToQueue()
        }

        // 모든 작업이 완료된 후 새로운 작업을 추가
        DispatchQueue.main.async {
            if self.operationQueue.operations.allSatisfy({ $0.isFinished }) {
                self.addNewOperationToQueue()
            }
        }

        return didFinishLaunching
    }

    // 새로운 작업 인스턴스를 큐에 추가하는 함수
    func addNewOperationToQueue() {
        let operation = MyOperation()
        operationQueue.addOperation(operation)
    }
}

// 작업 정의
class MyOperation: Operation {
    override func main() {
        if isCancelled { return }
        // 작업 내용
        print("Operation is running")
        // 예시: 작업 수행
        sleep(2) // 작업이 2초 동안 수행된다고 가정
    }
}
