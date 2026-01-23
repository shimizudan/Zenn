---
title: "リーグ戦でAが優勝する確率：共通テスト2026の確率問題を一般化する"
emoji: "🏆"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ["math", "julia", "probability", "statistics"]
published: true # trueを指定する

---

## はじめに

2026年度大学入学共通テスト「数学I・数学A」の第4問は、リーグ戦形式の大会でAが優勝する確率を求める問題でした。問題では $n=3$ 人と $n=4$ 人の場合を扱っていますが、本記事では一般の $n$ 人の場合に拡張し、理論的な解析と`Julia` によるシミュレーションで検証します。

## 問題設定

:::message
**問題設定**

$n$ 人（A, B, C, ...）でリーグ戦（総当たり戦）を行う。

- Aが対戦相手に勝つ確率は $\dfrac{2}{3}$
- A以外の2人が対戦するとき、勝つ確率はどちらも $\dfrac{1}{2}$
- 各対戦の結果は互いに影響を与えない（独立）
- 引き分けはない

**優勝者の決め方**

勝ち数が一番多い人が1人であれば、その人を優勝者とする。そうでなければ、抽選により勝ち数が一番多い人の中から1人を選ぶ。ただし、勝ち数が一番多い人が $m$ 人であるとき、それぞれの人が選ばれる確率は $\dfrac{1}{m}$ とする。
:::

## n=3の場合（A, B, Cの3人）

### 状況の整理

- 全試合数: $\binom{3}{2} = 3$ 試合（A-B, A-C, B-C）
- Aの対戦数: 2試合

### Aの勝ち数の確率分布

Aが $k$ 勝 $(2-k)$ 敗となる確率は：

$$
P(\text{A が } k \text{ 勝}) = \binom{2}{k} \left(\frac{2}{3}\right)^k \left(\frac{1}{3}\right)^{2-k}
$$

| Aの勝ち数 | 確率 |
|:---:|:---:|
| 2勝0敗 | $\left(\dfrac{2}{3}\right)^2 = \dfrac{4}{9}$ |
| 1勝1敗 | $2 \cdot \dfrac{2}{3} \cdot \dfrac{1}{3} = \dfrac{4}{9}$ |
| 0勝2敗 | $\left(\dfrac{1}{3}\right)^2 = \dfrac{1}{9}$ |

### Aが優勝する確率

**(i) Aが2勝0敗の場合**

Aが全勝すれば、B, Cはそれぞれ最大でも1勝しかできないため、Aが必ず単独優勝します。

$$
P(\text{A が 2勝0敗で優勝}) = \frac{4}{9}
$$

**(ii) Aが1勝1敗の場合**

Aが優勝するには、B, Cも1勝1敗で3人が同率となり、抽選でAが選ばれる必要があります。

全員が1勝1敗になるパターン：
- AがBに勝ち、Cに負け、BがCに勝つ：確率 $\dfrac{2}{3} \cdot \dfrac{1}{3} \cdot \dfrac{1}{2} = \dfrac{1}{9}$
- AがCに勝ち、Bに負け、CがBに勝つ：確率 $\dfrac{1}{3} \cdot \dfrac{2}{3} \cdot \dfrac{1}{2} = \dfrac{1}{9}$

よって、全員1勝1敗になる確率は $\dfrac{2}{9}$

抽選でAが選ばれる確率は $\dfrac{1}{3}$ なので：

$$
P(\text{A が 1勝1敗で優勝}) = \frac{2}{9} \times \frac{1}{3} = \frac{2}{27}
$$

**(iii) Aが0勝2敗の場合**

Aは最下位なので優勝できません。

### n=3でのAが優勝する確率

$$
P_3 = \frac{4}{9} + \frac{2}{27} = \frac{12}{27} + \frac{2}{27} = \frac{14}{27} \approx 0.5185
$$

## n=4の場合（A, B, C, Dの4人）

### 状況の整理

