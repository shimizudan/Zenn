---
title: "TypstのCeTZパッケージで3D立方体を描く：対角線と平面の垂直性の証明問題"
emoji: "🎲"
type: "idea"
topics: ["typst", "cetz", "数学", "立体幾何", "3D"]
published: false
publication_name: "typstn"
---

:::message
この記事は[Typst Advent Calendar 2025](https://qiita.com/advent-calendar/2025/typst)の12月7日の記事です。
:::

## はじめに

X（旧Twitter）で[@takechan1414213](https://x.com/takechan1414213)さんから面白い立体幾何の証明問題が投稿されました：

:::message
**問題**: 立方体ABCD-EFGHで対角線AGは平面BDEに垂直であることを証明せよ。
:::

この記事では、この問題の証明をTypstとCeTZパッケージを使って視覚化する方法を詳しく解説します。特に**3D空間での描画**と**視点（viewpoint）の変更**に焦点を当てて、CeTZパッケージのコードを丁寧に説明していきます。

## 完成図

以下がCeTZで作成した証明図です：

![CeTZで作成した立方体の証明図](/images/typst-cetz-cube-perpendicular.png)

## 問題と証明の概要

**問題**: 立方体ABCD-EFGHで対角線AGは平面BDEに垂直であることを証明せよ。

**証明のポイント**:

直線と平面の垂直条件を使います：

1. 直線lと平面α上の平行でない2直線が垂直 ⇒ 直線lと平面αが垂直

この条件を使って：

- **DB ⊥ 面ACGE** より、**AG ⊥ DB** …①
- **BE ⊥ 面AFGD** より、**AG ⊥ EB** …②
- ①、② より、**対角線AG ⊥ 平面BDE**

図では、3つの異なる視点から立方体を描画し、それぞれの垂直関係を強調しています。

## CeTZパッケージとは

CeTZは、Typstで図形を描画するための強力なパッケージです。2D図形だけでなく、**3D空間での描画**にも対応しています。

まず、CeTZパッケージをインポートします：

```js:
#import "@preview/cetz:0.4.2"
```

## 3D描画の基本構造

CeTZで3D図形を描くには、`ortho()`関数を使用します：

```js:
#cetz.canvas(length: 4cm, {
  import cetz.draw: *

  ortho(x: 20deg, y: 30deg, {
    // ここに3D描画コードを記述
  })
})
```

### `ortho()`関数とは

`ortho()`は**斜投影（orthographic projection）**を設定する関数です：

- `x: 20deg`: x軸方向の回転角度（視点の高さを調整）
- `y: 30deg`: y軸方向の回転角度（視点の水平方向を調整）

この2つのパラメータで**視点を自由に変更**できます。

### 視点の変更による効果

同じ立方体を異なる視点で描画することで、異なる面や線の関係を強調できます。この問題では、3つの視点を使い分けています：

1. **最初の図**: 平面BDE（青い三角形）と対角線AG（赤い線）を強調
2. **2つ目の図**: 面ACGE（黄色の四角形）とDB（青い線）の垂直関係を強調
3. **3つ目の図**: 面AFGD（黄色の四角形）とEB（青い線）の垂直関係を強調

すべて同じ `ortho(x: 20deg, y: 30deg, {...})` を使っていますが、強調する要素を変えることで異なる視点から問題を理解できます。

## 立方体の頂点の定義

3D空間で立方体の各頂点を定義します：

```js:
let H = (0,0,0)
let E = (0,0,1)
let D = (0,1,0)
let B = (1,1,1)
let A = (0,1,1)
let G = (1,0,0)
let F = (1,0,1)
let C = (1,1,0)
```

座標は `(x, y, z)` の形式で指定します。このコードでは：

- H を原点 (0,0,0) に配置
- 立方体の一辺の長さを 1 に設定
- 各頂点を3D座標で定義

このように座標を定義することで、**立方体の幾何学的な関係が正確に保たれます**。

## 点と点ラベルの描画

頂点に点とラベルを描画するための関数を定義します：

```js:
let draw-point(pos, text, color, anchor) = {
  circle(pos, radius: 0.0, fill: color, stroke: none)
  content((), block(inset: 0.3em)[#text], anchor: anchor)
}

draw-point(A,  "A", black, "north")
draw-point(B,  "B", black, "south-west")
draw-point(C,  "C", black, "north")
draw-point(D,  "D", black, "north")
draw-point(E,  "E", black, "south")
draw-point(F,  "F", black, "south")
draw-point(G,  "G", black, "south")
draw-point(H,  "H", black, "south")
```

### ポイント

- `circle(pos, radius: 0.0, ...)`: 半径0の円（実質的に描画されない）を配置
- `content((), ...)`: 現在位置にテキストを配置
- `anchor`: ラベルの配置位置（"north", "south", "south-west"など）

`anchor`パラメータを調整することで、頂点の位置に応じてラベルが重ならないように配置できます。

## 平面の描画と塗りつぶし

平面BDEを青い塗りつぶし付きの三角形として描画します：

```js:
line(D,E,B,close:true,name:"DEB",stroke: blue,fill:aqua.transparentize(70%))
```

### パラメータの説明

- `D, E, B`: 3つの頂点を順に指定
- `close: true`: 最後の点から最初の点へ線を引いて閉じる
- `stroke: blue`: 輪郭線を青色で描画
- `fill: aqua.transparentize(70%)`: 水色で塗りつぶし、透明度70%

`transparentize(70%)`を使うことで、**背後にある辺も見える**ように表現できます。これは3D表現において重要なテクニックです。

## 立方体の辺の描画

立方体の各辺を描画します：

```js:
line(A,B,name:"AB")
line(B,C,name:"BC")
line(C,D,name:"CD")
line(D,A,name:"DA")
line(A,E,name:"AE")
line(B,F,name:"BF")
line(C,G,name:"CG")
line(E,F,name:"EF")
line(F,G,name:"FG")
```

### 見えない辺の表現

立方体の背面にあって見えない辺は、点線で描画します：

```js:
line(D,H,name:"DH",stroke: (dash: "dotted"))
line(G,H,name:"GH",stroke: (dash: "dotted"))
line(H,E,name:"HE",stroke: (dash: "dotted"))
```

`stroke: (dash: "dotted")`で点線になります。これにより、**3D空間での前後関係**が明確になります。

## 対角線と交点の描画

対角線AGとその中間点を描画します：

```js:
let P = (1/3,2/3,2/3)

let draw-point(pos, color) = {
  circle(pos, radius: 0.02, fill: color, stroke: none)
}

draw-point(P, red)

line(G,P,name:"PG",stroke: red)
line(A,P,name:"AP",stroke: red)
```

- `P`: 対角線AG上の点（平面BDEとの交点）
- `draw-point(P, red)`: 赤い点として強調
- 対角線を2つの線分に分けて赤色で描画

## 異なる平面の強調表示

証明では、異なる平面を強調する必要があります。

### 面ACGE（黄色）の描画

```js:
line(A,C,G,E,close:true,name:"ACGE",stroke: olive,fill:yellow.transparentize(70%))
```

4つの頂点を順に指定して四角形を描き、黄色で塗りつぶします。

### 面AFGD（黄色）の描画

```js:
line(A,D,G,F,close:true,name:"AFGD",stroke: olive,fill:yellow.transparentize(70%))
```

同様に、異なる4つの頂点で別の平面を描画します。

## 垂直な直線の強調

証明で重要な垂直関係を示す直線を強調します：

```js:
// DB を青色で強調
line(D,B,name:"DB",stroke: blue)

// EB を青色で強調
line(E,B,name:"EB",stroke: blue)
```

これらの線を青色にすることで、対角線AG（赤色）との垂直関係が視覚的にわかりやすくなります。

## 視点変更のテクニック

同じ `ortho(x: 20deg, y: 30deg, {...})` を使いつつ、異なる要素を強調することで、実質的に「視点を変える」効果を得ています：

### 最初の図（平面BDEを強調）

```js:
ortho(x: 20deg, y: 30deg, {
  // ...
  line(D,E,B,close:true,stroke: blue,fill:aqua.transparentize(70%))
  line(G,P,stroke: red)
  line(A,P,stroke: red)
  // ...
})
```

### 2つ目の図（面ACGEとDBを強調）

```js:
ortho(x: 20deg, y: 30deg, {
  // ...
  line(A,C,G,E,close:true,stroke: olive,fill:yellow.transparentize(70%))
  line(D,B,stroke: blue)
  // ...
})
```

### 3つ目の図（面AFGDとEBを強調）

```js:
ortho(x: 20deg, y: 30deg, {
  // ...
  line(A,D,G,F,close:true,stroke: olive,fill:yellow.transparentize(70%))
  line(E,B,stroke: blue)
  // ...
})
```

視点角度は同じですが、**強調する面と線を変える**ことで、証明の各ステップを明確に示しています。

## 視点角度を変更する実験

`ortho()`の角度パラメータを変更すると、異なる視点から立方体を見ることができます：

### 例1: 上から見た視点

```js:
ortho(x: 80deg, y: 30deg, {
  // 上から見下ろす視点
})
```

### 例2: 正面から見た視点

```js:
ortho(x: 0deg, y: 0deg, {
  // 正面から見る視点
})
```

### 例3: 斜め上から見た視点

```js:
ortho(x: 45deg, y: 45deg, {
  // 斜め45度から見る視点
})
```

問題や図の性質に応じて、最も分かりやすい角度を選択できます。

## 図全体のコード（最初の図）

完全なコードを示します：

```js:
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

#import "@preview/colorful-boxes:1.4.2": *

#let my_block(back_color, frame_color, title_color, content_color, title, content) = {
  block(width:auto,radius: 4pt, stroke: back_color + 3pt)[
    #block(width: 100%,fill: back_color, inset: (x: 20pt, y: 5pt), below: 0pt)[#text(title_color,font: ("New Computer Modern","BIZ UDPMincho"))[#title]]
   #block(radius: (
    bottom: 3pt,
  ),width: 100%, fill: frame_color, inset: (x: 20pt, y: 10pt))[#text(content_color)[#content]]
  ]
}

#my_block(olive,rgb(95%, 100%, 95%) , white, black, [\@takechan1414213さんからの証明問題], [
  立方体ABCD-EFGHで対角線AGは平面BDEに垂直であることを証明せよ。

  #import "@preview/cetz:0.4.2"
  #figure(
    cetz.canvas(length:4cm,{
      import cetz.draw: *

      ortho(x: 20deg, y: 30deg, {
        let H = (0,0,0)
        let E = (0,0,1)
        let D = (0,1,0)
        let B = (1,1,1)
        let A = (0,1,1)
        let G = (1,0,0)
        let F = (1,0,1)
        let C = (1,1,0)
        let P = (1/3,2/3,2/3)

        let draw-point(pos, text, color, anchor) = {
          circle(pos, radius: 0.0, fill: color, stroke: none)
          content((), block(inset: 0.3em)[#text], anchor: anchor)
        }

        draw-point(A,  "A", black, "north")
        draw-point(B,  "B", black, "south-west")
        draw-point(C,  "C", black, "north")
        draw-point(D,  "D", black, "north")
        draw-point(E,  "E", black, "south")
        draw-point(F,  "F", black, "south")
        draw-point(G,  "G", black, "south")
        draw-point(H,  "H", black, "south")

        line(D,E,B,close:true,name:"DEB",stroke: blue,fill:aqua.transparentize(70%))

        line(A,B,name:"AB")
        line(D,H,name:"DH",stroke: (dash: "dotted") )

        let draw-point(pos, color) = {
          circle(pos, radius: 0.02, fill: color, stroke: none)
        }

        draw-point(P, red)

        line(B,C,name:"BC")
        line(C,D,name:"CD")
        line(D,A,name:"DA")
        line(A,E,name:"AE")
        line(B,F,name:"BF")
        line(C,G,name:"CG")
        line(E,F,name:"EF")
        line(F,G,name:"FG")
        line(G,H,name:"GH",stroke: (dash: "dotted"))
        line(H,E,name:"HE",stroke: (dash: "dotted"))

        line(G,P,name:"PG",stroke: red)
        line(A,P,name:"AP",stroke: red)
      })
    })
  )
])
```

## CeTZの3D描画機能まとめ

この記事で紹介したCeTZの3D描画機能をまとめます：

### 3D投影設定

- `ortho(x: 角度, y: 角度, {...})`: 斜投影を設定し、視点を制御
  - `x`: 垂直方向の回転角度（視点の高さ）
  - `y`: 水平方向の回転角度（視点の水平位置）

### 3D座標

- `(x, y, z)`: 3次元座標で点を指定
- 座標計算で立方体の幾何学的関係を正確に表現

### 3D図形の描画

- `line(点1, 点2, ...)`: 3D空間での線分・折れ線
- `circle(3D座標, ...)`: 3D空間での円
- `content((), text(...))`: 現在位置にテキストを配置

### 3D表現のテクニック

- `stroke: (dash: "dotted")`: 見えない辺を点線で表現
- `fill: color.transparentize(透明度%)`: 透明な塗りつぶしで奥行きを表現
- 色分けによる要素の強調（平面、直線、点）

### 視点変更の戦略

- 角度パラメータの調整で物理的な視点を変更
- 強調要素の変更で視覚的な焦点を変更
- 複数の図を組み合わせて多角的な理解を促進

## まとめ

この記事では、TypstのCeTZパッケージを使って3D立方体を描画し、立体幾何の証明問題を視覚化する方法を解説しました。特に以下のテクニックを紹介しました：

- `ortho()`を使った3D斜投影の設定と視点の制御
- 3D座標 `(x, y, z)` を使った立方体の頂点定義
- 透明度を使った平面の塗りつぶしと奥行き表現
- 点線を使った見えない辺の表現
- 色分けによる幾何学的関係の強調
- 複数の図を使った多角的な視点の提示

CeTZパッケージの3D描画機能は、立体幾何の問題を視覚化するのに非常に有効です。視点を変えながら、垂直関係や平面の位置関係を明確に示すことができます。

立体幾何の問題を視覚化することで、証明の流れが理解しやすくなります。ぜひ、皆さんもCeTZを使って3D図形を描いてみてください！

## 参考

- [CeTZ公式ドキュメント](https://github.com/cetz-package/cetz)
- [Typst公式サイト](https://typst.app/)
- [@takechan1414213さんの問題](https://x.com/takechan1414213/status/1896889773488558199)
