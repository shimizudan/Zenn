---
title: "多数決で生き残るのは何人か？"
emoji: "🚃"
type: "idea"
topics: [julia, 数学, 確率, シミュレーション, 統計]
published: true
---

https://x.com/dannchu/status/2037803031862071797

> 生徒のリーダーシップ研修（シンガポール）で様子を見ていたら，「トロッコ問題」のトピックがありました。そのことを考えていた時に次のような問題に辿り着きました。（有名な話なのかな？） #数学の問題
>
> **トロッコ問題を考えていたらこんな問題になりました。**
>
> 人が $n$ 人います。みんなで同時に、コインを投げて「表」か「裏」を決めます。
> - 多い方のグループだけが残ります
> - 少ない方はいなくなります
> - もし同じ人数なら、全員そのまま残ります
>
> これを何回もくり返します。さいごに残る人数は、何人になるでしょうか？
> （興味がある人は，何回繰り返したら最後の人数になるのかシミュレーションしてみよう！）
>
> — 清水 団 Dan Shimizu (@dannchu) 2026年3月28日

---

## 問題

人が $n$ 人います。みんなで同時に、コインを投げて「表」か「裏」を決めます。

- 多い方のグループだけが残ります
- 少ない方はいなくなります
- もし同じ人数なら、全員そのまま残ります

これを何回もくり返します。さいごに残る人数は、何人になるでしょうか？

---

## シミュレーション実装

### 1回のシミュレーション

まず1回のシミュレーション（$n$ 人からスタート）を実装します。ルールは「多数派が残る、同数なら全員残って次ラウンドへ」。最終的に残る人数と、かかったラウンド数を返します。

**収束の判定方法：** 人数が変化しなくなった時点を「収束」とみなしますが、タイ（同数）が偶然連続することもあるため、「同じ値が連続して `stable_threshold` 回続いたら収束」と判定します。ここでは `stable_threshold=100` としています。ただし、その判定のために費やした100回分はラウンド数から引き、**実際に人数が変化し続けた最小のラウンド数**を返します。

```julia
function simulate_once(n::Int; stable_threshold::Int=100)
    rounds = 0
    current = n
    stable_count = 0
    while stable_count < stable_threshold
        count_heads = sum(rand(0:1, current))
        count_tails = current - count_heads
        rounds += 1
        next = if count_heads > count_tails
            count_heads     # 表が多数派 → 裏を除外
        elseif count_tails > count_heads
            count_tails     # 裏が多数派 → 表を除外
        else
            current         # 同数（タイ）→ 全員残る
        end
        stable_count = (next == current) ? stable_count + 1 : 0
        current = next
    end
    # 収束判定の100回分を引いて、値が変化し続けた実際のラウンド数を返す
    return current, rounds - stable_threshold
end

# テスト
for n in [3, 5, 10, 20]
    final, rounds = simulate_once(n)
    println("n=$n → 最終人数: $final 人（$rounds ラウンド）")
end
```

```
n=3 → 最終人数: 2 人（1 ラウンド）
n=5 → 最終人数: 2 人（2 ラウンド）
n=10 → 最終人数: 2 人（6 ラウンド）
n=20 → 最終人数: 2 人（9 ラウンド）
```

どのケースでも最終人数は **2人** になっています。

---

### 多数回シミュレーションによる統計

```julia
using Statistics

# 複数回シミュレーションして統計を取る
function simulate_many(n::Int, trials::Int=10000)
    final_counts = Int[]
    round_counts = Int[]
    for _ in 1:trials
        fc, rc = simulate_once(n)
        push!(final_counts, fc)
        push!(round_counts, rc)
    end
    return final_counts, round_counts
end

n = 10
trials = 10000
final_counts, round_counts = simulate_many(n, trials)

println("n=$n, 試行回数=$trials")
println("最終人数の平均: ", round(mean(final_counts), digits=3))
println("ラウンド数の平均: ", round(mean(round_counts), digits=3))
println("ラウンド数の最大: ", maximum(round_counts))
```

```
n=10, 試行回数=10000
最終人数の平均: 2.0
ラウンド数の平均: 6.075
ラウンド数の最大: 19
```

$n = 10$ の場合、最終人数は **常に2人**、ラウンド数の平均は約 **6回** です。

---

### n を変えてラウンド数の期待値を調べる

```julia
# n を変えてラウンド数の期待値を調べる（最終人数は n≥2 なら常に 2）
ns = 2:2:30
trials = 20000

println("n  | ラウンド数の平均 | ラウンド数の最大")
println("---|-----------------|----------------")
for n in ns
    _, rc = simulate_many(n, trials)
    avg_rounds = round(mean(rc), digits=2)
    max_rounds = maximum(rc)
    println("$n  | $avg_rounds             | $max_rounds")
end
```

```
n  | ラウンド数の平均 | ラウンド数の最大
---|-----------------|----------------
2  | 0.0             | 0
4  | 3.32             | 15
6  | 4.78             | 18
8  | 5.1              | 17
10  | 6.06             | 20
12  | 6.04             | 23
14  | 6.5              | 22
16  | 6.73             | 20
18  | 7.18             | 20
20  | 7.15             | 23
22  | 7.37             | 22
24  | 7.47             | 25
26  | 7.73             | 23
28  | 7.81             | 22
30  | 8.04             | 22
```

$n$ が増えるにつれてラウンド数の期待値も増加しますが、対数的な増加であることがわかります。

---

## 可視化

### ラウンド数の分布（n=20）