- 全試合数: $\binom{4}{2} = 6$ 試合
- Aの対戦数: 3試合

### Aの勝ち数の確率分布

| Aの勝ち数 | 確率 |
|:---:|:---:|
| 3勝0敗 | $\left(\dfrac{2}{3}\right)^3 = \dfrac{8}{27}$ |
| 2勝1敗 | $3 \cdot \left(\dfrac{2}{3}\right)^2 \cdot \dfrac{1}{3} = \dfrac{4}{9}$ |
| 1勝2敗 | $3 \cdot \dfrac{2}{3} \cdot \left(\dfrac{1}{3}\right)^2 = \dfrac{2}{9}$ |
| 0勝3敗 | $\left(\dfrac{1}{3}\right)^3 = \dfrac{1}{27}$ |

### Aが優勝する確率

**(i) Aが3勝0敗の場合**

Aが全勝すれば必ず単独優勝。

$$
P(\text{A が 3勝0敗で優勝}) = \frac{8}{27}
$$

**(ii) Aが2勝1敗の場合**

この場合は複雑で、以下の2つのケースに分けます：

**ケース1: 全敗者がいる場合**

B, C, Dのうち1人が全敗（0勝3敗）のとき、残りの3人で優勝を争います。

例えばDが全敗する確率：

$$
P(\text{D全敗}) = \frac{2}{3} \times \frac{1}{2} \times \frac{1}{2} = \frac{1}{6}
$$

Dが全敗のとき、Aが2勝1敗で優勝するには、A, B, C間で全員同率となり抽選で選ばれる必要があります。n=3の解析と同様に計算すると：

$$
P(\text{D全敗かつAが2勝1敗で優勝}) = \frac{1}{6} \times \frac{2}{27} = \frac{1}{81}
$$

B, C, Dが全敗する場合も同様なので：

$$
P(\text{全敗者がいてAが2勝1敗で優勝}) = 3 \times \frac{1}{81} = \frac{1}{27}
$$

**ケース2: 全敗者がいない場合**

Aが2勝1敗のとき、Aが負ける相手はB, C, Dの3通りあります。

例えば、**Aが負ける相手がBである**とき（AはC, Dに勝つ）：

| | A | B | C | D | 勝ち数 |
|:---:|:---:|:---:|:---:|:---:|:---:|
| A | - | × | ○ | ○ | 2 |
| B | ○ | - | ? | ? | 1+? |
| C | × | ? | - | ? | 0+? |
| D | × | ? | ? | - | 0+? |

B, C, D間の3試合の結果によって、全敗者の有無とAの優勝可否が決まります。

B vs C, B vs D, C vs D の8パターンを調べると：

| B vs C | B vs D | C vs D | B勝 | C勝 | D勝 | 全敗者 | Aが優勝？ |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| B○ | B○ | C○ | 3 | 1 | 0 | D | 除外 |
| B○ | B○ | D○ | 3 | 0 | 1 | C | 除外 |
| B○ | D○ | C○ | 2 | 1 | 1 | なし | A,B同率→抽選 |
| B○ | D○ | D○ | 2 | 0 | 2 | C | 除外 |
| C○ | B○ | C○ | 2 | 2 | 0 | D | 除外 |
| C○ | B○ | D○ | 2 | 1 | 1 | なし | A,B同率→抽選 |
| C○ | D○ | C○ | 1 | 2 | 1 | なし | A,C同率→抽選 |
| C○ | D○ | D○ | 1 | 1 | 2 | なし | A,D同率→抽選 |

全敗者がいない場合は**4パターン**あり、いずれも2人が同率トップで抽選となります。

AがBに負けC,Dに勝つ確率：

$$
\frac{1}{3} \times \frac{2}{3} \times \frac{2}{3} = \frac{4}{27}
$$

全敗者がいなくてAが優勝する条件付き確率：

$$
4 \times \frac{1}{8} \times \frac{1}{2} = \frac{1}{4}
$$

