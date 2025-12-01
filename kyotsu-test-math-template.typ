// 共通テスト数学IIBC テンプレート

// ページ設定
#set page(
  paper: "a4",
  margin: (top: 25mm, bottom: 25mm, left: 20mm, right: 20mm),
  numbering: "— 1 —",
  number-align: center,
  footer: context [
    #align(right)[
      #text(size: 9pt)[2604—#counter(page).display()]
    ]
  ]
)

// フォント設定
#set text(
  font: ("Hiragino Mincho ProN", "Hiragino Sans"),
  size: 10.5pt,
  lang: "ja"
)

// 段落設定
#set par(
  justify: true,
  leading: 0.8em,
  first-line-indent: 1em
)

// 数式設定
#set math.equation(numbering: none)

// 見出し設定
#show heading.where(level: 1): it => [
  #set align(left)
  #set text(size: 12pt, weight: "bold", font: "Hiragino Sans")
  #v(1em)
  #it.body
  #v(0.5em)
]

#show heading.where(level: 2): it => [
  #set text(size: 12pt, weight: "bold")
  #v(0.8em)
  #it.body
  #v(0.4em)
]

// 解答欄ボックスの関数
#let answer-box(content) = {
  h(0.15em, weak: true)
  box(
    stroke: 1pt + black,
    inset: 3pt,
    baseline: 20%,
    width: 3em,
    height: 1.4em,
    align(center + horizon, $display(#content)$)
  )
  h(0.15em, weak: true)
}

// 選択肢番号の関数（丸数字）
#let choice(body) = {
  box(
    stroke: 0.8pt + black,
    inset: (x: 2pt, y: 4pt),
    radius: 100%,
    baseline: 25%,
    text(size: 9pt, body)
  )
}

// 丸囲み数字（Unicode文字を使用）
#let circle(num) = {
  // 1-20までの丸囲み数字に対応
  let circled = (
    "①", "②", "③", "④", "⑤",
    "⑥", "⑦", "⑧", "⑨", "⑩",
    "⑪", "⑫", "⑬", "⑭", "⑮",
    "⑯", "⑰", "⑱", "⑲", "⑳"
  )
  if type(num) == int and num >= 1 and num <= 20 {
    circled.at(num - 1)
  } else {
    num  // numが範囲外の場合はそのまま表示
  }
}

// 問題番号の関数
#let question(num, points: none, required: false) = {
  let req-text = if required {
    text(fill: black, font: "Hiragino Sans", size: 11pt)[（必答問題）]
  } else {
    text(fill: black, font: "Hiragino Sans", size: 11pt)[（選択問題）]
  }

  let point-text = if points != none {
    text(fill: black, font: "Hiragino Sans", size: 11pt)[（配点 #points）]
  } else { "" }

  [
    = 第 #num 問 #req-text #point-text
  ]
}

// 注意事項ボックス
#let notice-box(content) = {
  rect(
    width: 100%,
    inset: 10pt,
    stroke: 1.5pt + black,
    [#content]
  )
}

// 会話ボックス
#let dialogue-box(content) = {
  rect(
    width: 100%,
    inset: 10pt,
    stroke: (
      top: none,
      bottom: none,
      left: none,
      right: none,
      rest: 1pt + black
    ),
    [#content]
  )
}

// 表組みヘルパー
#let answer-table(..choices) = {
  let items = choices.pos()
  table(
    columns: items.len(),
    stroke: 1pt + black,
    inset: 8pt,
    ..items
  )
}

// 分数の解答欄
#let frac-answer(num, den) = {
  $frac(#answer-box(num), #answer-box(den))$
}

// ===== 以下、実際の問題作成例 =====

#notice-box[
  試験開始の指示があるまで、この問題冊子の中を見てはいけません。
]

#align(center)[
  #text(size: 20pt, weight: "bold")[数　学　#circle(2)　]
  #text(size: 14pt)[『数学II，数学B，数学C』]
  #h(2em)
  #box(
    stroke: 1pt + black,
    inset: 8pt,
    [100 点\ 70 分]
  )
]

#v(1em)

『旧簿記・会計及び『旧情報関係基礎』の問題冊子は、出願時にそれぞれの科目の受験を希望した者に配付します。

== I　注　意　事　項

1. 出題科目、ページ及び選択方法は、下表のとおりです。

#text(size: 9pt)[（新教育課程履修者）]

#table(
  columns: 3,
  stroke: 1pt + black,
  inset: 8pt,
  [出　　題　　科　　目], [ページ], [選　　択　　方　　法],
  [『数学II，数学B，数学C』], [3～ 42], [左の科目を解答しなさい。]
)

#v(0.5em)

2. 解答用紙の記入・マークについて

#circle(1) 解答用紙に、正しく記入・マークされていない場合は、採点できないことがあります。特に、解答用紙の解答科目欄にマークされていない場合又は複数の科目にマークされている場合は、0点となることがあります。

#circle(2) 新教育課程履修者が、解答科目欄で旧教育課程の科目をマークしている場合は、0点となります。