```julia
using Plots, PlotsGRBackendFontJaEmoji

# ラウンド数の分布を可視化（n=20の場合）
n = 20
trials = 50000
_, round_counts = simulate_many(n, trials)

histogram(round_counts,
    bins=range(0.5, maximum(round_counts)+0.5, step=1),
    xlabel="ラウンド数",
    ylabel="確率",
    title="ラウンド数の分布 (n=$n, 試行=$trials)\n最終人数は常に 2 人",
    legend=false,
    color=:steelblue,
    normalize=:probability,
    size=(700, 400))
```

![ラウンド数の分布 (n=20)](/images/trolley_round_dist.png)

$n = 20$ のとき、ラウンド数の分布はおよそ **5〜10回** に集中しており、右に長い裾を持っています。

---

### n とラウンド数の期待値の関係

```julia
# n とラウンド数の期待値の関係をグラフ化
ns = 2:50
trials = 10000

avg_rounds_list = Float64[]

for n in ns
    _, rc = simulate_many(n, trials)
    push!(avg_rounds_list, mean(rc))
end

plot(ns, avg_rounds_list,
    xlabel="初期人数 n",
    ylabel="ラウンド数の期待値",
    title="n とラウンド数の期待値\n（最終人数は n≥2 で常に 2 人）",
    legend=false,
    lw=2,
    color=:steelblue,
    marker=:circle,
    markersize=3,
    size=(700, 400))
```

![n とラウンド数の期待値](/images/trolley_expected_rounds.png)

$n$ の増加に対してラウンド数の期待値が対数的に増加していることがよくわかります。

---

### 対数関数へのフィッティング

各ラウンドで約 $n/2$ 人が残るので、$t$ ラウンド後には $n/2^t$ 人が残ります。$n/2^t = 2$ を解くと

$$t = \log_2 n - 1 \approx \log_2 n$$

タイのラウンドは人数が減らないため、定数項 $b$ でその影響を補正します。

```julia
# 対数関数へのフィッティング
ns_fit = collect(3:100)
trials_fit = 20000

avg_rounds_fit = Float64[]
for n in ns_fit
    _, rc = simulate_many(n, trials_fit)
    push!(avg_rounds_fit, mean(rc))
end

# log₂(n) にフィット：E[rounds] ≈ a * log₂(n) + b
log2_ns = log2.(ns_fit)
A = hcat(log2_ns, ones(length(log2_ns)))   # 設計行列
coeffs = A \ avg_rounds_fit                  # 最小二乗法
a, b = coeffs
println("フィット結果：E[ラウンド数] ≈ $(round(a, digits=3)) × log₂(n) + $(round(b, digits=3))")

using Plots
p = scatter(ns_fit, avg_rounds_fit,
    label="シミュレーション",
    xlabel="初期人数 n",
    ylabel="ラウンド数の期待値",
    title="ラウンド数の期待値と対数フィット",
    markersize=3, color=:steelblue, alpha=0.6)

plot!(p, ns_fit, a .* log2_ns .+ b,
    label="$(round(a,digits=2)) × log₂(n) + $(round(b,digits=2))",
    lw=2, color=:red)

plot!(p, ns_fit, log2.(ns_fit) .- 1,
    label="log₂(n) − 1（理論値）",
    lw=2, color=:green, linestyle=:dash,
    size=(700, 450))
```

![ラウンド数の期待値と対数フィット](/images/trolley_log_fit.png)

フィッティング結果から、ラウンド数の期待値は $\log_2 n$ に比例することが確認でき、理論値 $\log_2 n - 1$ ともよく一致しています。

---

### 人数の推移の例（n=30）

```julia
# 1試行の人数推移を可視化
function simulate_trace(n::Int; stable_threshold::Int=100)
    history = [n]
    current = n
    stable_count = 0
    while stable_count < stable_threshold
        count_heads = sum(rand(0:1, current))
        count_tails = current - count_heads
        next = if count_heads > count_tails
            count_heads
        elseif count_tails > count_heads
            count_tails
        else
            current
        end
        stable_count = (next == current) ? stable_count + 1 : 0
        current = next
        if stable_count == 0  # 値が変化したときだけ記録
            push!(history, current)
        end
    end
    return history
end

# 8回分の軌跡を重ね書き
n = 30
plt = plot(title="人数の推移の例 (n=$n)",
           xlabel="ラウンド", ylabel="残り人数",
           legend=:topright, size=(700, 400))

for i in 1:8
    trace = simulate_trace(n)
    plot!(plt, 0:length(trace)-1, trace, label="試行$i", lw=1.5, marker=:circle, markersize=4)
end

plt
```

![人数の推移の例 (n=30)](/images/trolley_trace.png)

各試行で減り方のスピードは異なりますが、全て最終的には2人に収束します。急激に減る試行もあれば、タイが続いてなかなか減らない試行もあることがわかります。

---

## まとめ

このシミュレーションから以下のことがわかりました：

| 項目 | 結果 |
|------|------|
| 最終人数 | **常に2人**（$n \geq 2$ のとき） |
| ラウンド数の期待値 | $\approx \log_2 n$（対数的増加） |
| 理論値 | $\log_2 n - 1$ |

- **最終人数は常に2人**になります（同数タイのルールにより1人にはなりません）
- ラウンド数の期待値は $\log_2 n$ に近く、**初期人数が2倍になるとラウンドが約1回増える**程度です
- タイのラウンドがあるため、理論値 $\log_2 n - 1$ より実際のラウンド数はやや多くなります