よって、AがBに負けて全敗者なしで優勝する確率：

$$
\frac{4}{27} \times \frac{1}{4} = \frac{1}{27}
$$

Aが負ける相手がC, Dの場合も対称性から同様に $\dfrac{1}{27}$ ずつ。

$$
P(\text{全敗者なしでAが2勝1敗で優勝}) = 3 \times \frac{1}{27} = \frac{1}{9}
$$

**Aが2勝1敗で優勝する確率の合計：**

$$
P(\text{Aが2勝1敗で優勝}) = \frac{1}{27} + \frac{1}{9} = \frac{1}{27} + \frac{3}{27} = \frac{4}{27}
$$

**(iii) Aが1勝2敗以下の場合**

必ず2勝以上の人がいるため、Aは優勝できません。

### n=4でのAが優勝する確率

$$
P_4 = \frac{8}{27} + \frac{4}{27} = \frac{12}{27} = \frac{4}{9} \approx 0.4444
$$

:::message
**n=3とn=4の比較**

- $n = 3$: $P_3 = \dfrac{14}{27}$
- $n = 4$: $P_4 = \dfrac{4}{9} = \dfrac{12}{27}$

差: $\dfrac{14}{27} - \dfrac{12}{27} = \dfrac{2}{27}$（約7.4%ポイント減少）

4人のリーグ戦では、3人の場合より $\dfrac{2}{27}$ だけAが優勝する確率が**小さく**なります。
:::

## Juliaによる理論値の計算

### 全パターン列挙による厳密計算

Juliaは有理数（`Rational`型）を扱えるため、全ての試合結果パターンを列挙して厳密な理論値を計算できます。

```julia
using Combinatorics

"""
全試合結果を列挙して、Aが優勝する確率を有理数で厳密に計算
"""
function exact_probability(n::Int)
    # 全試合のリストを作成: (i, j) は i番目と j番目の対戦
    # 1番目がA、2番目以降がB, C, D, ...
    matches = [(i, j) for i in 1:n for j in (i+1):n]
    num_matches = length(matches)  # = binomial(n, 2)

    total_prob = Rational{BigInt}(0)

    # 全ての試合結果パターンを列挙（0: 前者勝ち、1: 後者勝ち）
    for pattern in 0:(2^num_matches - 1)
        # この結果パターンが起こる確率を計算
        prob = Rational{BigInt}(1)

        # 各プレイヤーの勝ち数
        wins = zeros(Int, n)

        for (k, (i, j)) in enumerate(matches)
            # k番目の試合の勝者を決定
            bit = (pattern >> (k-1)) & 1

            if bit == 0
                winner = i  # i が勝ち
            else
                winner = j  # j が勝ち
            end

            wins[winner] += 1

            # この試合の確率
            if i == 1
                # Aの対戦: Aが勝つ確率 2/3、相手が勝つ確率 1/3
                if winner == 1
                    prob *= Rational{BigInt}(2, 3)
                else
                    prob *= Rational{BigInt}(1, 3)
                end
            else
                # A以外の対戦: 各 1/2
                prob *= Rational{BigInt}(1, 2)
            end
        end

        # Aが優勝するかどうか判定
        max_wins = maximum(wins)

        if wins[1] == max_wins
            # Aがトップグループにいる場合、抽選で選ばれる確率 1/num_tied
            num_tied = count(w -> w == max_wins, wins)
            total_prob += prob * Rational{BigInt}(1, num_tied)
        end
    end

    return total_prob
end

# 計算実行
for n in 3:7
    prob = exact_probability(n)
    println("n = $n: P(A優勝) = $prob = $(Float64(prob))")
end
```

### 理論値の実行結果
```output
n = 3: P(A優勝) = 14//27 = 0.5185185185185185
n = 4: P(A優勝) = 4//9 = 0.4444444444444444
n = 5: P(A優勝) = 37//90 = 0.4111111111111111
n = 6: P(A優勝) = 1135//2916 = 0.3892318244170096
n = 7: P(A優勝) = 54259//145152 = 0.3738081459435626
```

