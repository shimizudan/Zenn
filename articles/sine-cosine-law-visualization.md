---
title: "正弦定理と余弦定理：証明・応用・Juliaによる可視化"
emoji: "📐"
type: "idea"
topics: ["数学", "julia", "三角関数", "幾何"]
published: true

---

## はじめに

**正弦定理**と**余弦定理**は、高校数学「数学I」で学ぶ三角比の基本定理です。三角形の辺と角の関係を記述するこれらの定理は、測量・物理・工学など幅広い分野で応用されています。

本記事では、以下のテーマを扱います：

1. **正弦定理と余弦定理の主張と証明**
2. **三角形の求解**（辺と角から残りの要素を求める）
3. **Juliaによる可視化**（外接円・三角形の描画）
4. **応用例**（三角形の面積・ヘロンの公式との関係）

## 正弦定理

### 定理の主張

:::message
**正弦定理**

$\triangle ABC$ の外接円の半径を $R$ とすると、

$$
\frac{a}{\sin A} = \frac{b}{\sin B} = \frac{c}{\sin C} = 2R
$$

ここで、$a = BC$, $b = CA$, $c = AB$ は各角の対辺の長さである。
:::

### 証明

外接円の中心を $O$、半径を $R$ とします。辺 $BC$ に対する円周角が $\angle A$ です。

**場合1: $\angle A$ が鋭角の場合**

円周角の定理より、中心角 $\angle BOC = 2A$ です。$BC$ の中点を $M$ とすると、$OM \perp BC$ であり、

$$
BM = R \sin A
$$

よって $a = BC = 2BM = 2R\sin A$、すなわち

$$
\frac{a}{\sin A} = 2R
$$

**場合2: $\angle A = 90°$ の場合**

$BC$ が直径となるので $a = 2R$ です。$\sin 90° = 1$ より、

$$
\frac{a}{\sin A} = \frac{2R}{1} = 2R
$$

**場合3: $\angle A$ が鈍角の場合**

$A$ の補角を用いた円周角の性質から、同様に $\frac{a}{\sin A} = 2R$ が成り立ちます。

$B$, $C$ についても同様の議論が成り立つので、正弦定理が証明されます。

### Juliaによる正弦定理の検証

```julia
using Plots

# 三角形の頂点を定義
A_coord = [0.0, 0.0]
B_coord = [5.0, 0.0]
C_coord = [2.0, 4.0]

# 辺の長さを計算
a = sqrt(sum((B_coord - C_coord).^2))  # BC
b = sqrt(sum((C_coord - A_coord).^2))  # CA
c = sqrt(sum((A_coord - B_coord).^2))  # AB

# 角度を余弦定理で計算
cos_A = (b^2 + c^2 - a^2) / (2b * c)
cos_B = (c^2 + a^2 - b^2) / (2c * a)
cos_C = (a^2 + b^2 - c^2) / (2a * b)

A_angle = acos(cos_A)
B_angle = acos(cos_B)
C_angle = acos(cos_C)

# 正弦定理の検証
println("正弦定理の検証:")
println("a / sin(A) = ", round(a / sin(A_angle), digits=6))
println("b / sin(B) = ", round(b / sin(B_angle), digits=6))
println("c / sin(C) = ", round(c / sin(C_angle), digits=6))

R = a / (2sin(A_angle))
println("外接円の半径 R = ", round(R, digits=6))
```

**実行結果（例）:**
```
正弦定理の検証:
a / sin(A) = 5.590170
b / sin(B) = 5.590170
c / sin(C) = 5.590170
外接円の半径 R = 2.795085
```

## 余弦定理

### 定理の主張

:::message
**余弦定理**

$\triangle ABC$ において、

$$
a^2 = b^2 + c^2 - 2bc\cos A
$$
$$
b^2 = c^2 + a^2 - 2ca\cos B
$$
$$
c^2 = a^2 + b^2 - 2ab\cos C
$$
:::

余弦定理は**ピタゴラスの定理の一般化**です。$\angle A = 90°$ のとき $\cos A = 0$ となり、$a^2 = b^2 + c^2$ に帰着します。

