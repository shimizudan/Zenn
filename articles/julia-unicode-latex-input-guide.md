---
title: "JuliaのLaTeX形式でのUnicode入力完全ガイド：π、θから演算子まで"
emoji: "🔣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [julia, unicode, latex, vscode, jupyter]
published: false
---

## はじめに

Juliaでは、数学記号をLaTeX形式で簡単に入力できます。例えば、`\pi<tab>`と入力すると`π`に、`\theta<tab>`と入力すると`θ`に変換されます。この機能は、Julia REPL、VSCodeのJupyter Notebook（.ipynb）、その他のエディタで利用できます。

本記事では、Juliaで使える**LaTeX形式のUnicode入力を網羅的に紹介**し、さらに**定数や演算子として予約されているもの**についても解説します。

## LaTeX形式の入力方法

### 基本的な使い方

1. バックスラッシュ `\` に続いてLaTeXコマンドを入力
2. Tabキーを押して変換
3. Unicode文字が入力される

**例：**
```julia
\pi<tab>      # π
\theta<tab>   # θ
\alpha<tab>   # α
\sum<tab>     # ∑
\int<tab>     # ∫
```

### VSCodeでの利用

VSCodeでJuliaの拡張機能をインストールすれば、Julia REPLと同様にLaTeX形式での入力が可能です。

:::message
初回起動時はLanguageServer.jlの起動に時間がかかることがあります。Tab補完が効かない場合は、少し待ってから試してください。
:::

### Jupyter Notebookでの利用

JuliaカーネルがインストールされたJupyter Notebookでも、同様にLaTeX形式での入力が可能です。

### 入力コードの調べ方

既存のUnicode文字の入力方法を調べたい場合は、Julia REPLで `?` を入力してヘルプモードに入り、その文字をペーストすると入力方法が表示されます。

```julia
julia> ?
help?> π
"π" can be typed by \pi<tab>
```

## ギリシャ文字

### 小文字のギリシャ文字

| LaTeXコマンド | 文字 | 名前 |
|--------------|------|------|
| `\alpha` | α | アルファ |
| `\beta` | β | ベータ |
| `\gamma` | γ | ガンマ |
| `\delta` | δ | デルタ |
| `\epsilon` | ε | イプシロン |
| `\zeta` | ζ | ゼータ |
| `\eta` | η | イータ |
| `\theta` | θ | シータ |
| `\iota` | ι | イオタ |
| `\kappa` | κ | カッパ |
| `\lambda` | λ | ラムダ |
| `\mu` | μ | ミュー |
| `\nu` | ν | ニュー |
| `\xi` | ξ | クサイ |
| `\pi` | π | パイ |
| `\rho` | ρ | ロー |
| `\sigma` | σ | シグマ |
| `\tau` | τ | タウ |
| `\upsilon` | υ | ウプシロン |
| `\phi` | φ | ファイ |
| `\chi` | χ | カイ |
| `\psi` | ψ | プサイ |
| `\omega` | ω | オメガ |

### 大文字のギリシャ文字

| LaTeXコマンド | 文字 | 名前 |
|--------------|------|------|
| `\Alpha` | Α | アルファ |
| `\Beta` | Β | ベータ |
| `\Gamma` | Γ | ガンマ |
| `\Delta` | Δ | デルタ |
| `\Epsilon` | Ε | イプシロン |
| `\Theta` | Θ | シータ |
| `\Lambda` | Λ | ラムダ |
| `\Pi` | Π | パイ |
| `\Sigma` | Σ | シグマ |
| `\Upsilon` | Υ | ウプシロン |
| `\Phi` | Φ | ファイ |
| `\Psi` | Ψ | プサイ |
| `\Omega` | Ω | オメガ |

## 数学演算子と記号

### 基本的な演算子

| LaTeXコマンド | 文字 | 意味 |
|--------------|------|------|
| `\pm` | ± | プラスマイナス |
| `\times` | × | 乗算 |
| `\div` | ÷ | 除算（整数除算） |
| `\cdot` | ⋅ | ドット積 |
| `\ast` | ∗ | アスタリスク |

**Juliaでの演算子利用例：**
```julia
julia> 5 ÷ 2  # 整数除算（\div<tab>で入力）
2

