//
//  BBSTarget.swift
//  PetTip
//
//  Created by carebiz on 12/30/23.
//

import Foundation
import Alamofire

enum BBSTarget {
    case winnerList(WinnerListRequest)
    case winnerDtlList(WinnerDtlListRequest)
    case eventList(EventListRequest)
    case eventDtlList(EventDtlListRequest)
    case noticeList(NoticeListRequest)
    case noticeDtlList(NoticeDtlListRequest)
    case qnaList(QnAListRequest)
    case qnaCreate(QnACreateRequest)
    case qnaDelete(QnADeleteRequest)
    case qnaUpdate(QnAUpdateRequest)
    case qnaDtlList(QnADtlListRequest)
    case faqList(FaqListRequest)
}

extension BBSTarget: TargetType {

    var baseURL: String {
        return String("\(Global.BASE_URI)/bbs")
    }

    var method: HTTPMethod {
        switch self {
        case .winnerList: return .post
        case .winnerDtlList: return .post
        case .eventList: return .post
        case .eventDtlList: return .post
        case .noticeList: return .post
        case .noticeDtlList: return .post
        case .qnaList: return .post
        case .qnaCreate: return .post
        case .qnaDelete: return .post
        case .qnaUpdate: return .post
        case .qnaDtlList: return .post
        case .faqList: return .post
        }
    }

    var path: String {
        switch self {
        case .winnerList: return "/winner/list"
        case .winnerDtlList: return "/winner/dtl/list"
        case .eventList: return "/event/list"
        case .eventDtlList: return "/event/dtl/list"
        case .noticeList: return "/ntc/list"
        case .noticeDtlList: return "/ntc/dtl/list"
        case .qnaList: return "/qna/bsc/list"
        case .qnaCreate: return "/qna/create"
        case .qnaDelete: return "/qna/delete"
        case .qnaUpdate: return "/qna/update"
        case .qnaDtlList: return "/qna/dtl/list"
        case .faqList: return "/faq/list"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .winnerList(let request): return .body(request)
        case .winnerDtlList(let request): return .body(request)
        case .eventList(let request): return .body(request)
        case .eventDtlList(let request): return .body(request)
        case .noticeList(let request): return .body(request)
        case .noticeDtlList(let request): return .body(request)
        case .qnaList(let request): return .body(request)
        case .qnaCreate(let request): return .body(request)
        case .qnaDelete(let request): return .body(request)
        case .qnaUpdate(let request): return .body(request)
        case .qnaDtlList(let request): return .body(request)
        case .faqList(let request): return .body(request)
        }
    }
}
