#set page(paper: "a4", flipped: false, margin: 1.5cm, fill: white)
#set text(font: "Hiragino Maru Gothic ProN", size: 11pt)
#import "@preview/cetz:0.4.2"
#import "@preview/tablex:0.0.9": tablex, cellx, hlinex, vlinex


// 曲線矢印（上に凸で減少）
#let arrow-right-down = box(cetz.canvas(length: 1em, {
  import cetz.draw: *

  arc((0, 0), start: 90deg, stop: 0deg, radius: .8, mark: (end: ">",fill: black,scale:0.5),stroke:0.5pt)
}))

// 曲線矢印（下に凸で減少）
#let arrow-down-right = box(cetz.canvas(length: 1em, {
  import cetz.draw: *

  arc((0, 0), start: 180deg, stop: 270deg, radius: .8, mark: (end: ">",fill: black,scale:0.5),stroke:0.5pt)
}))

// 曲線矢印（下に凸で増加）
#let arrow-right-up = box(cetz.canvas(length: 1em, {
  import cetz.draw: *

  arc((0, 0), start: 270deg, stop: 360deg, radius: .8, mark: (end: ">",fill: black,scale:0.5),stroke:0.5pt)
}))


// 曲線矢印（上に凸で増加）
#let arrow-up-right = box(cetz.canvas(length: 1em, {
  import cetz.draw: *

  arc((0, 0), start: 180deg, stop: 90deg, radius: .8, mark: (end: ">",fill: black,scale:0.5),stroke:0.5pt)
}))

// #arrow-right-down 
// #arrow-down-right
// #arrow-right-up
// #arrow-up-right


#import "@preview/colorful-boxes:1.4.2": *
 
#let my_block(back_color, frame_color, title_color, content_color, title, content) = {
  block(width:auto,radius: 4pt, stroke: back_color + 3pt)[
    #block(width: 100%,fill: back_color, inset: (x: 20pt, y: 5pt), below: 0pt)[#text(title_color,font: ("New Computer Modern","Hiragino Maru Gothic ProN"))[#title]]
   #block(radius: (
    bottom: 3pt,
  ),width: 100%, fill: frame_color, inset: (x: 20pt, y: 10pt))[#text(content_color)[#content]]
  ]
}
 
#my_block(olive,rgb(95%, 100%, 95%) , white, black, [*関数の増減とグラフ*], [

#v(3mm)
$display(y = cos 2x - 2 sin x)$ $display((0 lt.equiv x lt.equiv 2pi))$ について， $y'$ , $y''$ を求め，増減表を書き，グラフを描きましょう。
#v(3mm)

  ])

#v(3mm)

#columns(2)[
=== 導関数
 #v(2mm)

第1次導関数は
- $ y' &= -2 sin 2x - 2 cos x \
&= -4 sin x cos x - 2 cos x \
&= -2 cos x (2 sin x + 1)\
 $
 #v(5mm)

第2次導関数は

- $ 
y'' &= -2(-sin x)(2 sin x + 1) - 2 cos x dot 2 cos x \
&= 2 sin x (2 sin x + 1) - 4 cos^2 x \
&= 4 sin^2 x + 2 sin x - 4 cos^2 x \
&= 4 sin^2 x + 2 sin x - 4(1 - sin^2 x) \
&= 8 sin^2 x + 2 sin x - 4
$

 #v(5mm)


=== 極値・変曲点・増減表
 #v(2mm)

