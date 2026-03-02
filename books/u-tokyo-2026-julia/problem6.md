---
title: "第6問：約数と3で割った余り"
---

## 問題

![第6問](/images/u-tokyo-2026-006.png)

## 問題の設定

正の整数 $n$ の約数のうち，3 で割って **1 余る**ものの個数を $f(n)$，**2 余る**ものの個数を $g(n)$ とします。

例えば $n = 6$ の約数は $1, 2, 3, 6$ であり：
- $1 \equiv 1 \pmod{3}$，$6 \equiv 0 \pmod{3}$，$3 \equiv 0 \pmod{3}$，$2 \equiv 2 \pmod{3}$
- よって $f(6) = 1$（約数 $1$），$g(6) = 1$（約数 $2$）

## Juliaで考える

### $f(n)$，$g(n)$ を求める関数

```julia
# 約数を列挙
function divisors(n::Int)
    divs = Int[]
    for i in 1:isqrt(n)
        if n % i == 0
            push!(divs, i)
            if i != div(n, i)
                push!(divs, div(n, i))
            end
        end
    end
    return divs
end

# f(n), g(n) を求める
function fg(n::Int)
    f = 0
    g = 0
    for d in divisors(n)
        r = d % 3
        if r == 1
            f += 1
        elseif r == 2
            g += 1
        end
    end
    return f, g
end
```

### $n = 2800$ での確認

```julia
println(fg(2800))
```

```
(16, 14)
```

$n = 2800$ のとき，$f(2800) = 16$，$g(2800) = 14$ です。

### $f(n)$ と $g(n)$ のグラフ

$n = 1$ から $100$ までの $f(n)$，$g(n)$ を折線グラフで描きます。

```julia
using CairoMakie

N = 100
ns = collect(1:N)
fs = Int[]
gs = Int[]

for n in ns
    f, g = fg(n)
    push!(fs, f)
    push!(gs, g)
end

fig = CairoMakie.Figure(size=(800, 500))
ax = CairoMakie.Axis(fig[1, 1], xlabel="n", ylabel="個数",
                      title="f(n) と g(n) のグラフ（n = 1 〜 100）")
CairoMakie.lines!(ax, ns, fs, label="f(n)（3で割って1余る約数の個数）",
                  linewidth=1.5, color=:steelblue)
CairoMakie.lines!(ax, ns, gs, label="g(n)（3で割って2余る約数の個数）",
                  linewidth=1.5, color=:crimson)
CairoMakie.axislegend(ax, position=:lt)
fig
```

![f(n)とg(n)のグラフ](/images/u-tokyo-2026-graph6.png)

折線グラフを見ると，$f(n)$ と $g(n)$ の値は $n$ によって大きく変動しますが，全体的に $f(n) \geqq g(n)$ の傾向が見えます。

$f(n) - g(n)$ の差を描くと，その構造がよりはっきりします。

```julia
diffs = fs .- gs
fig2 = CairoMakie.Figure(size=(800, 400), fonts=(; regular="Hiragino Sans", bold="Hiragino Sans"))
ax2 = CairoMakie.Axis(fig2[1, 1], xlabel="n", ylabel="f(n) - g(n)",
                       title="f(n) - g(n) のグラフ（n = 1 〜 100）")
CairoMakie.lines!(ax2, ns, diffs, linewidth=1.5, color=:purple)
CairoMakie.hlines!(ax2, [0], color=:black, linewidth=0.8)
fig2
```

![f(n)-g(n)のグラフ](/images/u-tokyo-2026-graph6b.png)

### $g(n) = G$ のときに取り得る $f(n)$ の値

$g(n) = G$（固定）のとき，$f(n)$ はどのような値を取り得るかを調べます。

```julia
function possible_f_values(G::Int)
    S = Set{Int}()
    twoG = 2G

    # 約数列挙
    divisors = Int[]
    for a in 1:twoG
        if twoG % a == 0
            push!(divisors, a)
        end
    end

    # Case 1: f = g のケース
    for A in divisors
        B = div(twoG, A)
        if iseven(B)
            push!(S, G)
        end
    end

    # Case 2: f = g + A のケース
    for A in divisors
        t = div(twoG, A)
        B = t + 1
        if iseven(t) && B > 1
            push!(S, G + A)
        end
    end

    return sort!(collect(S))
end

println(possible_f_values(15))
```

```
[15, 16, 18, 20, 30]
```

$g(n) = 15$ のとき，$f(n)$ は $\{15, 16, 18, 20, 30\}$ のいずれかの値を取り得ます。

### いくつかの $G$ での結果

| $G$ | $f(n)$ の取り得る値 |
|---|---|
| 1 | $[1, 2]$ |
| 2 | $[2, 3, 4]$ |
| 3 | $[3, 4, 6]$ |
| 4 | $[4, 5, 6, 8]$ |
| 5 | $[5, 6, 10]$ |
| 15 | $[15, 16, 18, 20, 30]$ |

