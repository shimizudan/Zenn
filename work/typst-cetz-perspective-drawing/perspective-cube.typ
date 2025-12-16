#set page(width: auto, height: auto, margin: 1cm)
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

= 遠近法で描いた立方体

== 真正面から見た立方体（パースペクティブあり）

#figure(
  cetz.canvas(length: 3cm, {
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

#pagebreak()

== 異なる距離パラメータの比較

#grid(
  columns: 3,
  gutter: 1cm,
  // distance = 2（強い遠近感）
  cetz.canvas(length: 2.5cm, {
    import cetz.draw: *
    let A = (-0.5, 0.5, -0.5)
    let B = (0.5, 0.5, -0.5)
    let C = (0.5, -0.5, -0.5)
    let D = (-0.5, -0.5, -0.5)
    let E = (-0.5, 0.5, 0.5)
    let F = (0.5, 0.5, 0.5)
    let G = (0.5, -0.5, 0.5)
    let H = (-0.5, -0.5, 0.5)

    let d = 2
    let A2d = perspective(A, distance: d)
    let B2d = perspective(B, distance: d)
    let C2d = perspective(C, distance: d)
    let D2d = perspective(D, distance: d)
    let E2d = perspective(E, distance: d)
    let F2d = perspective(F, distance: d)
    let G2d = perspective(G, distance: d)
    let H2d = perspective(H, distance: d)

    line(E2d, F2d, G2d, H2d, close: true, stroke: blue + 1pt, fill: blue.transparentize(80%))
    line(A2d, B2d, C2d, D2d, close: true, stroke: red + 1pt, fill: red.transparentize(80%))
    line(A2d, E2d, stroke: black + 0.5pt)
    line(B2d, F2d, stroke: black + 0.5pt)
    line(C2d, G2d, stroke: black + 0.5pt)
    line(D2d, H2d, stroke: black + 0.5pt)
  }),

  // distance = 5（中程度の遠近感）
  cetz.canvas(length: 2.5cm, {
    import cetz.draw: *
    let A = (-0.5, 0.5, -0.5)
    let B = (0.5, 0.5, -0.5)
    let C = (0.5, -0.5, -0.5)
    let D = (-0.5, -0.5, -0.5)
    let E = (-0.5, 0.5, 0.5)
    let F = (0.5, 0.5, 0.5)
    let G = (0.5, -0.5, 0.5)
    let H = (-0.5, -0.5, 0.5)

    let d = 5
    let A2d = perspective(A, distance: d)
    let B2d = perspective(B, distance: d)
    let C2d = perspective(C, distance: d)
    let D2d = perspective(D, distance: d)
    let E2d = perspective(E, distance: d)
    let F2d = perspective(F, distance: d)
    let G2d = perspective(G, distance: d)
    let H2d = perspective(H, distance: d)

    line(E2d, F2d, G2d, H2d, close: true, stroke: blue + 1pt, fill: blue.transparentize(80%))
    line(A2d, B2d, C2d, D2d, close: true, stroke: red + 1pt, fill: red.transparentize(80%))
    line(A2d, E2d, stroke: black + 0.5pt)
    line(B2d, F2d, stroke: black + 0.5pt)
    line(C2d, G2d, stroke: black + 0.5pt)
    line(D2d, H2d, stroke: black + 0.5pt)
  }),

  // distance = 10（弱い遠近感）
  cetz.canvas(length: 2.5cm, {
    import cetz.draw: *
    let A = (-0.5, 0.5, -0.5)
    let B = (0.5, 0.5, -0.5)
    let C = (0.5, -0.5, -0.5)
    let D = (-0.5, -0.5, -0.5)
    let E = (-0.5, 0.5, 0.5)
    let F = (0.5, 0.5, 0.5)
    let G = (0.5, -0.5, 0.5)
    let H = (-0.5, -0.5, 0.5)

    let d = 10
    let A2d = perspective(A, distance: d)
    let B2d = perspective(B, distance: d)
    let C2d = perspective(C, distance: d)
    let D2d = perspective(D, distance: d)
    let E2d = perspective(E, distance: d)
    let F2d = perspective(F, distance: d)
    let G2d = perspective(G, distance: d)
    let H2d = perspective(H, distance: d)

    line(E2d, F2d, G2d, H2d, close: true, stroke: blue + 1pt, fill: blue.transparentize(80%))
    line(A2d, B2d, C2d, D2d, close: true, stroke: red + 1pt, fill: red.transparentize(80%))
    line(A2d, E2d, stroke: black + 0.5pt)
    line(B2d, F2d, stroke: black + 0.5pt)
    line(C2d, G2d, stroke: black + 0.5pt)
    line(D2d, H2d, stroke: black + 0.5pt)
  }),
)

#align(center)[
  #grid(
    columns: 3,
    gutter: 1cm,
    [distance = 2\ （強い遠近感）],
    [distance = 5\ （中程度）],
    [distance = 10\ （弱い遠近感）]
  )
]

