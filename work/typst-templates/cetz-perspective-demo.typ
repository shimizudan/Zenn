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

#import "@preview/cetz:0.4.2"

= CeTZでのパース（遠近法）の実装

== 1. パース付き立方体（透視投影）

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // パース（透視投影）の設定関数
    let perspective() = {
      let FOVx = 90deg // 水平方向の視野角
      let FOVy = 70deg // 垂直方向の視野角
      let near = 0.1   // ニアクリップ面までの距離
      let far = 1000   // ファークリップ面までの距離

      set-transform((
        (1 / calc.tan(FOVx / 2), 0, 0, 0),
        (0, 1 / calc.tan(FOVy / 2), 0, 0),
        (0, 0, -(far + near) / (far - near), -2 * (near * far) / (far - near)),
        (0, 0, -1, 0),
      ))
    }

    // パースを適用
    perspective()

    // カメラ位置の調整（回転）
    rotate(x: 25deg, y: 30deg, z: 0deg)

    // 立方体の頂点定義（z軸を奥行き方向に）
    let size = 2
    let depth = -5  // カメラからの距離

    // 後面の頂点（奥側）
    let H = (-size, -size, depth - size)
    let E = (-size, -size, depth)
    let D = (-size, size, depth - size)
    let A = (-size, size, depth)

    // 前面の頂点（手前側）
    let G = (size, -size, depth - size)
    let F = (size, -size, depth)
    let C = (size, size, depth - size)
    let B = (size, size, depth)

    // 後面（奥側）- 薄い色で描画
    line(H, E, A, D, close: true, fill: blue.transparentize(85%), stroke: gray)

    // 側面
    line(H, G, F, E, close: true, fill: green.transparentize(80%), stroke: gray)
    line(D, C, G, H, close: true, fill: yellow.transparentize(80%), stroke: gray)
    line(E, F, B, A, close: true, fill: red.transparentize(80%), stroke: gray)
    line(D, A, B, C, close: true, fill: purple.transparentize(80%), stroke: gray)

    // 前面（手前側）- 濃い色で描画
    line(G, F, B, C, close: true, fill: blue.transparentize(70%), stroke: black)

    // 頂点のラベル
    let draw-label(pos, text, anchor) = {
      circle(pos, radius: 0.05, fill: black, stroke: none)
      content(pos, [#text], anchor: anchor, padding: 0.2)
    }

    draw-label(A, "A", "east")
    draw-label(B, "B", "west")
    draw-label(C, "C", "south")
    draw-label(D, "D", "east")
    draw-label(E, "E", "north")
    draw-label(F, "F", "west")
    draw-label(G, "G", "south")
    draw-label(H, "H", "east")
  })
)

*特徴*：遠近法により、手前の面が大きく、奥の面が小さく表示されます。

== 2. 比較：正投影（ortho）vs 透視投影（perspective）

#grid(
  columns: 2,
  column-gutter: 1cm,
  [
    === 正投影（ortho）
    #figure(
      cetz.canvas(length: 3cm, {
        import cetz.draw: *

        ortho(x: 25deg, y: 30deg, {
          let H = (0,0,0)
          let E = (0,0,1)
          let D = (0,1,0)
          let B = (1,1,1)
          let A = (0,1,1)
          let G = (1,0,0)
          let F = (1,0,1)
          let C = (1,1,0)

          // 後面
          line(H, E, A, D, close: true, fill: blue.transparentize(85%), stroke: gray)

          // 前面
          line(G, F, B, C, close: true, fill: blue.transparentize(70%), stroke: black)

          // エッジ
          line(H, G)
          line(E, F)
          line(D, C)
          line(A, B)
        })
      })
    )

    - 平行線が平行のまま
    - 奥行きによるサイズ変化なし
    - 幾何学的に正確
  ],
  [
    === 透視投影（perspective）
    #figure(
      cetz.canvas(length: 3cm, {
        import cetz.draw: *

        let perspective() = {
          let FOVx = 90deg
          let FOVy = 70deg
          let near = 0.1
          let far = 1000
          set-transform((
            (1 / calc.tan(FOVx / 2), 0, 0, 0),
            (0, 1 / calc.tan(FOVy / 2), 0, 0),
            (0, 0, -(far + near) / (far - near), -2 * (near * far) / (far - near)),
            (0, 0, -1, 0),
          ))
        }

        perspective()
        rotate(x: 25deg, y: 30deg, z: 0deg)

        let depth = -5
        let H = (-1, -1, depth - 1)
        let E = (-1, -1, depth)
        let D = (-1, 1, depth - 1)
        let A = (-1, 1, depth)
        let G = (1, -1, depth - 1)
        let F = (1, -1, depth)
        let C = (1, 1, depth - 1)
        let B = (1, 1, depth)

        // 後面
        line(H, E, A, D, close: true, fill: blue.transparentize(85%), stroke: gray)

        // 前面
        line(G, F, B, C, close: true, fill: blue.transparentize(70%), stroke: black)

        // エッジ
        line(H, G)
        line(E, F)
        line(D, C)
        line(A, B)
      })
    )

    - 平行線が消失点に収束
    - 奥が小さく、手前が大きい
    - 写実的で自然な見た目
  ]
)

== 3. パラメータの効果

=== 視野角（FOV）の変化

