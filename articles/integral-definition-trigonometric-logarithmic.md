---
title: "積分による三角関数・対数関数の定義"
emoji: "📐"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ["数学", "julia", "微積分", "三角関数"]
published: true

---

## はじめに

本記事では、三角関数と対数関数を積分（長さ・面積）から定義する立場を採用し、高校数学から大学数学への自然な接続を試みます。

従来の高校数学では「定義を与えずに性質だけを列挙する」ことで生じる違和感や循環論法の問題を、積分による定義によって解消します。

具体的には：
- 単位円の**弧長**としてラジアンを定義し、その逆関数として正弦関数を導入
- 双曲線 $y=1/x$ の下の**面積**として対数関数を定義し、その逆関数として指数関数を導く

この立場により、微分公式・加法定理・基本極限などの性質がすべて定義から必然的に導かれることを示します。また、Juliaによる数値計算でこれらの定義を実装し、π や e の値を積分から直接計算します。

## 三角関数

### 単位円と「角＝長さ」という考え

**単位円 $x^2 + y^2 = 1$** を用いて、通常の高校数学では次のような順番で三角関数を考えます。

```
角 → 座標 → 三角関数
```

今回は、この順番を変えて、

```
積分（長さ）→ 角 → 三角関数
```

という順で定義します。

### 単位円の弧長として角を定義する

単位円の右半分を

$$
(x(t), y(t)) = (\sqrt{1-t^2}, t) \quad (-1 < t < 1)
$$

とパラメータ表示します。

**速さ（弧長要素）**

$$
x'(t) = \frac{-t}{\sqrt{1-t^2}}, \quad y'(t) = 1
$$

$$
\therefore \sqrt{x'(t)^2 + y'(t)^2} = \sqrt{\frac{t^2}{1-t^2} + 1} = \frac{1}{\sqrt{1-t^2}}
$$

**角の定義（積分）**

原点から見て、点P $(\sqrt{1-y^2}, y)$ までの弧長 $\theta$ を次のように定めます。

$$
\boxed{\theta = \int_0^y \frac{dt}{\sqrt{1-t^2}} \quad (-1 < y < 1)}
$$

- これは単位円上の弧の長さです
- 単位円なので「弧長 = 中心角（ラジアン）」

👉 $\pi$ の定義は次のようになります。

$$
\boxed{\pi = 2\int_0^1 \frac{dt}{\sqrt{1-t^2}}}
$$

### 正弦関数の定義（逆関数として）

上の定義より

$$
\theta = \int_0^y \frac{dt}{\sqrt{1-t^2}}
$$

は $y$ の単調増加関数です。よって逆関数 $\theta \to y$ が存在します。この逆関数を $\sin$ と定義すると、

$$
\boxed{y = \sin \theta \quad \left(-\frac{\pi}{2} < \theta < \frac{\pi}{2}\right)}
$$

つまり、**正弦とは「弧長 $\theta$ に対応する単位円上の $y$ 座標」** となります。

### 微分から余弦関数へ

**微分**

$$
\theta = \int_0^y \frac{dt}{\sqrt{1-t^2}} \quad \Longrightarrow \quad \frac{d\theta}{dy} = \frac{1}{\sqrt{1-y^2}}
$$

$$
\therefore \frac{dy}{d\theta} = \sqrt{1-y^2}
$$

$$
\therefore \frac{d}{d\theta} \sin \theta = \sqrt{1 - \sin^2 \theta}
$$

**余弦関数の定義**

$$
\boxed{\cos \theta = \sqrt{1 - \sin^2 \theta} \quad \left(-\frac{\pi}{2} < \theta < \frac{\pi}{2}\right)}
$$

$\cos \theta$ をこのように定義すれば、

$$
\sin^2 \theta + \cos^2 \theta = 1
$$

$$
(\sin \theta)' = \cos \theta
$$

が成り立ちます。

### 面積 $S=\theta/2$ が自然に出る理由

![単位円の扇形](/images/110_unit_circle_sector.png)

単位円の扇形の面積 $S$ は、部分積分を用いると

$$
S = \int_0^y \sqrt{1-t^2} \, dt - \frac{1}{2} y \sqrt{1-y^2}
$$