#pagebreak()

== 平行投影との比較

#grid(
  columns: 2,
  gutter: 2cm,
  // 平行投影（CeTZのortho使用）
  [
    #cetz.canvas(length: 3cm, {
      import cetz.draw: *
      ortho(x: 0deg, y: 0deg, {
        let A = (-0.5, 0.5, -0.5)
        let B = (0.5, 0.5, -0.5)
        let C = (0.5, -0.5, -0.5)
        let D = (-0.5, -0.5, -0.5)
        let E = (-0.5, 0.5, 0.5)
        let F = (0.5, 0.5, 0.5)
        let G = (0.5, -0.5, 0.5)
        let H = (-0.5, -0.5, 0.5)

        // 奥の面
        line(E, F, G, H, close: true, stroke: blue + 1.5pt, fill: blue.transparentize(80%))
        // 手前の面
        line(A, B, C, D, close: true, stroke: red + 1.5pt, fill: red.transparentize(80%))
        // 接続する辺
        line(A, E, stroke: black + 0.8pt)
        line(B, F, stroke: black + 0.8pt)
        line(C, G, stroke: black + 0.8pt)
        line(D, H, stroke: black + 0.8pt)
      })
    })
    #align(center)[*平行投影*\ （奥と手前が同じ大きさ）]
  ],

  // 遠近法
  [
    #cetz.canvas(length: 3cm, {
      import cetz.draw: *
      let A = (-0.5, 0.5, -0.5)
      let B = (0.5, 0.5, -0.5)
      let C = (0.5, -0.5, -0.5)
      let D = (-0.5, -0.5, -0.5)
      let E = (-0.5, 0.5, 0.5)
      let F = (0.5, 0.5, 0.5)
      let G = (0.5, -0.5, 0.5)
      let H = (-0.5, -0.5, 0.5)

      let d = 3
      let A2d = perspective(A, distance: d)
      let B2d = perspective(B, distance: d)
      let C2d = perspective(C, distance: d)
      let D2d = perspective(D, distance: d)
      let E2d = perspective(E, distance: d)
      let F2d = perspective(F, distance: d)
      let G2d = perspective(G, distance: d)
      let H2d = perspective(H, distance: d)

      line(E2d, F2d, G2d, H2d, close: true, stroke: blue + 1.5pt, fill: blue.transparentize(80%))
      line(A2d, B2d, C2d, D2d, close: true, stroke: red + 1.5pt, fill: red.transparentize(80%))
      line(A2d, E2d, stroke: black + 0.8pt)
      line(B2d, F2d, stroke: black + 0.8pt)
      line(C2d, G2d, stroke: black + 0.8pt)
      line(D2d, H2d, stroke: black + 0.8pt)
    })
    #align(center)[*遠近法（パースペクティブ）*\ （奥の面が小さくなる）]
  ]
)

#pagebreak()

== 斜めから見た立方体（回転 + 遠近法）