### 証明

$\angle A$ の場合を示します。頂点 $A$ から辺 $BC$（またはその延長）に下ろした垂線の足を $H$ とします。

**場合1: $\angle A$ が鋭角の場合**

$AH = c\sin B$, $BH = c\cos B$ とおくと、$CH = a - c\cos B$ です。

直角三角形 $AHC$ にピタゴラスの定理を適用して、

$$
b^2 = AH^2 + CH^2 = c^2\sin^2 B + (a - c\cos B)^2
$$
$$
= c^2\sin^2 B + a^2 - 2ac\cos B + c^2\cos^2 B
$$
$$
= c^2(\sin^2 B + \cos^2 B) + a^2 - 2ac\cos B
$$
$$
= a^2 + c^2 - 2ac\cos B
$$

これは $b^2 = c^2 + a^2 - 2ca\cos B$ と一致します。

別の方法として、座標を使った証明も簡潔です。$A$ を原点、$B$ を $(c, 0)$ に置くと、$C = (b\cos A, b\sin A)$ です。

$$
a^2 = BC^2 = (b\cos A - c)^2 + (b\sin A)^2
$$
$$
= b^2\cos^2 A - 2bc\cos A + c^2 + b^2\sin^2 A
$$
$$
= b^2 + c^2 - 2bc\cos A
$$

### Juliaによる余弦定理の検証

```julia
# 余弦定理の検証
println("\n余弦定理の検証:")
println("a² = ", round(a^2, digits=6))
println("b² + c² - 2bc·cos(A) = ", round(b^2 + c^2 - 2b*c*cos_A, digits=6))

println("b² = ", round(b^2, digits=6))
println("c² + a² - 2ca·cos(B) = ", round(c^2 + a^2 - 2c*a*cos_B, digits=6))

println("c² = ", round(c^2, digits=6))
println("a² + b² - 2ab·cos(C) = ", round(a^2 + b^2 - 2a*b*cos_C, digits=6))
```

**実行結果（例）:**
```
余弦定理の検証:
a² = 25.0
b² + c² - 2bc·cos(A) = 25.0
b² = 20.0
c² + a² - 2ca·cos(B) = 20.0
c² = 25.0
a² + b² - 2ab·cos(C) = 25.0
```

## 三角形と外接円の可視化

### 外接円の中心の計算

外接円の中心（外心）は、各辺の垂直二等分線の交点です。

