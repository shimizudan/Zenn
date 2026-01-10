#import "@preview/js:0.1.3": *
#import "@preview/cetz:0.4.2"

#show: js.with(
  lang: "ja",
  seriffont-cjk: "Hiragino Mincho ProN",
  sansfont-cjk: "Hiragino Kaku Gothic ProN",
  paper: "a4",
  fontsize: 10pt,
  cols: 2,
)

// ボックス表示用の関数を定義（中央揃え）
#let boxed(content) = align(center)[
  #rect(
    inset: 8pt,
    stroke: 1pt + black,
    radius: 2pt,
    content
  )
]

// 見出しのフォントをヒラギノ丸ゴシックに設定（10pt）
#show heading: set text(font: "Hiragino Kaku Gothic ProN", size: 10pt)

#maketitle(
  title: "積分による三角関数・対数関数の定義",
  authors: (("清水 団 (Dan Shimizu)", "城北中学校・高等学校"),),
  abstract: [
    本稿では、三角関数と対数関数を積分（長さ・面積）から定義する立場を採用し、高校数学から大学数学への自然な接続を試みます。従来の高校数学では「定義を与えずに性質だけを列挙する」ことで生じる違和感や循環論法の問題を、積分による定義によって解消します。具体的には、単位円の弧長としてラジアンを定義し、その逆関数として正弦関数を導入します。同様に、双曲線 $y=1/x$ の下の面積として対数関数を定義し、その逆関数として指数関数を導きます。この立場により、微分公式・加法定理・基本極限などの性質がすべて定義から必然的に導かれることを示します。
  ]
)

= 三角関数

== 単位円と「角＝長さ」という考え

*単位円 $x^2 + y^2 = 1 $* を用いて，通常の高校数学では次のような順番で，三角関数を考えます。

#v(0.5em)
#align(center)[角 → 座標 → 三角関数]
#v(0.5em)

今回は，この順番を変えて，
#v(0.5em)
#align(center)[積分（長さ）→ 角 → 三角関数]
#v(0.5em)

という順で定義します。


== 単位円の弧長として角を定義する

- 単位円の右半分を

  $ (x(t), y(t)) = (sqrt(1-t^2), t) quad (-1 < t < 1) $

  とパラメータ表示します。

- *速さ（弧長要素）*

  $ x'(t) = frac(-t, sqrt(1-t^2)), quad y'(t) = 1 $


  $ therefore sqrt(x'(t)^2 + y'(t)^2)
&= sqrt(frac(t^2, 1-t^2) + 1)= frac(1, sqrt(1-t^2)) $


- *角の定義（積分）*

  原点から見て、点P $(sqrt(1-y^2), y)$ までの弧長 $θ$ を次のように定めます。

  #v(0.5em)
  #boxed[$
  θ &= integral_0^y frac(d t, sqrt(1-t^2)) quad (-1 < y < 1)
  $]
  #v(0.5em)


  - これは単位円上の弧の長さです
  - 単位円なので

    #v(0.5em)
    #align(center)[弧長 = 中心角（ラジアン）]
    #v(0.5em)

  👉 $π$ の定義は次のようになります。

  #let args = arguments(fill: rgb("#7fdbff28"),stroke: blue, inset: 8pt,radius: 4pt,[$
  pi &= 2integral_0^1 frac(d t, sqrt(1-t^2))
  $])
  #figure(box(..args))


== 正弦関数の定義（逆関数として）

上の定義より

$ theta = integral_0^y frac(d t, sqrt(1-t^2)) $

は $y$ の単調増加関数です。よって逆関数 $θ->y$が存在します。この逆関数を $sin$ と定義すると，

#v(0.5em)
#boxed[$
y = sin theta quad (-frac(pi, 2) < theta < frac(pi, 2))
$]
#v(0.5em)

です。つまり，*正弦とは「弧長 $theta$ に対応する単位円上の $y$ 座標」*
となります。