3. 試験中に問題冊子の印刷不鮮明、ページの落丁・乱丁及び解答用紙の汚れ等に気付いた場合は、手を高く挙げて監督者に知らせなさい。

== II　解答上の注意

解答上の注意は、裏表紙に記載してあります。問題冊子を裏返して必ず読みなさい。

#pagebreak()

// ===== 問題例 =====

= 数学II，数学B，数学C

#table(
  columns: 2,
  stroke: 1pt + black,
  inset: 10pt,
  align: center,
  [問　題], [選　択　方　法],
  [第1問], [必　　　答],
  [第2問], [必　　　答],
  [第3問], [必　　　答],
  [第4問], table.cell(rowspan: 4)[いずれか3問を選択し、\ 解答しなさい。],
  [第5問],
  [第6問],
  [第7問],
)

#pagebreak()

#question(1, points: 15, required: true)

(1) $0 <= theta < pi$ のとき、方程式

$ sin(theta + pi/6) = sin 2theta #h(2em) dots.h.c #circle(1) $

の解を求めよう。以下では、$alpha = theta + pi/6$，$beta = 2theta$ とおく。このとき、#circle(1) は

$ sin alpha = sin beta #h(2em) dots.h.c #circle(2) $

となる。

(i) 二つの一般角 $alpha$ と $beta$ が等しければ、$sin alpha$ と $sin beta$ は等しい。$alpha = beta$ を満たす $theta$ は #answer-box[ア] $pi$ であり、これは #circle(1) の解の一つである。そして、$theta = $ #answer-box[ア] $pi$ のとき

$ sin(theta + pi/6) = sin 2theta = frac(#answer-box[イ], #answer-box[ウ]) $

となる。

(ii) 太郎さんと花子さんは、$theta = $ #answer-box[ア] $pi$ 以外の #circle(1) の解を求める方法について話している。

#dialogue-box[
  太郎：角が等しくなくても、サインの値が等しくなることがあるね。

  花子：サインの値が等しくなるのはどんなときか、単位円を用いて考えてみようか。
]

単位円上で点 $upright(P)(cos alpha, sin alpha)$，$upright(Q)(cos beta, sin beta)$ を考える。$sin alpha = sin beta$ が成り立つとき、点 $upright(P)$ と点 $upright(Q)$ の関係について #answer-box[エ] が成り立つ。

#answer-box[エ] の解答群

#choice[0] 点 $upright(P)$ と点 $upright(Q)$ の $x$ 座標が等しい

#choice[1] 点 $upright(P)$ と点 $upright(Q)$ の $y$ 座標が等しい

#choice[2] 点 $upright(P)$ と点 $upright(Q)$ が $x$ 軸に関して対称

#choice[3] 点 $upright(P)$ と点 $upright(Q)$ が $y$ 軸に関して対称

#choice[4] 点 $upright(P)$ と点 $upright(Q)$ が原点に関して対称

#v(1em)

したがって、#circle(2) を満たす $alpha$ と $beta$ の関係は

$ alpha = beta #h(1em) "または" #h(1em) alpha = #answer-box[オ] - beta $

である。ただし、#answer-box[オ] には適切な符号と角度を入れる。

$theta + pi/6 = $ #answer-box[オ] $- 2theta$ となる $theta$ は

