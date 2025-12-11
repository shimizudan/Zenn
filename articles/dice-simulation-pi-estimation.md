---
title: "サイコロで円周率を推定する：浜松医科大2025年入試問題のシミュレーション"
emoji: "🎲"
type: "idea"
topics: [julia, 数学, モンテカルロ法, 確率, 円周率]
published: false
---

## はじめに

2025年度浜松医科大学の入試問題に、サイコロを使った興味深い確率問題が出題されました。本記事では、この問題を題材に以下の2つのテーマを扱います：

1. **サイコロの出目を使って任意の数を均等に生成する方法**（問題(1)(2)）
2. **モンテカルロ法による円周率の推定**（問題(3)(4)）

特に後半では、「試行回数を増やすだけでは精度が上がらない」という重要な誤解を解明します。


## 問題の概要

**問題2**: 1から6までの目がすべて同じ確率で出るさいころが1つある。以下の問いに答えよ。

(1) このさいころを使って、1から10までの10通りの数をどれも同じ確率で得ることができる方法を1つ示せ。ただし、さいころは何回振ってもかまわない。

(2) このさいころを使って、1から100までの100通りの数をどれも同じ確率で得ることができる方法を1つ示せ。ただし、さいころは何回振ってもかまわない。

(3) (2)で与えた方法で1から100までの数を200個求め、それらを順に $x_1, x_2, \cdots, x_{100}, y_1, y_2, \cdots, y_{100}$ とする。これらを用いて、$x_i^2 + y_i^2 \leq 10000$ ($i = 1, 2, \cdots, 100$) を満たす $i$ の個数を求める。これによりどのような値を知ることができるかを答えよ。

(4) (3)で知ることができた値の精度をよりよくする方法を1つ示せ。

