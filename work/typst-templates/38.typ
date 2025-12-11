#set page(
paper: "a4",
height: 297mm,
width: 210mm,
margin: (x: 1.5cm, y: 1.5cm),
)
 
#set par(
  justify: true,
  leading: 1em,
)
 
#set text(
  font: ("New Computer Modern","BIZ UDPMincho")
)
 
#show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: "BIZ UDPGothic") 
#set text(lang: "ja")
 
#set enum(numbering: "(1)",)
 
#import "@preview/colorful-boxes:1.4.2": *
 
#let my_block(back_color, frame_color, title_color, content_color, title, content) = {
  block(width:auto,radius: 4pt, stroke: back_color + 3pt)[
    #block(width: 100%,fill: back_color, inset: (x: 20pt, y: 5pt), below: 0pt)[#text(title_color,font: ("New Computer Modern","BIZ UDPMincho"))[#title]]
   #block(radius: (
    bottom: 3pt,
  ),width: 100%, fill: frame_color, inset: (x: 20pt, y: 10pt))[#text(content_color)[#content]]
  ]
}
 
#my_block(olive,rgb(95%, 100%, 95%) , white, black, [\@takechan1414213さんからの証明問題], [

立方体ABCD-EFGHで対角線AGは平面BDEに垂直であることを証明せよ。


    #import "@preview/cetz:0.4.2"
    #figure(
      cetz.canvas(length:4cm,{
      import cetz.draw: *

      ortho(x: 20deg, y: 30deg, {

  
      let H = (0,0,0)
      let E = (0,0,1)
      let D = (0,1,0)
      let B = (1,1,1)
      let A = (0,1,1)
      let G = (1,0,0)
      let F = (1,0,1)
      let C = (1,1,0)
      let P = (1/3,2/3,2/3)


      
      let draw-point(pos, text, color, anchor) = {
      circle(pos, radius: 0.0, fill: color, stroke: none)
      content((), block(inset: 0.3em)[#text], anchor: anchor)
      }

      draw-point(A,  "A", black, "north")
      draw-point(B,  "B", black, "south-west")
      draw-point(C,  "C", black, "north")
      draw-point(D,  "D", black, "north")
      draw-point(E,  "E", black, "south")
      draw-point(F,  "F", black, "south")
      draw-point(G,  "G", black, "south")
      draw-point(H,  "H", black, "south")
      
      line(D,E,B,close:true,name:"DEB",stroke: blue,fill:aqua.transparentize(70%))
      
      
      line(A,B,name:"AB")
      line(D,H,name:"DH",stroke: (dash: "dotted") )

      let draw-point(pos, color) = {
      circle(pos, radius: 0.02, fill: color, stroke: none)
      }
      
      draw-point(P, red)

      line(B,C,name:"BC")
      line(C,D,name:"CD")
      line(D,A,name:"DA")
      line(A,E,name:"AE")
      line(B,F,name:"BF")
      line(C,G,name:"CG")
      line(E,F,name:"EF")
      line(F,G,name:"FG")
      line(G,H,name:"GH",stroke: (dash: "dotted"))
      line(H,E,name:"HE",stroke: (dash: "dotted"))

      line(G,P,name:"PG",stroke: red)
      line(A,P,name:"AP",stroke: red)
      
      })
      })
    )

  ])







次のように証明する。

#let args = arguments(fill: rgb("#7fdbff28"),stroke: blue, inset: 8pt,radius: 4pt,[+ 直線lと平面αが垂直 $==>$ 直線lと平面α上の任意の直線が垂直
  + 直線lと平面α上の平行でない2直線が垂直 $==>$ 直線lと平面αが垂直
])
#figure(box(..args))
  
  #columns(2)[