julia> [1, 2, 3] ⋅ [4, 5, 6]  # ドット積は定義によっては使用可能
```

### 比較・関係演算子

| LaTeXコマンド | 文字 | 意味 |
|--------------|------|------|
| `\ne` | ≠ | 等しくない |
| `\le` | ≤ | 以下 |
| `\ge` | ≥ | 以上 |
| `\approx` | ≈ | 近似 |
| `\sim` | ∼ | 同等 |
| `\equiv` | ≡ | 合同 |
| `\propto` | ∝ | 比例 |
| `\ll` | ≪ | 非常に小さい |
| `\gg` | ≫ | 非常に大きい |

**使用例：**
```julia
julia> 5 ≠ 3  # \ne<tab>
true

julia> 5 ≤ 10  # \le<tab>
true

julia> 5 ≥ 3  # \ge<tab>
true
```

### 集合論の記号

| LaTeXコマンド | 文字 | 意味 |
|--------------|------|------|
| `\in` | ∈ | 属する |
| `\notin` | ∉ | 属さない |
| `\ni` | ∋ | 含む |
| `\subset` | ⊂ | 真部分集合 |
| `\supset` | ⊃ | 真部分集合（逆） |
| `\subseteq` | ⊆ | 部分集合 |
| `\supseteq` | ⊇ | 部分集合（逆） |
| `\cup` | ∪ | 和集合 |
| `\cap` | ∩ | 積集合 |
| `\emptyset` | ∅ | 空集合 |

**使用例：**
```julia
julia> 3 ∈ [1, 2, 3, 4]  # \in<tab>
true
```

### 論理演算子

| LaTeXコマンド | 文字 | 意味 | Juliaの関数 |
|--------------|------|------|-------------|
| `\neg` | ¬ | 否定 | `!` |
| `\wedge` | ∧ | 論理積（AND） | `&` |
| `\vee` | ∨ | 論理和（OR） | `|` |
| `\oplus` | ⊕ | XOR | `xor` |
| `\barwedge` | ⊼ | NAND | - |
| `\veebar` | ⊻ | XOR（ビット演算） | `⊻` |

**使用例：**
```julia
julia> true ∧ false  # カスタム演算子として定義可能
# 標準では & を使用
julia> true & false
false

julia> 2 ⊻ 11  # \veebar<tab> でXOR（Julia標準）
9

julia> xor(2, 11)  # 同じ結果
9
```

### 微積分の記号

| LaTeXコマンド | 文字 | 意味 |
|--------------|------|------|
| `\partial` | ∂ | 偏微分 |
| `\nabla` | ∇ | ナブラ |
| `\int` | ∫ | 積分 |
| `\iint` | ∬ | 二重積分 |
| `\oint` | ∮ | 周回積分 |
| `\sum` | ∑ | 総和 |
| `\prod` | ∏ | 総乗 |
| `\infty` | ∞ | 無限大 |
| `\surd` | √ | 平方根 |

### ルート記号

| LaTeXコマンド | 文字 | 意味 |
|--------------|------|------|
| `\sqrt` | √ | 平方根 |
| `\cbrt` | ∛ | 三乗根 |
| `\fourthroot` | ∜ | 四乗根 |

**使用例：**
```julia
julia> √4  # \sqrt<tab>
2.0

julia> ∛8  # \cbrt<tab>
2.0

julia> ∜16  # \fourthroot<tab>
2.0
```

## 矢印記号

| LaTeXコマンド | 文字 | 意味 |
|--------------|------|------|
| `\leftarrow` | ← | 左矢印 |
| `\rightarrow` | → | 右矢印 |
| `\leftrightarrow` | ↔ | 両矢印 |
| `\Leftarrow` | ⇐ | 左二重矢印 |
| `\Rightarrow` | ⇒ | 右二重矢印 |
| `\Leftrightarrow` | ⇔ | 両二重矢印 |
| `\mapsto` | ↦ | 写像 |
| `\uparrow` | ↑ | 上矢印 |
| `\downarrow` | ↓ | 下矢印 |

## デリミタ（括弧類）

| LaTeXコマンド | 文字 | 意味 |
|--------------|------|------|
| `\langle` | ⟨ | 左山括弧 |
| `\rangle` | ⟩ | 右山括弧 |
| `\lceil` | ⌈ | 左天井 |
| `\rceil` | ⌉ | 右天井 |
| `\lfloor` | ⌊ | 左床 |
| `\rfloor` | ⌋ | 右床 |

## 上付き文字と下付き文字

### 上付き文字（Superscripts）

| LaTeXコマンド | 文字 |
|--------------|------|
| `\^0` | ⁰ |
| `\^1` | ¹ |
| `\^2` | ² |
| `\^3` | ³ |
| `\^4` | ⁴ |
| `\^5` | ⁵ |
| `\^6` | ⁶ |
| `\^7` | ⁷ |
| `\^8` | ⁸ |
| `\^9` | ⁹ |

### 下付き文字（Subscripts）

| LaTeXコマンド | 文字 |
|--------------|------|
| `\_0` | ₀ |
| `\_1` | ₁ |
| `\_2` | ₂ |
| `\_3` | ₃ |
| `\_4` | ₄ |
| `\_5` | ₅ |
| `\_6` | ₆ |
| `\_7` | ₇ |
| `\_8` | ₈ |
| `\_9` | ₉ |

**使用例：**
```julia
julia> x₁ = 10  # \_1<tab>
10

