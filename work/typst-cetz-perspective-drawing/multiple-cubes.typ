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

// 立方体を描画する関数
#let draw-cube(offset-x, offset-z, size, angle-y, angle-x, d, cube-color) = {
  import cetz.draw: *

  // 立方体の頂点を定義（オフセットを適用）
  let half = size / 2
  let A = (offset-x - half, half, offset-z - half)
  let B = (offset-x + half, half, offset-z - half)
  let C = (offset-x + half, -half, offset-z - half)
  let D = (offset-x - half, -half, offset-z - half)
  let E = (offset-x - half, half, offset-z + half)
  let F = (offset-x + half, half, offset-z + half)
  let G = (offset-x + half, -half, offset-z + half)
  let H = (offset-x - half, -half, offset-z + half)

  // 回転を適用
  let A-rot = rotate-x(rotate-y(A, angle-y), angle-x)
  let B-rot = rotate-x(rotate-y(B, angle-y), angle-x)
  let C-rot = rotate-x(rotate-y(C, angle-y), angle-x)
  let D-rot = rotate-x(rotate-y(D, angle-y), angle-x)
  let E-rot = rotate-x(rotate-y(E, angle-y), angle-x)
  let F-rot = rotate-x(rotate-y(F, angle-y), angle-x)
  let G-rot = rotate-x(rotate-y(G, angle-y), angle-x)
  let H-rot = rotate-x(rotate-y(H, angle-y), angle-x)

  // パースペクティブ変換
  let A2d = perspective(A-rot, distance: d)
  let B2d = perspective(B-rot, distance: d)
  let C2d = perspective(C-rot, distance: d)
  let D2d = perspective(D-rot, distance: d)
  let E2d = perspective(E-rot, distance: d)
  let F2d = perspective(F-rot, distance: d)
  let G2d = perspective(G-rot, distance: d)
  let H2d = perspective(H-rot, distance: d)

  // 背面の面（奥）
  line(E2d, H2d, G2d, F2d, close: true,
       stroke: cube-color.darken(30%) + 0.8pt,
       fill: cube-color.transparentize(90%))

  // 左側面
  line(A2d, E2d, F2d, B2d, close: true,
       stroke: cube-color.darken(10%) + 1pt,
       fill: cube-color.transparentize(85%))

  // 底面
  line(D2d, C2d, G2d, H2d, close: true,
       stroke: cube-color.darken(20%) + 1pt,
       fill: cube-color.transparentize(85%))

  // 手前の面
  line(A2d, B2d, C2d, D2d, close: true,
       stroke: cube-color + 1.2pt,
       fill: cube-color.transparentize(80%))

  // 上面
  line(A2d, B2d, F2d, E2d, close: true,
       stroke: cube-color.lighten(10%) + 1pt,
       fill: cube-color.transparentize(85%))

  // 右側面
  line(B2d, C2d, G2d, F2d, close: true,
       stroke: cube-color.darken(10%) + 1pt,
       fill: cube-color.transparentize(85%))
}

#figure(
  cetz.canvas(length: 6cm, {
    import cetz.draw: *

    // 共通の回転角度と距離パラメータ
    let angle-y = 30deg
    let angle-x = 15deg
    let d = 3.5

    // 手前の立方体（赤）
    draw-cube(-0.8, -0.5, 0.6, angle-y, angle-x, d, red)

    // 中央の立方体（青）
    draw-cube(0.2, 0.8, 0.5, angle-y, angle-x, d, blue)

    // 奥の立方体（緑）- より小さく、より遠く
    draw-cube(0.8, 1.8, 0.4, angle-y, angle-x, d, green)
  }),
  caption: [奥行き方向に配置した3つの立方体（遠近法により遠くの立方体が小さく見える）]
)