-  $"DB" perp "面ACGE"$ より，
  $ "AG" perp "DB" #h(2mm)dots.c #h(2mm)"①" $



    #import "@preview/cetz:0.3.2"
    #figure(
      cetz.canvas(length:4cm,{
      import cetz.draw: *

      ortho(x: 20deg, y: 30deg, {

  
      let H = (0,0,0)
      let E = (0,0,1)
      let D = (0,1,0)
      let B = (1,1,1)
      let A = (0,1,1)
      let G = (1,0,0)
      let F = (1,0,1)
      let C = (1,1,0)
      let P = (1/3,2/3,2/3)


      
      let draw-point(pos, text, color, anchor) = {
      circle(pos, radius: 0.0, fill: color, stroke: none)
      content((), block(inset: 0.3em)[#text], anchor: anchor)
      }

      draw-point(A,  "A", black, "north")
      draw-point(B,  "B", black, "south-west")
      draw-point(C,  "C", black, "north")
      draw-point(D,  "D", black, "north")
      draw-point(E,  "E", black, "south")
      draw-point(F,  "F", black, "south")
      draw-point(G,  "G", black, "south")
      draw-point(H,  "H", black, "south")
      
      line(A,C,G,E,close:true,name:"DEB",stroke: olive,fill:yellow.transparentize(70%))
      
      
      line(A,B,name:"AB")
      line(D,H,name:"DH",stroke: (dash: "dotted") )

      let draw-point(pos, color) = {
      circle(pos, radius: 0.02, fill: color, stroke: none)
      }
      

      line(B,C,name:"BC")
      line(C,D,name:"CD")
      line(D,A,name:"DA")
      line(A,E,name:"AE")
      line(B,F,name:"BF")
      line(C,G,name:"CG")
      line(E,F,name:"EF")
      line(F,G,name:"FG")
      line(G,H,name:"GH",stroke: (dash: "dotted"))
      line(H,E,name:"HE",stroke: (dash: "dotted"))

      line(G,P,name:"PG",stroke: red)
      line(A,P,name:"AP",stroke: red)
      line(D,B,name:"AP",stroke: blue)
      
      
      })
      })
    )

#colbreak()

-  $"BE" perp "面AFGD"$ より，
  $ "AG" perp "EB"#h(2mm)dots.c #h(2mm)"②"  $




    #import "@preview/cetz:0.3.2"
    #figure(
      cetz.canvas(length:4cm,{
      import cetz.draw: *

      ortho(x: 20deg, y: 30deg, {

  
      let H = (0,0,0)
      let E = (0,0,1)
      let D = (0,1,0)
      let B = (1,1,1)
      let A = (0,1,1)
      let G = (1,0,0)
      let F = (1,0,1)
      let C = (1,1,0)
      let P = (1/3,2/3,2/3)


      
      let draw-point(pos, text, color, anchor) = {
      circle(pos, radius: 0.0, fill: color, stroke: none)
      content((), block(inset: 0.3em)[#text], anchor: anchor)
      }

      draw-point(A,  "A", black, "north")
      draw-point(B,  "B", black, "south-west")
      draw-point(C,  "C", black, "north")
      draw-point(D,  "D", black, "north")
      draw-point(E,  "E", black, "south")
      draw-point(F,  "F", black, "south")
      draw-point(G,  "G", black, "south")
      draw-point(H,  "H", black, "south")
      
      line(A,D,G,F,close:true,name:"DEB",stroke: olive,fill:yellow.transparentize(70%))
      
      
      line(A,B,name:"AB")
      line(D,H,name:"DH",stroke: (dash: "dotted") )

      let draw-point(pos, color) = {
      circle(pos, radius: 0.02, fill: color, stroke: none)
      }
      

      line(B,C,name:"BC")
      line(C,D,name:"CD")
      line(D,A,name:"DA")
      line(A,E,name:"AE")
      line(B,F,name:"BF")
      line(C,G,name:"CG")
      line(E,F,name:"EF")
      line(F,G,name:"FG")
      line(G,H,name:"GH",stroke: (dash: "dotted"))
      line(H,E,name:"HE",stroke: (dash: "dotted"))

      line(G,P,name:"PG",stroke: red)
      line(A,P,name:"AP",stroke: red)
      line(E,B,name:"AP",stroke: blue)
      
      
      })
      })
    )
  ]
- ①，② より，
    $"対角線AG" perp "平面BDE" $


