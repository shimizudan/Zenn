---
title: "嘘つきは何人か？——約数と自己言及の数学"
emoji: "🤥"
type: "idea"
topics: [julia, 数学, 整数論, シミュレーション, 確率]
published: true
math: true
---

https://x.com/Nazoi_dori/status/2039285281678119149

> 小学校のとき作った問題を思い出した
>
> 160人いる。
> 1番「嘘つきの人数は1の倍数」
> 2番「嘘つきの人数は2の倍数」
> ：
> n番「嘘つきの人数はnの倍数」
> ：
> 160番「嘘つきの人数は160の倍数」
> 嘘つきは何人？
>
> — 菅道鳥 (@Nazoi_dori) 2026年4月1日

---

## 問題

160人います。n番の人（$n = 1, 2, \ldots, 160$）は全員こう言います。

> 「嘘つきの人数は $n$ の倍数だ。」

正直者は本当のことを言い、嘘つきは嘘をつきます。**嘘つきは何人でしょうか？**

---

## 考え方

嘘つきの人数を $L$ とおきます。

- **n番が正直者** $\iff$ 「$L$ は $n$ の倍数」が真 $\iff$ $n \mid L$
- **n番が嘘つき** $\iff$ 「$L$ は $n$ の倍数」が偽 $\iff$ $n \nmid L$

正直者の人数は、1〜160の中で $L$ を割り切る数の個数、つまり $L$ の約数の個数 $d(L)$（1〜160の範囲）です。嘘つきの人数はその残りなので：

$$L = 160 - |\{n \in \{1,\ldots,160\} \mid n \mid L\}|$$

あるいは $d(L)$ を「$L$ の約数の個数（1〜160 内）」と書けば：

$$d(L) = 160 - L$$

---

## Julia で全探索

```julia
# L の候補を全探索する
solutions = Int[]

for L in 0:160
    # 1〜160 の中で L を割り切る数の個数（正直者の数）
    honest_count = count(n -> L % n == 0, 1:160)
    liar_count = 160 - honest_count

    if liar_count == L
        push!(solutions, L)
    end
end

println("解: ", solutions)
```

```
解: [0, 152]
```

解は **L = 0** と **L = 152** の2つです。

---

## 解の詳細

```julia
# 解の詳細を表示する
for L in solutions
    divisors_in_range = filter(n -> L % n == 0, 1:160)
    println("=== 嘘つきの人数: L = $L ===")
    println("  正直者の数: ", 160 - L, " 人")
    println("  正直者（Lの約数）: ", divisors_in_range)
    println()
end
```

```
=== 嘘つきの人数: L = 0 ===
  正直者の数: 160 人
  正直者（Lの約数）: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
   17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
   36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54,
   55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73,
   74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92,
   93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
   110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124,
   125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139,
   140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154,
   155, 156, 157, 158, 159, 160]

=== 嘘つきの人数: L = 152 ===
  正直者の数: 8 人
  正直者（Lの約数）: [1, 2, 4, 8, 19, 38, 76, 152]
```

- **L = 0**：嘘つきが0人 → 全員正直者 → 全員「0は $n$ の倍数」と言っている（0はすべての整数の倍数）→ 矛盾なし ✓
- **L = 152**：嘘つきが152人。$152 = 2^3 \times 19$ の約数は $\{1, 2, 4, 8, 19, 38, 76, 152\}$ の8個 → 正直者8人、嘘つき152人 → 一致 ✓

---

## なぜ 152 が答えになるのか

満たすべき条件を整理します：

$$d(L) = 160 - L$$

「$L$ の約数の個数」と「$160 - L$」がぴったり一致しなければなりません。

### 1〜160 内の数の約数の個数の最大値

```julia
using Primes

X = []
for x in 1:160
    append!(X, divisors(x) |> length)
end
@show union!(X)
```

```
union!(X) = Any[1, 2, 3, 4, 6, 5, 8, 9, 10, 12, 7, 16, 15]
```

約数の個数として登場するのは一部の値のみで、最大値は **16**（$120 = 2^3 \times 3 \times 5$ のとき、$(3+1)(1+1)(1+1)=16$）。

$d(L) = 160 - L$ を満たすには $L = 160 - d(L)$ なので、候補は：

```julia
X = 160 .- [7, 8, 9, 12, 15, 16]
[divisors(x) for x in X]
```

```
6-element Vector{Vector{Int64}}:
 [1, 3, 9, 17, 51, 153]
 [1, 2, 4, 8, 19, 38, 76, 152]
 [1, 151]
 [1, 2, 4, 37, 74, 148]
 [1, 5, 29, 145]
 [1, 2, 3, 4, 6, 8, 9, 12, 16, 18, 24, 36, 48, 72, 144]
```

