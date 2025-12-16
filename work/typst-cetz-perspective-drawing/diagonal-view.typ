#set page(width: auto, height: auto, margin: 1cm, fill: white)
#set text(font: "Hiragino Maru Gothic ProN")
#import "@preview/cetz:0.4.2"

// パースペクティブ変換関数
#let perspective(point, distance: 5) = {
  let (x, y, z) = point
  let scale = 1 / (1 + z / distance)
  (x * scale, y * scale)
}

// Y軸周りの回転関数
#let rotate-y(point, angle) = {
  let (x, y, z) = point
  let cos_a = calc.cos(angle)
  let sin_a = calc.sin(angle)
  (x * cos_a + z * sin_a, y, -x * sin_a + z * cos_a)
}

// X軸周りの回転関数
#let rotate-x(point, angle) = {
  let (x, y, z) = point
  let cos_a = calc.cos(angle)
  let sin_a = calc.sin(angle)
  (x, y * cos_a - z * sin_a, y * sin_a + z * cos_a)
}

#figure(
  cetz.canvas(length: 6cm, {
    import cetz.draw: *

    // 立方体の頂点を定義（手前から奥へ配置）
    // 手前側（z = -0.5）- 視点に近い
    let A = (-0.5, 0.5, -0.5)   // 左上手前
    let B = (0.5, 0.5, -0.5)    // 右上手前
    let C = (0.5, -0.5, -0.5)   // 右下手前
    let D = (-0.5, -0.5, -0.5)  // 左下手前
    // 奥側（z = 1.0）- 遠くに配置
    let E = (-0.5, 0.5, 1.0)    // 左上奥
    let F = (0.5, 0.5, 1.0)     // 右上奥
    let G = (0.5, -0.5, 1.0)    // 右下奥
    let H = (-0.5, -0.5, 1.0)   // 左下奥

    // Y軸周りに30度回転（斜め前方から見る）
    let angle-y = 30deg
    let angle-x = 15deg

    let A-rot = rotate-x(rotate-y(A, angle-y), angle-x)
    let B-rot = rotate-x(rotate-y(B, angle-y), angle-x)
    let C-rot = rotate-x(rotate-y(C, angle-y), angle-x)
    let D-rot = rotate-x(rotate-y(D, angle-y), angle-x)
    let E-rot = rotate-x(rotate-y(E, angle-y), angle-x)
    let F-rot = rotate-x(rotate-y(F, angle-y), angle-x)
    let G-rot = rotate-x(rotate-y(G, angle-y), angle-x)
    let H-rot = rotate-x(rotate-y(H, angle-y), angle-x)

    // パースペクティブ変換（距離を小さくして遠近感を強調）
    let d = 2.5
    let A2d = perspective(A-rot, distance: d)
    let B2d = perspective(B-rot, distance: d)
    let C2d = perspective(C-rot, distance: d)
    let D2d = perspective(D-rot, distance: d)
    let E2d = perspective(E-rot, distance: d)
    let F2d = perspective(F-rot, distance: d)
    let G2d = perspective(G-rot, distance: d)
    let H2d = perspective(H-rot, distance: d)

    // 背面の面（奥）- 先に描画
    line(E2d, H2d, G2d, F2d, close: true,
         stroke: gray + 1pt, fill: gray.transparentize(90%))

    // 左側面
    line(A2d, E2d, F2d, B2d, close: true,
         stroke: green + 1.2pt, fill: green.transparentize(85%))

    // 底面
    line(D2d, C2d, G2d, H2d, close: true,
         stroke: orange + 1.2pt, fill: orange.transparentize(85%))

    // 手前の面（最前面）
    line(A2d, B2d, C2d, D2d, close: true,
         stroke: red + 1.5pt, fill: red.transparentize(80%))

    // 上面
    line(A2d, B2d, F2d, E2d, close: true,
         stroke: purple + 1.2pt, fill: purple.transparentize(85%))

    // 右側面
    line(B2d, C2d, G2d, F2d, close: true,
         stroke: blue + 1.2pt, fill: blue.transparentize(85%))

    // 頂点ラベル
    content(A2d, [A], anchor: "east", padding: 0.15)
    content(B2d, [B], anchor: "west", padding: 0.15)
    content(C2d, [C], anchor: "north", padding: 0.15)
    content(D2d, [D], anchor: "north", padding: 0.15)
    content(E2d, [E], anchor: "south", padding: 0.15)
    content(F2d, [F], anchor: "south-west", padding: 0.15)
    content(G2d, [G], anchor: "south", padding: 0.15)
    content(H2d, [H], anchor: "south", padding: 0.15)
  }),
  caption: [斜め前方から見た立方体（奥行きにパースがついた遠近法）]
)
