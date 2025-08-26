import SwiftUI

struct UserDataView: View {
    
    @Binding var userInfo: UserModel
    var isRegistration = false
    
    var body: some View {
        ScrollView{
            VStack{
                // VStack has limit for number of inner elements => using Group
                Group{
                    Text("Name:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter your name", text: $userInfo.name)
                        .iceControlStyle()
                        .disableAutocorrection(true)
                    
                    Text("Surname:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter your surname", text: $userInfo.surname)
                        .iceControlStyle()
                        .disableAutocorrection(true)
                    
                    Text("Country:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter your country", text: $userInfo.country)
                        .iceControlStyle()
                        .disableAutocorrection(true)
                    
                    Text("Town:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter your town", text: $userInfo.town)
                        .iceControlStyle()
                        .disableAutocorrection(true)
                }
                
                Group{
                    Text("Birth date:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    DateView(dateInf: $userInfo.birthDate)
                        .iceControlStyle(hght: .infinity)
                }
                
                if !isRegistration{
                    Text("Notes:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextEditor(text: $userInfo.notes)
                        .iceControlStyle(hght: 150)
                    Text("Number of favourites: \(userInfo.favourites.count)")
                }
                
            }
            .padding(5)
        }
        .iceControlStyle(hght: .infinity)
    }
}


struct DateView: View{
    @Binding var dateInf: Date
    @State private var showCalendar = false
    // range of available birth date
    var dateRange: ClosedRange<Date>{
        let calendar = Calendar.current
        let now = Date()
        // 150 years ago
        let resonableLimit = calendar.date(byAdding: .year, value: -150, to: now)!
        return resonableLimit...now
    }
    
    var body : some View{
        VStack(){
            Button(action: {withAnimation{
                showCalendar = !showCalendar
            }}){
                Text("\(dateInf.getFormattedDate())")
                    .underline()
                    .foregroundColor(.blue)
            }
            if showCalendar{
                DatePicker("Date",
                           selection:
                            Binding(
                                get: {dateInf},
                                // set need for making birth time at start of days date
                                set: {newDate in
                                    dateInf = Calendar.current.startOfDay(for: newDate)
                                }
                            ),
                           in: dateRange, displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            }   
        }
    }
}

extension Date{
    func getFormattedDate () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
