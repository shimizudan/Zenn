---
title: "第2問：格子点と三角形の確率"
---

## 問題

![第2問](/images/u-tokyo-2026-002.png)

## Juliaで考える

### 確率 $p_n$ を求めるコードを作る

$x \in \{1, 2, 3\}$，$y \in \{1, \ldots, n\}$ の $3n$ 個の格子点から3点を選んで三角形を作れる確率 $p_n$ を計算します。

3点が三角形を作れるかどうかは「共線でない」ことと等価です。外積を使って共線判定を行います。`Combinatorics.jl` パッケージの `combinations` 関数を利用します。

```julia
using Combinatorics

function p(n)
    # 3n個の格子点を生成: x∈{1,2,3}, y∈{1,...,n}
    points = [(x, y) for x in 1:3 for y in 1:n]

    total = binomial(3n, 3)
    triangle_count = 0

    for combo in combinations(points, 3)
        (x1, y1), (x2, y2), (x3, y3) = combo
        # 外積で共線判定: 0でなければ三角形
        if (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1) != 0
            triangle_count += 1
        end
    end

    return triangle_count // total  # 有理数で返す
end
```

### (1) $p_5$ を求める

```julia
println("p_5 = ", p(5))
```

```
p_5 = 412//455
```

$$p_5 = \frac{412}{455}$$

### (2) $p_{2m}$ を求める

$m = 2, 3, 4, 5, 6$ のそれぞれについて $p_{2m}$ を計算します。

```julia
for m in 2:6
    println("p_$(2m) = ", p(2m))
end
```

```
p_4  = 10//11
p_6  = 123//136
p_8  = 228//253
p_10 = 365//406
p_12 = 534//595
```

結果を表にまとめると：

| $m$ | $p_{2m}$ |
|---|---|
| 2 | $\dfrac{10}{11}$ |
| 3 | $\dfrac{123}{136}$ |
| 4 | $\dfrac{228}{253}$ |
| 5 | $\dfrac{365}{406}$ |
| 6 | $\dfrac{534}{595}$ |

### $p_n$ の変化をグラフで見る

$n$ を大きくしたとき $p_n$ がどこへ向かうかをグラフで確認します。

```julia
using CairoMakie

ns = collect(1:10)
ps = [Float64(p(n)) for n in ns]

fig = Figure(fonts=(; regular="Hiragino Sans", bold="Hiragino Sans"), size=(700, 450))
ax = Axis(fig[1, 1],
    xlabel=L"n",
    ylabel=L"p_n",
    title="pₙ（格子点から3点選んで三角形ができる確率）",
)
scatter!(ax, ns, ps, color=:steelblue, markersize=10)
lines!(ax, ns, ps, color=:steelblue, linewidth=1.5, linestyle=:dash)
hlines!(ax, [8/9], color=:crimson, linewidth=1.5, linestyle=:dash,
        label="8/9 ≈ 0.889（収束値）")
ylims!(ax, -0.05, 1.0)
axislegend(ax, position=:rb)
fig
```

![p_n のグラフ](/images/u-tokyo-2026-graph2.png)

$n=1$ のとき $p_1 = 0$（3点すべてが同じ行に並んでしまい三角形を作れない），$n=2$ 以降は **$\dfrac{8}{9}$ に向かって単調減少**していきます。1 には近づかないことがグラフからわかります。

参考として大きい $n$ での値を確認します。

```julia
for n in [1, 2, 5, 10, 20, 50]
    println("p_$n = $(p(n)) ≈ $(round(Float64(p(n)), digits=6))")
end
println("8/9 = $(round(8/9, digits=6))")
```

```
p_1  = 0//1       ≈ 0.0
p_2  = 9//10      ≈ 0.9
p_5  = 412//455   ≈ 0.905495
p_10 = 365//406   ≈ 0.899015
p_20 = 1530//1711 ≈ 0.894214
p_50 = 9825//11026 ≈ 0.891076
8/9               ≈ 0.888889
```

## まとめ

- 外積による共線判定を使って，確率 $p_n$ を有理数で正確に計算できました
- $p_5 = \dfrac{412}{455}$
- $p_{2m}$ の値は $m$ が増えるにつれて単調減少し，$\dfrac{8}{9}$ に近づいていく
- $n \to \infty$ のとき $p_n \to \dfrac{8}{9}$（1 には近づかない）

:::message
$n \to \infty$ のとき，三角形を作れない3点（共線）の割合が $\dfrac{1}{9}$ に収束します。これは「同じ列（$x$ 座標が同じ）の3点を選ぶ」パターンが支配的になるためです。
:::
