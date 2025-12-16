#set page(width: auto, height: auto, margin: 1cm, fill: white)
#set text(font: "Hiragino Maru Gothic ProN")
#import "@preview/cetz:0.4.2"

// パースペクティブ変換関数
#let perspective(point, distance: 5) = {
  let (x, y, z) = point
  let scale = 1 / (1 + z / distance)
  (x * scale, y * scale)
}

#figure(
  cetz.canvas(length: 6cm, {
    import cetz.draw: *

    // 立方体の頂点を定義（3D座標）
    let A = (-0.5, 0.5, -0.5)   // 左上手前
    let B = (0.5, 0.5, -0.5)    // 右上手前
    let C = (0.5, -0.5, -0.5)   // 右下手前
    let D = (-0.5, -0.5, -0.5)  // 左下手前
    let E = (-0.5, 0.5, 0.5)    // 左上奥
    let F = (0.5, 0.5, 0.5)     // 右上奥
    let G = (0.5, -0.5, 0.5)    // 右下奥
    let H = (-0.5, -0.5, 0.5)   // 左下奥

    // 視点からの距離（小さいほど遠近感が強い）
    let d = 3

    // 各頂点を2D座標に変換
    let A2d = perspective(A, distance: d)
    let B2d = perspective(B, distance: d)
    let C2d = perspective(C, distance: d)
    let D2d = perspective(D, distance: d)
    let E2d = perspective(E, distance: d)
    let F2d = perspective(F, distance: d)
    let G2d = perspective(G, distance: d)
    let H2d = perspective(H, distance: d)

    // 奥の面（小さくなる）
    line(E2d, F2d, G2d, H2d, close: true,
         stroke: blue + 1.5pt, fill: blue.transparentize(80%))

    // 手前の面（大きい）
    line(A2d, B2d, C2d, D2d, close: true,
         stroke: red + 1.5pt, fill: red.transparentize(80%))

    // 接続する辺
    line(A2d, E2d, stroke: black + 0.8pt)
    line(B2d, F2d, stroke: black + 0.8pt)
    line(C2d, G2d, stroke: black + 0.8pt)
    line(D2d, H2d, stroke: black + 0.8pt)

    // 頂点ラベル
    content(A2d, [A], anchor: "south-east", padding: 0.15)
    content(B2d, [B], anchor: "south-west", padding: 0.15)
    content(C2d, [C], anchor: "north-west", padding: 0.15)
    content(D2d, [D], anchor: "north-east", padding: 0.15)
    content(E2d, [E], anchor: "south-east", padding: 0.15)
    content(F2d, [F], anchor: "south-west", padding: 0.15)
    content(G2d, [G], anchor: "north-west", padding: 0.15)
    content(H2d, [H], anchor: "north-east", padding: 0.15)
  }),
  caption: [遠近法で描いた立方体（真正面から、distance=3）]
)