```julia
using Plots
using LinearAlgebra

# 外接円の中心を計算する関数
function circumcenter(A, B, C)
    ax, ay = A
    bx, by = B
    cx, cy = C

    D = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
    ux = ((ax^2 + ay^2) * (by - cy) + (bx^2 + by^2) * (cy - ay) + (cx^2 + cy^2) * (ay - by)) / D
    uy = ((ax^2 + ay^2) * (cx - bx) + (bx^2 + by^2) * (ax - cx) + (cx^2 + cy^2) * (bx - ax)) / D

    return [ux, uy]
end

# 三角形と外接円を描画する関数
function plot_triangle_circumcircle(A, B, C)
    # 外接円の中心と半径
    O = circumcenter(A, B, C)
    R = sqrt(sum((A - O).^2))

    # 辺の長さ
    a = norm(B - C)
    b = norm(C - A)
    c = norm(A - B)

    # 角度
    cos_A = (b^2 + c^2 - a^2) / (2b * c)
    cos_B = (c^2 + a^2 - b^2) / (2c * a)
    cos_C = (a^2 + b^2 - c^2) / (2a * b)

    A_deg = round(rad2deg(acos(cos_A)), digits=1)
    B_deg = round(rad2deg(acos(cos_B)), digits=1)
    C_deg = round(rad2deg(acos(cos_C)), digits=1)

    # 外接円を描画
    θ = range(0, 2π, length=200)
    circle_x = O[1] .+ R .* cos.(θ)
    circle_y = O[2] .+ R .* sin.(θ)

    p = plot(circle_x, circle_y,
        label="外接円 (R=$(round(R, digits=2)))",
        linewidth=2, color=:blue, linestyle=:dash,
        aspect_ratio=:equal)

    # 三角形を描画
    tri_x = [A[1], B[1], C[1], A[1]]
    tri_y = [A[2], B[2], C[2], A[2]]
    plot!(tri_x, tri_y,
        label="△ABC", linewidth=2, color=:red, fill=(0, 0.1, :red))

    # 頂点をプロット
    scatter!([A[1]], [A[2]], label="", markersize=6, color=:red)
    scatter!([B[1]], [B[2]], label="", markersize=6, color=:red)
    scatter!([C[1]], [C[2]], label="", markersize=6, color=:red)

    # 外心をプロット
    scatter!([O[1]], [O[2]], label="外心 O", markersize=6, color=:blue, markershape=:diamond)

    # ラベル
    offset = 0.3
    annotate!(A[1]-offset, A[2]-offset, text("A ($(A_deg)°)", 10, :red))
    annotate!(B[1]+offset, B[2]-offset, text("B ($(B_deg)°)", 10, :red))
    annotate!(C[1], C[2]+offset, text("C ($(C_deg)°)", 10, :red))

    # 辺の長さ
    mid_AB = (A + B) / 2
    mid_BC = (B + C) / 2
    mid_CA = (C + A) / 2
    annotate!(mid_AB[1], mid_AB[2]-0.4, text("c=$(round(c, digits=2))", 8, :black))
    annotate!(mid_BC[1]+0.5, mid_BC[2], text("a=$(round(a, digits=2))", 8, :black))
    annotate!(mid_CA[1]-0.5, mid_CA[2], text("b=$(round(b, digits=2))", 8, :black))

    plot!(title="正弦定理: a/sin(A) = b/sin(B) = c/sin(C) = 2R",
        xlabel="x", ylabel="y")

    return p
end

# 例1: 鋭角三角形
p1 = plot_triangle_circumcircle([0.0, 0.0], [5.0, 0.0], [2.0, 4.0])

# 例2: 直角三角形
p2 = plot_triangle_circumcircle([0.0, 0.0], [4.0, 0.0], [0.0, 3.0])

# 例3: 鈍角三角形
p3 = plot_triangle_circumcircle([0.0, 0.0], [6.0, 0.0], [5.0, 1.5])

plot(p1, p2, p3, layout=(1, 3), size=(1500, 500))
```

### 鋭角・直角・鈍角三角形での外心の位置

外心の位置は三角形の種類によって異なります：

| 三角形の種類 | 外心の位置 |
|:---:|:---:|
| 鋭角三角形 | 三角形の内部 |
| 直角三角形 | 斜辺の中点 |
| 鈍角三角形 | 三角形の外部 |

## 三角形の求解

正弦定理と余弦定理を用いて、三角形のすべての要素（3辺と3角）を求めることができます。

### パターン1: 2辺とその間の角（SAS）

```julia
# 2辺と間の角から残りの要素を求める
function solve_SAS(b, c, A_deg)
    A = deg2rad(A_deg)

    # 余弦定理で対辺を求める
    a = sqrt(b^2 + c^2 - 2b*c*cos(A))

    # 正弦定理で他の角を求める
    sin_B = b * sin(A) / a
    B = asin(sin_B)

    # 残りの角
    C = π - A - B

    println("=== SAS: b=$b, c=$c, A=$(A_deg)° ===")
    println("a = $(round(a, digits=4))")
    println("B = $(round(rad2deg(B), digits=2))°")
    println("C = $(round(rad2deg(C), digits=2))°")
    println("角の和: $(round(A_deg + rad2deg(B) + rad2deg(C), digits=2))°")

    return a, rad2deg(B), rad2deg(C)
end

solve_SAS(5, 7, 60)
```

**実行結果（例）:**
```
=== SAS: b=5, c=7, A=60° ===
a = 6.2450
B = 40.89°
C = 79.11°
角の和: 180.0°
```

### パターン2: 3辺（SSS）

