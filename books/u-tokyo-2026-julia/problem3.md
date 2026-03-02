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
# 中点 M = (a, b) = (3-2cosθ, -2sinθ)
# PQ は x²+y²=25 の弦で M を中点とする
function compute_PQ(θ)
    a = 3 - 2cos(θ)
    b = -2sin(θ)
    t_sq = 12 * (1 + cos(θ))   # t² = 25 - |M|²
    t_sq < 1e-8 && return nothing   # θ≈π は P=Q となり不適
    norm_M = sqrt(a^2 + b^2)
    t = sqrt(t_sq)
    # M から OM に垂直方向 ±t だけ移動
    Px = a - t * b / norm_M;  Py = b + t * a / norm_M
    Qx = a + t * b / norm_M;  Qy = b - t * a / norm_M
    return (Px, Py, Qx, Qy)
end

# ── (2) アニメーション: 線分PQを変化させながら塗りつぶす ──────────────

# 全PQセグメントを事前計算
n_segs = 300
θ_vals  = [θ for θ in LinRange(0.04, 4π - 0.04, n_segs) if abs(θ - π) > 0.08]
segs    = filter(!isnothing, [compute_PQ(θ) for θ in θ_vals])
N       = length(segs)

# Figure を作成
fig_anim = Figure(size=(600, 600))
ax_a = Axis(fig_anim[1, 1],
    aspect  = DataAspect(),
    title   = "(2) 線分PQが通過する範囲（アニメーション）",
    xlabel  = L"x", ylabel = L"y",
    limits  = (-6.5, 6.5, -6.5, 6.5))

# 静的要素: 大円 と Mの軌跡（破線）
lines!(ax_a, 5cos.(circle_θ), 5sin.(circle_θ), color=:black, linewidth=2)
lines!(ax_a, 3 .+ 2cos.(circle_θ), 2sin.(circle_θ),
    color=(:gray, 0.45), linewidth=1, linestyle=:dash)

# 動的要素: Observable で管理
acc_pts = Observable(Point2f[])          # 蓄積された線分（青・透明）
cur_pts = Observable([Point2f(0,0), Point2f(0,0)])  # 現在の線分（赤）
mid_pt  = Observable([Point2f(3, 0)])    # 現在の中点 M（赤丸）

lines!(ax_a, acc_pts, color=(:steelblue, 0.28), linewidth=1.5)
lines!(ax_a, cur_pts, color=:red, linewidth=3)
scatter!(ax_a, mid_pt, color=:red, markersize=9)

# GIF として保存 (pq_animation.gif)
record(fig_anim, "pq_animation.gif", 1:N; framerate=10) do i
    Px, Py, Qx, Qy = segs[i]

    # 蓄積リストに追加（NaN で線分を区切る）
    push!(acc_pts[], Point2f(Px, Py), Point2f(Qx, Qy), Point2f(NaN, NaN))
    notify(acc_pts)

    # 現在の PQ と中点 M を更新
    cur_pts[] = [Point2f(Px, Py), Point2f(Qx, Qy)]
    mid_pt[]  = [Point2f((Px+Qx)/2, (Py+Qy)/2)]
end

println("✓ GIF 保存完了: pq_animation.gif")

#VSCodeの.ipynbファイルで表示する場合
using Base64

gif_b64 = open("pq_animation.gif", "r") do io
    base64encode(read(io))
end

display("text/html", """
<img src="data:image/gif;base64,$gif_b64" style="max-width:600px; height:auto;">
""")
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
