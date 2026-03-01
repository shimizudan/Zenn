---
title: "第5問：複素数変換 $w=(z-\\alpha)^3$"
---

## 問題

![第5問](/images/u-tokyo-2026-005.png)

## Juliaで考える

### 複素数変換 $w = (z - \alpha)^3$ を可視化する

単位円 $C: |z|=1$ 上の点 $z$ を $w = (z - \alpha)^3$ で変換したとき，$w$ がどのような図形を描くかを調べます。まず $\alpha = -3$ として可視化します。

同心円をどのように変換するかを確認します。

```julia
using CairoMakie

α = -3.0 + 0.0im

# 同心円の半径と角度
rs = 0.5:0.5:5.0
θs = LinRange(0, 2π, 600)

colors = cgrad(:turbo, length(rs))

fig = CairoMakie.Figure(size=(1000, 500))
ax1 = CairoMakie.Axis(fig[1, 1], title="z-plane (concentric circles)",
                       xlabel="Re(z)", ylabel="Im(z)", aspect=DataAspect())
ax2 = CairoMakie.Axis(fig[1, 2], title="w-plane  w = (z - α)³,  α = $α",
                       xlabel="Re(w)", ylabel="Im(w)", aspect=DataAspect())

for (i, r) in enumerate(rs)
    zs = r .* exp.(im .* θs)    # z-平面上の同心円
    ws = (zs .- α).^3           # w = (z - α)³ で変換

    col = colors[i / length(rs)]
    CairoMakie.lines!(ax1, real.(zs), imag.(zs), color=col, linewidth=1.5)
    CairoMakie.lines!(ax2, real.(ws), imag.(ws), color=col, linewidth=1.5)
end
```

![同心円の変換](/images/u-tokyo-2026-graph5a.png)

### 単位円 $|z|=1$ の像を描く

```julia
α = -3.0 + 0.0im
θs = LinRange(0, 2π, 600)

zs = exp.(im .* θs)        # |z| = 1 の円
ws = (zs .- α).^3          # w = (z - α)³ で変換

fig = CairoMakie.Figure(size=(1000, 500))
ax1 = CairoMakie.Axis(fig[1, 1], title="z-plane  |z| = 1",
                       xlabel="Re(z)", ylabel="Im(z)", aspect=DataAspect())
ax2 = CairoMakie.Axis(fig[1, 2], title="w-plane  w = (z - α)³,  α = $α",
                       xlabel="Re(w)", ylabel="Im(w)", aspect=DataAspect())

CairoMakie.lines!(ax1, real.(zs), imag.(zs), color=:steelblue, linewidth=2)
CairoMakie.lines!(ax2, real.(ws), imag.(ws), color=:crimson, linewidth=2)
```

![単位円の像](/images/u-tokyo-2026-graph5b.png)

### $\sin(\arg(w))$ の最大値を求める

$z = e^{it}$（$t \in [0, 2\pi]$）として，$w = (z + 3)^3$ の偏角の正弦 $\sin(\arg(w))$ の最大値・最小値を数値で確認します。

```julia
α  = -3.0 + 0.0im
ts = LinRange(0, 2π, 10000)

zs = exp.(im .* ts)          # |z| = 1
ws = (zs .- α).^3            # w = (z + 3)³

sinθ = imag.(ws) ./ abs.(ws) # sin(arg(w))

println("数値的な最大値 : ", maximum(sinθ))
println("数値的な最小値 : ", minimum(sinθ))
```

```
数値的な最大値 : 0.8518518518518519
数値的な最小値 : -0.8518518518518519
```
- $0.8518518518518519=23/27$ です。
  
### $\sin(\arg(w))$ のグラフ

```julia
fig = CairoMakie.Figure(size=(700, 350))
ax  = CairoMakie.Axis(fig[1, 1], xlabel="t", ylabel="sin(arg(w))",
                       title="sin(arg(w))  (|z|=1, w=(z+3)³)")
CairoMakie.lines!(ax, ts, sinθ, color=:steelblue, linewidth=2)
CairoMakie.hlines!(ax, [ 23/27], color=:crimson,     linewidth=1.5, linestyle=:dash, label=" 23/27")
CairoMakie.hlines!(ax, [-23/27], color=:forestgreen, linewidth=1.5, linestyle=:dash, label="-23/27")
CairoMakie.axislegend(ax, position=:rb)
fig
```

![sin(arg(w))のグラフ](/images/u-tokyo-2026-graph5c.png)


### D が正・負の実軸と共有点を持つ $\alpha$ の範囲

```julia
function in_region(α; N=400)
    ts  = LinRange(0, 2π, N+1)
    ws  = (exp.(im .* ts) .- α).^3
    imw = imag.(ws)
    rew = real.(ws)

    pos = false; neg = false
    for i in 1:N
        if imw[i] * imw[i+1] < 0
            f  = -imw[i] / (imw[i+1] - imw[i])
            rc = rew[i] + f * (rew[i+1] - rew[i])
            rc > 0 ? (pos = true) : (neg = true)
        end
        pos && neg && return true
    end
    return pos && neg
end
```

ヒートマップで $\alpha$ の範囲を可視化すると，単位円 $C$ の内部に $\alpha$ がある場合と外部にある場合で像の形が大きく異なることがわかります。

![αの範囲ヒートマップ](/images/u-tokyo-2026-graph5d.png)

## まとめ

- $w = (z + 3)^3$（$|z| = 1$）として，$\sin(\arg(w))$ の最小値は $-0.8518518518518519$，最大値は $0.8518518518518519$。
- Julia の複素数演算で，変換の様子をリアルタイムで可視化できる

:::message
Julia では複素数が標準でサポートされており，`im` が虚数単位です。`exp.(im .* θs)` のように書くことで単位円上の点を簡単に表現できます。
:::