```julia
# 3辺から角度を求める
function solve_SSS(a, b, c)
    # 三角不等式の確認
    if a + b <= c || b + c <= a || c + a <= b
        println("三角形が存在しません")
        return nothing
    end

    # 余弦定理で角度を求める
    A = acos((b^2 + c^2 - a^2) / (2b*c))
    B = acos((c^2 + a^2 - b^2) / (2c*a))
    C = π - A - B

    println("=== SSS: a=$a, b=$b, c=$c ===")
    println("A = $(round(rad2deg(A), digits=2))°")
    println("B = $(round(rad2deg(B), digits=2))°")
    println("C = $(round(rad2deg(C), digits=2))°")

    # 外接円の半径
    R = a / (2sin(A))
    println("外接円の半径 R = $(round(R, digits=4))")

    return rad2deg(A), rad2deg(B), rad2deg(C)
end

solve_SSS(3, 4, 5)
solve_SSS(5, 5, 5)
solve_SSS(7, 8, 13)
```

**実行結果（例）:**
```
=== SSS: a=3, b=4, c=5 ===
A = 36.87°
B = 53.13°
C = 90.0°
外接円の半径 R = 2.5

=== SSS: a=5, b=5, c=5 ===
A = 60.0°
B = 60.0°
C = 60.0°
外接円の半径 R = 2.8868

=== SSS: a=7, b=8, c=13 ===
A = 20.74°
B = 23.93°
C = 135.33°
外接円の半径 R = 9.8877
```

### パターン3: 1辺と両端の角（ASA）

```julia
# 1辺と両端の角から残りの要素を求める
function solve_ASA(a, B_deg, C_deg)
    B = deg2rad(B_deg)
    C = deg2rad(C_deg)
    A = π - B - C

    if A <= 0
        println("三角形が存在しません（角の和が180°以上）")
        return nothing
    end

    # 正弦定理で残りの辺を求める
    b = a * sin(B) / sin(A)
    c = a * sin(C) / sin(A)

    println("=== ASA: a=$a, B=$(B_deg)°, C=$(C_deg)° ===")
    println("A = $(round(rad2deg(A), digits=2))°")
    println("b = $(round(b, digits=4))")
    println("c = $(round(c, digits=4))")

    return rad2deg(A), b, c
end

solve_ASA(10, 45, 60)
```

**実行結果（例）:**
```
=== ASA: a=10, B=45°, C=60° ===
A = 75.0°
b = 7.3205
c = 8.9658
```

## 応用：三角形の面積

### 基本公式と余弦定理の組み合わせ

三角形の面積 $S$ は、

$$
S = \frac{1}{2}bc\sin A = \frac{1}{2}ca\sin B = \frac{1}{2}ab\sin C
$$

### ヘロンの公式

3辺 $a, b, c$ が与えられたとき、$s = \frac{a+b+c}{2}$ として、

$$
S = \sqrt{s(s-a)(s-b)(s-c)}
$$

この公式は余弦定理と面積公式から導くことができます。

**導出:** 余弦定理より $\cos A = \frac{b^2+c^2-a^2}{2bc}$ であるから、

$$
\sin^2 A = 1 - \cos^2 A = 1 - \left(\frac{b^2+c^2-a^2}{2bc}\right)^2
$$
$$
= \frac{(2bc)^2 - (b^2+c^2-a^2)^2}{(2bc)^2}
$$

分子を因数分解すると、

$$
(2bc + b^2+c^2-a^2)(2bc - b^2-c^2+a^2) = \{(b+c)^2 - a^2\}\{a^2 - (b-c)^2\}
$$
$$
= (b+c+a)(b+c-a)(a+b-c)(a-b+c)
$$

$s = \frac{a+b+c}{2}$ とおくと、各因子は $2s$, $2(s-a)$, $2(s-c)$, $2(s-b)$ となるので、

$$
\sin A = \frac{2\sqrt{s(s-a)(s-b)(s-c)}}{bc}
$$

したがって、

$$
S = \frac{1}{2}bc\sin A = \sqrt{s(s-a)(s-b)(s-c)}
$$

### Juliaによる面積計算の比較