部分積分により、

$$
\int_0^y \sqrt{1-t^2} \, dt = \left[t \sqrt{1-t^2}\right]_0^y + \int_0^y \frac{t^2}{\sqrt{1-t^2}} dt
$$

$$
= y \sqrt{1-y^2} + \int_0^y \frac{t^2-1+1}{\sqrt{1-t^2}} dt
$$

$$
= y \sqrt{1-y^2} - \int_0^y \sqrt{1-t^2} dt + \int_0^y \frac{dt}{\sqrt{1-t^2}}
$$

$$
\therefore \int_0^y \sqrt{1-t^2} \, dt = \frac{1}{2} y \sqrt{1-y^2} + \frac{1}{2} \int_0^y \frac{dt}{\sqrt{1-t^2}}
$$

$$
\therefore S = \frac{1}{2} \int_0^y \frac{dt}{\sqrt{1-t^2}} = \frac{1}{2} \theta
$$

つまり、**単位円の扇形の面積は $\frac{1}{2}\theta$** となります。

### 極限 $\lim_{\theta \to 0} \frac{\sin \theta}{\theta} = 1$

👉 面積比較や「循環論法」は不要です。

$$
\boxed{\frac{\sin \theta}{\theta} \quad \Longrightarrow \quad \lim_{\theta \to 0} = \left.\frac{d}{d\theta} \sin \theta\right|_{\theta=0} = \cos 0 = 1}
$$

## 対数関数・指数関数

### 対数関数の定義

対数関数 $\log$ を次のように定義します。

$$
\boxed{\log x = \int_1^x \frac{dt}{t} \quad (x > 0)}
$$

これは

- 点 $(1, 0)$ から $(x, 0)$ まで
- 曲線 $y = 1/t$ の下の符号付き面積

として定義されます。

### 基本性質

定義から導くことができます。

- $\displaystyle \log 1 = \int_1^1 \frac{dt}{t} = 0$

- **微分** 積分の基本定理より

$$
\frac{d}{dx} \log x = \frac{1}{x}
$$

  - $\log x$ は単調増加である

### 対数関数の性質

**命題**

$$
\boxed{\log(ab) = \log a + \log b}
$$

**証明**

$$
\log(ab) = \int_1^{ab} \frac{dt}{t} = \int_1^a \frac{dt}{t} + \int_a^{ab} \frac{dt}{t}
$$

後半で変数変換 $t = au$ を行うと

$$
\int_a^{ab} \frac{dt}{t} = \int_1^b \frac{du}{u} = \log b
$$

### 指数関数の定義（逆関数）

$\log x$ は単調増加なので逆関数をもちます。

**定義**

$$
\boxed{x = \exp t \Longleftrightarrow t = \log x}
$$

### 微分から指数関数へ

逆関数の微分より

$$
\frac{dt}{dx} = \frac{1}{x} \Longrightarrow \frac{dx}{dt} = x
$$

したがって

$$
\boxed{\frac{d}{dt} \exp t = \exp t}
$$

👉 指数関数とは「自分自身が微分になる関数」です。

### 定数 $e$ の定義

**定義**

$$
\boxed{e = \exp 1}
$$

すなわち、$e$ は

> 曲線 $\displaystyle y = \frac{1}{x}$ の下の面積が 1 になるときの $x$

### 基本極限の即時導出

$$
\lim_{x \to 0} \frac{e^x - 1}{x} = \left.\frac{d}{dx} e^x\right|_{x=0} = e^0 = 1
$$

### まとめ（三角関数との対応）

三角関数と対数関数は、いずれも「積分で定義される量の逆関数」という共通構造をもちます。

| **三角関数** | **対数関数** |
|:------------|:------------|
| 単位円の弧長 | 双曲線下の面積 |
| $\displaystyle \theta = \int_0^y \frac{dt}{\sqrt{1-t^2}}$ | $\displaystyle \log x = \int_1^x \frac{dt}{t}$ |
| 逆関数が $\sin$ | 逆関数が $\exp$ |

## Juliaによる数値実験

以上の定義を、Juliaで実装して数値的に確認してみます。

### π の計算