:::message
**考察**

- $n = 3$: $P_3 = \dfrac{14}{27}$（問題の答えと一致）
- $n = 4$: $P_4 = \dfrac{4}{9}$（問題の答えと一致）

$n = 4$ の場合、$\dfrac{4}{9} = \dfrac{12}{27}$ なので、$n = 3$ の場合の $\dfrac{14}{27}$ から $\dfrac{2}{27}$ だけ減少しています。
:::


## 一般の $n$ についての考察

### 確率の構造

n人のリーグ戦でAが優勝する確率 $P_n$ は以下のように分解できます：

$$
P_n = \sum_{k=0}^{n-1} P(\text{A が } k \text{ 勝で優勝})
$$

ここで、Aがk勝する確率は：

$$
P(\text{A が } k \text{ 勝}) = \binom{n-1}{k} \left(\frac{2}{3}\right)^k \left(\frac{1}{3}\right)^{n-1-k}
$$

### 計算の困難さ

一般のnについて閉じた形で $P_n$ を求めることは非常に困難であると思われます。

1. **他の参加者の勝ち数分布の複雑さ**: A以外の(n-1)人の間で $\binom{n-1}{2}$ 試合が行われ、その結果の全パターンを考慮する必要がある

2. **同率の場合の処理**: 複数人が同率トップになる確率と、その中でAが抽選で選ばれる確率を計算する必要がある

3. **パターン数の爆発**: 全試合の結果パターン数は $2^{\binom{n}{2}}$ で、nが増えると急激に増加

そこで、モンテカルロシミュレーションによる数値的アプローチが有効です。


## Juliaによるシミュレーション

### シミュレーションコード

```julia
using Random
using StatsBase
using Printf

# n=3〜7の理論値（有理数）
const THEORETICAL_VALUES = Dict(
    3 => 14//27,      # ≈ 0.5185
    4 => 4//9,        # ≈ 0.4444
    5 => 37//90,      # ≈ 0.4111
    6 => 1135//2916,  # ≈ 0.3892
    7 => 54259//145152 # ≈ 0.3738
)

"""
n人のリーグ戦を1回シミュレートし、Aが優勝すれば1、そうでなければ0を返す
"""
function simulate_tournament(n::Int)
    # 勝ち数を記録（1番目がA）
    wins = zeros(Int, n)

    # 全ての対戦をシミュレート
    for i in 1:n
        for j in (i+1):n
            if i == 1
                # Aの対戦：Aが2/3で勝つ
                if rand() < 2/3
                    wins[1] += 1  # Aの勝ち
                else
                    wins[j] += 1  # 相手の勝ち
                end
            else
                # A以外の対戦：各1/2で勝つ
                if rand() < 0.5
                    wins[i] += 1
                else
                    wins[j] += 1
                end
            end
        end
    end

    # 最大勝ち数を持つ人を特定
    max_wins = maximum(wins)
    top_players = findall(w -> w == max_wins, wins)

    # Aがトップグループにいれば、抽選で優勝する確率
    if 1 in top_players
        # Aがトップグループにいる場合、1/m の確率で優勝（mは同率の人数）
        return rand() < 1/length(top_players) ? 1 : 0
    else
        return 0
    end
end

"""
n人のリーグ戦でAが優勝する確率をシミュレーションで推定
"""
function estimate_probability(n::Int, num_simulations::Int=1_000_000)
    wins_count = 0
    for _ in 1:num_simulations
        wins_count += simulate_tournament(n)
    end
    return wins_count / num_simulations
end

# メイン実行
function main()
    Random.seed!(42)  # 再現性のため

    println("=" ^ 60)
    println("リーグ戦でAが優勝する確率のシミュレーション")
    println("=" ^ 60)
    println()

    println("【シミュレーション条件】")
    println("- Aが対戦相手に勝つ確率: 2/3")
    println("- A以外の対戦: 各1/2")
    println("- 試行回数: 1,000,000回")
    println()

    println("【結果】")
    println("-" ^ 60)
    @printf("| %5s | %12s | %12s | %12s |\n", "n", "シミュレーション", "理論値", "誤差")
    println("-" ^ 60)

    results = Dict{Int, Float64}()

    for n in 3:20
        prob = estimate_probability(n, 1_000_000)
        results[n] = prob
        if haskey(THEORETICAL_VALUES, n)
            theoretical = Float64(THEORETICAL_VALUES[n])
            error = abs(prob - theoretical)
            @printf("| %5d | %12.6f | %12.6f | %12.6f |\n", n, prob, theoretical, error)
        else
            @printf("| %5d | %12.6f | %12s | %12s |\n", n, prob, "-", "-")
        end
    end
    println("-" ^ 60)
    println()

    return results
end

# 実行
results = main()
```

