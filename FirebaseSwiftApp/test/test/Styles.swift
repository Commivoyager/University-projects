import SwiftUI

struct IceControlStyle: ViewModifier{
    var hght: CGFloat = 45
    func body(content: Content) -> some View
    {
        content
            .padding()
            .font(.title2) // размер шрифта
            .foregroundColor(.white)
            .frame(height: hght)
            .frame(maxWidth: .infinity)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

extension View{
    func iceControlStyle(hght: CGFloat = 45) -> some View{
        self.modifier(IceControlStyle(hght: hght))
    }
}


struct IceScreenStyle: ViewModifier{
    func body(content: Content) -> some View{
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
    }
}

extension View{
    func iceScreenStyle() -> some View{
        self.modifier(IceScreenStyle())
    }
}


struct IcePasswordField: View{
    var placeholder: String = "";
    @Binding var password: String;
    @State private var isSeen: Bool = false;
    
    init(_ placeholder: String, password: Binding<String>){
        self.placeholder = placeholder
        self._password = password
    }
    var body: some View{
        HStack{
            if(isSeen){
                TextField(placeholder, text: $password)
            }else{
                SecureField(placeholder, text: $password)
            }
            Button(action: {isSeen.toggle()}){
                Image(systemName: isSeen ? "eye" : "eye.slash").foregroundColor(.white)
            }
            .frame( alignment: .trailing)
        }
        .iceControlStyle()
        .disableAutocorrection(true)
    }
}