#figure(
  cetz.canvas(length: 3cm, {
    import cetz.draw: *

    // 立方体の頂点を定義
    let A = (-0.5, 0.5, -0.5)
    let B = (0.5, 0.5, -0.5)
    let C = (0.5, -0.5, -0.5)
    let D = (-0.5, -0.5, -0.5)
    let E = (-0.5, 0.5, 0.5)
    let F = (0.5, 0.5, 0.5)
    let G = (0.5, -0.5, 0.5)
    let H = (-0.5, -0.5, 0.5)

    // Y軸周りに30度、X軸周りに20度回転
    let angle-y = 30deg
    let angle-x = 20deg

    let A-rot = rotate-x(rotate-y(A, angle-y), angle-x)
    let B-rot = rotate-x(rotate-y(B, angle-y), angle-x)
    let C-rot = rotate-x(rotate-y(C, angle-y), angle-x)
    let D-rot = rotate-x(rotate-y(D, angle-y), angle-x)
    let E-rot = rotate-x(rotate-y(E, angle-y), angle-x)
    let F-rot = rotate-x(rotate-y(F, angle-y), angle-x)
    let G-rot = rotate-x(rotate-y(G, angle-y), angle-x)
    let H-rot = rotate-x(rotate-y(H, angle-y), angle-x)

    // パースペクティブ変換
    let d = 3
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
         stroke: gray + 0.8pt, fill: gray.transparentize(90%))

    // 左側面
    line(A2d, E2d, F2d, B2d, close: true,
         stroke: green + 1pt, fill: green.transparentize(85%))

    // 底面
    line(D2d, C2d, G2d, H2d, close: true,
         stroke: orange + 1pt, fill: orange.transparentize(85%))

    // 手前の面（最前面）
    line(A2d, B2d, C2d, D2d, close: true,
         stroke: red + 1.5pt, fill: red.transparentize(80%))

    // 上面
    line(A2d, B2d, F2d, E2d, close: true,
         stroke: purple + 1pt, fill: purple.transparentize(85%))

    // 右側面
    line(B2d, C2d, G2d, F2d, close: true,
         stroke: blue + 1pt, fill: blue.transparentize(85%))

    // 頂点ラベル
    content(A2d, [A], anchor: "east", padding: 0.1)
    content(B2d, [B], anchor: "west", padding: 0.1)
    content(C2d, [C], anchor: "north", padding: 0.1)
    content(D2d, [D], anchor: "north", padding: 0.1)
    content(E2d, [E], anchor: "south", padding: 0.1)
    content(F2d, [F], anchor: "south-west", padding: 0.1)
    content(G2d, [G], anchor: "south", padding: 0.1)
    content(H2d, [H], anchor: "south", padding: 0.1)
  }),
  caption: [斜めから見た立方体（Y軸30°, X軸20°回転 + 遠近法）]
)

#pagebreak()

== 異なる角度から見た立方体