| $d(L)$ | $L = 160 - d(L)$ | $L$ の約数（1〜160） | 約数の個数 | 一致？ |
|:------:|:----------------:|:-------------------:|:---------:|:------:|
| 7 | 153 | 1, 3, 9, 17, 51, 153 | **6** | 6 ≠ 7 ✗ |
| 8 | 152 | 1, 2, 4, 8, 19, 38, 76, 152 | **8** | 8 = 8 ✓ |
| 9 | 151 | 1, 151 | **2** | 2 ≠ 9 ✗ |
| 12 | 148 | 1, 2, 4, 37, 74, 148 | **6** | 6 ≠ 12 ✗ |
| 15 | 145 | 1, 5, 29, 145 | **4** | 4 ≠ 15 ✗ |
| 16 | 144 | 1, 2, 3, 4, 6, 8, 9, 12, 16, 18, 24, 36, 48, 72, 144 | **15** | 15 ≠ 16 ✗ |

**152 だけが条件を満たします。**

---

## グラフによる視覚化

2つの関数を考えます：

- $f(L) = L$（対角線：「仮定した嘘つきの数」）
- $g(L) = 160 - d(L)$（「$L$ を仮定したときに計算される嘘つきの数」）

**解 = 2つの曲線の交点** $f(L) = g(L)$

```julia
using Plots, PlotsGRBackendFontJaEmoji

Ls = 0:160

# f(L) = L（対角線）
f = collect(Ls)

# g(L) = 160 - d(L)（Lを仮定したときの嘘つきの数）
g = [160 - count(n -> L % n == 0, 1:160) for L in Ls]

# 解（交点）
sols = [L for L in Ls if g[L+1] == L]

p = plot(Ls, f,
    label = "f(L) = L　（仮定した嘘つきの数）",
    color = :steelblue,
    linewidth = 2,
    linestyle = :dash,
    xlabel = "L（嘘つきの人数の仮定値）",
    ylabel = "人数",
    title = "嘘つき問題：2つの関数の交点が解",
    size = (700, 500),
    legend = :bottomright
)

plot!(p, Ls, g,
    label = "g(L) = 160 - d(L)　（計算される嘘つきの数）",
    color = :crimson,
    linewidth = 2
)

# 交点をプロット
scatter!(p, sols, sols,
    label = "解: L = $(sols)",
    color = :green,
    markersize = 8,
    markershape = :circle
)

# 解にアノテーション
for s in sols
    annotate!(p, s + 3, s + 6, text("L = $s", 9, :green))
end

p
```

![嘘つき問題：2つの関数の交点が解](/images/liar-problem-160/liar_graph_full.png)

L = 140〜160 の拡大図：

```julia
# L = 140〜160 の拡大グラフ
Ls2 = 140:160

f2 = collect(Ls2)
g2 = [160 - count(n -> L % n == 0, 1:160) for L in Ls2]
sols2 = [L for L in Ls2 if g2[L-139] == L]

p2 = plot(Ls2, f2,
    label = "f(L) = L　（仮定した嘘つきの数）",
    color = :steelblue,
    linewidth = 2,
    linestyle = :dash,
    xlabel = "L（嘘つきの人数の仮定値）",
    ylabel = "人数",
    title = "拡大図：L = 140〜160",
    size = (700, 500),
    legend = :bottomright,
    xticks = 140:2:160
)

plot!(p2, Ls2, g2,
    label = "g(L) = 160 - d(L)　（計算される嘘つきの数）",
    color = :crimson,
    linewidth = 2
)

scatter!(p2, sols2, sols2,
    label = "解: L = $(sols2)",
    color = :green,
    markersize = 8,
    markershape = :circle
)

for s in sols2
    annotate!(p2, s + 0.3, s + 1.5, text("L = $s", 9, :green))
end

p2
```

![拡大図：L = 140〜160](/images/liar-problem-160/liar_graph_zoom.png)

拡大すると $L = 152$ のところで $f$ と $g$ が交差しているのがよくわかります。

---

## 一般化：総人数を $x$ に変えたとき

$x$ 人に一般化します。n番の人（$n = 1, \ldots, x$）が「嘘つきの人数は $n$ の倍数」と言うとき、

$$L = x - |\{n \in \{1,\ldots,x\} \mid n \mid L\}|$$

を満たす $L$（$0 \leq L \leq x$）を $x = 1$ から $1000$ まで調べます。