### 別解：乗法性を使った再帰探索

$f(n)$，$g(n)$ の乗法性を利用した別アプローチです。

#### 数学的背景

$\gcd(a, b) = 1$ のとき，$ab$ の約数は $d_1 d_2$（$d_1 \mid a$，$d_2 \mid b$）の形に一意に分解され，$d_1 d_2 \bmod 3$ は $d_1 \bmod 3$ と $d_2 \bmod 3$ の積で決まります（$1 \times 1 \equiv 1$，$2 \times 2 \equiv 1$，$1 \times 2 \equiv 2$）。よって：

$$f(ab) = f(a)f(b) + g(a)g(b), \quad g(ab) = f(a)g(b) + g(a)f(b)$$

出発点は $\bigl(f(1),\, g(1)\bigr) = (1, 0)$ です。

#### 3種類の操作

互いに素な素数冪を掛けることで $(f, g)$ を更新できます。

| 操作 | 掛ける素数冪 | $(f, g)$ の変換 |
|---|---|---|
| Op 1 | $p^{k-1}$（$p \equiv 1 \pmod{3}$）| $(kf,\; kg)$ |
| Op 2 | $p^{2k-1}$（$p \equiv 2 \pmod{3}$，奇数乗）| $(k(f+g),\; k(f+g))$ |
| Op 3 | $p^{2k}$（$p \equiv 2 \pmod{3}$，偶数乗）| $(k(f+g)+f,\; k(f+g)+g)$ |

- **Op 1**：$p \equiv 1$ の素数冪の約数はすべて $\equiv 1$ なので $f(p^{k-1})=k$，$g(p^{k-1})=0$
- **Op 2**：奇数乗では $\equiv 1$ の約数と $\equiv 2$ の約数が同数（$k$ 個ずつ）
- **Op 3**：偶数乗では $\equiv 1$ の約数が $k+1$ 個，$\equiv 2$ の約数が $k$ 個

#### 再帰探索コード

$(1, 0)$ を起点に 3 つの操作を深さ優先で繰り返し，$g = 15$ に到達したときの $f$ を記録します。

```julia
results = Int[]

function search!(results, f, g)
    # Op1: p≡1 mod 3 の素数の k-1 乗を掛ける → (k*f, k*g)
    for k in 2:100
        nf, ng = k*f, k*g
        if nf > 50 || ng > 15
            break
        elseif ng == 15
            push!(results, nf); break
        else
            search!(results, nf, ng)
        end
    end

    # Op2: p≡2 mod 3 の素数の奇数乗 p^(2k-1) を掛ける → (k*(f+g), k*(f+g))
    for k in 1:100
        s = k*(f+g)
        if s > 15
            break
        elseif s == 15
            push!(results, s); break
        else
            search!(results, s, s)
        end
    end

    # Op3: p≡2 mod 3 の素数の偶数乗 p^(2k) を掛ける → (k*(f+g)+f, k*(f+g)+g)
    for k in 1:100
        nf, ng = k*(f+g)+f, k*(f+g)+g
        if nf > 50 || ng > 15
            break
        elseif ng == 15
            push!(results, nf); break
        else
            search!(results, nf, ng)
        end
    end
end

search!(results, 1, 0)
println("g = 15 となるときの f の値のリスト:")
println(sort(unique(results)))
```

```
g = 15 となるときの f の値のリスト:
[15, 16, 18, 20, 30]
```

先の `possible_f_values(15)` と同じ結果が得られます。各値に対応する探索経路の例：

| $f$ | 経路（操作列）|
|---|---|
| $15$ | $(1,0) \xrightarrow{\text{Op2}, k=15} (15,15)$ |
| $16$ | $(1,0) \xrightarrow{\text{Op3}, k=15} (16,15)$ |
| $18$ | $(1,0) \xrightarrow{\text{Op1}, k=3} (3,0) \xrightarrow{\text{Op3}, k=5} (18,15)$ |
| $20$ | $(1,0) \xrightarrow{\text{Op1}, k=5} (5,0) \xrightarrow{\text{Op3}, k=3} (20,15)$ |
| $30$ | $(1,0) \xrightarrow{\text{Op1}, k=15} (15,0) \xrightarrow{\text{Op3}, k=1} (30,15)$ |

## まとめ

- 約数を3で割った余りで分類することで，$f(n)$ と $g(n)$ を定義
- $n = 2800$ のとき $f(2800) = 16$，$g(2800) = 14$
- $g(n) = G$ を固定したとき，$f(n)$ の取り得る値は $G$ の約数構造に依存する
- $f(n) \geqq g(n)$ が常に成立する（直感的に，$1 \equiv 1 \pmod{3}$ が常に約数なので $f(n) \geqq 1$，一方 $g(n)$ は 0 になることもある）

:::message
この問題の核心は，$f(n)$ と $g(n)$ の差 $f(n) - g(n)$ が乗法的関数であることにあります。Julia でのシミュレーションにより，その性質を数値的に確認できます。
:::
