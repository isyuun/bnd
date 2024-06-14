//
//  LocationController.swift
//  PetTip
//
//  Created by Ahn Je Wook on 6/11/24.
//

import Foundation
import CoreLocation


class LocationController: NSObject {

    private let locationManager = CLLocationManager()
    public weak var delegate: LocationControllerDelegate?
    var locationReqType: Int = 0 // 0:NONE, 1:ONCE, 2:CONTINUE

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    func locationServicesEnabled() async -> Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus

        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }

    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {

        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태

            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            if (locationReqType == 0) {

            } else if (locationReqType == 1) {
                locationManager.requestWhenInUseAuthorization()

            } else if (locationReqType == 2) {
                locationManager.requestAlwaysAuthorization()
            }

            
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            delegate?.failedLocationServiceAuthorization()
            break

        case .authorizedAlways, .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태

            if (locationReqType == 1) {
                locationManager.allowsBackgroundLocationUpdates = false

            } else if (locationReqType == 2) {
                locationManager.allowsBackgroundLocationUpdates = true
            }

            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            locationManager.startUpdatingLocation()

            delegate?.successLocationServiceAuthorization()

        default:
            print("Default")
        }
    }

    internal func startContinueLocation() {
        locationReqType = 2
        checkUserDeviceLocationServiceAuthorization()
    }

    func stopContinueLocation() {
        locationReqType = 0
        locationManager.stopUpdatingLocation()
    }
    
    internal func requestLocation(type: Int) {
        locationReqType = type
        checkUserDeviceLocationServiceAuthorization()
    }

    func updateCurrLocation(_ locations: [CLLocation]) {}
    
}

extension LocationController: CLLocationManagerDelegate {

    // 사용자의 위치를 성공적으로 가져왔을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateCurrLocation(locations)
        
        if (locationReqType == 0 || locationReqType == 1) {
            locationManager.stopUpdatingLocation()
        }
    }

    // 사용자가 GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했을 때 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print(#function)
        delegate?.errorLocationService(message: error.localizedDescription)
    }

    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }

    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
}


protocol LocationControllerDelegate: AnyObject {
    func didUpdateLocations(_ locations: [CLLocation])
    func successLocationServiceAuthorization()
    func failedLocationServiceAuthorization()
    func errorLocationService(message: String?)
    func walkingTimerCallback()
}
