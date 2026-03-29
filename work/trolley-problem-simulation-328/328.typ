#set page(
paper: "a4",
height: 297mm,
width: 150mm,
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
 
#my_block(olive,rgb(95%, 100%, 95%) , white, black, [トロッコ問題を考えていたらこんな問題になりました。], [
人が $n$ 人います。
みんなで同時に、コインを投げて「表」か「裏」を決めます。

- 多い方のグループだけが残ります
- 少ない方はいなくなります
- もし同じ人数なら、全員そのまま残ります

これを何回もくり返します。さいごに残る人数は、何人になるでしょうか？ 

（興味がある人は，何回繰り返したら最後の人数になるのかシミュレーションしてみよう！）])