#grid(
  columns: 3,
  gutter: 1cm,
  // Y軸15度回転
  cetz.canvas(length: 2.5cm, {
    import cetz.draw: *
    let A = (-0.5, 0.5, -0.5)
    let B = (0.5, 0.5, -0.5)
    let C = (0.5, -0.5, -0.5)
    let D = (-0.5, -0.5, -0.5)
    let E = (-0.5, 0.5, 0.5)
    let F = (0.5, 0.5, 0.5)
    let G = (0.5, -0.5, 0.5)
    let H = (-0.5, -0.5, 0.5)

    let angle = 15deg
    let A-rot = rotate-y(A, angle)
    let B-rot = rotate-y(B, angle)
    let C-rot = rotate-y(C, angle)
    let D-rot = rotate-y(D, angle)
    let E-rot = rotate-y(E, angle)
    let F-rot = rotate-y(F, angle)
    let G-rot = rotate-y(G, angle)
    let H-rot = rotate-y(H, angle)

    let d = 3
    let A2d = perspective(A-rot, distance: d)
    let B2d = perspective(B-rot, distance: d)
    let C2d = perspective(C-rot, distance: d)
    let D2d = perspective(D-rot, distance: d)
    let E2d = perspective(E-rot, distance: d)
    let F2d = perspective(F-rot, distance: d)
    let G2d = perspective(G-rot, distance: d)
    let H2d = perspective(H-rot, distance: d)

    line(A2d, B2d, C2d, D2d, close: true, stroke: red + 1pt, fill: red.transparentize(85%))
    line(E2d, F2d, G2d, H2d, close: true, stroke: blue + 1pt, fill: blue.transparentize(85%))
    line(B2d, F2d, G2d, C2d, close: true, stroke: green + 1pt, fill: green.transparentize(85%))
    line(A2d, E2d, stroke: black + 0.5pt)
    line(D2d, H2d, stroke: black + 0.5pt)
  }),

  // Y軸30度回転
  cetz.canvas(length: 2.5cm, {
    import cetz.draw: *
    let A = (-0.5, 0.5, -0.5)
    let B = (0.5, 0.5, -0.5)
    let C = (0.5, -0.5, -0.5)
    let D = (-0.5, -0.5, -0.5)
    let E = (-0.5, 0.5, 0.5)
    let F = (0.5, 0.5, 0.5)
    let G = (0.5, -0.5, 0.5)
    let H = (-0.5, -0.5, 0.5)

    let angle = 30deg
    let A-rot = rotate-y(A, angle)
    let B-rot = rotate-y(B, angle)
    let C-rot = rotate-y(C, angle)
    let D-rot = rotate-y(D, angle)
    let E-rot = rotate-y(E, angle)
    let F-rot = rotate-y(F, angle)
    let G-rot = rotate-y(G, angle)
    let H-rot = rotate-y(H, angle)

    let d = 3
    let A2d = perspective(A-rot, distance: d)
    let B2d = perspective(B-rot, distance: d)
    let C2d = perspective(C-rot, distance: d)
    let D2d = perspective(D-rot, distance: d)
    let E2d = perspective(E-rot, distance: d)
    let F2d = perspective(F-rot, distance: d)
    let G2d = perspective(G-rot, distance: d)
    let H2d = perspective(H-rot, distance: d)

    line(A2d, B2d, C2d, D2d, close: true, stroke: red + 1pt, fill: red.transparentize(85%))
    line(E2d, F2d, G2d, H2d, close: true, stroke: blue + 1pt, fill: blue.transparentize(85%))
    line(B2d, F2d, G2d, C2d, close: true, stroke: green + 1pt, fill: green.transparentize(85%))
    line(A2d, E2d, stroke: black + 0.5pt)
    line(D2d, H2d, stroke: black + 0.5pt)
  }),

  // Y軸45度回転
  cetz.canvas(length: 2.5cm, {
    import cetz.draw: *
    let A = (-0.5, 0.5, -0.5)
    let B = (0.5, 0.5, -0.5)
    let C = (0.5, -0.5, -0.5)
    let D = (-0.5, -0.5, -0.5)
    let E = (-0.5, 0.5, 0.5)
    let F = (0.5, 0.5, 0.5)
    let G = (0.5, -0.5, 0.5)
    let H = (-0.5, -0.5, 0.5)

    let angle = 45deg
    let A-rot = rotate-y(A, angle)
    let B-rot = rotate-y(B, angle)
    let C-rot = rotate-y(C, angle)
    let D-rot = rotate-y(D, angle)
    let E-rot = rotate-y(E, angle)
    let F-rot = rotate-y(F, angle)
    let G-rot = rotate-y(G, angle)
    let H-rot = rotate-y(H, angle)

    let d = 3
    let A2d = perspective(A-rot, distance: d)
    let B2d = perspective(B-rot, distance: d)
    let C2d = perspective(C-rot, distance: d)
    let D2d = perspective(D-rot, distance: d)
    let E2d = perspective(E-rot, distance: d)
    let F2d = perspective(F-rot, distance: d)
    let G2d = perspective(G-rot, distance: d)
    let H2d = perspective(H-rot, distance: d)

    line(A2d, B2d, C2d, D2d, close: true, stroke: red + 1pt, fill: red.transparentize(85%))
    line(E2d, F2d, G2d, H2d, close: true, stroke: blue + 1pt, fill: blue.transparentize(85%))
    line(B2d, F2d, G2d, C2d, close: true, stroke: green + 1pt, fill: green.transparentize(85%))
    line(A2d, E2d, stroke: black + 0.5pt)
    line(D2d, H2d, stroke: black + 0.5pt)
  }),
)

#align(center)[
  #grid(
    columns: 3,
    gutter: 1cm,
    [Y軸 15° 回転],
    [Y軸 30° 回転],
    [Y軸 45° 回転]
  )
]