- $display(y' = 0)$ となるのは：

    - $display(cos x = 0)$ のとき：$ x = display(pi/2) ", " display((3pi)/2) $

    - $display(2 sin x + 1 = 0)$ すなわち $display(sin x = -1/2)$ のとき：$ x = display((7pi)/6) ", " display((11pi)/6) $

    #v(5mm)

- $display(y'' = 0)$ となるのは：

  - $display(8 sin^2 x + 2 sin x - 4 = 0)$ より 
  
  $ display(4 sin^2 x + sin x - 2 = 0) $

  $ display(sin x = (-1 plus.minus sqrt(33))/8) $

   #v(5mm)


#colbreak()
- $alpha, beta, gamma, delta$ を次を満たす角とする：
  #v(5mm)
  - $display(sin alpha = (-1 + sqrt(33))/8)$ かつ $display(0 < alpha < pi/2)$

  - $display(sin beta = (-1 + sqrt(33))/8)$ かつ $display(pi/2 < beta < pi)$

  - $display(sin gamma = (-1 - sqrt(33))/8)$ かつ $display(pi < gamma < (3pi)/2)$

  - $display(sin delta = (-1 - sqrt(33))/8)$ かつ $display((3pi)/2 < delta < 2pi)$

   #v(5mm)

=== 極小値:
 #v(2mm)
- $display(x = pi/2)$ のとき：$ y &= cos pi - 2 sin(pi/2)= -1 - 2 = -3 $

- $display(x = (3pi)/2)$ のとき：$ y &= cos 3pi - 2 sin((3pi)/2)= -1 - 2(-1) = 1 $

  #v(5mm)

=== 極大値:
 #v(2mm)
- $display(x = (7pi)/6)$ のとき：$ y &= cos((7pi)/3) - 2 sin((7pi)/6)= 1/2 - 2(-1/2) = 3/2 $

- $display(x = (11pi)/6)$ のとき：$ y &= cos((11pi)/3) - 2 sin((11pi)/6)= 1/2 - 2(-1/2) = 3/2 $

=== 変曲点
 #v(1mm)
- $x = alpha,beta,gamma,delta$ に対応する点

$ (alpha,(3-3sqrt(33))/16),(beta,(3-3sqrt(33))/16), (gamma,(3+3sqrt(33))/16),(delta,(3+3sqrt(33))/16)$

]
 #v(5mm)
#figure(
  table(
    columns: 20,
    align: center + horizon,
    stroke: (x, y) => (
      left: if x == 1 { 1pt } else { 0pt },
      right: 0pt,
      top: if y == 1 or y == 2 or y == 3 { 1pt } else { 0pt },
      bottom: none
    ),

    // ヘッダー行
    [$x$], [$0$], [$dots.c$], [$alpha$], [$dots.c$], [$pi/2$], [$dots.c$], [$beta$], [$dots.c$], [$(7pi)/6$], [$dots.c$], [$gamma$], [$dots.c$], [$(3pi)/2$], [$dots.c$], [$delta$], [$dots.c$], [$(11pi)/6$], [$dots.c$], [$2pi$],

    // y'の行
    [$y'$], [$-$], [$-$], [$-$], [$-$], [$0$], [$+$], [$+$], [$+$], [$0$], [$-$], [$-$], [$-$], [$0$], [$+$], [$+$], [$+$], [$0$], [$-$], [$-$],

    // y''の行
    [$y''$], [$-$], [$-$], [$0$], [$+$], [$+$], [$+$], [$0$], [$-$], [$-$], [$-$], [$0$], [$+$], [$+$], [$+$], [0], [$-$], [$-$], [$-$], [$-$],

    // yの行
    [$y$], [$1$], arrow-right-down, [$(3-3sqrt(33))/16$], arrow-down-right, [$-3$], arrow-right-up, [$(3-3sqrt(33))/16$], arrow-up-right, [$3/2$], arrow-right-down, [$(3+3sqrt(33))/16$], arrow-down-right, [$1$], arrow-right-up, [$(3+3sqrt(33))/16$], arrow-up-right, [$3/2$], arrow-right-down, [$1$], [],
  ),
  caption: [増減表]
)

#pagebreak()

=== グラフ

