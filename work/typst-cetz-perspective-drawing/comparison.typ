#set page(width: auto, height: auto, margin: 1cm, fill: white)
#set text(font: "Hiragino Maru Gothic ProN")
#import "@preview/cetz:0.4.2"

// パースペクティブ変換関数
#let perspective(point, distance: 5) = {
  let (x, y, z) = point
  let scale = 1 / (1 + z / distance)
  (x * scale, y * scale)
}

#grid(
  columns: 2,
  gutter: 2cm,
  // 平行投影（CeTZのortho使用）
  [
    #cetz.canvas(length: 7cm, {
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
        line(A, E, stroke: black + 1pt)
        line(B, F, stroke: black + 1pt)
        line(C, G, stroke: black + 1pt)
        line(D, H, stroke: black + 1pt)
      })
    })
    #align(center)[
      #text(size: 14pt, weight: "bold")[平行投影]
      #v(0.3em)
      #text(size: 11pt)[奥と手前が同じ大きさ]
    ]
  ],

  // 遠近法
  [
    #cetz.canvas(length: 7cm, {
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
      line(A2d, E2d, stroke: black + 1pt)
      line(B2d, F2d, stroke: black + 1pt)
      line(C2d, G2d, stroke: black + 1pt)
      line(D2d, H2d, stroke: black + 1pt)
    })
    #align(center)[
      #text(size: 14pt, weight: "bold")[遠近法（パースペクティブ）]
      #v(0.3em)
      #text(size: 11pt)[奥の面が小さくなる]
    ]
  ]
)