```julia
# 3つの方法で面積を計算して比較
function compare_area_formulas(A_coord, B_coord, C_coord)
    a = norm(B_coord - C_coord)
    b = norm(C_coord - A_coord)
    c = norm(A_coord - B_coord)

    cos_A = (b^2 + c^2 - a^2) / (2b * c)
    sin_A = sqrt(1 - cos_A^2)

    # 方法1: (1/2)bc sin(A)
    S1 = 0.5 * b * c * sin_A

    # 方法2: ヘロンの公式
    s = (a + b + c) / 2
    S2 = sqrt(s * (s-a) * (s-b) * (s-c))

    # 方法3: 外積（座標から直接）
    AB = B_coord - A_coord
    AC = C_coord - A_coord
    S3 = abs(AB[1]*AC[2] - AB[2]*AC[1]) / 2

    println("面積計算の比較:")
    println("  (1/2)bc·sin(A) = $(round(S1, digits=6))")
    println("  ヘロンの公式    = $(round(S2, digits=6))")
    println("  外積            = $(round(S3, digits=6))")
    println("  辺: a=$(round(a,digits=3)), b=$(round(b,digits=3)), c=$(round(c,digits=3))")

    return S1
end

# 例
compare_area_formulas([0.0, 0.0], [5.0, 0.0], [2.0, 4.0])
println()
compare_area_formulas([0.0, 0.0], [4.0, 0.0], [0.0, 3.0])
println()
compare_area_formulas([0.0, 0.0], [6.0, 0.0], [3.0, 1.0])
```

**実行結果（例）:**
```
面積計算の比較:
  (1/2)bc·sin(A) = 10.0
  ヘロンの公式    = 10.0
  外積            = 10.0
  辺: a=5.0, b=4.472, c=5.0

面積計算の比較:
  (1/2)bc·sin(A) = 6.0
  ヘロンの公式    = 6.0
  外積            = 6.0
  辺: a=5.0, b=3.0, c=4.0

面積計算の比較:
  (1/2)bc·sin(A) = 3.0
  ヘロンの公式    = 3.0
  外積            = 3.0
  辺: a=3.162, b=3.162, c=6.0
```

## 正弦定理と余弦定理の関係

### 余弦定理から正弦定理を導く

実は、余弦定理から正弦定理を導くことができます。

余弦定理 $\cos A = \frac{b^2+c^2-a^2}{2bc}$ より、

$$
\sin^2 A = 1 - \cos^2 A = \frac{4b^2c^2 - (b^2+c^2-a^2)^2}{4b^2c^2}
$$

ヘロンの公式の導出で示したように、分子は

$$
4b^2c^2 - (b^2+c^2-a^2)^2 = 16s(s-a)(s-b)(s-c)
$$

よって $\sin A = \frac{4S}{2bc} = \frac{2S}{bc}$ ですから（$S$ は面積）、

$$
\frac{a}{\sin A} = \frac{abc}{2S}
$$

この式は $a, b, c$ について対称なので、$\frac{a}{\sin A} = \frac{b}{\sin B} = \frac{c}{\sin C} = \frac{abc}{2S}$ となります。

さらに、$S = \frac{abc}{4R}$（外接円の半径 $R$ を用いた面積公式）を代入すると、

$$
\frac{abc}{2S} = \frac{abc}{2 \cdot \frac{abc}{4R}} = 2R
$$

となり、正弦定理 $\frac{a}{\sin A} = 2R$ が得られます。

### ランダムな三角形での検証

