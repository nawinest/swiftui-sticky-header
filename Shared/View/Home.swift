//
//  Home.swift
//  StickyHeader (iOS)
//
//  Created by Nawin Poolsawad on 15/7/2565 BE.
//

import SwiftUI

struct Home: View {
    @State var currentType: String = "Popular"
    @Namespace var animation
    
    @State var _albums: [Album] = albums
    
    @State var headerOffsets: (CGFloat,CGFloat) = (0,0)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HeaderView()
            
            //MARK: - Pinned Header
            LazyVStack(pinnedViews: [
                .sectionHeaders
            ]) {
                Section {
                    SongList()
                } header: {
                    PinnedHeaderView()
                        .background(Color.black)
                        .offset(y: (headerOffsets.0 - 47.0) < 0 ? Tools.getStatusBarHeight() - headerOffsets.0: 0)
                        .modifier(OffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
                        .modifier(OffsetModifier(offset: $headerOffsets.1))
                }
            }
        }
        .overlay(content: {
            Rectangle()
                .fill(.black)
                .frame(height: 50)
                .frame(maxHeight: .infinity,alignment: .top)
                .opacity(headerOffsets.0 < Tools.getStatusBarHeight() ? 1 : 0)
        })
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = size.height + minY
            Image("Ariana")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: height, alignment: .top)
                .overlay(content: {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("ARTIST")
                                .font(.callout)
                                .foregroundColor(.gray)
                            HStack {
                                Text("Ariana Grande")
                                    .font(.title.bold())
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                                    .background(
                                        Circle()
                                            .background(Color.blue)
                                            .padding(5)
                                    )
                            }
                            Label {
                                Text("Monthy Listener")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.7))
                            } icon: {
                                Text("69,454,333")
                                    .fontWeight(.semibold)
                            }
                            .font(.caption)
                        }
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                })
                .cornerRadius(20)
                .offset(y: -minY)
        }
        .frame(height: 250)
    }
    
    @ViewBuilder
    func PinnedHeaderView()->some View{
        let types: [String] = ["Popular","Albums","Songs","Fans also like","About"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25){
                
                ForEach(types,id: \.self){type in
                    VStack(spacing: 12){
                        Text(type)
                            .fontWeight(.semibold)
                            .foregroundColor(currentType == type ? .white : .gray)
                        
                        ZStack{
                            if currentType == type{
                                Capsule()
                                    .fill(.white)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                            else{
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }
                        }
                        .padding(.horizontal,8)
                        .frame(height: 4)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            currentType = type
                        }
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 47.0)
        }
    }
    
    func getIndex(album: Album)->Int{
        return _albums.firstIndex { currentAlbum in
            return album.id == currentAlbum.id
        } ?? 0
    }
    
    // MARK: Pinned Content
    @ViewBuilder
    func SongList()->some View{
        VStack(spacing: 25){
            ForEach($_albums){$album in
                
                HStack(spacing: 12){
                    
                    Text("#\(getIndex(album: album) + 1)")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    Image(album.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(album.albumName)
                            .fontWeight(.semibold)
                        
                        Label {
                            Text("65,587,909")
                        } icon: {
                            Image(systemName: "beats.headphones")
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.gray)
                        .font(.caption)
                    }
                    Spacer()
                    
                    Button {
                        album.isLiked.toggle()
                    } label: {
                     
                        Image(systemName: album.isLiked ? "suit.heart.fill" : "suit.heart")
                            .font(.title3)
                            .foregroundColor(album.isLiked ? Color("Green") : .white)
                    }
                    
                    Button {
                    } label: {
                     
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .padding(.bottom,900)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

class Tools {
    static func getStatusBarHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
}