julia> x₂ = 20  # \_2<tab>
20

julia> x₁ + x₂
30
```

## Juliaで定義済みの定数

以下の記号は、Juliaで**定数として予約**されています。

| 記号 | LaTeXコマンド | 値 | 説明 |
|------|--------------|-----|------|
| π | `\pi` | 3.14159... | 円周率 |
| ℯ | `\euler` | 2.71828... | 自然対数の底（e） |
| γ | `\gamma` | 0.57721... | オイラー定数 |
| φ | `\varphi` | 1.61803... | 黄金比 |
| catalan | - | 0.91596... | カタラン定数 |

:::message alert
**注意：** これらの定数は再代入できません。
:::

**確認例：**
```julia
julia> π
π = 3.1415926535897...

julia> ℯ  # \euler<tab>
ℯ = 2.7182818284590...

julia> π = 3.14  # エラー！
ERROR: cannot assign a value to variable MathConstants.π from module Main
```

### 無限大とNaN

| 記号 | 意味 |
|------|------|
| `Inf` | 正の無限大 |
| `-Inf` | 負の無限大 |
| `NaN` | Not-a-Number（非数） |

```julia
julia> 1/0
Inf

julia> -1/0
-Inf

julia> 0/0
NaN

julia> NaN == NaN  # NaNは自分自身とも等しくない
false
```

## Unicode演算子の定義

Juliaでは、Unicode記号を使って**カスタム演算子を定義**できます。

### ユーザー定義演算子の例

```julia
# クロネッカー積を ⊗ で定義
⊗(A, B) = kron(A, B)

julia> [1 2; 3 4] ⊗ [5 6; 7 8]
4×4 Matrix{Int64}:
  5   6  10  12
  7   8  14  16
 15  18  20  24
 21  24  28  32
```

### ドット演算子の自動適用

Juliaでは、ユーザー定義のUnicode演算子にもドット演算子（ブロードキャスト）が自動的に適用されます。

```julia
julia> f ⊗ g = (x) -> f(x) * g(x)  # 関数の合成例

julia> [1, 2, 3] .⊗ [4, 5, 6]  # ドット演算子で要素ごとの演算
```

## 特殊な文字の正規化

Juliaでは、一部のUnicode文字が自動的に**正規化**されます。

| 入力文字 | Unicode | 正規化後 |
|---------|---------|---------|
| ɛ (Latin small letter open e) | U+025B | ε (Greek epsilon) |
| µ (Micro sign) | U+00B5 | μ (Greek mu) |
| · (Middle dot) | U+00B7 | ⋅ (Dot operator) |
| − (Minus sign) | U+2212 | - (Hyphen-minus) |

```julia
julia> ɛ = 0.001  # Latin small letter open e
0.001

julia> ε  # Greek epsilon（同じ変数）
0.001
```

## Unicode文字の完全なリスト

Juliaで利用可能なすべてのLaTeX→Unicode変換の完全なリストは、以下で確認できます：

1. **公式ドキュメント：** [Julia Unicode Input](https://docs.julialang.org/en/v1/manual/unicode-input/)
2. **ソースコード：** [latex_symbols.jl](https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/src/latex_symbols.jl)

また、Julia REPLで以下のコマンドを実行すると、すべてのLaTeX記号を取得できます：

```julia
julia> Base.REPLCompletions.latex_symbols
Dict{String, String} with 1000+ entries:
  "\\pi"    => "π"
  "\\theta" => "θ"
  ...
```

## 実用例：数式をそのままコードに

Juliaの強力なUnicode対応により、数学の教科書に書かれている数式をそのままコードにできます。

### 例1：二次方程式の解の公式

```julia
function solve_quadratic(a, b, c)
    Δ = b^2 - 4*a*c  # 判別式（\Delta<tab>）
    if Δ < 0
        return nothing  # 実数解なし
    end
    x₁ = (-b + √Δ) / (2a)  # \sqrt<tab>, \_1<tab>
    x₂ = (-b - √Δ) / (2a)  # \_2<tab>
    return (x₁, x₂)
