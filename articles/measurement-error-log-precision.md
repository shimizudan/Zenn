---
title: "対数の近似値の危険性：Julia Measurements.jlで誤差を可視化する"
emoji: "🌻"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: [julia, 数学, 誤差解析]
published: true
---

:::message
この記事は[Julia Advent Calendar 2025](https://qiita.com/advent-calendar/2025/julia)の12月5日の記事です。
:::

## はじめに

この記事を書くきっかけとなったのは、[@masa77450900さんのXポスト](https://x.com/masa77450900/status/1995798551608394242)で紹介されていた興味深い数学の問題でした。数学の問題で対数表を使って計算する際、近似値を使うことで思わぬ誤答を招くことがあります。本記事では、次の問題を例に、Julia言語のMeasurements.jlパッケージを使って、誤差がどのように伝播するかを可視化します。

:::message
**問題**
$6^{700}$の値の最高位の数字を答えなさい。ただし、$\log_{10} 2 = 0.3010$、$\log_{10} 3 = 0.4771$としてよい。
:::

## 問題の解法

### 基本的な考え方

$6^{700}$の最高位の数字を求めるには、この数が何桁で、その先頭の数字を求める必要があります。

$$
\log_{10}(6^{700}) = 700 \log_{10} 6 = 700 \log_{10}(2 \times 3) = 700(\log_{10} 2 + \log_{10} 3)
$$

与えられた値を使って計算すると：

$$
\log_{10}(6^{700}) = 700 \times (0.3010 + 0.4771) = 700 \times 0.7781 = 544.67
$$

これは$6^{700}$が545桁の数で、$10^{544.67} = 10^{0.67} \times 10^{544}$となることを意味します。

最高位の数字は$10^{0.67}$の整数部分なので、$10^{0.67}$を評価します。

与えられた値から：

$$
\log_{10} 4 = 2\log_{10} 2 = 2 \times 0.3010 = 0.6020
$$

$$
\log_{10} 5 = \log_{10}\frac{10}{2} = 1 - \log_{10} 2 = 1 - 0.3010 = 0.6990
$$

したがって：

$$
0.6020 < 0.67 < 0.6990
$$

つまり：

$$
\log_{10} 4 < 0.67 < \log_{10} 5
$$

よって：

$$
4 < 10^{0.67} < 5
$$

与えられた近似値を使うと**最高位の数字は4**となります。

### 実際の答え

しかし、実際に高精度で計算すると、**正解は5**なのです！

## Julia言語で検証する

### 正確な値の計算

まず、Juliaで高精度計算を行い、実際の最高位の数字を確認します。

```julia
# 高精度計算のためBigFloatを使用
setprecision(BigFloat, 1024)  # 精度を上げる

# 6^700を計算
result = BigInt(6)^700
println("6^700 = ", result)

# 先頭の数字を確認
result_str = string(result)
println("最高位の数字: ", result_str[1])
println("桁数: ", length(result_str))
```

実行結果：
```
6^700 = 5408786345007208493...（545桁）
最高位の数字: 5
桁数: 545
```

### 近似値を使った計算

次に、問題で与えられた近似値を使って計算してみます。

```julia
# 与えられた近似値
log10_2_approx = 0.3010
log10_3_approx = 0.4771

# 6 = 2 × 3 なので
log10_6_approx = log10_2_approx + log10_3_approx
println("log₁₀(6) ≈ ", log10_6_approx)

# 6^700 の対数
log10_result_approx = 700 * log10_6_approx
println("log₁₀(6^700) ≈ ", log10_result_approx)

# 小数部分
fractional_part = log10_result_approx - floor(log10_result_approx)
println("小数部分: ", fractional_part)

# 最高位の数字
first_digit_approx = 10^fractional_part
println("10^", fractional_part, " ≈ ", first_digit_approx)
println("近似値による最高位の数字: ", floor(Int, first_digit_approx))
```

実行結果：
```
log₁₀(6) ≈ 0.7781
log₁₀(6^700) ≈ 544.67
小数部分: 0.67
10^0.67 ≈ 4.677...
近似値による最高位の数字: 4
```

### 正確な対数値との比較

```julia
# 実際の対数値（高精度）
log10_2_exact = log10(BigFloat(2))
log10_3_exact = log10(BigFloat(3))

println("正確な log₁₀(2) = ", log10_2_exact)
println("正確な log₁₀(3) = ", log10_3_exact)

log10_6_exact = log10_2_exact + log10_3_exact
log10_result_exact = 700 * log10_6_exact

println("正確な log₁₀(6^700) = ", log10_result_exact)

fractional_exact = log10_result_exact - floor(log10_result_exact)
println("正確な小数部分: ", fractional_exact)

first_digit_exact = 10^fractional_exact
println("正確な 10^(小数部分) = ", first_digit_exact)
println("正確な最高位の数字: ", floor(Int, first_digit_exact))
```

実行結果：
```
正確な log₁₀(2) = 0.301029995663981...
正確な log₁₀(3) = 0.477121254719662...
正確な log₁₀(6^700) = 544.705724...
正確な小数部分: 0.705724...
正確な 10^(小数部分) = 5.077...
正確な最高位の数字: 5
```

## Measurements.jlで誤差伝播を可視化

ここからが本題です。Measurements.jlパッケージを使って、与えられた近似値の誤差がどのように最終結果に影響するかを解析します。

### Measurements.jlとは

Measurements.jlは、測定値の誤差を自動的に伝播計算してくれるJuliaのパッケージです。数値に不確かさを付与し、計算を行うと、誤差が自動的に伝播されます。

### パッケージのインストールと読み込み

```julia
using Pkg
Pkg.add("Measurements")

using Measurements
```

### 誤差付き計算

与えられた対数の値に誤差を考慮します。小数第4位までしか与えられていないので、誤差は±0.0001程度と考えられます。

```julia
using Measurements

# 誤差を考慮した対数値
# ±0.00005の誤差を仮定（最終桁の丸め誤差）
log10_2_measured = 0.3010 ± 0.00005
log10_3_measured = 0.4771 ± 0.00005

println("測定値: log₁₀(2) = ", log10_2_measured)
println("測定値: log₁₀(3) = ", log10_3_measured)

# 6 = 2 × 3 なので
log10_6_measured = log10_2_measured + log10_3_measured
println("log₁₀(6) = ", log10_6_measured)

# 6^700 の対数
log10_result_measured = 700 * log10_6_measured
println("log₁₀(6^700) = ", log10_result_measured)

# 小数部分の取得は注意が必要
# Measurementsでは小数部分を直接取れないので、中心値と誤差を分けて処理
center_value = log10_result_measured.val
uncertainty = log10_result_measured.err

println("\n中心値: ", center_value)
println("不確かさ: ±", uncertainty)

# 小数部分
fractional = center_value - floor(center_value)
println("小数部分: ", fractional)
println("小数部分の不確かさの影響: ±", uncertainty)

# この小数部分が 0.7 付近にあり、不確かさが ±0.05 程度ある
println("\n小数部分の範囲: ", fractional - uncertainty, " ~ ", fractional + uncertainty)
```

実行結果：
```
測定値: log₁₀(2) = 0.301 ± 0.00005
測定値: log₁₀(3) = 0.4771 ± 0.00005
log₁₀(6) = 0.7781 ± 0.00007071
log₁₀(6^700) = 544.67 ± 0.04950

中心値: 544.67
不確かさ: ±0.04950

小数部分: 0.67
小数部分の不確かさの影響: ±0.04950

小数部分の範囲: 0.62050 ~ 0.71950
```

### 最高位の数字への影響を計算

```julia
# 10^(小数部分)の範囲を計算
lower_bound = 10^(fractional - uncertainty)
upper_bound = 10^(fractional + uncertainty)

println("\n10^(小数部分)の範囲:")
println("下限: 10^", fractional - uncertainty, " = ", lower_bound)
println("上限: 10^", fractional + uncertainty, " = ", upper_bound)
println("\n最高位の数字の可能性:")
println("下限の整数部分: ", floor(Int, lower_bound))
println("上限の整数部分: ", floor(Int, upper_bound))

# 誤差により、最高位が4か5のどちらか判定不可能であることを示す
if floor(Int, lower_bound) != floor(Int, upper_bound)
    println("\n⚠️  誤差の範囲内で最高位の数字が確定できません！")
    println("最高位は ", floor(Int, lower_bound), " または ", floor(Int, upper_bound), " の可能性があります。")
end
```

実行結果：
```
10^(小数部分)の範囲:
下限: 10^0.62050 = 4.173...
上限: 10^0.71950 = 5.239...

最高位の数字の可能性:
下限の整数部分: 4
上限の整数部分: 5

⚠️  誤差の範囲内で最高位の数字が確定できません！
最高位は 4 または 5 の可能性があります。
```

## 何が起こったのか

### 誤差の増幅

与えられた対数の値 $\log_{10} 2 = 0.3010$、$\log_{10} 3 = 0.4771$ はいずれも小数第4位までの精度です。

$$
\log_{10} 6 = \log_{10} 2 + \log_{10} 3 = 0.7781 \pm 0.00007
$$

これを700倍すると：

$$
700 \times \log_{10} 6 = 544.67 \pm 0.05
$$

誤差が約**700倍に増幅**されています。

### 臨界点付近の問題

小数部分が $0.67 \pm 0.05$ となり、この範囲は：

$$
0.62 < \text{小数部分} < 0.72
$$

$10^x$ の整数部分を考えると：

- $10^{0.62} \approx 4.17$ → 最高位は **4**
- $10^{0.72} \approx 5.24$ → 最高位は **5**

つまり、誤差の範囲が $10^{0.699...} = 5.0$ という臨界点をまたいでしまったため、最高位の数字が確定できなくなりました。

### 実際の正確な値

$$
\log_{10} 6 = 0.778151250383644...
$$

$$
700 \times \log_{10} 6 = 544.705875268351...
$$

小数部分は $0.705875...$ なので：

$$
10^{0.705875} \approx 5.077
$$

したがって、正確な最高位の数字は **5** です。

与えられた近似値 $0.7781$ は $0.00000125$ ほど小さく、この微小な誤差が700倍されて、小数部分が臨界値 $\log_{10} 5 \approx 0.699$ を下回ってしまったのです。

## まとめ

この問題から学べること：

1. **対数の近似値を使う際は、誤差の伝播に注意が必要**
   - 特に、掛け算や累乗で誤差が増幅される

2. **臨界点付近では精度が致命的**
   - 今回は $10^{0.699} = 5.0$ という境界付近だったため、わずかな誤差で答えが変わった

3. **Measurements.jlの有用性**
   - 誤差がどのように伝播するかを自動計算できる
   - 計算結果の不確かさを定量的に評価できる

数学の問題で「与えられた近似値を使って計算せよ」と指示された場合でも、その近似値の精度が十分かどうかを意識することが重要です。特に、指数関数や対数関数のような非線形な関数では、わずかな誤差が大きな影響を及ぼすことがあります。

## 完全なJuliaコード

最後に、上記の検証を一つにまとめたコードを示します。

```julia
using Measurements

println("=" ^ 60)
println("問題: 6^700 の最高位の数字を求める")
println("=" ^ 60)

# 1. 正確な計算
println("\n[1] 正確な計算（高精度）")
println("-" ^ 60)

result = BigInt(6)^700
result_str = string(result)
println("6^700 の最高位の数字: ", result_str[1])
println("桁数: ", length(result_str))

# 正確な対数
setprecision(BigFloat, 256)
log10_6_exact = log10(BigFloat(6))
log10_result_exact = 700 * log10_6_exact
fractional_exact = log10_result_exact - floor(log10_result_exact)
first_digit_exact = 10^fractional_exact

println("log₁₀(6^700) = ", Float64(log10_result_exact))
println("小数部分 = ", Float64(fractional_exact))
println("10^(小数部分) = ", Float64(first_digit_exact))
println("最高位の数字: ", floor(Int, first_digit_exact))

# 2. 近似値を使った計算
println("\n[2] 与えられた近似値を使った計算")
println("-" ^ 60)

log10_2_approx = 0.3010
log10_3_approx = 0.4771
log10_6_approx = log10_2_approx + log10_3_approx
log10_result_approx = 700 * log10_6_approx
fractional_approx = log10_result_approx - floor(log10_result_approx)
first_digit_approx = 10^fractional_approx

println("log₁₀(6) ≈ ", log10_6_approx)
println("log₁₀(6^700) ≈ ", log10_result_approx)
println("小数部分 ≈ ", fractional_approx)
println("10^(小数部分) ≈ ", first_digit_approx)
println("近似値による最高位の数字: ", floor(Int, first_digit_approx))

# 3. Measurements.jlで誤差解析
println("\n[3] Measurements.jlによる誤差解析")
println("-" ^ 60)

log10_2_measured = 0.3010 ± 0.00005
log10_3_measured = 0.4771 ± 0.00005
log10_6_measured = log10_2_measured + log10_3_measured
log10_result_measured = 700 * log10_6_measured

center_value = log10_result_measured.val
uncertainty = log10_result_measured.err
fractional = center_value - floor(center_value)

println("log₁₀(2) = ", log10_2_measured)
println("log₁₀(3) = ", log10_3_measured)
println("log₁₀(6) = ", log10_6_measured)
println("log₁₀(6^700) = ", log10_result_measured)
println("\n小数部分: ", fractional, " ± ", uncertainty)
println("範囲: ", fractional - uncertainty, " ~ ", fractional + uncertainty)

lower_bound = 10^(fractional - uncertainty)
upper_bound = 10^(fractional + uncertainty)

println("\n10^(小数部分)の範囲:")
println("  下限: ", lower_bound, " → 最高位 ", floor(Int, lower_bound))
println("  上限: ", upper_bound, " → 最高位 ", floor(Int, upper_bound))

# 4. 結論
println("\n[4] 結論")
println("-" ^ 60)
println("✓ 正確な計算: 最高位は 5")
println("✗ 近似値計算: 最高位は 4 （誤答！）")
println("⚠️  誤差解析: 最高位は 4 または 5 の可能性あり（判定不能）")
println("\n問題点: log₁₀の精度不足により、700倍した時点で")
println("         誤差が ±0.05 程度に増幅され、臨界点（log₁₀(5)≈0.699）")
println("         をまたいでしまったため、最高位が確定できない。")
println("=" ^ 60)
```

このコードを実行することで、問題の本質的な原因を数値的に確認できます。

## 参考文献

本記事で使用したJuliaのMeasurements.jlパッケージについては、以下のZenn記事を参考にしました：

- [JuliaのMeasurements.jlパッケージの使い方](https://zenn.dev/ohno/articles/8f53d45f9ae85d)
