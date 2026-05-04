---
title: "RaTeX（Pure Rust × WASM）で数式をWebに表示する"
emoji: "🧮"
type: "tech"
topics: [javascript, html, wasm, rust, 数学]
published: true
math: true
---

## RaTeX とは

[RaTeX](https://github.com/erweixin/RaTeX) は **Pure Rust で書かれた KaTeX 互換の数式レンダラー**です。WebAssembly（WASM）にコンパイルされ、ブラウザ上で LaTeX 数式を canvas に描画する Web Component として使えます。

- KaTeX の LaTeX 構文をほぼそのまま使える
- `\ce{}` による化学式、`\pu{}` による単位表記にも対応
- npm CDN から1行で読み込むだけで利用可能

デモサイトを公開しています：

**https://shimizudan.github.io/20260504ratex/**

---

## 基本的な使い方

```html
<!-- フォント CSS -->
<link rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/ratex-wasm@0.1.4/fonts.css">

<!-- Web Component -->
<script type="module"
  src="https://cdn.jsdelivr.net/npm/ratex-wasm@0.1.4/dist/ratex-formula.js">
</script>
```

あとは `<ratex-formula>` タグに `latex` 属性で数式を渡すだけです：

```html
<ratex-formula latex="e^{i\pi} + 1 = 0" font-size="36"></ratex-formula>
```

---

## フォント読み込み問題と解決策

`<ratex-formula>` を静的 HTML に直接書くと、フォントのダウンロード完了前に canvas 描画が走って**文字化け**することがあります。

`document.fonts.load()` で全フォントの読み込み完了を待ってから動的生成することで正常に表示できます。

```html
<!-- HTML 側：data 属性で数式を保持 -->
<span class="rf" data-latex="x = \dfrac{-b \pm \sqrt{b^2-4ac}}{2a}"
      data-fs="28" data-pad="8"></span>
```

```js
async function initFormulas() {
  // 全 KaTeX フォントバリアントの読み込みを待つ
  await Promise.all([
    document.fonts.load('20px KaTeX_Main'),
    document.fonts.load('italic 20px KaTeX_Math'),
    document.fonts.load('bold 20px KaTeX_Main'),
    // ... 必要なバリアントを列挙
  ].map(p => p.catch(() => {})));

  // フォント準備完了後に <ratex-formula> を動的生成
  document.querySelectorAll('span.rf').forEach(span => {
    const el = document.createElement('ratex-formula');
    el.setAttribute('latex',     span.dataset.latex);
    el.setAttribute('font-size', span.dataset.fs  || '28');
    el.setAttribute('padding',   span.dataset.pad || '8');
    if (span.dataset.color) el.setAttribute('color', span.dataset.color);
    span.replaceWith(el);
  });
}

initFormulas();
```

---

## デモサイトに収録した数式（37 式）

### 代数 / Algebra

| 数式 | 説明 |
|------|------|
| $x = \dfrac{-b \pm \sqrt{b^2 - 4ac}}{2a}$ | 解の公式。判別式 $D = b^2 - 4ac$ の符号で解の個数が決まる |
| $(x+y)^n = \displaystyle\sum_{k=0}^{n} \binom{n}{k} x^k y^{n-k}$ | 二項定理。パスカルの三角形と深く結びつく |
| $\displaystyle\sum_{k=0}^{n-1} ar^k = a\,\dfrac{1-r^n}{1-r}$ | 等比数列の和（$r \neq 1$） |
| $\log_a(xy) = \log_a x + \log_a y$ | 対数の積の法則 |
| $\displaystyle\sum_{n=1}^{\infty} \frac{1}{n^2} = \frac{\pi^2}{6}$ | バーゼル問題。オイラーが1735年に証明 |

### 解析・微積分 / Calculus

| 数式 | 説明 |
|------|------|
| $f'(x) = \displaystyle\lim_{h \to 0} \dfrac{f(x+h) - f(x)}{h}$ | 導関数の定義 |
| $\displaystyle\int_a^b f(x)\,dx = F(b) - F(a)$ | 微積分学の基本定理 |
| $f(x) = \displaystyle\sum_{n=0}^{\infty} \dfrac{f^{(n)}(a)}{n!}(x-a)^n$ | テイラー展開 |
| $\displaystyle\int_{-\infty}^{\infty} e^{-x^2}\,dx = \sqrt{\pi}$ | ガウス積分。正規分布の規格化に使われる |
| $e^{i\theta} = \cos\theta + i\sin\theta$ | オイラーの公式。$\theta = \pi$ でオイラーの等式 |
| $f(a) = \dfrac{1}{2\pi i}\displaystyle\oint_\gamma \dfrac{f(z)}{z-a}\,dz$ | コーシーの積分公式 |
| $\hat{f}(\xi) = \displaystyle\int_{-\infty}^{\infty} f(x)\,e^{-2\pi i x\xi}\,dx$ | フーリエ変換 |
| $\displaystyle\oint_{\partial\Sigma}\mathbf{F}\cdot d\mathbf{r} = \iint_{\Sigma}(\nabla\times\mathbf{F})\cdot d\mathbf{S}$ | ストークスの定理 |

### 線形代数 / Linear Algebra

| 数式 | 説明 |
|------|------|
| $\det(A) = \displaystyle\sum_{\sigma\in S_n}\mathrm{sgn}(\sigma)\prod_{i=1}^n a_{i,\sigma(i)}$ | 行列式の定義 |
| $A\mathbf{v} = \lambda\mathbf{v} \iff \det(A - \lambda I) = 0$ | 固有値方程式 |
| $\lvert\langle \mathbf{u},\mathbf{v}\rangle\rvert^2 \leq \langle\mathbf{u},\mathbf{u}\rangle\,\langle\mathbf{v},\mathbf{v}\rangle$ | コーシー＝シュワルツ不等式 |

### 確率・統計 / Probability & Statistics

| 数式 | 説明 |
|------|------|
| $f(x) = \dfrac{1}{\sigma\sqrt{2\pi}}\exp\!\left(-\dfrac{(x-\mu)^2}{2\sigma^2}\right)$ | 正規分布の確率密度関数 |
| $P(A\mid B) = \dfrac{P(B\mid A)\,P(A)}{P(B)}$ | ベイズの定理 |
| $P(X=k) = \dbinom{n}{k}p^k(1-p)^{n-k}$ | 二項分布 |
| $\dfrac{\bar{X}_n - \mu}{\sigma/\sqrt{n}} \xrightarrow{d} N(0,1)$ | 中心極限定理 |
| $H(X) = -\displaystyle\sum_{i} p_i \log_2 p_i$ | シャノンエントロピー |

### 物理 / Physics

| 数式 | 説明 |
|------|------|
| $\mathbf{F} = m\mathbf{a} = m\dfrac{d^2\mathbf{r}}{dt^2}$ | ニュートンの第2法則 |
| $i\hbar\dfrac{\partial}{\partial t}\Psi = \hat{H}\Psi$ | シュレーディンガー方程式 |
| $E = mc^2$ | 質量とエネルギーの等価性 |
| $\nabla\times\mathbf{E} = -\dfrac{\partial\mathbf{B}}{\partial t}$ | マクスウェル方程式（ファラデーの法則） |
| $G_{\mu\nu} + \Lambda g_{\mu\nu} = \dfrac{8\pi G}{c^4}T_{\mu\nu}$ | アインシュタイン方程式 |
| $\Delta x\,\Delta p \geq \dfrac{\hbar}{2}$ | ハイゼンベルクの不確定性原理 |

### 化学 / Chemistry

`\ce{}` コマンドで化学反応式、`\pu{}` で単位付き数値を表記できます。

| 数式 | 説明 |
|------|------|
| $\ce{H2SO4 + 2NaOH -> Na2SO4 + 2H2O}$ | 硫酸と水酸化ナトリウムの中和反応 |
| $\ce{Fe^{2+} + 2e- -> Fe}$ | 鉄イオンの還元反応 |
| $\Delta G = \Delta H - T\Delta S$ | ギブズ自由エネルギー |
| $k = A\,e^{-E_a/(RT)}$ | アレニウスの式 |
| $\pu{1.5e-3 mol//L}$ | `\pu{}` による IUPAC 準拠の単位表記 |

---

## PDF 出力①：数式のみ

RaTeX の `ratex-pdf` クレートを使うと数式を PDF に書き出せます。

```bash
# RaTeX をクローンしてビルド
git clone https://github.com/erweixin/RaTeX.git
cd RaTeX && cargo build --release -p ratex-pdf --features cli

# 数式リスト (formulas.txt) から個別 PDF を生成
cat formulas.txt | ./target/release/render-pdf \
    --output-dir pdf_parts --font-size 48

# pypdf で 1 ファイルにまとめる
pip install pypdf
python3 make_pdf.py
```

`formulas.txt` に LaTeX 数式を1行1式で並べるだけです。

---

## PDF 出力②：文章＋数式ドキュメント

`document.txt` に見出し・本文・数式を書いて PDF に変換できます。

### document.txt の書式

| 記法 | 意味 |
|------|------|
| `# タイトル` | H1 見出し（青下線付き） |
| `## セクション` | H2 見出し |
| `### 小見出し` | H3 見出し |
| `$$数式$$` | 数式（中央揃え・RaTeX でレンダリング） |
| 通常テキスト | 本文（日本語対応・Noto Sans JP） |

### 生成の流れ

```
document.txt
  ├─ # / ## / ###  → fpdf2 で見出し描画
  ├─ テキスト行    → Noto Sans JP で日本語本文
  └─ $$数式$$      → ratex-render で PNG 生成 → PDF に埋め込み
```

```bash
# Python 依存ライブラリ
pip install fpdf2 Pillow

# PDF を生成
python3 make_doc_pdf.py               # document.txt → document.pdf
python3 make_doc_pdf.py myfile.txt    # 任意のファイルを指定
```

日本語フォント（Noto Sans JP）のセットアップが別途必要です（詳細は [README](https://github.com/shimizudan/20260504ratex#pdf-出力文章数式ドキュメント) を参照）。

---

## まとめ

| 項目 | 内容 |
|------|------|
| レンダラー | Pure Rust × WASM（KaTeX 互換） |
| 導入方法 | npm CDN から2行（CSS + JS）で利用可能 |
| 対応記法 | LaTeX 数式・`\ce{}`（化学式）・`\pu{}`（単位） |
| 注意点 | フォント読み込み前の描画を避けるため動的生成が推奨 |
| PDF 出力 | Rust CLI または Python（fpdf2）経由で生成可能 |

KaTeX や MathJax と比べて**フォント待ちの文字化けが起きやすい**という罠はありますが、一度ハマりどころを押さえてしまえば静的 HTML に数式を埋め込む手軽な選択肢になります。

ソースコードとデモは GitHub で公開しています。

https://github.com/shimizudan/20260504ratex
