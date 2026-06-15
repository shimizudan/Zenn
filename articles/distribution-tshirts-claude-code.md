---
title: "Claude Codeで確率分布Tシャツを19種類つくって販売してみた"
emoji: "👕"
type: "idea"
topics: [claudecode, julia, typst, 数学, 統計]
published: true
math: true
---

:::message
本記事は、2026年6月14日（日）に開催された **[日曜数学会 #36](https://twitter.com/hashtag/%E6%97%A5%E6%9B%9C%E6%95%B0%E5%AD%A6%E4%BC%9A)** での発表内容をもとにしています。
:::

## きっかけ

正規分布のTシャツ、ネットを探すといろいろ出回っています。でも、よく見ると**数式が間違っているものが多い**のです。数学教師として、正しい数式でちゃんとしたものを作りたいと思っていました。

そこから「正規分布だけでなく、他の分布でもTシャツを作れるのでは？」と発想が広がり、**Claude Codeを使って19種類の確率分布Tシャツを量産する**ことにしました。

---

## デザイン作成のワークフロー

Claude Codeを中心に、次の5ステップでデザインを量産しました。

**Step 1 — Claude Code に分布名を与える**

VS Code上でClaude Codeに分布名を指示するだけです。あとはほぼ自動で進みます。

**Step 2 — Julia でグラフを生成**

Claude Codeが生成したJuliaスクリプトで、分布のグラフを描画してPNGとして出力します。

**Step 3 — Typst でデザインに仕上げる**

数式・グラフ・パラメータ説明・名言（引用文）を[Typst](https://typst.app/)で組版します。数式の組版品質が高く、LaTeX的な表現力をより軽快に扱えます。

**Step 4 — VS Code でプレビュー確認・微調整**

その場でプレビューしながら色・レイアウトを調整します。

**Step 5 — suzuri.jp にアップロード → 完成**

デザイン画像をアップするだけでTシャツとして販売できます。在庫不要・印刷発送はsuzuriが代行してくれるので、実質ゼロコストで開店できます。

---

## 19種類の確率分布

完成したTシャツのラインナップです。各分布に**正しい確率密度関数（PDF）または確率質量関数（PMF）**を掲載しています。

### 01 正規分布（Normal Distribution）

$$f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$$

身長や測定誤差など、世界中の「ばらつき」に現れる分布の王様。

![正規分布 Tシャツ](/images/distribution-tshirts-claude-code/01_normal_distribution.png)

### 02 二項分布（Binomial Distribution）

$$P(X = k) = \binom{n}{k} p^k (1-p)^{n-k}$$

コインをn回投げて表が出る回数。確率の出発点。

![二項分布 Tシャツ](/images/distribution-tshirts-claude-code/02_binomial_distribution.png)

### 03 ポアソン分布（Poisson Distribution）

$$P(X = k) = \frac{\lambda^k e^{-\lambda}}{k!}$$

1時間に届くメールの数。「まれな出来事」の回数を数える。

![ポアソン分布 Tシャツ](/images/distribution-tshirts-claude-code/03_poisson_distribution.png)

### 04 一様分布（Uniform Distribution）

$$f(x) = \begin{cases} \dfrac{1}{b-a} & \text{if } a \le x \le b \\ 0 & \text{otherwise} \end{cases}$$

サイコロもルーレットも、どこも同じ確からしさ。

![一様分布 Tシャツ](/images/distribution-tshirts-claude-code/04_uniform_distribution.png)

### 05 指数分布（Exponential Distribution）

$$f(x) = \lambda e^{-\lambda x} \quad (x \ge 0)$$

次のバスが来るまでの待ち時間。「記憶を持たない」分布。無記憶性 $P(X > s+t \mid X > s) = P(X > t)$ が特徴的です。

![指数分布 Tシャツ](/images/distribution-tshirts-claude-code/05_exponential_distribution.png)

### 06 ガンマ分布（Gamma Distribution）

$$f(x) = \frac{x^{\alpha-1} e^{-x/\theta}}{\theta^\alpha \Gamma(\alpha)} \quad (x > 0)$$

待ち時間をk回分まとめると現れる分布。ガンマ関数 $\Gamma(\alpha) = \int_0^\infty t^{\alpha-1} e^{-t} dt$ を含みます。

![ガンマ分布 Tシャツ](/images/distribution-tshirts-claude-code/06_gamma_distribution.png)

### 07 ベータ分布（Beta Distribution）

$$f(x) = \frac{x^{\alpha-1}(1-x)^{\beta-1}}{B(\alpha, \beta)} \quad (0 < x < 1)$$

「確率そのもの」の分布。ベイズ統計で大活躍。

![ベータ分布 Tシャツ](/images/distribution-tshirts-claude-code/07_beta_distribution.png)

### 08 カイ二乗分布（Chi-Squared Distribution）

$$f(x) = \frac{x^{k/2-1} e^{-x/2}}{2^{k/2} \Gamma(k/2)} \quad (x > 0)$$

標準正規分布の2乗和。検定でおなじみの主役。

![カイ二乗分布 Tシャツ](/images/distribution-tshirts-claude-code/08_chi_squared_distribution.png)

### 09 t分布（Student's t-Distribution）

$$f(t) = \frac{\Gamma\!\left(\frac{\nu+1}{2}\right)}{\sqrt{\nu\pi}\,\Gamma\!\left(\frac{\nu}{2}\right)} \left(1 + \frac{t^2}{\nu}\right)^{-\frac{\nu+1}{2}}$$

ギネスビールの技師（W.S. Gosset）が生んだ、小標本の強い味方。

![t分布 Tシャツ](/images/distribution-tshirts-claude-code/09_t_distribution.png)

### 10 F分布（F Distribution）

$$f(x) = \frac{\sqrt{\dfrac{(d_1 x)^{d_1} d_2^{d_2}}{(d_1 x + d_2)^{d_1+d_2}}}}{x\, B\!\left(\dfrac{d_1}{2}, \dfrac{d_2}{2}\right)}$$

分散の比を測る。分散分析（ANOVA）の主役。

![F分布 Tシャツ](/images/distribution-tshirts-claude-code/10_f_distribution.png)

### 11 対数正規分布（Log-Normal Distribution）

$$f(x) = \frac{1}{x\sigma\sqrt{2\pi}} e^{-\frac{(\ln x - \mu)^2}{2\sigma^2}} \quad (x > 0)$$

所得や細菌の増殖など、「掛け算で効く」ばらつき。

![対数正規分布 Tシャツ](/images/distribution-tshirts-claude-code/11_lognormal_distribution.png)

### 12 ロジスティック分布（Logistic Distribution）

$$f(x) = \frac{e^{-(x-\mu)/s}}{s\left(1 + e^{-(x-\mu)/s}\right)^2}$$

機械学習のシグモイド関数の裏にいる分布。CDFがそのままシグモイド関数 $F(x) = \dfrac{1}{1+e^{-(x-\mu)/s}}$ になります。

![ロジスティック分布 Tシャツ](/images/distribution-tshirts-claude-code/12_logistic_distribution.png)

### 13 コーシー分布（Cauchy Distribution）

$$f(x) = \frac{1}{\pi\gamma\left[1 + \left(\dfrac{x-x_0}{\gamma}\right)^2\right]}$$

平均も分散も存在しない、確率論の異端児。裾が極めて重い（Heavy tails）ため、期待値・分散ともにundefinedです。

![コーシー分布 Tシャツ](/images/distribution-tshirts-claude-code/13_cauchy_distribution.png)

### 14 レイリー分布（Rayleigh Distribution）

$$f(x) = \frac{x}{\sigma^2} \exp\!\left(-\frac{x^2}{2\sigma^2}\right) \quad (x \ge 0)$$

風速や波の高さのモデル。2次元のゆらぎの大きさ。

![レイリー分布 Tシャツ](/images/distribution-tshirts-claude-code/14_rayleigh_distribution.png)

### 15 三角分布（Triangular Distribution）

$$f(x) = \begin{cases} \dfrac{2(x-a)}{(b-a)(c-a)} & a \le x \le c \\[6pt] \dfrac{2(b-x)}{(b-a)(b-c)} & c < x \le b \end{cases}$$

最小・最頻・最大の3点だけで決まるシンプルさ。PERT推定でよく使われます。

![三角分布 Tシャツ](/images/distribution-tshirts-claude-code/15_triangular_distribution.png)

### 16 ワイブル分布（Weibull Distribution）

$$f(x) = \frac{k}{\lambda}\left(\frac{x}{\lambda}\right)^{k-1} \exp\!\left(-\left(\frac{x}{\lambda}\right)^k\right) \quad (x \ge 0)$$

製品の寿命や故障時間を表す、信頼性工学の定番。$k=1$ で指数分布、$k=2$ でレイリー分布になります。

![ワイブル分布 Tシャツ](/images/distribution-tshirts-claude-code/16_weibull_distribution.png)

### 17 切断正規分布（Truncated Normal Distribution）

$$f(x) = \frac{1}{\sigma} \cdot \frac{\varphi\!\left(\dfrac{x-\mu}{\sigma}\right)}{\Phi\!\left(\dfrac{b-\mu}{\sigma}\right) - \Phi\!\left(\dfrac{a-\mu}{\sigma}\right)}$$

範囲を区切った正規分布。打ち切りデータのモデル。$\varphi$ は標準正規PDF、$\Phi$ は標準正規CDFです。

![切断正規分布 Tシャツ](/images/distribution-tshirts-claude-code/17_truncated_normal_distribution.png)

### 18 スタナイン分布（Stanine Distribution）

$$\text{Stanine} = \text{round}(2z + 5) \quad (z = \text{standard score})$$

成績を9段階に分ける教育測定の分布。**Standard Nine** の略で、$E[X]=5$、$\text{SD} \approx 2$ です。

| Stanine | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|:-------:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| %       | 4 | 7 | 12 | 17 | 20 | 17 | 12 | 7 | 4 |

![スタナイン分布 Tシャツ](/images/distribution-tshirts-claude-code/18_stanine_distribution.png)

### 19 ガンベル分布（Gumbel Distribution）

$$f(x) = \frac{1}{\beta}\exp\!\bigl(-(z + e^{-z})\bigr), \quad z = \frac{x-\mu}{\beta}$$

最大値が従う分布。洪水・猛暑などの**極値統計**で活躍。オイラー–マスケローニ定数 $\gamma_E \approx 0.5772$ が期待値に現れます（$E[X] = \mu + \beta\gamma_E$）。

![ガンベル分布 Tシャツ](/images/distribution-tshirts-claude-code/19_gumbel_distribution.png)

---

## suzuri.jp で販売開始

デザインが完成したら、[suzuri.jp](https://suzuri.jp) に画像をアップするだけです。

- **在庫不要** — 印刷・発送はすべてsuzuriが代行
- **無料で開店** — 初期費用ゼロ
- **グッズ展開** — Tシャツだけでなくトートバッグやマグカップにも対応

「こっそり」開店してみたところ、19種類の確率分布Tシャツが購入できる状態になりました。

---

## まとめ

- 数式が間違った既製品への「不満」から始まったプロジェクトでした
- Claude Code × Julia × Typst の組み合わせで、**指示するだけで19種類を効率よく量産**できました
- 正規分布からガンベル分布まで、教科書に登場する主要な確率分布をすべてカバーできました

数学・統計が、Tシャツを通して少しでも身近になれば嬉しいです。
