---
title: "第3問：球面上の3点と線分の通過範囲"
---

## 問題

![第3問](/images/u-tokyo-2026-003.png)

## 問題の設定を整理する

- $\text{P} = (x_1, y_1, 0)$，$\text{Q} = (x_2, y_2, 0)$：球面 $x^2+y^2+z^2=25$ 上かつ $xy$ 平面上
- $\text{R} = (x_3, y_3, z_3)$：球面上
- 重心 $\text{G} = (2, 0, 1)$

**重心条件から：**

$$\frac{z_1+z_2+z_3}{3}=1 \implies z_3=3, \quad x_3^2+y_3^2+9=25 \implies x_3^2+y_3^2=16$$

$x_3=4\cos\theta$，$y_3=4\sin\theta$（$\theta \in [0,2\pi)$）とパラメータ表示する．

**$(1)$ 中点 $\text{M}$ の軌跡：**

$$\text{M} = \left(\frac{x_1+x_2}{2}, \frac{y_1+y_2}{2}\right) = \left(3-2\cos\theta,\ -2\sin\theta\right)$$

$$\therefore\quad (x-3)^2 + y^2 = 4 \quad \text{（中心 }(3,0)\text{，半径 2 の円，ただし }(5,0)\text{ を除く）}$$

## Juliaで考える

### (1) 中点 M の軌跡を描く

`CairoMakie.jl` を使って，軌跡を可視化します。

```julia
using CairoMakie, LaTeXStrings

set_theme!(fonts=(; regular="Hiragino Sans", bold="Hiragino Sans"))
circle_θ = LinRange(0, 2π, 500)

fig1 = Figure(size=(520, 520))
ax1 = Axis(fig1[1, 1],
    aspect   = DataAspect(),
    title    = "(1) 線分PQの中点Mの軌跡",
    xlabel   = L"x", ylabel = L"y",
    limits   = (-6.5, 6.5, -6.5, 6.5))

# 球面と xy 平面の交線（半径5の円）
lines!(ax1, 5cos.(circle_θ), 5sin.(circle_θ),
    color=:black, linewidth=2, label=L"x^2+y^2=25")

# 軌跡: (x-3)²+y²=4
lines!(ax1, 3 .+ 2cos.(circle_θ), 2sin.(circle_θ),
    color=:blue, linewidth=2.5, label=L"(x-3)^2+y^2=4")

# 軌跡の中心 (3,0)
scatter!(ax1, [3], [0], color=:blue, markersize=10)
text!(ax1, 3.1, 0.35, text=L"(3,0)", fontsize=13)

# 除外点 (5,0)
scatter!(ax1, [5], [0], color=:red, markersize=13, marker=:xcross)
text!(ax1, 4.6, -0.55, text="(5,0)を除く", fontsize=11)

axislegend(ax1, position=:lt)
fig1
```

![中点Mの軌跡](/images/u-tokyo-2026-graph3a.png)

中点 M の軌跡は，中心 $(3, 0)$，半径 2 の円（ただし $(5, 0)$ を除く）であることが視覚的に確認できます。

### (2) 線分 PQ が通過する範囲のアニメーション

$\theta$ をパラメータとして PQ の端点を計算し，線分が通過する範囲をアニメーションで可視化します。

```julia
# PQ の端点を計算する関数
function compute_PQ(θ)
    a = 3 - 2cos(θ)
    b = -2sin(θ)
    t_sq = 12 * (1 + cos(θ))   # t² = 25 - |M|²
    t_sq < 1e-8 && return nothing
    norm_M = sqrt(a^2 + b^2)
    t = sqrt(t_sq)
    Px = a - t * b / norm_M;  Py = b + t * a / norm_M
    Qx = a + t * b / norm_M;  Qy = b - t * a / norm_M
    return (Px, Py, Qx, Qy)
end

# アニメーションを GIF として保存
record(fig_anim, "pq_animation.gif", 1:N; framerate=10) do i
    # 線分を蓄積しながら描画
    ...
end
```

アニメーションでは，$\theta$ を変化させながら線分 PQ が描かれていく様子を確認できます。

![線分PQのアニメーション](/images/u-tokyo-2026-pq-animation.gif)

## まとめ

- 中点 M の軌跡は $(x-3)^2 + y^2 = 4$（ただし $(5, 0)$ を除く）
- アニメーションにより，線分 PQ が通過する領域を視覚的に確認できる
- $\theta$ をパラメータとすることで，P・Q・R の座標をすべて $\theta$ で表現できる

:::message
$(5, 0)$ の除外は，$\theta = 0$ のとき R = $(4, 0, 3)$ となり，P = Q = $(5, 0, 0)$ となって，3点が一致してしまうためです。
:::