$ theta = frac(#answer-box[カ], #answer-box[キ]) pi $

であり、これは $0 <= theta < pi$ を満たすので、#circle(1) の解の一つである。

#v(1em)

(2) $x$ の関数 $f(x) = x^3 - 3x$ について考える。

(i) $f'(x) = $ #answer-box[ク] $x^2 - $ #answer-box[ケ] である。

$f'(x) = 0$ となる $x$ の値は $x = -$ #answer-box[コ]，#answer-box[サ] である。

$f(x)$ の増減表は次のようになる。

#table(
  columns: 7,
  stroke: 1pt + black,
  inset: 8pt,
  align: center,
  [$x$], [$dots.h.c$], [$-$ #answer-box[シ]], [$dots.h.c$], [#answer-box[ス]], [$dots.h.c$],
  [$f'(x)$], [#answer-box[セ]], [$0$], [#answer-box[ソ]], [$0$], [#answer-box[タ]],
  [$f(x)$], [#answer-box[チ]], [#answer-box[ツ]], [#answer-box[テ]], [#answer-box[ト]], [#answer-box[ナ]]
)

#v(0.5em)

#answer-box[セ]，#answer-box[ソ]，#answer-box[タ] の解答群（同じものを繰り返し選んでもよい。）

#choice[0] $+$ #h(2em) #choice[1] $-$ #h(2em) #choice[2] $0$

#answer-box[チ]，#answer-box[テ]，#answer-box[ナ] の解答群（同じものを繰り返し選んでもよい。）

#choice[0] $arrow.t$ #h(2em) #choice[1] $arrow.b$

#v(1em)

(ii) 曲線 $y = f(x)$ と直線 $y = k$ が異なる3点で交わるような実数 $k$ の値の範囲は

$ -#answer-box[ニ] < k < #answer-box[ヌ] $

である。

#pagebreak()

#question(2, points: 15, required: true)

三角形 $upright(A) upright(B) upright(C)$ において、$upright(A) upright(B) = 5$，$upright(B) upright(C) = 7$，$angle upright(A) upright(B) upright(C) = 60 degree$ とする。辺 $upright(B) upright(C)$ の中点を $upright(M)$ とする。

(1) 余弦定理により、$upright(A) upright(C) = $ #answer-box[ア] $sqrt(#answer-box[イ])$ である。

また、$upright(A) upright(M) = display(frac(sqrt(#answer-box[ウエ]), #answer-box[オ]))$ である。

(2) 三角形 $upright(A) upright(B) upright(C)$ の面積は $display(frac(#answer-box[カキ], #answer-box[ク])) sqrt(#answer-box[ケ])$ である。

(3) 三角形 $upright(A) upright(B) upright(C)$ の外接円の半径 $R$ は

$ R = frac(#answer-box[コサ], #answer-box[シ]) sqrt(#answer-box[ス]) $

である。

(4) 太郎さんと花子さんは、点 $upright(M)$ を通り三角形 $upright(A) upright(B) upright(C)$ の面積を二等分する直線について話している。

#dialogue-box[
  太郎：点 $upright(M)$ は辺 $upright(B) upright(C)$ の中点だから、線分 $upright(A) upright(M)$ は三角形 $upright(A) upright(B) upright(C)$ の中線だね。

  花子：中線は三角形の面積を二等分するから、直線 $upright(A) upright(M)$ がその一つだね。

  太郎：他にもありそうだね。辺 $upright(A) upright(B)$ 上に点 $upright(P)$ をとって、直線 $upright(M) upright(P)$ が三角形 $upright(A) upright(B) upright(C)$ の面積を二等分する場合を考えてみよう。

  花子：そのとき、$upright(A) upright(P)$ の長さはどうなるかな。
]

点 $upright(M)$ を通り三角形 $upright(A) upright(B) upright(C)$ の面積を二等分する直線のうち、直線 $upright(A) upright(M)$ 以外のものと辺 $upright(A) upright(B)$ の交点を $upright(P)$ とすると

$ upright(A) upright(P) = frac(#answer-box[セ], #answer-box[ソ]) $

である。

#pagebreak()

#question(3, points: 20, required: true)

複素数平面上の3点 $upright(A)(alpha)$，$upright(B)(beta)$，$upright(C)(gamma)$ を頂点とする三角形 $upright(A) upright(B) upright(C)$ について考える。ただし、$alpha$，$beta$，$gamma$ は相異なる複素数とする。

(1) $alpha = 2 + i$，$beta = -1 + 2i$，$gamma = 1 - i$ のとき、三角形 $upright(A) upright(B) upright(C)$ はどのような三角形か。#answer-box[ア] が成り立つ。

#answer-box[ア] の解答群

#choice[0] 正三角形である

#choice[1] 直角二等辺三角形である

#choice[2] 直角三角形であるが二等辺三角形ではない

#choice[3] 二等辺三角形であるが直角三角形ではない

#choice[4] 正三角形でも、直角三角形でも、二等辺三角形でもない

(2) 三角形 $upright(A) upright(B) upright(C)$ が正三角形であるための条件について考える。

(i) 三角形 $upright(A) upright(B) upright(C)$ が正三角形であるとき、$abs(beta - alpha) = abs(gamma - alpha)$ が成り立ち、また、$gamma - alpha$ は $beta - alpha$ を原点を中心として #answer-box[イ] $degree$ 回転した複素数である。したがって

$ gamma = alpha + (beta - alpha) dot.op #answer-box[ウエ] $

が成り立つ。ただし、#answer-box[ウエ] には $cos #answer-box[イ] degree + i sin #answer-box[イ] degree$ を計算した結果を入れる。

(ii) 逆に、$gamma = alpha + (beta - alpha) dot.op #answer-box[ウエ]$ が成り立つとき、三角形 $upright(A) upright(B) upright(C)$ は正三角形である。

(3) $alpha = 1 + 2i$，$beta = 3 + 4i$ のとき、$gamma = alpha + (beta - alpha) dot.op #answer-box[ウエ]$ を満たす複素数 $gamma$ は

$ gamma = #answer-box[オ] + #answer-box[カ] i #h(1em) "または" #h(1em) gamma = #answer-box[キ] + #answer-box[ク] i $

である。ただし、#answer-box[オ]，#answer-box[キ] の解答群は次のとおりとする。

#answer-box[オ]，#answer-box[キ] の解答群（解答の順序は問わない。）

#choice[0] $2 - sqrt(3)$ #h(1.5em) #choice[1] $2 + sqrt(3)$ #h(1.5em) #choice[2] $4 - sqrt(3)$ #h(1.5em) #choice[3] $4 + sqrt(3)$

#pagebreak()
