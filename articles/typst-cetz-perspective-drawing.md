---
title: "TypstのCeTZで遠近法を実装：立体図形にパースをつけて描く"
emoji: "📐"
type: "idea"
topics: ["typst", "cetz", "3D", "遠近法", "パースペクティブ"]
published: true
---

この記事は [Typst Advent Calendar 2025](https://qiita.com/advent-calendar/2025/typst) の12月14日の記事です。

## はじめに

TypstのCeTZパッケージは3D図形の描画に対応していますが、デフォルトでは**平行投影（orthographic projection）**が使われます。平行投影では、遠くの物体も近くの物体も同じ大きさに描かれるため、リアルな立体感を表現するには限界があります。

この記事では、**遠近法（perspective projection）**を実装し、**奥にある面が小さく見える**ような立体図形の描き方を解説します。特に、立方体を真正面から見たときに、奥の正方形の面が小さくなる図を作成します。

## 完成図

以下が遠近法を適用した立方体の例です：

![遠近法を適用した立方体](/images/typst-cetz-perspective-cube.png)

左が平行投影、右が遠近法（パースペクティブ投影）で描いた立方体です。右の図では、奥にある面が小さく描かれているのがわかります。

## CeTZでの遠近法の実装方法

CeTZには遠近法の機能が組み込まれていないため、**変換行列（transformation matrix）**を使って手動で実装します。

### 遠近法の基本原理

遠近法では、視点（カメラ）からの距離に応じて点の座標を変換します。基本的な変換式は以下の通りです：

```
x' = x / (1 + z/d)
y' = y / (1 + z/d)
```

ここで：
- `(x, y, z)`: 元の3D座標
- `(x', y')`: 投影後の2D座標
- `d`: 視点からの距離（大きいほど遠近感が弱くなる）

### パースペクティブ変換関数の実装

まず、3D座標を遠近法で2D座標に変換する関数を定義します：

```js
#import "@preview/cetz:0.4.2"

#let perspective(point, distance: 5) = {
  let (x, y, z) = point
  let scale = 1 / (1 + z / distance)
  (x * scale, y * scale)
}
```

この関数は：
- `point`: 3D座標 `(x, y, z)`
- `distance`: 視点からの距離パラメータ（デフォルト: 5）
- 戻り値: 投影後の2D座標 `(x', y')`

### 立方体の頂点定義

立方体の8つの頂点を3D座標で定義します。ここでは、立方体の中心を原点にして、z軸方向に奥行きを設定します：

```js
// 手前の面の4つの頂点（z = -0.5）
let A = (-0.5, 0.5, -0.5)   // 左上手前
let B = (0.5, 0.5, -0.5)    // 右上手前
let C = (0.5, -0.5, -0.5)   // 右下手前
let D = (-0.5, -0.5, -0.5)  // 左下手前

// 奥の面の4つの頂点（z = 0.5）
let E = (-0.5, 0.5, 0.5)    // 左上奥
let F = (0.5, 0.5, 0.5)     // 右上奥
let G = (0.5, -0.5, 0.5)    // 右下奥
let H = (-0.5, -0.5, 0.5)   // 左下奥
```

z座標が大きいほど（正の方向）、奥にある点を表します。

### パースペクティブ投影の適用

各頂点に遠近法を適用して2D座標に変換します：

```js
// 視点からの距離を設定（値を小さくすると遠近感が強くなる）
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
```

### 立方体の描画

変換した2D座標を使って立方体を描画します：

```js
#cetz.canvas({
  import cetz.draw: *

  // 奥の面（小さくなる）
  line(E2d, F2d, G2d, H2d, close: true,
       stroke: blue + 1pt, fill: blue.transparentize(80%))

  // 手前の面（大きい）
  line(A2d, B2d, C2d, D2d, close: true,
       stroke: red + 1pt, fill: red.transparentize(80%))

  // 接続する辺
  line(A2d, E2d, stroke: black + 0.5pt)
  line(B2d, F2d, stroke: black + 0.5pt)
  line(C2d, G2d, stroke: black + 0.5pt)
  line(D2d, H2d, stroke: black + 0.5pt)

  // 頂点ラベル
  content(A2d, [A], anchor: "south-east", padding: 0.1)
  content(B2d, [B], anchor: "south-west", padding: 0.1)
  content(C2d, [C], anchor: "north-west", padding: 0.1)
  content(D2d, [D], anchor: "north-east", padding: 0.1)
  content(E2d, [E], anchor: "south-east", padding: 0.1)
  content(F2d, [F], anchor: "south-west", padding: 0.1)
  content(G2d, [G], anchor: "north-west", padding: 0.1)
  content(H2d, [H], anchor: "north-east", padding: 0.1)
})
```

## 完全なコード例

真正面から見た立方体を遠近法で描画する完全なコードです：

```js
#set page(width: auto, height: auto, margin: 1cm)
#import "@preview/cetz:0.4.2"

// パースペクティブ変換関数
#let perspective(point, distance: 5) = {
  let (x, y, z) = point
  let scale = 1 / (1 + z / distance)
  (x * scale, y * scale)
}

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
  caption: [遠近法で描いた立方体（真正面から）]
)
```

このコードで生成される図：

![真正面から見た立方体（遠近法）](/images/typst-cetz-front-view.png)

## パラメータの調整

### 視点距離（distance）の効果

`distance`パラメータを変えることで、遠近感の強さを調整できます：

```js
// 遠近感が強い（distance = 2）
let A2d_strong = perspective(A, distance: 2)

// 遠近感が中程度（distance = 5）
let A2d_medium = perspective(A, distance: 5)

// 遠近感が弱い（distance = 10）
let A2d_weak = perspective(A, distance: 10)
```

- **distance が小さい**（例: 2）：奥の面が非常に小さくなり、強い遠近感
- **distance が大きい**（例: 10）：奥の面とほぼ同じ大きさで、弱い遠近感
- **distance = ∞**：平行投影と同じ（遠近感なし）

### 立方体の配置

z座標を調整することで、立方体の位置を変えられます：

```js
// 手前寄りの立方体（z = -1 ～ 0）
let A_near = (-0.5, 0.5, -1)
let E_near = (-0.5, 0.5, 0)

// 奥寄りの立方体（z = 0 ～ 1）
let A_far = (-0.5, 0.5, 0)
let E_far = (-0.5, 0.5, 1)
```

## 斜めから見た立方体

真正面だけでなく、斜め前方から見た立方体も描けます。3D座標を回転させてから遠近法を適用することで、奥行きにパースがついた効果を表現できます。

### 回転関数の定義

まず、Y軸周りとX軸周りの回転関数を定義します：

```js
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
```

### 回転とパースペクティブの組み合わせ

立方体を回転させてから遠近法を適用する例：

```js
#cetz.canvas(length: 3cm, {
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
  // ... 他の頂点も同様に回転

  // パースペクティブ変換を適用
  let d = 3
  let A2d = perspective(A-rot, distance: d)
  let B2d = perspective(B-rot, distance: d)
  // ... 他の頂点も同様に変換

  // 立方体を描画（各面を色分け）
  line(A2d, B2d, C2d, D2d, close: true,
       stroke: red + 1.5pt, fill: red.transparentize(80%))
  line(E2d, F2d, G2d, H2d, close: true,
       stroke: blue + 1pt, fill: blue.transparentize(80%))
  // ... 側面も描画
})
```

### 描画順序の重要性

斜めから見た立方体を描く際は、**描画順序**が重要です。奥の面から手前の面へと順番に描くことで、正しい前後関係が表現されます：

```js
// 1. 背面（奥）- 先に描画
line(E2d, H2d, G2d, F2d, close: true,
     stroke: gray + 0.8pt, fill: gray.transparentize(90%))

// 2. 左側面
line(A2d, E2d, F2d, B2d, close: true,
     stroke: green + 1pt, fill: green.transparentize(85%))

// 3. 底面
line(D2d, C2d, G2d, H2d, close: true,
     stroke: orange + 1pt, fill: orange.transparentize(85%))

// 4. 手前の面（最前面）- 最後に描画
line(A2d, B2d, C2d, D2d, close: true,
     stroke: red + 1.5pt, fill: red.transparentize(80%))

// 5. 上面
line(A2d, B2d, F2d, E2d, close: true,
     stroke: purple + 1pt, fill: purple.transparentize(85%))

// 6. 右側面
line(B2d, C2d, G2d, F2d, close: true,
     stroke: blue + 1pt, fill: blue.transparentize(85%))
```

透明度を使うことで、各面が重なっても見えるようにしています。

### 異なる角度での表示

回転角度を変えることで、さまざまな角度から立方体を観察できます：

```js
// 小さい角度（15度）- ほぼ正面
let A-rot = rotate-y(A, 15deg)

// 中程度の角度（30度）- バランスの良い斜め視点
let A-rot = rotate-y(A, 30deg)

// 大きい角度（45度）- 側面がよく見える
let A-rot = rotate-y(A, 45deg)
```

角度が大きくなるほど、側面がよく見えるようになり、立体感が増します。

### 完全なコード例

斜めから見た立方体を描画する完全なコードです：

```js
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

    // Y軸周りに30度、X軸周りに15度回転（斜め前方から見る）
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
```

このコードで生成される図：

![斜め前方から見た立方体（遠近法）](/images/typst-cetz-diagonal-view.png)

この図では、以下の要素が確認できます：
- **視点**: Y軸30°、X軸15°回転で斜め前方から見る視点
- **奥行き感**: 手前（z=-0.5）から奥（z=1.0）に向かって徐々に小さくなり、奥行きにパースがついている
- **手前の面（赤）**: 最も大きく鮮明に描画される
- **奥の面（灰色）**: 遠近法により明らかに小さく描画され、遠さが強調される
- **各側面（緑、青、紫、オレンジ）**: 立体感を表現するために色分け
- **透明度**: 各面が重なっても見えるように透明度を設定
- **distance = 2.5**: 小さい値で強い遠近感を実現

## 比較：平行投影 vs 遠近法

2つの投影方法を並べて比較する例：

```js
#import "@preview/cetz:0.4.2"

#grid(
  columns: 2,
  gutter: 1cm,
  [
    // 平行投影（ortho使用）
    #cetz.canvas(length: 2cm, {
      import cetz.draw: *
      ortho(x: 0deg, y: 0deg, {
        let A = (-0.5, 0.5, -0.5)
        let B = (0.5, 0.5, -0.5)
        // ... (以下、通常の描画)
      })
    })
    #align(center)[平行投影]
  ],
  [
    // 遠近法
    #cetz.canvas(length: 2cm, {
      import cetz.draw: *
      // ... (パースペクティブ変換を使った描画)
    })
    #align(center)[遠近法]
  ]
)
```

## 応用例

### 複数の立方体を配置

遠近法を使えば、複数の立方体を奥行き方向に配置できます。z座標のオフセットを変えることで、手前から奥に向かって立方体を並べることができます：

```js
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

  // 立方体の各面を描画
  line(E2d, H2d, G2d, F2d, close: true,
       stroke: cube-color.darken(30%) + 0.8pt,
       fill: cube-color.transparentize(90%))
  line(A2d, E2d, F2d, B2d, close: true,
       stroke: cube-color.darken(10%) + 1pt,
       fill: cube-color.transparentize(85%))
  line(D2d, C2d, G2d, H2d, close: true,
       stroke: cube-color.darken(20%) + 1pt,
       fill: cube-color.transparentize(85%))
  line(A2d, B2d, C2d, D2d, close: true,
       stroke: cube-color + 1.2pt,
       fill: cube-color.transparentize(80%))
  line(A2d, B2d, F2d, E2d, close: true,
       stroke: cube-color.lighten(10%) + 1pt,
       fill: cube-color.transparentize(85%))
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
  caption: [奥行き方向に配置した3つの立方体]
)
```

このコードで生成される図：

![複数の立方体を配置](/images/typst-cetz-multiple-cubes.png)

この例では、以下のポイントに注目してください：

- **立方体描画関数の作成**: `draw-cube()`関数で、位置、サイズ、色を指定して立方体を描画
- **z座標のオフセット**: 手前（z=-0.5）、中央（z=0.8）、奥（z=1.8）と配置
- **サイズの調整**: 奥の立方体をより小さく（0.4）して、遠近感を強調
- **色の区別**: 赤、青、緑で3つの立方体を区別
- **自動的な遠近感**: 遠くの立方体ほど小さく描画される

### 消失点を可視化

1点透視の消失点を明示的に描画することもできます：

```js
// 消失点は (0, 0) に設定
circle((0, 0), radius: 0.05, fill: black)
content((0, 0), [消失点], anchor: "south", padding: 0.2)
```

## まとめ

この記事では、TypstのCeTZパッケージで遠近法（パースペクティブ投影）を実装する方法を解説しました。主なポイント：

- **変換関数の定義**：`perspective()`関数で3D→2D変換を実装
  - 基本式：`x' = x / (1 + z/d)`, `y' = y / (1 + z/d)`
- **視点距離の調整**：`distance`パラメータで遠近感の強さを制御
  - 値が小さいほど強い遠近感（奥の面が小さくなる）
- **真正面からの視点**：奥の正方形の面が小さくなる効果を実現
- **回転変換の組み合わせ**：`rotate-y()`と`rotate-x()`で斜めから見た図を作成
  - Y軸周りの回転で水平方向の角度を調整
  - X軸周りの回転で垂直方向の角度を調整
- **描画順序の制御**：奥の面から手前の面へと順番に描画
- **透明度の活用**：各面を透明にして奥行き感を表現

### 実装のポイント

CeTZには遠近法が組み込まれていませんが、以下の3ステップで実装できます：

1. **3D座標の定義**：立方体の頂点を `(x, y, z)` で定義
2. **回転変換（オプション）**：斜めから見る場合は回転関数を適用
3. **パースペクティブ変換**：`perspective()`関数で2D座標に投影

この手法を使えば、よりリアルな3D図形を描画できます。立体幾何の問題の視覚化や、技術文書での立体図の作成に活用できます。

ぜひ、皆さんも遠近法を使った立体図形の描画に挑戦してみてください！

## 参考

- [CeTZ公式ドキュメント](https://github.com/cetz-package/cetz)
- [Typst公式サイト](https://typst.app/)
- [Typst Forum - How can I add perspective to a CeTZ drawing?](https://forum.typst.app/t/how-can-i-add-perspective-to-a-cetz-drawing/6639/3)