### 実行結果

```
============================================================
リーグ戦でAが優勝する確率のシミュレーション
============================================================

【シミュレーション条件】
- Aが対戦相手に勝つ確率: 2/3
- A以外の対戦: 各1/2
- 試行回数: 1,000,000回


【結果】
------------------------------------------------------------
|     n | シミュレーション |       理論値 |         誤差 |
------------------------------------------------------------
|     3 |     0.517997 |     0.518519 |     0.000522 |
|     4 |     0.445262 |     0.444444 |     0.000818 |
|     5 |     0.410972 |     0.411111 |     0.000139 |
|     6 |     0.389127 |     0.389232 |     0.000105 |
|     7 |     0.373625 |     0.373808 |     0.000183 |
|     8 |     0.365653 |            - |            - |
|     9 |     0.359172 |            - |            - |
|    10 |     0.356295 |            - |            - |
|    11 |     0.355520 |            - |            - |
|    12 |     0.354633 |            - |            - |
|    13 |     0.355975 |            - |            - |
|    14 |     0.357549 |            - |            - |
|    15 |     0.360371 |            - |            - |
|    16 |     0.364086 |            - |            - |
|    17 |     0.367050 |            - |            - |
|    18 |     0.371484 |            - |            - |
|    19 |     0.375504 |            - |            - |
|    20 |     0.378787 |            - |            - |
------------------------------------------------------------

```

- シミュレーション結果と理論値が非常によく一致しています。
- $n=12$ で最小となっているように見えます。


### 図1：グラフによる可視化（n=3〜20）

```julia
using Plots, PlotsGRBackendFontJaEmoji

function plot_probability_vs_n()
    Random.seed!(42)

    ns = 3:20
    probs = Float64[]

    for n in ns
        prob = estimate_probability(n, 1_000_000)
        push!(probs, prob)
        println("n=$n: P(A優勝) = $prob")
    end

    # 理論値（n=3）
    theoretical_n3 = 14/27

    p = plot(ns, probs,
        marker=:circle,
        markersize=6,
        linewidth=2,
        label="シミュレーション",
        xlabel="参加者数 n",
        ylabel="Aが優勝する確率",
        title="リーグ戦でAが優勝する確率",
        legend=:topright,
        ylim=(0.3, 0.6),
        grid=true
    )

    # n=3の理論値をプロット
    scatter!([3], [theoretical_n3],
        marker=:star5,
        markersize=10,
        color=:red,
        label="理論値 (n=3): 14/27"
    )

    # 1/n のラインを追加（参考）
    plot!(ns, 1 ./ ns,
        linestyle=:dash,
        color=:gray,
        label="1/n（参考）",
        ylim=(0,.6)
    )

    savefig(p, "league_tournament_probability.png")
    return p
end

plot_probability_vs_n()
```


![リーグ戦でAが優勝する確率](/images/league_tournament_probability.png)

上のグラフから、以下のことがわかります：