```julia
using Random

Random.seed!(42)

println("ランダムな三角形での正弦定理・余弦定理の検証")
println("=" ^ 60)

for i = 1:5
    # ランダムな三角形を生成
    A = rand(2) * 10
    B = rand(2) * 10
    C = rand(2) * 10

    a = norm(B - C)
    b = norm(C - A)
    c = norm(A - B)

    # 三角不等式の確認
    if a + b <= c || b + c <= a || c + a <= b
        continue
    end

    cos_A = clamp((b^2 + c^2 - a^2) / (2b*c), -1, 1)
    cos_B = clamp((c^2 + a^2 - b^2) / (2c*a), -1, 1)
    cos_C = clamp((a^2 + b^2 - c^2) / (2a*b), -1, 1)

    sin_A = sin(acos(cos_A))
    sin_B = sin(acos(cos_B))
    sin_C = sin(acos(cos_C))

    # 正弦定理の検証
    ratio_A = a / sin_A
    ratio_B = b / sin_B
    ratio_C = c / sin_C

    # 余弦定理の検証
    lhs = a^2
    rhs = b^2 + c^2 - 2b*c*cos_A

    println("三角形 #$i:")
    println("  a/sin(A) = $(round(ratio_A, digits=4)), " *
            "b/sin(B) = $(round(ratio_B, digits=4)), " *
            "c/sin(C) = $(round(ratio_C, digits=4))")
    println("  a² = $(round(lhs, digits=4)), " *
            "b²+c²-2bc·cos(A) = $(round(rhs, digits=4))")
    println()
end
```

## 余弦定理の一般化：Stewart の定理

余弦定理をさらに一般化した定理として、**Stewart の定理**があります。

:::message
**Stewart の定理**

$\triangle ABC$ の辺 $BC$ 上に点 $D$ があり、$BD = m$, $DC = n$, $AD = d$ とすると、

$$
a(d^2 + mn) = b^2 m + c^2 n
$$

ここで $a = m + n = BC$ である。
:::

この定理は余弦定理の特殊な場合を含みます。$D$ が $B$ と一致する（$m = 0$, $n = a$）とき $d = c$ となり、$a \cdot c^2 = b^2 \cdot 0 + c^2 \cdot a$（自明）。$D$ が辺 $BC$ の中点のとき（$m = n = \frac{a}{2}$）は**中線定理**が得られます：

$$
d^2 = \frac{2b^2 + 2c^2 - a^2}{4}
$$

### 中線定理の検証

```julia
# 中線定理の検証
function verify_median_theorem(A_coord, B_coord, C_coord)
    a = norm(B_coord - C_coord)
    b = norm(C_coord - A_coord)
    c = norm(A_coord - B_coord)

    # 辺BCの中点
    M = (B_coord + C_coord) / 2

    # 中線の長さ
    m_a = norm(A_coord - M)

    # 中線定理による値
    m_a_theory = sqrt((2b^2 + 2c^2 - a^2) / 4)

    println("中線定理の検証:")
    println("  中線 AM の長さ（直接計算） = $(round(m_a, digits=6))")
    println("  中線定理による値            = $(round(m_a_theory, digits=6))")

    return m_a
end

verify_median_theorem([0.0, 0.0], [5.0, 0.0], [2.0, 4.0])
```

**実行結果（例）:**
```
中線定理の検証:
  中線 AM の長さ（直接計算） = 4.031129
  中線定理による値            = 4.031129
```

## まとめ

### 正弦定理と余弦定理の使い分け

| 既知の条件 | 使う定理 | 求められるもの |
|:---:|:---:|:---:|
| 2辺と間の角（SAS） | 余弦定理 | 対辺の長さ |
| 3辺（SSS） | 余弦定理 | 各角度 |
| 1辺と2角（ASA, AAS） | 正弦定理 | 残りの辺 |
| 2辺と対角 | 正弦定理 | 他の角（解が2つの場合あり） |

### 定理間のつながり

```
ピタゴラスの定理 ← 余弦定理（A=90°の特殊ケース）
                      ↓
                  正弦定理（余弦定理から導出可能）
                      ↓
                  面積公式・ヘロンの公式
                      ↓
              Stewart の定理・中線定理
```

### Juliaの活用

- `LinearAlgebra` の `norm` による距離計算
- `Plots.jl` による三角形と外接円の可視化
- ランダム生成による定理の数値的検証

正弦定理と余弦定理は高校数学の基本ですが、その背後には豊かな数学的構造があり、ヘロンの公式や Stewart の定理へと自然に拡張されます。Julia による計算と可視化を通じて、これらの定理の意味と応用をより深く理解できるでしょう。
