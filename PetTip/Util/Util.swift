//
//  Util.swift
//  PetTip
//
//  Created by carebiz on 1/1/24.
//

import Foundation

class Util {

    static func transDiffDateStr(_ oriDateStr: String) -> String {
        if oriDateStr != "미상" && oriDateStr.count == 8 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let birthday = dateFormatter.date(from: oriDateStr)

            let offset = Calendar.current.dateComponents([.year, .month, .day], from: birthday!, to: Date())

            // let MAX_KIND_CNT = 2
            let MAX_KIND_CNT = 3
            var kindCnt = 0

            // let splitter = " "
            let splitter = ""

            var diffStr: String = ""
            if let y = offset.year {
                if y > 0 {
                    diffStr = String("\(y)년")
                    kindCnt += 1
                }
            }
            if let m = offset.month {
                if m > 0 {
                    diffStr = diffStr.count > 0 ? diffStr + splitter : diffStr
                    diffStr += String("\(m)개월")
                    kindCnt += 1
                }
            }
            if let d = offset.day {
                if d > 0 {
                    if kindCnt < MAX_KIND_CNT {
                        diffStr = diffStr.count > 0 ? diffStr + splitter : diffStr
                        diffStr += String("\(d)일")
                    }
                }
            }

            return diffStr
        }

        return "미상"
    }

    static func getModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        // print("#model: ", model)
        return model
    }

    // MARK: - JWT decode
    static func decode(jwtToken jwt: String) -> [String: Any] {
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }

            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
}