```julia
# x = 1〜1000 について，嘘つきの人数 L の解を全探索
results = Dict{Int, Vector{Int}}()

for x in 1:1000
    solutions = Int[]
    for L in 0:x
        honest_count = count(n -> L % n == 0, 1:x)
        liar_count = x - honest_count
        if liar_count == L
            push!(solutions, L)
        end
    end
    results[x] = solutions
end

# 結果を表示
println("x（総人数）  解 L")
println("-" ^ 40)
for x in 1:1000
    sols = results[x]
    println("x = $(lpad(x,4)) : $(sols)")
end
```

```
x（総人数）  解 L
----------------------------------------
x =    1 : [0]
x =    2 : [0, 1]
x =    3 : [0]
x =    4 : [0, 2]
x =    5 : [0, 3]
x =    6 : [0]
x =    7 : [0, 4, 5]
x =    8 : [0]
x =    9 : [0, 7]
x =   10 : [0, 6]
...
x =  160 : [0, 152]
...
x = 1000 : [0, 984, 988]
```

### 解の個数の分布

```julia
# 解の個数別に集計
using Printf

println("解の個数  該当する x の一覧")
println("-" ^ 60)
for k in sort(unique(length(v) for v in values(results)))
    xs = sort([x for (x, v) in results if length(v) == k])
    println("解が $(k) 個 : x = $(xs)")
end

println()
println("解が 0 のケース（解なし）:")
no_sol = sort([x for (x, v) in results if isempty(v)])
println(no_sol)
```

```
解の個数  該当する x の一覧
------------------------------------------------------------
解が 1 個 : x = [1, 3, 6, 8, 11, 16, 17, 20, 22, 23, ...]
解が 2 個 : x = [2, 4, 5, 9, 10, 13, 14, 15, 24, 28, ...]
解が 3 個 : x = [7, 12, 18, 19, 21, 25, 26, 31, 39, 43, ...]
解が 4 個 : x = [38, 50, 69, 81, 86, 138, 162, 172, 181, ...]
解が 5 個 : x = [122, 159, 318, 339, 362, 718, 750]

解が 0 のケース（解なし）:
Int64[]
```

解なし（$x \leq 1000$）は**ありません**。$L = 0$ は常に解です（0 はすべての整数の倍数）。

### 散布図

```julia
# x と解 L の関係をグラフで可視化
using Plots, PlotsGRBackendFontJaEmoji

xs_all = Int[]
ls_all = Int[]

for x in 1:1000
    for L in results[x]
        push!(xs_all, x)
        push!(ls_all, L)
    end
end

scatter(xs_all, ls_all,
    xlabel = "x（総人数）",
    ylabel = "解 L（嘘つきの人数）",
    title = "人数 x を変化させたときの解 L（x = 1〜1000）",
    label = "解 L",
    color = :steelblue,
    markersize = 3,
    markerstrokewidth = 0,
    size = (900, 500),
    legend = :topleft
)

# x = 160 の解を強調
x160_sols = results[160]
scatter!(fill(160, length(x160_sols)), x160_sols,
    label = "x = 160 の解 $(x160_sols)",
    color = :red,
    markersize = 8,
    markershape = :star5
)
```

![人数 x を変化させたときの解 L](/images/liar-problem-160/liar_scatter.png)

解 $L$ は $x$ に近い値（嘘つき多数）と $L = 0$（全員正直）に集中しています。

---

## x = 50 の詳細例

```julia
# x = 50 の詳細確認
x = 50
solutions_50 = Int[]

for L in 0:x
    honest_count = count(n -> L % n == 0, 1:x)
    liar_count = x - honest_count
    if liar_count == L
        push!(solutions_50, L)
    end
end

println("=== x = $x のとき ===")
println("解: ", solutions_50)
println()

for L in solutions_50
    divs = filter(n -> L % n == 0, 1:x)
    println("--- L = $L ---")
    println("  正直者の数: $(x - L) 人")
    println("  約数（1〜$(x) 内）: $(divs)  → $(length(divs)) 個")
    println("  $(x) - $(L) = $(x - L)  vs  約数の個数 = $(length(divs))  → $(length(divs) == x - L ? "一致 ✓" : "不一致 ✗")")
    println()
end
```

```
=== x = 50 のとき ===
解: [0, 42, 44, 46]

--- L = 0 ---
  正直者の数: 50 人
  約数（1〜50 内）: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
   18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
   37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]  → 50 個
  50 - 0 = 50  vs  約数の個数 = 50  → 一致 ✓

--- L = 42 ---
  正直者の数: 8 人
  約数（1〜50 内）: [1, 2, 3, 6, 7, 14, 21, 42]  → 8 個
  50 - 42 = 8  vs  約数の個数 = 8  → 一致 ✓

--- L = 44 ---
  正直者の数: 6 人
  約数（1〜50 内）: [1, 2, 4, 11, 22, 44]  → 6 個
  50 - 44 = 6  vs  約数の個数 = 6  → 一致 ✓

--- L = 46 ---
  正直者の数: 4 人
  約数（1〜50 内）: [1, 2, 23, 46]  → 4 個
  50 - 46 = 4  vs  約数の個数 = 4  → 一致 ✓
```