- **青い線（シミュレーション）**: Aが優勝する確率。$n$ が増えると減少し、$n=12$ 付近で最小値をとる
- **赤い星**: n=3での理論値 14/27
- **灰色の破線（1/n）**: 全員が均等な強さの場合の確率。Aの確率は常にこれより高い


### 図2：$n$ を大きくしたときの確率の推移（n=3〜200）

![p=2/3の場合の詳細](/images/league_tournament_p_2_3_detail.png)

上のグラフは $n$ を200まで拡張した場合の結果です。$n=12$ 付近で最小値（約0.35）をとった後、確率は上昇に転じ、$n \to \infty$ で $1$ に収束していく様子がわかります。

### なぜAが優勝する確率が $1$ に近づくのか？

これは**大数の法則**で説明できます。

$n$ が十分大きいとき、各参加者の勝率は期待値に収束します：
- Aの勝率: $\dfrac{\text{Aの勝ち数}}{n-1} \to p$
- 他の参加者Bの勝率（A以外との対戦）: $\dfrac{\text{Bの勝ち数（A以外）}}{n-2} \to \dfrac{1}{2}$

$p > \dfrac{1}{2}$ なら、Aの勝率が他の参加者より高いため、$n$ が大きくなるとAが単独トップになる確率が $1$ に収束します。

:::message alert
**重要な洞察**

$p = \dfrac{2}{3}$ の場合、$n$ が小さいうちは「運の要素」が大きく、Aが負ける可能性がある。しかし $n$ が大きくなると「実力通りの結果」になり、Aがほぼ確実に優勝する。

**共通テストの問題設定（$n = 3, 4$）は、ちょうどAにとって最も不利な領域**である！
:::



### 図3：Aの勝率 $p$ をパラメータとした解析

問題では $p = \dfrac{2}{3}$ でしたが、$p$ を変えたときの振る舞いを調べると興味深い結果が得られます。

![pを変えた時のn依存性](/images/league_tournament_p_dependence.png)

- **$p = 0.5$**（全員同じ強さ）の場合：確率は $1/n$ に漸近
- **$p > 0.5$** の場合：$n \to \infty$ で確率は $1$ に収束
- $p$ が大きいほど、収束が速い


## まとめ

本記事では、2026年度共通テストの確率問題を一般化し、$n$ 人のリーグ戦でAが優勝する確率を分析しました。

- **n=3の場合**: $P_3 = \dfrac{14}{27} \approx 0.5185$
- **n=4の場合**: $P_4 = \dfrac{4}{9} \approx 0.4444$
- **n=5以上の場合**: 全パターン列挙による厳密計算が可能（ただし計算量は指数的に増加）
- **$n \to \infty$ の極限**: $p = \dfrac{2}{3}$ では最小値（$n \approx 12$）を経て $1$ に収束
- **$p$ の影響**: $p > \dfrac{1}{2}$ なら大数の法則により $n \to \infty$ で優勝確率は $1$ に収束

この問題は、確率論の基本的な計算技術、複雑な状況でのシミュレーションの有用性、そして大数の法則の直感的理解を示す良い例題です。共通テストの問題設定（$n = 3, 4$）は、実はAにとって最も不利な領域であるという意外な事実も発見できました。

## 参考

- 2026年度大学入学共通テスト「数学I・数学A」第4問

## 付録：図のコード

### 図2：$n$ を大きくしたときの確率の推移

