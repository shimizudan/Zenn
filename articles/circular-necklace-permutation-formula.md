---
title: "同じものを含む円順列・数珠順列の公式について"
emoji: "📿"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: [julia, 数学, 組合せ論, 数論]
published: true # trueを指定する
published_at: 2025-12-25 00:03 # 未来の日時を指定する

---


この記事は [日曜数学 Advent Calendar 2025](https://adventar.org/calendars/12125) 、
[Julia Advent Calendar 2025 シリーズ2](https://qiita.com/advent-calendar/2025/julia)の12月25日の記事です。

## はじめに

円順列や数珠順列は、組合せ論の基本的なテーマです。しかし、**同じものを含む場合**の公式は複雑で、「なぜその式で求まるのか」を理解するのは容易ではありません。

:::message
**具体例：**
赤玉4個、白玉6個を円形に並べる方法は何通りあるか？

答え：**22通り**
:::

本記事では、この公式の**数学的背景**を詳しく解説し、最後にJuliaでの実装を紹介します。

### 関連記事

以前、Juliaでの実装を紹介した記事があります：
- [Julia での順列・組み合わせ・円順列・数珠順列](https://zenn.dev/dannchu/articles/4d35b5d2b4c94c)
- [同じものを含む円順列の総数（Julia版）](https://zenn.dev/dannchu/articles/2a27581585a338)
- [Julia実装：同じものを含む円順列・数珠順列](https://zenn.dev/dannchu/articles/b7418ba9c0560d)

本記事では、**公式の数学的な理由**に焦点を当てます。

## 基礎知識の復習

### 通常の順列と円順列

**順列（一列に並べる）：**
異なるn個のものを一列に並べる方法は $n!$ 通り。

**円順列（円形に並べる）：**
異なるn個のものを円形に並べる方法は $(n-1)!$ 通り。

なぜ $(n-1)!$ になるかというと、円形配置では「回転して同じになる配置」を1通りと数えるためです。n個の順列 $n!$ を、n通りの回転で割って $\frac{n!}{n} = (n-1)!$ となります。

### 同じものを含む順列（多項係数）

$n$個のうち、種類$1$が$n₁$個、種類$2$が$n₂$個、...、種類$m$が$nₘ$個あるとき（$n = n_1 + n_2 + \cdots + n_m$）、一列に並べる方法は：

$$
\frac{n!}{n_1! \cdot n_2! \cdots n_m!} = \binom{n}{n_1, n_2, \ldots, n_m}
$$

右辺の記号 $\binom{n}{n_1, n_2, \ldots, n_m}$ を**多項係数**（multinomial coefficient）といいます。これは通常の二項係数 $\binom{n}{k}$ を一般化したものです。

**例：** 赤玉2個、青玉3個を一列に並べる方法

$$
\binom{5}{2,3}=\frac{5!}{2! \cdot 3!} = \frac{120}{2 \cdot 6} = 10 \text{ 通り}
$$

## 同じものを含む円順列の公式

### 友田の公式

$m$種類の球があり、各種類が $n_1, n_2, \ldots, n_m$ 個あるとき、円順列の総数は：

$$
f(n_1, n_2, \ldots, n_m) = \frac{1}{N} \sum_{k \mid l} \varphi(k) \binom{N/k}{n_1/k, n_2/k, \ldots, n_m/k}
$$

ここで：
- $N = n_1 + n_2 + \cdots + n_m$（球の総数）
- $l = \gcd(n_1, n_2, \ldots, n_m)$（全ての個数の最大公約数）
- $k \mid l$ は「$k$ が $l$ の約数」を意味する
- $\varphi(k)$ はオイラーのトーシェント関数（$k$ 以下で $k$ と互いに素な自然数の個数）

### なぜこの公式が成り立つのか？

この公式は**バーンサイドの補題**（コーシー・フロベニウスの定理）に基づいています。

:::message
**バーンサイドの補題とは？**

対称性を持つものを数えるとき、「すべての操作について、その操作で変わらない配置の個数の平均」を取ると、本当に異なる配置の個数が求まる、という定理です。
:::

#### 基本的な考え方

円順列では、**回転させても同じになる配置**を1通りと数えます。

**例：** ABC を円形に並べる
- ABC を時計回りに1つ回転 → BCA
- さらに回転 → CAB

これらは「同じ円順列」として1通りと数えます。

#### バーンサイドの補題の適用

円に $N$ 個の玉を並べる場合、回転操作は以下の $N$ 通りあります：
- 0個分回転（動かさない）
- 1個分回転
- 2個分回転
- ...
- $(N-1)$ 個分回転

バーンサイドの補題により：


$$\text{円順列の数} = \frac{1}{N} \sum_{i=0}^{N-1} \text{($i$ 個分回転で変わらない配置の数)}$$

#### 重要な観察：周期性

「$k$ 個分の回転で元に戻る配置」が存在するためには、**すべての色の個数が $k$ の倍数**である必要があります。

**例：** AABBAABB（赤2個、白2個、赤2個、白2個）
- 4個分の回転で元に戻る
- 赤は4個（4の倍数）、白は4個（4の倍数）なので可能

もし赤3個、白5個の場合、どんな配置でも4個分の回転では元に戻りません（3も5も4の倍数でないため）。

したがって、意味のある回転は

$$
l = \gcd(n_1, n_2, \ldots, n_m)
$$
の約数だけです。

#### オイラーのトーシェント関数 $\varphi(k)$ の登場

実は、$k$ 個分の回転で元に戻る配置の個数を直接数えるのは難しいです。そこで、**周期がちょうど $k$** である配置を数える方が簡単です。

$\varphi(k)$ は、1から $k$ までの整数のうち、$k$ と互いに素なものの個数です：
- $\varphi(1) = 1$
- $\varphi(2) = 1$
- $\varphi(3) = 2$（1と2）
- $\varphi(4) = 2$（1と3）
- $\varphi(6) = 2$（1と5）

**例：** $\varphi(6) = 2$ は、1と5が $\gcd(6,1)=1$、$\gcd(6,5)=1$ を満たすからです。

#### なぜ $\varphi(k)$ が役立つのか？

$N$ 個の位置のうち、**ちょうど $k$ 個ごとに同じパターンが繰り返す配置**を考えます。

このとき、1周するまでに $N/k$ 回パターンが繰り返されます。最初の $k$ 個の位置のうち、どの位置から始めるかで $\varphi(k)$ 通りの「本質的に異なる」配置が得られます。

これを利用して、友田の公式が導かれます。

### 具体例で理解する

**例：** 赤玉4個、白玉6個の円順列

**ステップ1：基本情報の確認**
- $N = 4 + 6 = 10$（玉の総数）
- $l = \gcd(4, 6) = 2$（最大公約数）
- $l$の約数は {1, 2}

**ステップ2：各回転について、変わらない配置を数える**

バーンサイドの補題を使うと：

$$f(4,6) = \frac{1}{10} \sum_{k \mid 2} \text{($k$ 個分の回転で変わらない配置の数)}$$

これを計算するために、友田の公式を使います：

$$
f(4,6) = \frac{1}{10} \left[ \varphi(1) \binom{10}{4,6} + \varphi(2) \binom{5}{2,3} \right]
$$

**ステップ3：各項を計算**

**$k=1$ の項**（回転しない、または10個分回転）

$$
\varphi(1) \binom{10}{4,6} = 1 \times \frac{10!}{4! \cdot 6!} = 1 \times 210 = 210
$$

これは「一列に並べた配置」の数です。10個の位置に赤4個、白6個を配置する方法が210通りあります。

**$k=2$ の項**（2個ずつ、5個分回転で元に戻る配置）

$$
\varphi(2) \binom{5}{2,3} = 1 \times \frac{5!}{2! \cdot 3!} = 1 \times 10 = 10
$$

これは「AABBB のパターンを2回繰り返す」ような配置です。5個の基本パターン（赤2個、白3個）を作り、それを2回繰り返して10個にします。

**ステップ4：合計して平均を取る**

$$
f(4,6) = \frac{1}{10} \left[ 210 + 10 \right] = \frac{220}{10} = 22
$$

**答え：22通り**

### 各項の意味をもっと詳しく

#### $k=1$ の項：周期が10の配置

「10個分回転しないと元に戻らない」配置、つまり普通の配置です。

一列に並べる方法が210通りあり、これらはすべて「0個分の回転」（動かさない）でのみ変わりません。

#### $k=2$ の項：周期が5の配置

「5個分の回転で元に戻る」配置です。

例えば：**赤赤白白白**を2回繰り返すと**赤赤白白白赤赤白白白**となります。

この配置を5個分回転させると：
- 元の配置：赤赤白白白|赤赤白白白
- 5個回転後：赤赤白白白|赤赤白白白（同じ！）

5個の基本パターン（赤2個、白3個）の並べ方は

$$
\binom{5}{2,3} = 10
$$
通りあります。

#### バーンサイドの補題の直感的理解

バーンサイドの補題は「すべての回転操作で変わらない配置の数の平均」を計算します。

- 0個分回転：210個の配置がすべて変わらない
- 1個分回転：0個の配置が変わらない（どれも変わってしまう）
- 2個分回転：0個の配置が変わらない
- ...
- 5個分回転：10個の配置が変わらない（周期5のもの）
- ...
- 9個分回転：0個の配置が変わらない

合計：210 + 0 + 0 + ... + 10 + ... + 0 = 220
平均：220 ÷ 10 = **22通り**

これを効率的に計算するために、友田の公式では最大公約数の約数だけを調べます。

## 数珠順列への拡張

### 数珠順列とは

数珠順列は、円順列に加えて**裏返しても同じ**と見なす配置です。

基本的な考え方：

$$
\text{数珠順列} = \frac{\text{円順列} + \text{対称配置の数}}{2}
$$

### 数珠順列の公式

m種類の球があり、各種類が $n_1, n_2, \ldots, n_m$ 個あるとき、数珠順列の総数は：

$$
g(n_1, n_2, \ldots, n_m) =
\begin{cases}
\displaystyle\frac{f(n_1, n_2, \ldots, n_m) + \binom{N/2}{\lfloor n_1/2 \rfloor, \lfloor n_2/2 \rfloor, \ldots, \lfloor n_m/2 \rfloor}}{2} & (M \leqq 2) \\[10pt]
\displaystyle\frac{f(n_1, n_2, \ldots, n_m)}{2} & (M\geqq 3)
\end{cases}
$$

ここで：
- $f(n_1, n_2, \ldots, n_m)$ は友田の公式で求めた円順列の総数
- $N = n_1 + n_2 + \cdots + n_m$（球の総数）
- $\lfloor x \rfloor$ は床関数（小数点以下切り捨て）
- 奇数個の種類の数 $M = |\{i \mid n_i \text{ は奇数}\}|$

### 対称配置の条件

配置が裏返しと一致する（対称）ためには、**奇数個の種類が2種類以下**である必要があります。

**なぜか？**

円を裏返すということは、配置を線対称にすることです。対称軸を考えると：

1. **軸上の位置**：球の総数 $N$ が奇数なら1個、偶数なら0個または2個
2. **軸の両側**：対称に配置される球は同じ色でなければならない

**偶数個の種類**は両側に同数ずつ配置できますが、**奇数個の種類**は軸上に1個置く必要があります。

- $N$ が偶数の場合：奇数個の種類は0個または2個（2種類が軸上に1個ずつ）
- $N$ が奇数の場合：奇数個の種類は1個（1種類のみ軸上に1個）

したがって、**奇数個の種類が3種類以上**あると対称配置は不可能です。

### 公式

```julia
function juzu(a)
    N = sum(a)
    t = enkan(a)  # 円順列の数
    q = div.(a, 2)
    M = count(isodd, a)  # 奇数個の種類の数

    if M ≤ 2
        # 対称配置が存在する場合
        t += multinomial(q...)
    end

    return t ÷ 2
end
```

**$M \leqq 2$ の場合の追加項** `multinomial(q...)` は、各種類をちょうど半分ずつ（切り捨て）使った配置の数です。これが対称配置の候補となります。

### 従来の4つの場合分けとの関係

従来は以下の4つに分けていました：

1. **全て偶数個**：$M = 0$
2. **奇数1色のみ**：$M = 1$
3. **奇数2色**：$M = 2$
4. **奇数3色以上**：$M \geqq 3$

この4つを **$M \leqq 2$** という単一条件に統合したのが、上記の公式の革新的なポイントです。

## Julia実装

### 基本版

```julia
using Primes

# 約数を求める関数
function divisors(n)
    n == 1 && return [1]
    pf = factor(n)
    divs = [1]
    for (p, e) in pf
        new_divs = Int[]
        for i in 0:e
            append!(new_divs, divs .* p^i)
        end
        divs = new_divs
    end
    return sort(divs)
end

# 多項係数
function multinomial(args...)
    n = sum(args)
    result = factorial(n)
    for k in args
        result ÷= factorial(k)
    end
    return result
end

# 円順列
function enkan(a)
    l = gcd(a)
    N = sum(a)
    p = 0

    for k in divisors(l)
        q = div.(a, k)
        p += totient(k) * multinomial(q...)
    end

    return p ÷ N
end

# 数珠順列
function juzu(a)
    N = sum(a)
    t = enkan(a)
    q = div.(a, 2)
    M = count(isodd, a)

    if M ≤ 2
        t += multinomial(q...)
    end

    return t ÷ 2
end
```

### 大きな数に対応した版

非常に大きな数を扱う場合、`BigInt`を使用します：

```julia
using Primes

# 約数を求める関数（BigInt対応）
function divisors(n::T) where T<:Integer
    n == 1 && return T[1]
    pf = factor(n)
    divs = T[1]
    for (p, e) in pf
        new_divs = T[]
        for i in 0:e
            append!(new_divs, divs .* p^i)
        end
        divs = new_divs
    end
    return sort(divs)
end

# 多項係数（BigInt対応）
function multinomial(args...)
    T = promote_type(typeof.(args)...)
    n = sum(args)
    result = factorial(big(n))
    for k in args
        result ÷= factorial(big(k))
    end
    return T(result)
end

# 円順列（BigInt対応）
function enkan(a::Vector{T}) where T<:Integer
    l = gcd(a)
    N = sum(a)
    p = zero(BigInt)

    for k in divisors(l)
        q = div.(a, k)
        p += totient(k) * multinomial(q...)
    end

    return T(p ÷ N)
end

# 数珠順列（BigInt対応）
function juzu(a::Vector{T}) where T<:Integer
    N = sum(a)
    t = BigInt(enkan(a))
    q = div.(a, 2)
    M = count(isodd, a)

    if M ≤ 2
        t += multinomial(q...)
    end

    return T(t ÷ 2)
end
```

### 実行例

```julia
# 小さい数の例
println("円順列 enkan([4, 6]) = ", enkan([4, 6]))        # 22
println("数珠順列 juzu([4, 6]) = ", juzu([4, 6]))        # 16

println("円順列 enkan([3, 2, 2]) = ", enkan([3, 2, 2]))  # 30
println("数珠順列 juzu([3, 2, 2]) = ", juzu([3, 2, 2]))  # 18

println("円順列 enkan([3, 3, 3]) = ", enkan([3, 3, 3]))  # 188
println("数珠順列 juzu([3, 3, 3]) = ", juzu([3, 3, 3]))  # 94

# 大きな数の例（BigInt使用）
a_big = big.([50, 50, 50])
println("円順列（大）enkan($a_big) = ", enkan(a_big))
println("数珠順列（大）juzu($a_big) = ", juzu(a_big))

# さらに大きな例
a_huge = big.([100, 100, 100, 100])
println("数珠順列（巨大）juzu($a_huge) = ", juzu(a_huge))
```

### 実行結果

```
円順列 enkan([4, 6]) = 22
数珠順列 juzu([4, 6]) = 16
円順列 enkan([3, 2, 2]) = 30
数珠順列 juzu([3, 2, 2]) = 18
円順列 enkan([3, 3, 3]) = 188
数珠順列 juzu([3, 3, 3]) = 94
円順列（大）enkan([50, 50, 50]) = 13538717753897293206738502797409038030676021535992164043823429191616
数珠順列（大）juzu([50, 50, 50]) = 6769358876948646603369251398704522339213078664466515960526240317936
数珠順列（巨大）juzu([100, 100, 100, 100]) = 105513874772580866903701484326970783912796602953267550981465... (235桁)
```

## まとめ

本記事では、同じものを含む円順列・数珠順列の公式について、以下を解説しました：

1. **友田の公式**は、バーンサイドの補題（コーシー・フロベニウスの定理）に基づく
2. **最大公約数の約数**を調べるのは、配置の周期性を考慮するため
3. **オイラーのトーシェント関数**は、原始的な周期を持つ配置を数えるため
4. **数珠順列の条件「$\bold{m \leqq 2}$」** は、対称配置の存在条件を表す
5. **Julia実装**では、BigIntを使うことで任意精度の計算が可能

この公式を理解することで、組合せ論と数論のつながりを実感できます。

### 重要ポイントの再確認

**バーンサイドの補題の本質：**
- 回転などの対称操作で「変わらない配置」の数を平均すると、本質的に異なる配置の数が得られる
- これは高校数学の範囲を少し超えますが、具体例で理解できる美しい定理です

**なぜ最大公約数が重要か：**
- すべての色の個数の最大公約数の約数だけを調べれば十分
- それ以外の回転では、変わらない配置は存在しない

**数珠順列のポイント：**
- 円順列に「裏返し」の操作を加えたもの
- 奇数個の種類が3種類以上あると、対称配置は作れない

## 参考文献

- [友田勝久「完全順列，全射，円順列の総数－反転公式および和集合の要素数に関する公式の利用－」(2012)](https://tomodak.com/report/junretsu2012.pdf)
- [Burnside's lemma - Wikipedia](https://en.wikipedia.org/wiki/Burnside's_lemma)
- [Brilliant Math & Science Wiki: Burnside's Lemma](https://brilliant.org/wiki/burnsides-lemma/)
- [Cauchy-Frobenius Lemma - Wolfram MathWorld](https://mathworld.wolfram.com/Cauchy-FrobeniusLemma.html)
- [Julia での順列・組み合わせ・円順列・数珠順列](https://zenn.dev/dannchu/articles/4d35b5d2b4c94c)
- [同じものを含む円順列の総数(Julia版)](https://zenn.dev/dannchu/articles/2a27581585a338)
- [Julia実装:同じものを含む円順列・数珠順列](https://zenn.dev/dannchu/articles/b7418ba9c0560d)
