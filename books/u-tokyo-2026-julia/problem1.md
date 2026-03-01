---
title: "第1問：積分の評価"
---

## 問題

![第1問](/images/u-tokyo-2026-001.png)

## Juliaで考える

### $f(\theta)$ のグラフを描く

まず，$f(\theta) = \sin\theta - \theta + \dfrac{\theta^3}{6}$ のグラフを区間 $-1 \leqq \theta \leqq 1$ で描いてみます。グラフの描画には `CairoMakie.jl`，図中の数式表示には `LaTeXStrings.jl` を利用します。

```julia
using CairoMakie
using LaTeXStrings

f(θ) = sin(θ) - θ + θ^3/6

θ = -1:0.01:1

fig = Figure(fonts=(; regular="Hiragino Sans", bold="Hiragino Sans"))

ax = Axis(fig[1, 1],
    xlabel=L"\theta",
    ylabel=L"y",
)
lines!(ax, θ, f.(θ), label=L"y=\sin\theta-\theta+\frac{\theta^3}{6}")
axislegend(ax, position=:rb)
fig
```

![f(θ)のグラフ](/images/u-tokyo-2026-graph1a.png)

グラフを見ると，$[-1, 1]$ で $f$ は増加関数のように見えます。最小値は左端 $\theta=-1$，最大値は右端 $\theta=1$ で取れそうです。

### 最大値・最小値を数値で確認する

```julia
m, M = f(-1), f(1)
```

```
(-0.008137651474563162, 0.008137651474563162)
```

$M = -m$ であることが確認できます。$M$ の値は非常に 0 に近いです。

念のため，`Optim.jl`（最適化パッケージ）を使って確認します。

```julia
using Optim, Printf

# 最小化（1変数）
result = optimize(f, -1, 1)  # 区間指定
@printf("θ=%.4f のとき，最小値 %.4f\n", result.minimizer, result.minimum)

# 最大化 → -f を最小化
result = optimize(θ -> -f(θ), -1, 1)
@printf("θ=%.4f のとき，最大値 %.4f\n", result.minimizer, -result.minimum)
```

```
θ=-1.0000 のとき，最小値 -0.0081
θ=1.0000 のとき，最大値 0.0081
```

最小値は $\theta=-1$ で，最大値は $\theta=1$ で取れることが確認できました。

### 数値積分で $\int_0^{2\pi} \sin(\cos x - x)\, dx$ を求める

中辺の積分を `QuadGK.jl` パッケージで数値積分して，その値を求めます。

```julia
using QuadGK

7π/8, quadgk(x->sin(cos(x)-x), 0, 2π)[1], 7π/8 + 4M
```

```
(2.748893571891069, 2.7649193747683367, 2.7814441777893215)
```

$\dfrac{7\pi}{8} \approx 2.749$，積分値 $\approx 2.765$，$\dfrac{7\pi}{8} + 4M \approx 2.781$ となりました。

### 不等式をJuliaで直接確認する

```julia
7π/8 ≤ quadgk(x->sin(cos(x)-x), 0, 2π)[1] ≤ 7π/8 + 4M
```

```
true
```

不等式 $\dfrac{7\pi}{8} \leqq \displaystyle\int_0^{2\pi} \sin(\cos x - x)\, dx \leqq \dfrac{7\pi}{8} + 4M$ が成立していることが数値的に確認できました。

### $g(x) = \sin(\cos x - x)$ のグラフを描く

最後に，被積分関数 $g(x) = \sin(\cos x - x)$ のグラフを描いておきます。

```julia
g(x) = sin(cos(x) - x)

x = 0:0.01:4π

fig = Figure(fonts=(; regular="Hiragino Sans", bold="Hiragino Sans"))

ax = Axis(fig[1, 1],
    xlabel=L"x",
    ylabel=L"y",
)
lines!(ax, x, g.(x), label=L"y=\sin(\cos x-x)", color=:red)
axislegend(ax, position=:rb)
fig
```

![g(x)のグラフ](/images/u-tokyo-2026-graph1b.png)

## まとめ

- $f(\theta) = \sin\theta - \theta + \dfrac{\theta^3}{6}$ は $[-1, 1]$ で単調増加
- 最大値 $M = f(1) \approx 0.0081$，最小値 $m = f(-1) = -M$
- 数値積分により $\displaystyle\int_0^{2\pi} \sin(\cos x - x)\, dx \approx 2.765$
- 不等式 $\dfrac{7\pi}{8} \leqq \displaystyle\int_0^{2\pi} \sin(\cos x - x)\, dx \leqq \dfrac{7\pi}{8} + 4M$ が成立することを数値的に確認