== 微分から余弦関数へ
- *微分*

  $ theta = integral_0^y frac(d t, sqrt(1-t^2))
  quad ==> quad
  frac(d theta, d y) = frac(1, sqrt(1-y^2)) $

  $ therefore frac(d y, d theta) = sqrt(1-y^2) $

  $
  therefore frac(d, d theta) sin theta
  = sqrt(1 - sin^2 theta)
  $

  #v(0.5em)


- *余弦関数の定義*

  #v(0.5em)
  #boxed[$
  cos theta = sqrt(1 - sin^2 theta) #h(2mm) (display(-frac(pi, 2) < theta < frac(pi, 2)))
  $]
  #v(0.5em)

  $cos θ$ をこのように定義すれば，

  $ sin^2 theta + cos^2 theta = 1 $

   $ (sin θ)' = cos theta  $

  が成り立ちます。


== 面積 $bold(S=display(theta/2))$ が自然に出る理由

単位円の扇形の面積を考えます。

#align(center)[
#cetz.canvas({
  import cetz.draw: *



  // 単位円（第1象限のみ）
  arc((2, 0), start: 0deg, stop: 90deg, radius: 2, stroke: black + 0.8pt)


  // 扇形の塗りつぶし（角度30度の例）
  let angle = 30
  let y-coord = 2 * calc.sin(angle * calc.pi / 180)
  let x-coord = 2 * calc.cos(angle * calc.pi / 180)

  // 扇形を塗る
  arc((2, 0), start: 0deg, stop: angle * 1deg, radius: 2, fill: rgb(200, 220, 255, 150), stroke: none)

 line((0,0),(2, 0),(x-coord, y-coord), start: 0deg, stop: angle * 1deg, radius: 2, fill: rgb(200, 220, 255, 150), stroke: none)

  // 半径
  line((0, 0), (2, 0), stroke: black + 0.8pt)
  line((0, 0), (x-coord, y-coord), stroke: black + 0.8pt)

  // 座標軸
  line((-0.3, 0), (2.5, 0), stroke: black + 0.5pt, mark: (end: ">", fill: black))
  line((0, -0.3), (0, 2.5), stroke: black + 0.5pt, mark: (end: ">", fill: black))

  // Pからy軸への垂線
  line((x-coord, y-coord), (0, y-coord), stroke: (paint: black, dash: "dashed", thickness: 0.5pt))

  // 点の表示
  circle((x-coord, y-coord), radius: 0.05, fill: black)

  // ラベル
  content((x-coord + 0.1, y-coord + 0.1), $"P"(sqrt(1-y^2), y)$, anchor: "west")
  content((2.3, -0.2), $x$, anchor: "north")
  content((-0.2, 2.3), $y$, anchor: "east")
  content((1, -0.3), $1$, anchor: "north")
  content((-0.1, -0.1), $"O"$, anchor: "north-east")
  content((.6, 0.04), $theta$, anchor: "south")
})
]

扇形の面積 $S$ は部分積分を用いると

$ S&= integral_0^y sqrt(1-t^2) d t - frac(1, 2) y sqrt(1-y^2)\ $

ここで，部分積分を用いて，

$ 
   &integral_0^y sqrt(1-t^2) d t
   =[t sqrt(1-t^2)]_0^y+ integral_0^y (t^2)/(sqrt(1-t^2)) #h(1mm) d t\
   &=y sqrt(1-y^2)+ integral_0^y (t^2-1+1)/(sqrt(1-t^2)) #h(1mm) d t\
   &=y sqrt(1-y^2)- integral_0^y sqrt(1-t^2) #h(1mm) d t+integral_0^y frac(d t, sqrt(1-t^2))\
    $

$ therefore integral_0^y sqrt(1-t^2) d t&=1/2 y sqrt(1-y^2)+1/2  integral_0^y frac(d t, sqrt(1-t^2))  $


