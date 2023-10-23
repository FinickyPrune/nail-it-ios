//
//  DebugData.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 23.10.2023.
//

import Foundation

struct DebugData {

    static func loginData() throws -> [String: Any?] {
        try NailItSignInResponse(id: 1,
                             name: "FinickyPrune",
                             phoneNumber: "+75551989111",
                             accessToken: "access_token",
                             message: nil,
                             status: nil).toDictionary()
    }

    static func mastersWithAppointmentsData() throws -> [[String: Any?]] {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSZZZ"

        let date = Date()
        let minutes = Calendar.current.component(.minute, from: date)

        var appointments: [Appointment] = []
        for i in 1..<20 {
            appointments.append( Appointment(appointmentId: 0,
                                             serviceTitle: "title",
                                             salonTitle: nil,
                                             salonAddress: nil,
                                             masterName: nil,
                                             date: dateFormatter.string(from: date.addingTimeInterval(TimeInterval(i * 3600 - minutes * 60 + 10 * 3600 + 30 * 60))),
                                             price: nil,
                                             time: "time"))
        }

        return try [MasterWithAppResponse(master: Master(masterId: 0,
                                                         name: "Ola",
                                                         rate: 0.0,
                                                         beautySalonId: nil,
                                                         masterCategoryId: nil),
                                          appointmentDtos: appointments).toDictionary(),
                    MasterWithAppResponse(master: Master(masterId: 1,
                                                         name: "Lily",
                                                         rate: 0.5,
                                                         beautySalonId: nil,
                                                         masterCategoryId: nil),
                                          appointmentDtos: appointments).toDictionary(),
                    MasterWithAppResponse(master: Master(masterId: 1,
                                                         name: "Jean",
                                                         rate: 2.5,
                                                         beautySalonId: nil,
                                                         masterCategoryId: nil),
                                          appointmentDtos: appointments).toDictionary(),
                    MasterWithAppResponse(master: Master(masterId: 1,
                                                         name: "Ruby",
                                                         rate: 3.5,
                                                         beautySalonId: nil,
                                                         masterCategoryId: nil),
                                          appointmentDtos: appointments).toDictionary(),
                    MasterWithAppResponse(master: Master(masterId: 1,
                                                         name: "Maeve",
                                                         rate: 5,
                                                         beautySalonId: nil,
                                                         masterCategoryId: nil),
                                          appointmentDtos: appointments).toDictionary()]
    }
}