```julia
using Plots, PlotsGRBackendFontJaEmoji
using Random

function plot_probability_large_n()
    Random.seed!(42)

    # n=3〜30は1刻み、35〜100は5刻み、110〜200は10刻み
    ns = vcat(3:30, 35:5:100, 110:10:200)
    probs = Float64[]

    for n in ns
        prob = estimate_probability(n, 100_000)
        push!(probs, prob)
        println("n=$n: P(A優勝) = $prob")
    end

    # 理論値（n=3〜7）
    theoretical = Dict(
        3 => 14//27,
        4 => 4//9,
        5 => 37//90,
        6 => 1135//2916,
        7 => 54259//145152
    )

    p = plot(ns, probs,
        marker=:circle,
        markersize=3,
        linewidth=2,
        label="シミュレーション (p=2/3)",
        xlabel="参加者数 n",
        ylabel="Aが優勝する確率",
        title="リーグ戦でAが優勝する確率（n=3〜200）",
        legend=:bottomright,
        ylim=(0.3, 1.0),
        grid=true,
        size=(800, 500)
    )

    # 理論値をプロット
    scatter!([3, 4, 5, 6, 7], [Float64(theoretical[k]) for k in 3:7],
        marker=:star5,
        markersize=10,
        color=:red,
        label="理論値 (n=3〜7)"
    )

    # 1/n のラインを追加（参考）
    plot!(ns, 1 ./ ns,
        linestyle=:dash,
        color=:gray,
        label="1/n（全員均等の場合）"
    )

    # 漸近線 y=1 を追加
    hline!([1.0], linestyle=:dot, color=:green, label="y=1（漸近線）")

    savefig(p, "league_tournament_p_2_3_detail.png")
    return p
end

plot_probability_large_n()
```

### 図3：Aの勝率 $p$ をパラメータとした解析

```julia
using Plots, PlotsGRBackendFontJaEmoji
using Random

"""
n人のリーグ戦でAが優勝する確率をシミュレーション（勝率pを指定可能）
"""
function simulate_tournament_p(n::Int, p::Float64)
    wins = zeros(Int, n)

    for i in 1:n
        for j in (i+1):n
            if i == 1
                # Aの対戦：Aがpで勝つ
                if rand() < p
                    wins[1] += 1
                else
                    wins[j] += 1
                end
            else
                # A以外の対戦：各1/2で勝つ
                if rand() < 0.5
                    wins[i] += 1
                else
                    wins[j] += 1
                end
            end
        end
    end

    max_wins = maximum(wins)
    top_players = findall(w -> w == max_wins, wins)

    if 1 in top_players
        return rand() < 1/length(top_players) ? 1 : 0
    else
        return 0
    end
end

function estimate_probability_p(n::Int, p::Float64, num_simulations::Int=100_000)
    wins_count = 0
    for _ in 1:num_simulations
        wins_count += simulate_tournament_p(n, p)
    end
    return wins_count / num_simulations
end

function plot_probability_vs_p()
    Random.seed!(42)

    ps = [0.5, 0.55, 0.6, 2/3, 0.7, 0.75, 0.8]
    # n=3〜30は1刻み、35〜100は5刻み、110〜200は10刻み
    ns = vcat(3:30, 35:5:100, 110:10:200)
    colors = [:gray, :blue, :green, :red, :orange, :purple, :brown]

    p_plot = plot(
        xlabel="参加者数 n",
        ylabel="Aが優勝する確率",
        title="Aの勝率 p をパラメータとした優勝確率（n=3〜200）",
        legend=:right,
        ylim=(0, 1.05),
        grid=true,
        size=(900, 600)
    )

    for (i, p) in enumerate(ps)
        probs = Float64[]
        for n in ns
            prob = estimate_probability_p(n, p, 50_000)
            push!(probs, prob)
        end

        label_str = p == 2/3 ? "p = 2/3" : "p = $p"
        linewidth = p == 2/3 ? 3 : 2

        plot!(ns, probs,
            marker=:circle,
            markersize=2,
            linewidth=linewidth,
            color=colors[i],
            label=label_str
        )
        println("p = $p 完了")
    end

    # p=0.5の参考線
    hline!([0.5], linestyle=:dot, color=:black, alpha=0.5, label="")

    # 1/nの参考線
    plot!(ns, 1 ./ ns,
        linestyle=:dash,
        color=:black,
        alpha=0.5,
        label="1/n（参考）"
    )

    savefig(p_plot, "league_tournament_p_dependence.png")
    return p_plot
end

plot_probability_vs_p()
```
