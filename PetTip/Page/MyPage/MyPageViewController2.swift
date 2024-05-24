//
//  MyPageViewController2.swift
//  PetTip
//
//  Created by isyuun on 2024/4/30.
//

import UIKit
import NaverThirdPartyLogin

class MyPageViewController2: MyPageViewController {
    // 출처: https://doggyfootstep.tistory.com/22 [iOS'DoggyFootstep:티스토리]
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func logout() {
        super.logout()
        //카카오로그아웃
        //네이버로그아웃
        //페이스북로그아웃
        //구글로그아웃
        //애플로그아웃
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let count = myPetList?.myPets.count else { return }
        let index = indexPath.row
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][indexPath:\(indexPath)][\(index)/\(count)]")
        if index < count {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        super.viewDidAppear(animated)
        initRx()
    }

    override func initRx() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        super.initRx()
    }

    override func showSelectMyPetForInvite() {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][\(Global.userNckNm)][\(Global.myPetList)][\(Global.dailyLifePetList)]")
        // super.showSelectMyPetForInvite()

        if (dailyLifePetList == nil || dailyLifePetList?.pets.count == 0) {
            self.showToast(msg: "등록된 펫이 없습니다")
            return
        }

        if let v = UINib(nibName: "SelectInvitePetView2", bundle: nil).instantiate(withOwner: self).first as? SelectInvitePetView2 {
            v.initialize()
            v.setData(dailyLifePetList?.pets as Any)
            v.lb_title.text = "누구를 위해 초대를 할까요?"
            v.btn_select.setAttrTitle("초대하기", 14)
            v.isSingleSelectMode = false
            v.didTapOK = { selectedPets, endDt in
                self.didTapPopupOK()

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                let nowDt = dateFormatter.string(from: Date())

                self.invtt_create(pets: selectedPets, beginDt: nowDt, endDt: endDt)
            }

            self.popupShow(contentView: v, wSideMargin: 0, type: .bottom)
        }
    }

    var petInfos: [PetInfo] = [PetInfo]()
    var invttKeyVl: String!

    override func invtt_create(pets: [Pet], beginDt: String, endDt: String) {
        NSLog("[LOG][I][(\(#fileID):\(#line))::\(#function)][pets:\(pets)][beginDt:\(beginDt)][endDt:\(endDt)]")
        self.startLoading()

        self.petInfos.removeAll()
        pets.forEach { pet in
            let ownrPetUnqNo = pet.ownrPetUnqNo
            let petNm = pet.petNm
            let petInfo = PetInfo(ownrPetUnqNo: ownrPetUnqNo, petNm: petNm)
            self.petInfos.append(petInfo)
        }

        let request = MyPetInvttCreateRequest(pet: petInfos, relBgngDt: beginDt, relEndDt: endDt)
        MyPetAPI.invttCreate(request: request) { response, error in
            self.stopLoading()

            if let response = response {
                self.invttKeyVl = response.invttKeyVl
                self.performSegue(withIdentifier: "segueMyPageToInviteCreate", sender: self)
            }

            self.processNetworkError(error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueMyPageToInviteCreate") {
            guard let pc = sender as? MyPageViewController2 else { return }
            guard let vc = segue.destination as? InviteCreateViewController2 else { return }
            vc.invttKeyVl = pc.invttKeyVl
            vc.petNames.removeAll()
            pc.petInfos.forEach { petInfo in
                vc.petNames.append(petInfo.petNm)
            }
        }
    }
}