#grid(
  columns: 3,
  column-gutter: 0.5cm,
  [
    #align(center)[*FOV = 60°（狭い）*]
    #figure(
      cetz.canvas(length: 2.5cm, {
        import cetz.draw: *

        let perspective(fov) = {
          let near = 0.1
          let far = 1000
          set-transform((
            (1 / calc.tan(fov / 2), 0, 0, 0),
            (0, 1 / calc.tan(fov / 2), 0, 0),
            (0, 0, -(far + near) / (far - near), -2 * (near * far) / (far - near)),
            (0, 0, -1, 0),
          ))
        }

        perspective(60deg)
        rotate(x: 25deg, y: 30deg)

        let depth = -5
        let size = 2
        let G = (size, -size, depth - size)
        let F = (size, -size, depth)
        let C = (size, size, depth - size)
        let B = (size, size, depth)

        line(G, F, B, C, close: true, fill: blue.transparentize(70%), stroke: black)
      })
    )
  ],
  [
    #align(center)[*FOV = 90°（標準）*]
    #figure(
      cetz.canvas(length: 2.5cm, {
        import cetz.draw: *

        let perspective(fov) = {
          let near = 0.1
          let far = 1000
          set-transform((
            (1 / calc.tan(fov / 2), 0, 0, 0),
            (0, 1 / calc.tan(fov / 2), 0, 0),
            (0, 0, -(far + near) / (far - near), -2 * (near * far) / (far - near)),
            (0, 0, -1, 0),
          ))
        }

        perspective(90deg)
        rotate(x: 25deg, y: 30deg)

        let depth = -5
        let size = 2
        let G = (size, -size, depth - size)
        let F = (size, -size, depth)
        let C = (size, size, depth - size)
        let B = (size, size, depth)

        line(G, F, B, C, close: true, fill: green.transparentize(70%), stroke: black)
      })
    )
  ],
  [
    #align(center)[*FOV = 120°（広角）*]
    #figure(
      cetz.canvas(length: 2.5cm, {
        import cetz.draw: *

        let perspective(fov) = {
          let near = 0.1
          let far = 1000
          set-transform((
            (1 / calc.tan(fov / 2), 0, 0, 0),
            (0, 1 / calc.tan(fov / 2), 0, 0),
            (0, 0, -(far + near) / (far - near), -2 * (near * far) / (far - near)),
            (0, 0, -1, 0),
          ))
        }

        perspective(120deg)
        rotate(x: 25deg, y: 30deg)

        let depth = -5
        let size = 2
        let G = (size, -size, depth - size)
        let F = (size, -size, depth)
        let C = (size, size, depth - size)
        let B = (size, size, depth)

        line(G, F, B, C, close: true, fill: red.transparentize(70%), stroke: black)
      })
    )
  ]
)

- *FOVが小さい*：望遠レンズのような効果（歪みが少ない）
- *FOVが大きい*：広角レンズのような効果（歪みが大きい）

== 4. 実用例：複雑な3D図形

#figure(
  cetz.canvas(length: 1.2cm, {
    import cetz.draw: *

    let perspective() = {
      let FOVx = 80deg
      let FOVy = 60deg
      let near = 0.1
      let far = 1000
      set-transform((
        (1 / calc.tan(FOVx / 2), 0, 0, 0),
        (0, 1 / calc.tan(FOVy / 2), 0, 0),
        (0, 0, -(far + near) / (far - near), -2 * (near * far) / (far - near)),
        (0, 0, -1, 0),
      ))
    }

    perspective()
    rotate(x: 20deg, y: 45deg, z: 0deg)

    // 階段状の構造を描画
    let depth = -8

    for i in range(0, 5) {
      let z = depth + i * 0.8
      let x = i * 0.8
      let y = i * 0.8
      let s = 1.5 - i * 0.2

      // 各段の立方体
      let colors = (blue, green, yellow, orange, red)
      let color = colors.at(i)

      line(
        (x, y, z),
        (x + s, y, z),
        (x + s, y + s, z),
        (x, y + s, z),
        close: true,
        fill: color.transparentize(70%),
        stroke: black
      )

      // 側面
      line(
        (x + s, y, z),
        (x + s, y, z + 0.6),
        (x + s, y + s, z + 0.6),
        (x + s, y + s, z),
        close: true,
        fill: color.transparentize(85%),
        stroke: gray
      )

      line(
        (x, y + s, z),
        (x + s, y + s, z),
        (x + s, y + s, z + 0.6),
        (x, y + s, z + 0.6),
        close: true,
        fill: color.transparentize(80%),
        stroke: gray
      )
    }
  })
)

== パース設定の詳細説明

```typst
let perspective() = {
  let FOVx = 90deg  // 水平視野角：広いほど左右の歪みが大きい
  let FOVy = 70deg  // 垂直視野角：広いほど上下の歪みが大きい
  let near = 0.1    // ニアクリップ：これより近いものは描画されない
  let far = 1000    // ファークリップ：これより遠いものは描画されない

  set-transform((
    (1 / calc.tan(FOVx / 2), 0, 0, 0),
    (0, 1 / calc.tan(FOVy / 2), 0, 0),
    (0, 0, -(far + near) / (far - near), -2 * (near * far) / (far - near)),
    (0, 0, -1, 0),
  ))
}
```

*重要な注意点*：
- CeTZは自動的に隠面消去を行いません
- 描画順序を手動で制御する必要があります（奥→手前の順）
- z座標は負の値を使用（カメラはz=0の位置）

== まとめ

#table(
  columns: 3,
  [*項目*], [*正投影（ortho）*], [*透視投影（perspective）*],
  [平行線], [平行のまま], [消失点に収束],
  [奥行き表現], [サイズ変化なし], [遠くが小さくなる],
  [用途], [設計図・証明問題], [写実的な図・建築パース],
  [実装], [組み込み関数], [手動で変換行列を設定],
  [隠面処理], [不要（2.5D）], [手動で制御が必要],
)

パースを使うことで、より写実的で立体感のある図形を描くことができます。
数学的な証明には正投影、視覚的なプレゼンテーションには透視投影が適しています。