#figure(
  cetz.canvas(length: 2.0cm, {
    import cetz.draw: *

    let pi = calc.pi

    // 関数定義
    let f(x) = calc.cos(2 * x) - 2 * calc.sin(x)

    // 変曲点の角度を計算（ラジアン値として）
    // sin(x) = (-1 + sqrt(33))/8 の解
    let sin-val-1 = (-1 + calc.sqrt(33)) / 8
    let alpha = calc.asin(sin-val-1) / 1rad
    let beta = pi - alpha

    // sin(x) = (-1 - sqrt(33))/8 の解
    let sin-val-2 = (-1 - calc.sqrt(33)) / 8
    let gamma = pi - calc.asin(sin-val-2) / 1rad
    let delta = 2 * pi + calc.asin(sin-val-2) / 1rad

    // スケール設定
    let x-scale = 1.0
    let y-scale = 0.8

    // 座標変換関数
    let to-canvas(x, y) = ((x - 0) * x-scale, y * y-scale)

    // 座標軸
    let (x-max, _) = to-canvas(2 * pi, 0)
    line((-1, 0), (x-max + 1, 0), stroke: black + 1pt, mark: (end: ">",fill:black))
    line((0, -4.0 * y-scale), (0, 3.0 * y-scale ), stroke: black + 1pt, mark: (end: ">",fill:black))

    // 軸ラベル
    content((x-max + 1.1, 0), [$x$], anchor: "west")
    content((0, 3.0 * y-scale + 0.1), [$y$], anchor: "south")
    content((0 - .1, 0 - .1), text(font: "New Computer Modern")[O], anchor: "north-east")

    // 関数のプロット
    let points = ()
    let n-samples = 300
    for i in range(0, n-samples + 1) {
      let x = i / n-samples * 2 * pi
      let y = f(x)
      let (cx, cy) = to-canvas(x, y)
      points.push((cx, cy))
    }

    line(..points, stroke: blue + 1.5pt)

    // 端点のマーク
    // x = 0 での端点 (y = 1)
    let (cx0, cy0) = to-canvas(0, 1)
    circle((cx0, cy0), radius: 0.05, fill: blue, stroke: blue + 0.5pt)
    content((cx0 -.1, cy0 ), [$(0, 1)$], anchor: "east", fill: white)

    // x = 2π での端点 (y = 1)
    let (cx_end, cy_end) = to-canvas(2 * pi, 1)
    circle((cx_end, cy_end), radius: 0.05, fill: blue, stroke: blue + 0.5pt)
    content((cx_end + 0.1, cy_end + 0.0), [$(2π, 1)$], anchor: "west", fill: white)

    // 極値点のマーク
    // x = π/2 での極小 (y = -3)
    let (cx1, cy1) = to-canvas(pi / 2, -3)
    circle((cx1, cy1), radius: 0.05, fill: red, stroke: red + 0.5pt)
    content((cx1 + 0.0, cy1 - .2), [$(π/2, -3)$], anchor: "north", fill: white)

    // x = 7π/6 での極大 (y = 3/2)
    let (cx2, cy2) = to-canvas(7 * pi / 6, 3/2)
    circle((cx2, cy2), radius: 0.05, fill: green, stroke: green + 0.5pt)
    content((cx2, cy2 + 0.2), [$((7π)/6, 3/2)$], anchor: "south", fill: white)

    // x = 3π/2 での極小 (y = 1)
    let (cx3, cy3) = to-canvas(3 * pi / 2, 1)
    circle((cx3, cy3), radius: 0.05, fill: red, stroke: red + 0.5pt)
    content((cx3, cy3 - 0.2), [$((3π)/2, 1)$], anchor: "north", fill: white)

    // x = 11π/6 での極大 (y = 3/2)
    let (cx4, cy4) = to-canvas(11 * pi / 6, 3/2)
    circle((cx4, cy4), radius: 0.05, fill: green, stroke: green + 0.5pt)
    content((cx4 - 0.0, cy4 + .2), [$((11π)/6, 3/2)$], anchor: "south", fill: white)

    // 変曲点のマーク
    // x = α での変曲点
    let y_alpha = f(alpha)
    let (cx_alpha, cy_alpha) = to-canvas(alpha, y_alpha)
    circle((cx_alpha, cy_alpha), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    content((cx_alpha, cy_alpha + 0.2), [$(α,(3-3sqrt(33))/16)$], anchor: "west", fill: white)

    // x = β での変曲点
    let y_beta = f(beta)
    let (cx_beta, cy_beta) = to-canvas(beta, y_beta)
    circle((cx_beta, cy_beta), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    content((cx_beta + .1, cy_beta - 0.1), [$(β,(3-3sqrt(33))/16)$], anchor: "west", fill: white)

    // x = γ での変曲点
    let y_gamma = f(gamma)
    let (cx_gamma, cy_gamma) = to-canvas(gamma, y_gamma)
    circle((cx_gamma, cy_gamma), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    content((cx_gamma - 0.2, cy_gamma - 0.2), [$(γ,(3+3sqrt(33))/16)$], anchor: "north", fill: white)

    // x = δ での変曲点
    let y_delta = f(delta)
    let (cx_delta, cy_delta) = to-canvas(delta, y_delta)
    circle((cx_delta, cy_delta), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    content((cx_delta + .2, cy_delta - 0.2), [$(δ,(3+3sqrt(33))/16)$], anchor: "north", fill: white)
  }),
  caption: [$y = cos 2x - 2 sin x$ $(0 <= x <= 2pi)$ のグラフ]
)

 #v(5mm)

// ========== 2つ目のグラフ（軸上にラベル表示） ==========
#figure(
  cetz.canvas(length: 2.0cm, {
    import cetz.draw: *

    let pi = calc.pi

    // 関数定義
    let f(x) = calc.cos(2 * x) - 2 * calc.sin(x)

    // 変曲点の角度を計算（ラジアン値として）
    // sin(x) = (-1 + sqrt(33))/8 の解
    let sin-val-1 = (-1 + calc.sqrt(33)) / 8
    let alpha = calc.asin(sin-val-1) / 1rad
    let beta = pi - alpha

    // sin(x) = (-1 - sqrt(33))/8 の解
    let sin-val-2 = (-1 - calc.sqrt(33)) / 8
    let gamma = pi - calc.asin(sin-val-2) / 1rad
    let delta = 2 * pi + calc.asin(sin-val-2) / 1rad

    // スケール設定
    let x-scale = 1.0
    let y-scale = 0.8

    // 座標変換関数
    let to-canvas(x, y) = ((x - 0) * x-scale, y * y-scale)

    // 座標軸
    let (x-max, _) = to-canvas(2 * pi, 0)
    line((-1, 0), (x-max + 1, 0), stroke: black + 1pt, mark: (end: ">",fill:black))
    line((0, -4 * y-scale), (0, 3.0 * y-scale ), stroke: black + 1pt, mark: (end: ">",fill:black))

    // 軸ラベル
    content((x-max + 1.1, 0), [$x$], anchor: "west")
    content((0, 3.0 * y-scale + 0.1), [$y$], anchor: "south")
    content((0 - .1, 0 - .1), text(font: "New Computer Modern")[O], anchor: "north-east")

    // 関数のプロット
    let points = ()
    let n-samples = 300
    for i in range(0, n-samples + 1) {
      let x = i / n-samples * 2 * pi
      let y = f(x)
      let (cx, cy) = to-canvas(x, y)
      points.push((cx, cy))
    }

    line(..points, stroke: blue + 1.5pt)

    // 端点のマーク
    // x = 0 での端点 (y = 1)
    let (cx0, cy0) = to-canvas(0, 1)
    circle((cx0, cy0), radius: 0.05, fill: blue, stroke: blue + 0.5pt)
    // line((cx0, cy0), (cx0, 0), stroke: (paint: gray, dash: "dotted"))
    // content((cx0, -0.3), [$0$], anchor: "north")
    // line((cx0, cy0), (0, cy0), stroke: (paint: gray, dash: "dotted"))
    content((-0.1, cy0), [$1$], anchor: "east")

    // x = 2π での端点 (y = 1)
    let (cx_end, cy_end) = to-canvas(2 * pi, 1)
    circle((cx_end, cy_end), radius: 0.05, fill: blue, stroke: blue + 0.5pt)
    line((cx_end, cy_end), (0, cy_end), stroke: (paint: gray, dash: "dotted"))
    // content((cx0, -0.3), [$0$], anchor: "north")
    line((cx_end, cy_end), (cx_end, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx_end, -0.1), [$2π$], anchor: "north")

    // 極値点のマーク
    // x = π/2 での極小 (y = -3)
    let (cx1, cy1) = to-canvas(pi / 2, -3)
    circle((cx1, cy1), radius: 0.05, fill: red, stroke: red + 0.5pt)
    line((cx1, cy1), (cx1, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx1, +0.1), [$π/2$], anchor: "south")
    line((cx1, cy1), (0, cy1), stroke: (paint: gray, dash: "dotted"))
    content((-0.1, cy1), [$-3$], anchor: "east")

    // x = 7π/6 での極大 (y = 3/2)
    let (cx2, cy2) = to-canvas(7 * pi / 6, 3/2)
    circle((cx2, cy2), radius: 0.05, fill: green, stroke: green + 0.5pt)
    line((cx2, cy2), (cx2, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx2, -0.1), [$(7π)/6$], anchor: "north")
    // line((cx2, cy2), (0, cy2), stroke: (paint: gray, dash: "dotted"))
    // content((-0.2, cy2), [$3/2$], anchor: "east")

    // x = 3π/2 での極小 (y = 1)
    let (cx3, cy3) = to-canvas(3 * pi / 2, 1)
    circle((cx3, cy3), radius: 0.05, fill: red, stroke: red + 0.5pt)
    line((cx3, cy3), (cx3, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx3, -0.1), [$(3π)/2$], anchor: "north")

    // x = 11π/6 での極大 (y = 3/2)
    let (cx4, cy4) = to-canvas(11 * pi / 6, 3/2)
    circle((cx4, cy4), radius: 0.05, fill: green, stroke: green + 0.5pt)
    line((cx4, cy4), (cx4, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx4, -0.1), [$(11π)/6$], anchor: "north")
    line((cx4, cy4), (0,cy4), stroke: (paint: gray, dash: "dotted"))
    content((0 - .1, cy4), [$3/2$], anchor: "south-east")
    


    // 変曲点のマーク
    // x = α での変曲点
    let y_alpha = f(alpha)
    let (cx_alpha, cy_alpha) = to-canvas(alpha, y_alpha)
    circle((cx_alpha, cy_alpha), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    line((cx_alpha, cy_alpha), (cx_alpha, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx_alpha, + 0.1), [$α$], anchor: "south")
    // line((cx_alpha, cy_alpha), (0, cy_alpha), stroke: (paint: gray, dash: "dotted"))
    // content((-0.1, cy_alpha), [$(3-3sqrt(33))/16$], anchor: "east", size: 9pt)

    // x = β での変曲点
    let y_beta = f(beta)
    let (cx_beta, cy_beta) = to-canvas(beta, y_beta)
    circle((cx_beta, cy_beta), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    line((cx_beta, cy_beta), (cx_beta, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx_beta, + 0.1), [$β$], anchor: "south")
    line((cx_beta, cy_beta), (0, cy_beta), stroke: (paint: gray, dash: "dotted"))
    content((-0.1, cy_beta), [$(3-3sqrt(33))/16$], anchor: "east", size: 9pt)
    
 
    // x = γ での変曲点
    let y_gamma = f(gamma)
    let (cx_gamma, cy_gamma) = to-canvas(gamma, y_gamma)
    circle((cx_gamma, cy_gamma), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    line((cx_gamma, cy_gamma), (cx_gamma, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx_gamma, -0.1), [$γ$], anchor: "north")
    // line((cx_gamma, cy_gamma), (0, cy_gamma), stroke: (paint: gray, dash: "dotted"))
    // content((-0.4, cy_gamma), [$(3+3sqrt(33))/16$], anchor: "east", size: 9pt)

    // x = δ での変曲点
    let y_delta = f(delta)
    let (cx_delta, cy_delta) = to-canvas(delta, y_delta)
    circle((cx_delta, cy_delta), radius: 0.05, fill: orange, stroke: orange + 0.5pt)
    line((cx_delta, cy_delta), (cx_delta, 0), stroke: (paint: gray, dash: "dotted"))
    content((cx_delta, -0.1), [$δ$], anchor: "north")
    line((cx_delta, cy_delta), (0, cy_delta), stroke: (paint: gray, dash: "dotted"))
    content((-0.0, cy_delta), [$(3+3sqrt(33))/16 -->$], anchor: "east", size: 9pt)

  }),
  caption: [$y = cos 2x - 2 sin x$ $(0 <= x <= 2pi)$ のグラフ（軸ラベル付き）]
)