$ therefore S = frac(1, 2) integral_0^y frac(d t, sqrt(1-t^2))
= frac(1, 2) theta $

つまり， *単位円の扇形の面積 $display(frac(1, 2) theta
)$* となります。



== 極限 $display(lim_(theta -> 0) frac(sin theta, theta) = 1)$


👉 面積比較や「循環論法」は不要です。

#let args = arguments(fill: rgb("#7fdbff28"),stroke: blue, inset: 8pt,radius: 4pt,[
$ frac(sin theta, theta)
quad ==> quad
lim_(theta -> 0)
= lr(frac(d, d theta) sin theta|)_(theta=0)
= cos 0 = 1 $])
#figure(box(..args))




= 対数関数・指数関数


== 対数関数の定義

対数関数 $log$ を次のように定義します。

#v(0.5em)
#boxed[$
log x = integral_1^x frac(d t, t) quad (x > 0)
$]
#v(0.5em)

これは

- 点 $(1, 0)$ から $(x, 0)$ まで
- 曲線 $y = 1/t$ の下の符号付き面積

として定義されます。


== 基本性質

定義から導くことができます。

- $display(log 1 =  integral_1^1 frac(d t, t) = 0)$

#v(3mm)

- *微分*　積分の基本定理より

  #v(0.5em)
  $
  frac(d, d x) log x = frac(1, x)
  $
  #v(0.5em)

  -  $log x$ は単調増加である。


== 対数関数の性質

*命題*

#v(0.5em)
#boxed[$
log(a b) = log a + log b
$]
#v(0.5em)

*証明*

$ log(a b)
&= integral_1^(a b) frac(d t, t) = integral_1^a frac(d t, t) + integral_a^(a b) frac(d t, t) $

後半で変数変換 $t = a u$ を行うと

$ integral_a^(a b) frac(d t, t) = integral_1^b frac(d u, u) = log b $


== 指数関数の定義（逆関数）

$log x$ は単調増加なので逆関数をもちます。

*定義*

#v(0.5em)
#boxed[$
x = exp t <==> t = log x
$]
#v(0.5em)


== 微分から指数関数へ

逆関数の微分より

$ frac(d t, d x) = frac(1, x) ==> frac(d x, d t) = x $

したがって

#v(0.5em)
#boxed[$
frac(d, d t) exp t = exp t
$]
#v(0.5em)

👉 指数関数とは「自分自身が微分になる関数」です。


== 定数 $e$ の定義

*定義*

#v(0.5em)
#boxed[$
e = exp 1
$]
#v(0.5em)

すなわち，$e$ は

#v(0.5em)

#let args = arguments(fill: rgb("#7fdbff28"),stroke: blue, inset: 8pt,radius: 4pt,[ 曲線 $display(y = 1/x)$ の下の面積が 1 になるときの $x$])

#figure(box(..args))

#v(0.5em)


== 基本極限の即時導出

$ lim_(x -> 0) frac(e^x - 1, x)
= lr(frac(d, d x) e^x|)_(x=0)
= e^0 = 1 $



== まとめ（三角関数との対応）

三角関数と対数関数は、いずれも「積分で定義される量の逆関数」という共通構造をもちます。


#figure(
  table(
  columns: 2,
  align: left,
  stroke: none,
  [*三角関数*], [*対数関数*],
  [単位円の弧長], [双曲線下の面積],
  [$display(theta = integral_0^y frac(d t, sqrt(1-t^2)))$],
  [$display(log x = integral_1^x frac(d t, t))$],
  [逆関数が $sin$], [逆関数が $exp$],
))



= 参考文献

#block[
  黒木玄 (2025). "積分による三角関数・対数関数の定義に関する議論". X (旧Twitter), 2025年1月10日. #link("https://x.com/genkuroki/status/2009564879557181825")
]

#v(2em)

= 生成AI

本稿の執筆にあたり、ChatGPT-5.2およびClaude Code (Sonnet 4.5) を文書作成支援ツールとして利用しました。
