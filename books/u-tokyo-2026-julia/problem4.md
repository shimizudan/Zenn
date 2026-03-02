---
title: "第4問：接線がなす正三角形の面積"
---

## 問題

![第4問](/images/u-tokyo-2026-004.png)

## Juliaで考える

### 曲線 $y = x^3 - kx$ と接線のアニメーション

曲線 $C: y = x^3 - kx$ において，原点での接線の傾きは $y'(0) = -k$ です。これと $\pm 60°$ の角度をなす接線を考えます。

`ForwardDiff.jl` を使って導関数を計算し，$k$ を変化させながらアニメーションを描きます。

```julia
using CairoMakie
using ForwardDiff

function draw_frame!(ax, k)
    CairoMakie.empty!(ax)

    f(x)  = x^3 - k * x
    df(x) = ForwardDiff.derivative(f, x)
    xs    = LinRange(-8, 8, 500)

    # 曲線 C（青）
    CairoMakie.lines!(ax, xs, f.(xs), color=:steelblue, linewidth=2.5)

    # 原点接線（黒実線）
    CairoMakie.lines!(ax, xs, df(0) .* xs, color=:black, linewidth=1.5)

    # ±60° の接線（赤・緑）
    θ = atan(df(0))
    for (Δθ, col) in [(π/3, :crimson), (-π/3, :forestgreen)]
        m = tan(θ + Δθ)
        v = (m + k) / 3
        v > 1e-10 || continue
        for s in (1, -1)
            a  = s * sqrt(v)
            ys = [df(a) * (x - a) + f(a) for x in xs]
            CairoMakie.lines!(ax, xs, ys, color=col, linewidth=1.5)
        end
    end

    CairoMakie.xlims!(ax, -3, 3)
    CairoMakie.ylims!(ax, -3, 3)
    ax.title[] = "y = x³ - kx   (k = $(round(k, digits=2)))"
end

# k を -1 → 5 の100フレーム（サイズ削減のため）
ks = LinRange(-1.0, 5.0, 100)

fig = CairoMakie.Figure(size=(400, 400))
ax  = CairoMakie.Axis(fig[1, 1], xlabel="x", ylabel="y", aspect=DataAspect())

CairoMakie.record(fig, "tangent_animation.gif", ks; framerate=12) do k
    draw_frame!(ax, k)
end

#VSCodeの.ipynbファイルで表示する場合
using Base64

gif_b64 = open("tangent_animation.gif", "r") do io
    base64encode(read(io))
end

display("text/html", """
<img src="data:image/gif;base64,$gif_b64" style="max-width:600px; height:auto;">
""")
```

![接線のアニメーション](/images/tangent_animation.gif)

$k$ が変化すると，3本の接線の交点がなす三角形の形が変わることがわかります。

### 4 つの正三角形の面積を計算する

3本の接線が作る交点から三角形の面積を計算します。`Roots.jl` で $M = 4m$ となる $k$ を二分法で求めます。

```julia
using CairoMakie

# 2直線の交点
function intersect_lines(m1, b1, m2, b2)
    x = (b2 - b1) / (m1 - m2)
    return x, m1 * x + b1
end

# 3点から三角形の面積
function triangle_area(p1, p2, p3)
    return 0.5 * abs((p2[1]-p1[1])*(p3[2]-p1[2]) - (p3[1]-p1[1])*(p2[2]-p1[2]))
end

# 4つの正三角形の面積の最大値 M と最小値 m
function Mm(k)
    m₀ = -k
    θ  = atan(m₀)
    m₊ = tan(θ + π/3)
    m₋ = tan(θ - π/3)

    v₊ = (m₊ + k) / 3
    v₋ = (m₋ + k) / 3
    (v₊ > 0 && v₋ > 0) || return NaN, NaN

    a₁ = sqrt(v₊)
    a₂ = sqrt(v₋)

    b₁, b₂ = -2a₁^3, 2a₁^3
    c₁, c₂ = -2a₂^3, 2a₂^3

    areas = [
        triangle_area(
            intersect_lines(m₀, 0.0, m₊, b),
            intersect_lines(m₀, 0.0, m₋, c),
            intersect_lines(m₊, b,   m₋, c)
        )
        for b in (b₁, b₂), c in (c₁, c₂)
    ]

    return maximum(areas), minimum(areas)
end
```