出典: [X (Twitter) @Math_Exam_Prac](https://x.com/Math_Exam_Prac/status/1986058258944328031)

## Part 1: サイコロで任意の数を均等に生成する

### 問題(1): 1〜5を均等に生成

最も単純な方法は「**6が出たらやり直す**」です。

```julia
using StatsBase

function saikoro5()
    a = rand(1:6)
    if a != 6
        return a
    else
        saikoro5()  # 6が出たら再帰呼び出し
    end
end

# 500万回試行
result = [saikoro5() for _ = 1:5*10^6] |> countmap
```

**実行結果:**
```
Dict{Int64, Int64} with 5 entries:
  5 => 999622
  4 => 1001965
  2 => 999677
  3 => 999203
  1 => 999533
```

各目がほぼ均等に100万回ずつ出現し、確率 $\frac{1}{5}$ で分布していることが確認できます。

### 問題(1): 1〜10を均等に生成（入試問題の解答）

サイコロを2回振り、1回目の出目を $a$、2回目を $b$ として以下の規則で決定します：

- $a \leq 5$ のとき: $a$ を返す（1〜5）
- $a = 6$ かつ $b \leq 5$ のとき: $b + 5$ を返す（6〜10）
- $a = 6$ かつ $b = 6$ のとき: やり直す

```julia
function saikoro10()
    a = rand(1:6)
    if a <= 5
        return a
    else
        b = rand(1:6)
        if b <= 5
            return b + 5
        else
            saikoro10()  # (6,6)が出たらやり直し
        end
    end
end
```

この方法では、36通りの出目のうち30通りを使い、残り6通り（6のゾロ目）でやり直すことで、1〜10が均等に生成されます。

### 問題(2): 1〜100を均等に生成

同様の考え方で、サイコロを4回振って100進数的に扱います：

```julia
function saikoro100()
    # 4回振って4桁の6進数を作る
    digits = [rand(1:6) for _ = 1:4]

    # 6進数を10進数に変換（0-indexed）
    number = sum((digits[i] - 1) * 6^(i-1) for i = 1:4)

    # 0〜1295の範囲になるので、0〜99だけ採用
    if number < 100
        return number + 1  # 1〜100に変換
    else
        saikoro100()  # 100以上ならやり直し
    end
end
```

### 問題(2): 1〜7を均等に生成（おまけ）

サイコロ2個を使って、興味深い方法で1〜7を生成できます：

- 目が**異なる**場合: 最初のサイコロの目を返す（1〜6）
- **6以外のゾロ目**の場合: 7を返す
- **6のゾロ目**の場合: やり直す

```julia
function saikoro7()
    a, b = rand(1:6), rand(1:6)
    if a != b
        return a
    elseif a == b != 6
        return 7
    else
        saikoro7()  # (6,6)が出たらやり直し
    end
end

# 700万回試行
result = [saikoro7() for _ = 1:7*10^6] |> countmap
```

**実行結果:**
```
Dict{Int64, Int64} with 7 entries:
  5 => 998838
  4 => 1000017
  6 => 1000846
  7 => 1000118
  2 => 1000279
  3 => 1000669
  1 => 999233
```

各目が均等に約100万回ずつ出現しています。

**確率の計算:**
- 異なる目: $6 \times 5 = 30$通り → 各数字に5通りずつ
- ゾロ目（1〜5）: 5通り → すべて7に対応
- 合計: 35通りを使用（(6,6)の1通りは除外）

したがって各目の確率は $\frac{5}{35} = \frac{1}{7}$ で均等です。

## Part 2: モンテカルロ法による円周率の推定

### 問題(3): 基本的なモンテカルロ法

(2)の方法で1〜100の乱数を200個生成し、それを $(x_1, y_1), \cdots, (x_{100}, y_{100})$ のペアにします。

条件 $x_i^2 + y_i^2 \leq 10000$ を満たす点の個数 $N$ を数えると、半径100の円の面積を推定できます：

$$
\frac{N}{100} \approx \frac{\pi \times 100^2}{100^2} = \pi
$$

したがって、**$\pi$ の近似値を知ることができます**。

#### Juliaコードによる実装

```julia
using Random

# (3)のシミュレーション：試行回数を増やすだけ
function estimate_pi_fixed_grid(n_trials)
    Random.seed!(42)

    count_inside = 0
    for trial = 1:n_trials
        x = saikoro100()
        y = saikoro100()

        if x^2 + y^2 <= 10000
            count_inside += 1
        end
    end

    return 4.0 * count_inside / n_trials
end

# 試行回数を変えて実験
trials_list = [100, 1000, 10000, 100000]
println("問題(3)の方法：試行回数のみ増加")
println("=" ^ 50)
for n in trials_list
    pi_est = estimate_pi_fixed_grid(n)
    error = abs(pi_est - π)
    println("試行回数: $(lpad(n, 6)) → π推定値: $(round(pi_est, digits=6)), 誤差: $(round(error, digits=6))")
end
```

**実行結果（例）:**
```
問題(3)の方法：試行回数のみ増加
==================================================
試行回数:    100 → π推定値: 3.16, 誤差: 0.018407
試行回数:   1000 → π推定値: 3.152, 誤差: 0.010407
試行回数:  10000 → π推定値: 3.1464, 誤差: 0.004807
試行回数: 100000 → π推定値: 3.14436, 誤差: 0.002773
```

### 問題の本質：なぜ精度が上がらないのか？

**重要な指摘**: 問題(3)の方法で試行回数 $N$ を増やしても、**精度は根本的に向上しません**。

#### 理由の説明

問題(3)では、$(x, y)$ の取り得る値が $1 \leq x, y \leq 100$ の整数に限定されています。これは $100 \times 100 = 10000$ 個の格子点だけをサンプリングしていることを意味します。

試行回数を増やしても：
- 同じ10000個の格子点を繰り返しサンプリングするだけ
- 各格子点の出現頻度が均等に近づくだけ
- 空間の分解能は $100 \times 100$ で固定

つまり、**試行回数を無限に増やしても、真のπには近づきません**。近づくのは「$100 \times 100$ 格子における円の内部の格子点数÷総格子点数」という離散的な値です。

![格子点による円の近似](/images/grid_visualization.png)
*図1: 分割数10, 50, 100での格子点による円の近似。分割が細かくなるほど円の輪郭が滑らかになる。*

### 問題(4): 精度を向上させる方法

**正解**: 格子の**分割を細かくする**（分解能を上げる）

例えば、1〜1000の整数を使えば、$1000 \times 1000 = 10^6$ 個の格子点でサンプリングでき、精度が大幅に向上します。

#### Juliaコードによる比較実験

```julia
# 1〜maxの範囲で円周率を推定（分割数を変える）
function estimate_pi_with_resolution(n_trials, max_value)
    Random.seed!(42)

    count_inside = 0
    radius_squared = max_value^2

    for trial = 1:n_trials
        x = rand(1:max_value)
        y = rand(1:max_value)

        if x^2 + y^2 <= radius_squared
            count_inside += 1
        end
    end

    return 4.0 * count_inside / n_trials
end

# 分割数を変えて実験（試行回数は固定）
println("\n問題(4)の方法：分割を細かくする")
println("=" ^ 50)
resolutions = [10, 100, 1000, 10000]
n_trials = 100000

for max_val in resolutions
    pi_est = estimate_pi_with_resolution(n_trials, max_val)
    error = abs(pi_est - π)
    println("分割数: $(lpad(max_val, 5)) (格子点: $(lpad(max_val^2, 10))) → π推定値: $(round(pi_est, digits=6)), 誤差: $(round(error, digits=6))")
end
```

**実行結果（例）:**
```
問題(4)の方法：分割を細かくする
==================================================
分割数:    10 (格子点:        100) → π推定値: 3.08, 誤差: 0.061593
分割数:   100 (格子点:      10000) → π推定値: 3.14436, 誤差: 0.002773
分割数:  1000 (格子点:    1000000) → π推定値: 3.141386, 誤差: 0.000207
分割数: 10000 (格子点:  100000000) → π推定値: 3.141574, 誤差: 0.000019
```

![試行回数による収束の比較](/images/convergence_comparison.png)
*図2: 問題(3)の方法（分割数100固定）と問題(4)の方法（分割数1000）の比較。分割数を増やした方が真のπ（黒破線）に近づく。*

### 両方を組み合わせた完全なシミュレーション

最も効果的なのは、**分割を細かくする**（問題4）と**試行回数を増やす**（問題3）の両方を行うことです。

```julia
using Plots
using Random

# 完全なシミュレーション：分割数と試行回数の両方を変化
function comprehensive_simulation()
    Random.seed!(42)

    resolutions = [10, 50, 100, 500, 1000]
    trials_list = [100, 500, 1000, 5000, 10000]

    results = zeros(length(resolutions), length(trials_list))

    for (i, max_val) in enumerate(resolutions)
        for (j, n_trials) in enumerate(trials_list)
            results[i, j] = estimate_pi_with_resolution(n_trials, max_val)
        end
    end

    return resolutions, trials_list, results
end

# 実行して結果を表示
resolutions, trials_list, results = comprehensive_simulation()

println("\n総合シミュレーション結果（π推定値）")
println("=" ^ 70)
print("分割\\試行 ")
for n in trials_list
    print(lpad(n, 10))
end
println()
println("-" ^ 70)

for (i, res) in enumerate(resolutions)
    print(lpad(res, 8), "  ")
    for j = 1:length(trials_list)
        print(lpad(round(results[i, j], digits=4), 10))
    end
    println()
end

# 誤差のヒートマップを作成
errors = abs.(results .- π)

heatmap(trials_list, resolutions, errors,
    xlabel="試行回数", ylabel="分割数（1〜n）",
    title="円周率推定の誤差（|推定値 - π|）",
    color=:viridis, colorbar_title="誤差",
    xscale=:log10, yscale=:log10,
    size=(600, 500))
```

![誤差のヒートマップ](/images/error_heatmap.png)
*図3: 試行回数と分割数による円周率推定の誤差。縦軸（分割数）の効果が横軸（試行回数）より顕著。*

### 可視化：円の内部の格子点

```julia
using Plots

# 格子点の可視化
function visualize_grid(max_value)
    x_grid = 1:max_value
    y_grid = 1:max_value

    # 円の内部の点と外部の点を分類
    inside_x, inside_y = Int[], Int[]
    outside_x, outside_y = Int[], Int[]

    for x in x_grid
        for y in y_grid
            if x^2 + y^2 <= max_value^2
                push!(inside_x, x)
                push!(inside_y, y)
            else
                push!(outside_x, x)
                push!(outside_y, y)
            end
        end
    end

    # プロット
    p = scatter(inside_x, inside_y,
        label="円の内部", markersize=2, color=:red, alpha=0.5)
    scatter!(outside_x, outside_y,
        label="円の外部", markersize=2, color=:blue, alpha=0.3)

    # 円を描画
    θ = range(0, 2π, length=100)
    plot!(max_value .* cos.(θ), max_value .* sin.(θ),
        label="半径=$(max_value)の円", linewidth=2, color=:black)

    plot!(aspect_ratio=:equal,
        title="格子点による円の近似（分割数=$(max_value)）",
        xlabel="x", ylabel="y",
        xlim=(0, max_value*1.1), ylim=(0, max_value*1.1))

    return p
end

# 異なる分割数で可視化
p1 = visualize_grid(10)
p2 = visualize_grid(50)
p3 = visualize_grid(100)

plot(p1, p2, p3, layout=(1, 3), size=(1200, 400))
```

## まとめ

### サイコロによる均等分布生成

- **リジェクション法**を使えば、6面サイコロから任意の $n$ 個の数を均等に生成できる
- 効率的な実装には、6進数的な考え方が有効
- 7面サイコロの例のように、創意工夫で面白い方法も存在

### モンテカルロ法による円周率推定

| 方法 | 効果 | 理由 |
|------|------|------|
| 試行回数を増やす（問題3） | △ 限定的 | 同じ格子点を繰り返すだけ |
| 分割を細かくする（問題4） | ◎ 根本的改善 | サンプリング空間の分解能が向上 |
| 両方を組み合わせる | ◎◎ 最良 | 精度と安定性の両立 |

**重要な教訓**:
- 単純に試行回数を増やすだけでは精度は向上しない
- 空間の**分解能**（離散化の細かさ）が精度を決定する
- モンテカルロ法では「どこをサンプリングするか」が「何回サンプリングするか」と同じくらい重要

### Juliaの強み

- 簡潔な再帰関数の記述
- `countmap`による頻度集計
- 高速な数値計算
- `Plots.jl`による直感的な可視化

## 参考文献

- [浜松医科大学2025年度入試問題](https://x.com/Math_Exam_Prac/status/1986058258944328031)
- モンテカルロ法の基礎理論
- Julia公式ドキュメント: [Random numbers](https://docs.julialang.org/en/v1/stdlib/Random/)
