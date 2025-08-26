// only for DB initialization
import Foundation
import FirebaseFirestore

final class ItemsInitializator{
    
    static let shared = ItemsInitializator()
    private static let itemsCollection = "Icebrakers"
    private let db = Firestore.firestore()
    private var errMess: String = "";
    
    private init(){}
    
    public func uploadData(){
        for arrItem in icebreakers{
            DBManager.shared.putItem(item: arrItem)
        }
    }
    
    // array with data
    let icebreakers: [IcebreakerModel] = [
//        IcebreakerModel(
//            name: "Арктика",
//            description: "Головной атомный ледокол проекта 10520, первый в мире достиг Северного полюса.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1975, month: 4, day: 25)),
//            terminationDate: Calendar.current.date(from: DateComponents(year: 2008, month: 10, day: 01)),
//            countryName: "СССР",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg/3600px-Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg.png"
//        )
//        ,
//        IcebreakerModel(
//            name: "Сибирь",
//            description: "Второй атомный ледокол проекта 10520. Участвовал в проводке судов по Северному морскому пути до вывода из эксплуатации в 1992 году.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1977, month: 12, day: 28)),
//            terminationDate: Calendar.current.date(from: DateComponents(year: 1992, month: 11, day: 1)),
//            countryName: "СССР",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg/3600px-Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg.png"
//        ),
//        IcebreakerModel(
//            name: "Россия",
//            description: "Третий атомный ледокол проекта 10520. Эксплуатируется с 1985 года для проводки судов в Арктике.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1985, month: 12, day: 10)),
//            terminationDate: nil,
//            countryName: "СССР",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg/3600px-Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg.png"
//        ),
//        IcebreakerModel(
//            name: "Советский Союз",
//            description: "Четвёртый атомный ледокол проекта 10520. Использовался для научных экспедиций до 2000-х годов.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1989, month: 12, day: 31)),
//            terminationDate: nil,
//            countryName: "СССР",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg/3600px-Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg.png"
//        ),
//        IcebreakerModel(
//            name: "Ямал",
//            description: "Пятый атомный ледокол проекта 10520. С 1992 года используется для туристических круизов к Северному полюсу.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1992, month: 10, day: 1)),
//            terminationDate: nil,
//            countryName: "Россия",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Flag_of_the_Russian_Federation.svg/800px-Flag_of_the_Russian_Federation.svg.png"
//        ),
//        IcebreakerModel(
//            name: "50 лет Победы",
//            description: "Самый мощный атомный ледокол проекта 10520. Введён в эксплуатацию в 2007 году.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 2007, month: 2, day: 1)),
//            terminationDate: nil,
//            countryName: "Россия",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Flag_of_the_Russian_Federation.svg/800px-Flag_of_the_Russian_Federation.svg.png"
//        ),
//        IcebreakerModel(
//            name: "Арктика (проект 22220)",
//            description: "Головной атомный ледокол нового поколения. Спущен на воду в 2016 году, введён в эксплуатацию в 2020.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 2020, month: 10, day: 21)), // Дата ввода в строй
//            terminationDate: nil,
//            countryName: "Россия",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Flag_of_the_Russian_Federation.svg/800px-Flag_of_the_Russian_Federation.svg.png"
//        ),
//        IcebreakerModel(
//            name: "CCGS Louis S. St-Laurent",
//            description: "Крупнейший канадский ледокол (1969). Используется для научных исследований в Арктике.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1969, month: 10, day: 1)),
//            terminationDate: nil,
//            countryName: "Канада",
//            pictures: [],
//            countryFlag: "https://s0.rbk.ru/v6_top_pics/media/img/9/64/756691574229649.png"
//        ),
//        IcebreakerModel(
//            name: "USCGC Polar Star",
//            description: "Американский тяжёлый ледокол (1976). Обеспечивает операции в Антарктике.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1976, month: 1, day: 1)),
//            terminationDate: nil,
//            countryName: "США",
//            pictures: [],
//            countryFlag: "https://91b6be3bd2294a24b7b5-da4c182123f5956a3d22aa43eb816232.ssl.cf1.rackcdn.com/contentItem-1709985-8525472-c79tyqq1atrxa-or.jpg"
//        ),
//        IcebreakerModel(
//            name: "RV Polarstern",
//            description: "Немецкий научный ледокол (1982). Проводит исследования в Арктике и Антарктике.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1982, month: 12, day: 9)),
//            terminationDate: nil,
//            countryName: "Германия",
//            pictures: [],
//            countryFlag: "https://i.pinimg.com/originals/18/fd/89/18fd89f9ec613b067cc42e532c39628f.jpg"
//        ),
//        IcebreakerModel(
//            name: "Капитан Сорокин",
//            description: "Дизель-электрический ледокол (Финляндия, 1977). Эксплуатируется в портах Дальнего Востока.",
//            releaseDate: Calendar.current.date(from: DateComponents(year: 1977, month: 5, day: 15)),
//            terminationDate: nil,
//            countryName: "СССР",
//            pictures: [],
//            countryFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg/3600px-Flag_of_the_Chinese_Communist_Party_(Pre-1996).svg.png"
//        )
    ]
}