### $M = 4m$ となる $k$ を求める

```julia
using Roots

k_star = find_zero(k -> Mm(k)[1] - 4*Mm(k)[2], (1/sqrt(3)+0.01, 3.0))
println("M = 4m となる k ≈ ", round(k_star, digits=6))
```

```
M = 4m となる k ≈ 0.721688
```

### $M(k)$ と $m(k)$ のグラフ

```julia
ks = LinRange(1/sqrt(3) + 0.01, 3.0, 1000)
Ms = [Mm(k)[1] for k in ks]
ms = [Mm(k)[2] for k in ks]

fig = CairoMakie.Figure(size=(700, 500))
ax  = CairoMakie.Axis(fig[1, 1], xlabel="k", ylabel="面積", title="M(k) と m(k)（4つの正三角形の面積）")
CairoMakie.lines!(ax, ks, Ms, color=:crimson,     linewidth=2, label="M(k)（最大面積）")
CairoMakie.lines!(ax, ks, ms, color=:forestgreen, linewidth=2, label="m(k)（最小面積）")
CairoMakie.vlines!(ax, [k_star], color=:orange, linewidth=2, linestyle=:dash,
                   label="M=4m  (k≈$(round(k_star,digits=3)))")
CairoMakie.axislegend(ax)
fig
```

![M(k)とm(k)のグラフ](/images/u-tokyo-2026-graph4.png)

$k$ が大きくなるにつれて最大面積と最小面積の差が広がり，オレンジの破線で示した $k^\star$ で $M = 4m$ となります。

### $k = k^\star$ のときの接線の様子

```julia
using CairoMakie
using ForwardDiff

k_ex  = k_star   # M = 4m となる k（≈ 0.722）
f(x)  = x^3 - k_ex * x
df(x) = ForwardDiff.derivative(f, x)
xs    = LinRange(-3, 3, 500)

fig2 = CairoMakie.Figure(size=(600, 600))
ax2  = CairoMakie.Axis(fig2[1, 1], xlabel="x", ylabel="y", aspect=DataAspect(),
            title="y = x³ - k*x  (M = 4m となる k ≈ $(round(k_star, digits=3)))",
            limits=(-3, 3, -3, 3))

# 曲線 C
CairoMakie.lines!(ax2, xs, f.(xs), color=:steelblue, linewidth=2.5, label="曲線 C")

# 原点での接線（傾き df(0) = -k）
CairoMakie.lines!(ax2, xs, df(0) .* xs, color=:black, linewidth=1.5, label="原点の接線")

# ±60° の接線（各2本）
θ0 = atan(df(0))
for (Δθ, col, lab) in [(π/3, :crimson, "+60°接線"), (-π/3, :forestgreen, "-60°接線")]
    m = tan(θ0 + Δθ)
    v = (m + k_ex) / 3
    v > 1e-10 || continue
    first = true
    for s in (1, -1)
        a  = s * sqrt(v)
        b  = f(a) - df(a) * a   # y切片
        ys = [df(a) * x + b for x in xs]
        CairoMakie.lines!(ax2, xs, ys, color=col, linewidth=1.5,
                          label=first ? lab : nothing)
        first = false
    end
end
CairoMakie.axislegend(ax2, position=:lt)
fig2
```

![接線の様子](/images/u-tokyo-2026-graph4b.png)

## まとめ

- 曲線 $y = x^3 - kx$ において，原点での接線と $\pm 60°$ をなす接線が2本ずつ存在する（$k > \dfrac{1}{\sqrt{3}}$ のとき）
- これら3本ずつの接線の組み合わせにより，4つの三角形が作られる
- 最大面積 $M$ と最小面積 $m$ の比が $M = 4m$ となる $k$ を数値的に求めた

:::message
アニメーション（`tangent_animation.gif`）では $k$ を変化させながら接線の動きが確認できます。$k$ が $\dfrac{1}{\sqrt{3}}$ を超えたとき初めて $\pm 60°$ の接線が現れることも視覚的にわかります。
:::