---

## x = 50 のまとめ

総人数が 50 人の場合を詳しく見てみましょう。

満たすべき条件：

$$\lvert\{n \in \{1,\ldots,50\} \mid n \mid L\}\rvert = 50 - L$$

| 解 $L$ | 素因数分解 | 約数（1〜50 内） | 約数の個数 | $50 - L$ | 確認 |
|:------:|:---------:|:---------------:|:---------:|:--------:|:----:|
| 0 | — | 1〜50 すべて | **50** | **50** | ✓ |
| 42 | $2 \times 3 \times 7$ | 1, 2, 3, 6, 7, 14, 21, 42 | **8** | **8** | ✓ |
| 44 | $2^2 \times 11$ | 1, 2, 4, 11, 22, 44 | **6** | **6** | ✓ |
| 46 | $2 \times 23$ | 1, 2, 23, 46 | **4** | **4** | ✓ |

x = 50 では解が **4つ**存在し、x = 160 よりも豊かな構造をもちます。

---

## x > 1000 での解の最大個数

$L > 0$ のとき、条件 $d(L) = x - L$ は

$$\boxed{L + d(L) = x}$$

と書けます（$L \leq x$ なら $L$ のすべての約数は $x$ 以下に収まるため）。

篩で $d(L)$ を一括計算し、$x > 1000$ で解の個数の最大値を更新するものを探します：

```julia
# x > 1000 で解の個数の最大値を更新する x を探す
# 条件: L + d(L) = x （L=0 は常に解なので別扱い）

MAX_L = 2_000_000  # L の探索上限

# 篩で約数の個数を一括計算 O(N log N)
println("約数の個数を篩で計算中 (MAX_L = $MAX_L)...")
d = zeros(Int32, MAX_L)
for k in 1:MAX_L
    for m in k:k:MAX_L
        d[m] += 1
    end
end
println("完了")

# L + d(L) = x となる L を x ごとに集約（x > 1000 のみ）
sol_dict = Dict{Int, Vector{Int}}()
for L in 1:MAX_L
    s = L + Int(d[L])
    if s > 1000
        push!(get!(sol_dict, s, Int[]), L)
    end
end

# x > 1000 で解の個数が最大値を更新するものを出力
let current_max = 5
    println("\nx > 1000 で解の個数が最大値を更新するもの（初期最大値 = $current_max）")
    println("-" ^ 70)

    for x in sort(collect(keys(sol_dict)))
        ls = sol_dict[x]
        n_sols = 1 + length(ls)  # +1 は L = 0 の分
        if n_sols > current_max
            current_max = n_sols
            println("x = $(lpad(x,8)) : 解の個数 = $n_sols, 解 L = $(sort([0; ls]))")
        end
    end
    println("\n最終的な最大解の個数: $current_max")
end
```

```
約数の個数を篩で計算中 (MAX_L = 2000000)...
完了

x > 1000 で解の個数が最大値を更新するもの（初期最大値 = 5）
----------------------------------------------------------------------
x =     2766 : 解の個数 = 6, 解 L = [0, 2736, 2750, 2752, 2758, 2762]
x =    64686 : 解の個数 = 7, 解 L = [0, 64638, 64656, 64670, 64674, 64678, 64682]
x =  1972296 : 解の個数 = 8, 解 L = [0, 1972152, 1972200, 1972224, 1972260, 1972264, 1972280, 1972284]

最終的な最大解の個数: 8
```

$x = 1{,}972{,}296$ で解が **8個**に達します（200万以下の探索範囲内）。

---

## まとめ

| 項目 | 内容 |
|------|------|
| 元の問題（$x = 160$）の答え | $L = 0$（全員正直）または $L = 152$（嘘つき152人）|
| 条件の式 | $d(L) = x - L$（$L$ の約数の個数 = 正直者の数）|
| $L = 0$ は常に解 | 0 はすべての整数の倍数なので |
| $x \leq 1000$ で解なしの $x$ | なし |
| $x \leq 1000$ で解が最多の $x$ | $x = 122, 159, 318, 339, 362, 718, 750$（5個）|
| $x \leq 2{,}000{,}000$ での最大解数 | 8個（$x = 1{,}972{,}296$）|