$$
\pi = 2\int_0^1 \frac{dt}{\sqrt{1-t^2}}
$$

```julia
using QuadGK

# π の計算
integral_pi, error = quadgk(t -> 1/sqrt(1 - t^2), 0, 1)
pi_calculated = 2 * integral_pi

println("積分による π の値: ", pi_calculated)
println("Julia の π の値:    ", Float64(pi))
println("誤差:              ", abs(pi_calculated - π))
```

**出力:**
```
積分による π の値: 3.14159262139778
Julia の π の値:    3.141592653589793
誤差:              3.2192013055265534e-8
```

### e の計算

$\log e = 1$ となる $e$ を求めるため、$\int_1^x \frac{ds}{s} = 1$ を満たす $x$ を二分法で探します。

```julia
# log(x) = ∫₁ˣ 1/s ds を計算する関数
function log_integral(x)
    if x == 1
        return 0.0
    end
    integral, _ = quadgk(s -> 1/s, 1, x)
    return integral
end

# log(e) = 1 となる e を二分法で求める
function find_e()
    a, b = 2.0, 3.0
    tolerance = 1e-10

    while b - a > tolerance
        mid = (a + b) / 2
        log_mid = log_integral(mid)

        if log_mid < 1
            a = mid
        else
            b = mid
        end
    end

    return (a + b) / 2
end

e_calculated = find_e()
println("積分による e の値: ", e_calculated)
println("Julia の ℯ の値:   ", ℯ |> Float64)
println("誤差:             ", abs(e_calculated - ℯ))
```

**出力:**
```
積分による e の値: 2.7182818284782115
Julia の ℯ の値:   2.718281828459045
誤差:             1.9166446207918852e-11
```

### 正弦関数の計算

```julia
# y から θ を計算（弧長の積分）
function y_to_theta(y)
    if y == 0
        return 0.0
    end
    integral, _ = quadgk(t -> 1/sqrt(1 - t^2), 0, y)
    return integral
end

# θ から y を計算（逆関数として sin を定義）
function theta_to_y(theta)
    if theta == 0
        return 0.0
    end

    a, b = 0.0, 1.0
    tolerance = 1e-10

    while b - a > tolerance
        mid = (a + b) / 2
        theta_mid = y_to_theta(mid)

        if theta_mid < theta
            a = mid
        else
            b = mid
        end
    end

    return (a + b) / 2
end

# テスト: θ = π/6 (30度) のとき sin(π/6) = 0.5
theta_test = pi_calculated / 6
sin_calculated = theta_to_y(theta_test)

println("θ = π/6 のとき")
println("積分による sin(π/6): ", sin_calculated)
println("Julia の sin(π/6):   ", sin(π/6))
```

**出力:**
```
θ = π/6 のとき
積分による sin(π/6): 0.49999999537249096
Julia の sin(π/6):   0.49999999999999994
```

### 可視化

#### 正弦関数

![正弦関数（積分定義）](/images/110_graph_1.png)

青線が積分による定義、破線がJuliaの組み込み`sin`関数です。完全に一致していることがわかります。

#### 対数関数

![対数関数（積分定義）](/images/110_graph_2.png)

青線が積分による定義、破線がJuliaの組み込み`log`関数です。赤い点が $e$ の位置（$\log e = 1$）を示しています。

## まとめ

本記事では、三角関数と対数関数を積分から定義する立場を採用しました。

**メリット:**
1. **循環論法の回避**: 微分公式を証明するために微分を使う必要がない
2. **定義の明確化**: 「角とは長さである」「対数とは面積である」という幾何学的直観
3. **自然な導出**: 加法定理、基本極限などがすべて定義から導かれる
4. **大学数学への接続**: より厳密な解析学への自然な橋渡し

Juliaによる数値実験により、これらの定義が実際に正しく機能することを確認できました。

## 参考文献

黒木玄 (2025). "積分による三角関数・対数関数の定義に関する議論". X (旧Twitter), 2025年1月10日. https://x.com/genkuroki/status/2009564879557181825

## 生成AI

本稿の執筆にあたり、ChatGPT-5.2およびClaude Code (Sonnet 4.5) を文書作成支援ツールとして利用しました。