end

julia> solve_quadratic(1, -3, 2)
(2.0, 1.0)
```

### 例2：正規分布の確率密度関数

```julia
function normal_pdf(x, μ, σ)  # \mu<tab>, \sigma<tab>
    return 1/(σ*√(2π)) * exp(-(x-μ)^2 / (2σ^2))  # \pi<tab>
end

julia> normal_pdf(0, 0, 1)  # 標準正規分布のx=0での値
0.3989422804014327
```

### 例3：内積の定義

```julia
# ドット積演算子の定義
⋅(u, v) = sum(u .* v)  # \cdot<tab>

julia> [1, 2, 3] ⋅ [4, 5, 6]
32
```

### 例4：論理演算

```julia
# 論理積（AND）
∧(a, b) = a && b  # \wedge<tab>

# 論理和（OR）
∨(a, b) = a || b  # \vee<tab>

julia> true ∧ false
false

julia> true ∨ false
true
```

### 例5：Handcalcs.jlで美しい計算書を作成

Handcalcs.jlを使えば、Unicode記号を含む計算式を自動的にLaTeX形式の計算書として出力できます。

```julia
using Handcalcs

# 梁のたわみ計算
@handcalcs begin
    L = 5000  # 梁の長さ [mm]
    E = 205000  # ヤング率 [N/mm²]（\cdot<tab>で⋅が入力可能）
    I = 1.2e7  # 断面二次モーメント [mm⁴]
    w = 10  # 等分布荷重 [N/mm]

    # 最大たわみ（\delta<tab>）
    δ_max = (5 * w * L^4) / (384 * E * I)
end
```

上記のコードは、以下のような美しい計算書を出力します：

$$
\begin{aligned}
L &= 5000 \text{ [mm]}\\
E &= 205000 \text{ [N/mm²]}\\
I &= 1.2 \times 10^{7} \text{ [mm⁴]}\\
w &= 10 \text{ [N/mm]}\\
\delta_{\text{max}} &= \frac{5 \cdot w \cdot L^{4}}{384 \cdot E \cdot I} = \frac{5 \cdot 10 \cdot 5000^{4}}{384 \cdot 205000 \cdot 1.2 \times 10^{7}} = 6.65 \text{ [mm]}
\end{aligned}
$$

ギリシャ文字を使った例：

```julia
using Handcalcs

# 正規分布の確率密度関数
@handcalcs begin
    μ = 0  # 平均（\mu<tab>）
    σ = 1  # 標準偏差（\sigma<tab>）
    x = 1.5

    # 確率密度
    f_x = 1/(σ*√(2π)) * exp(-(x-μ)^2 / (2σ^2))
end
```

これにより、数式をコードで書きながら、自動的に読みやすい計算書が生成されます。

:::message
Handcalcs.jlのインストール：
```julia
using Pkg
Pkg.add("Handcalcs")
```
:::

## Tips: フォントの対応状況

記事や環境によっては、一部のUnicode文字が正しく表示されない場合があります。

:::message
**ブラウザやエディタのフォント設定を確認してください。**
- VS Codeでは、`Fira Code`、`JetBrains Mono`、`Cascadia Code`などのプログラミング用フォントがUnicode数学記号に対応しています。
- Julia REPLでは、ターミナルのフォント設定を確認してください。
:::

## まとめ

Juliaの強力なUnicode対応により、以下のことが可能です：

1. **数学記号をそのまま変数名や演算子として使用**できる
2. **LaTeX形式でTab補完**により、簡単に入力できる
3. **定数（π、ℯなど）が予約**されており、そのまま利用可能
4. **カスタム演算子を定義**して、数式をより読みやすく記述できる

数学的なコードを書く際に、Juliaのこの機能を活用することで、可読性が大幅に向上します。

## 参考資料

- [Unicode Input - Julia Documentation](https://docs.julialang.org/en/v1/manual/unicode-input/)
- [Mathematical Operations - Julia Documentation](https://docs.julialang.org/en/v1/manual/mathematical-operations/)
- [Variables - Julia Documentation](https://docs.julialang.org/en/v1/manual/variables/)
- [julia/stdlib/REPL/src/latex_symbols.jl](https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/src/latex_symbols.jl)
- [List/Display all math constants and operators defined as Unicode symbols in Julia Base](https://gist.github.com/liuyxpp/784d9935d5e3eeeb2212eeee4535dbbb)
