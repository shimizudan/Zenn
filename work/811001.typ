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
 
#my_block(olive,rgb(95%, 100%, 95%) , white, black, [複素数と不等式の問題], [
  $z^2-3z+2 lt.equiv 0$ となる複素数 $z$ を求めよ。
  ])

  $ z =a+b i #h(3mm) a,b in RR$ とすると

  $ z^2-3z+2 &= (a+b i)^2-3(a+b i)+2\
            &=a^2+2 a b i -b^2 -3a-3b i +2\
            &=(a^2-b^2-3a+2) + (2 a b -3b )i in RR  $
  $ therefore b(2a-3) = 0 $
  $ b = 0 or a = 3/2 $

  - $b=0$ のとき，$z in RR$
    $ z^2-3z+2 = (z-2)(z-1) lt.equiv 0 $
    $ 1 lt.equiv z lt.equiv 2 and z in RR  $

  - $a = 3/2$ のとき，$Z= 3/2 + b i $
      $ z^2-3z+2 = (3/2+b i-2)(3/2 + b i-1) = (b i-1/2)(b i +1/2) = -b^2-1/4 lt.equiv 1/4 lt.equiv 0 $
    $ 1 lt.equiv z lt.equiv 2 and z in RR  $

以上より，
  $ (z in RR and 1 lt.equiv z lt.equiv 2) or (Re(z) = 3/2)  $

#pagebreak()

#my_block(green.darken(20%),rgb(95%, 100%, 95%) , white, black, [\@tekkinoho さんからの最大・最小の問題], [
  $0 lt.eq theta lt.eq pi$ , $sin theta + cos theta gt.eq 1/2$ をみたして，$theta$ が動くとき，$sin theta - cos theta$ の値の取りうる値の範囲は？
])

#h(5mm)
$x = cos theta$ , $y = sin theta$ とすると

- $(cos theta, sin theta)$ #h(3mm) $(0 lt.eq theta lt.eq pi)$ → 赤と青の円弧，$x + y gt.eq 1/2$ → 水色の領域
- $x + y = 1/2$ → 黒線，$y - x = sqrt(2)$ → 青線，$y - x = -1$ → 紫線，$y - x = sqrt(7)/2$ → 緑線

$y - x = k$ とおいて，直線 $y = x + k$ が赤い円弧と共有点を持つような，$k$ の範囲を求めればよい。

- 赤い円弧の右側の端点の座標は $(1, 0)$
  $ k = 0 - 1 = -1 $

- 赤い円弧の左側の端点の座標は
  $ x^2 + (-x + 1/2)^2 = 1 $
  $ 2x^2 - x - 3/4 = 0 $
  $ 8x^2 - 4x - 3 = 0 $
  $ x = (2 - sqrt(28))/8 = (1 - sqrt(7))/4 $
  $ (x, y) = ((1 - sqrt(7))/4, (1 + sqrt(7))/4) $
  $ k = (1 + sqrt(7))/4 - (1 - sqrt(7))/4 = sqrt(7)/2 $

$ -1 lt.eq k lt.eq sqrt(7)/2 $

$ therefore -1 lt.eq sin theta - cos theta lt.eq sqrt(7)/2 $

#pagebreak()

#import "@preview/cetz:0.4.2"
#figure(
cetz.canvas(length: 3cm, {
  import cetz.draw: *

  // 座標軸
  line((-1.5, 0), (1.5, 0), stroke: (paint: black, thickness: 1pt), name: "x-axis")
  line((0, -1.5), (0, 1.5), stroke: (paint: black, thickness: 1pt), name: "y-axis")

  // 軸ラベル
  content((1.5, -0.15), anchor: "north", text(size: 14pt, $x$))
  content((-0.15, 1.5), anchor: "east", text(size: 14pt, $y$))
  content((-0.15, -0.15), anchor: "north-east", text(size: 14pt, $O$))

  // 単位円（赤い円弧：0 ≤ θ ≤ π）
  arc((0, 0), start: 0deg, stop: 180deg, radius: 1, stroke: (paint: red, thickness: 2.5pt), name: "arc-red")

  // 青い円弧（直線 x + y = 1/2 より左側の部分）
  // (1/2, 0)から(-1/2, 1)あたりまで
  arc((0, 0), start: 120deg, stop: 180deg, radius: 1, stroke: (paint: blue, thickness: 2.5pt), name: "arc-blue")

  // 直線 x + y = 1/2（黒線）
  line((-0.5, 1), (1, -0.5), stroke: (paint: black, thickness: 1.5pt))

  // 直線 y - x = √2（青線）
  line((-0.5, calc.sqrt(2) - 0.5), (0.5, calc.sqrt(2) + 0.5), stroke: (paint: blue, thickness: 1.5pt))

  // 直線 y - x = -1（紫線）
  line((-0.5, -1.5), (1.2, 0.2), stroke: (paint: purple, thickness: 1.5pt))

  // 直線 y - x = √7/2（緑線）
  let k_max = calc.sqrt(7) / 2
  line((-0.5, k_max - 0.5), (0.5, k_max + 0.5), stroke: (paint: green, thickness: 1.5pt))

  // 水色の領域（x + y ≥ 1/2 の部分）
  // 多角形で近似
  let pts = ()
  for i in range(0, 61) {
    let angle = i * 3deg
    let x = calc.cos(angle)
    let y = calc.sin(angle)
    if x + y >= 0.48 {  // 少し余裕を持たせる
      pts.push((x, y))
    }
  }
  // 直線との交点を追加
  let x1 = (1 - calc.sqrt(7)) / 4
  let y1 = (1 + calc.sqrt(7)) / 4
  pts.push((x1, y1))
  pts.push((0.5, 0))

  // 塗りつぶし
  if pts.len() > 2 {
    line(..pts, close: true, fill: rgb(200, 240, 255, 150), stroke: none)
  }

  // 端点
  circle((1, 0), radius: 0.05, fill: blue, stroke: none)
  let x_left = (1 - calc.sqrt(7)) / 4
  let y_left = (1 + calc.sqrt(7)) / 4
  circle((x_left, y_left), radius: 0.05, fill: blue, stroke: none)

  // 端点のラベル
  content((1, 0), anchor: "north-west", padding: 3pt, text(size: 12pt, $(1, 0)$))
  content((x_left, y_left), anchor: "south-east", padding: 3pt, text(size: 10pt, $((1-sqrt(7))/4, (1+sqrt(7))/4)$))
})
,caption: [$-1 lt.eq sin theta - cos theta lt.eq sqrt(7)/2$]
)
