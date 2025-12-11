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

    println("  a = $a")
    println("  N = $N")
    println("  l = gcd(a) = $l")
    println("  divisors(l) = ", divisors(l))

    for k in divisors(l)
        q = div.(a, k)
        phi_k = totient(k)
        multi = multinomial(q...)
        contribution = phi_k * multi
        println("    k=$k: q=$q, φ($k)=$phi_k, multinomial=$multi, contribution=$contribution")
        p += contribution
    end

    println("  sum = $p")
    println("  result = $p ÷ $N = $(p ÷ N)")

    return p ÷ N
end

# 数珠順列
function juzu(a)
    N = sum(a)
    t = enkan(a)
    q = div.(a, 2)
    m = count(isodd, a)

    println("\n数珠順列の計算:")
    println("  円順列の数 = $t")
    println("  q = div.(a, 2) = $q")
    println("  奇数個の種類の数 m = $m")

    if m ≤ 2
        add_term = multinomial(q...)
        println("  m ≤ 2 なので追加項 multinomial(q...) = $add_term を加える")
        t += add_term
        println("  合計 = $t")
    else
        println("  m > 2 なので追加項なし")
    end

    result = t ÷ 2
    println("  最終結果 = $t ÷ 2 = $result")

    return result
end

println("=== テストケース1: [4, 6] ===")
println("\n円順列:")
r1 = enkan([4, 6])
println("\n数珠順列:")
r2 = juzu([4, 6])
println("\n期待値: 円順列=22, 数珠順列=16")
println("実際の値: 円順列=$r1, 数珠順列=$r2")

println("\n" * "="^60)
println("\n=== テストケース2: [3, 2, 2] ===")
println("\n円順列:")
r3 = enkan([3, 2, 2])
println("\n数珠順列:")
r4 = juzu([3, 2, 2])
println("\n期待値: 円順列=36, 数珠順列=18")
println("実際の値: 円順列=$r3, 数珠順列=$r4")

println("\n" * "="^60)
println("\n=== 手計算で検証: [4, 6] ===")
println("ステップ1: N = 4 + 6 = 10")
println("ステップ2: l = gcd(4, 6) = 2")
println("ステップ3: lの約数 = {1, 2}")
println("ステップ4: 各項の計算")
println("  k=1: φ(1)=1, multinomial(10/(4,6)) = 10!/(4!×6!) = ", multinomial(4, 6))
println("       寄与 = 1 × ", multinomial(4, 6), " = ", 1 * multinomial(4, 6))
println("  k=2: φ(2)=1, multinomial(5/(2,3)) = 5!/(2!×3!) = ", multinomial(2, 3))
println("       寄与 = 1 × ", multinomial(2, 3), " = ", 1 * multinomial(2, 3))
println("ステップ5: 合計 = ", 1 * multinomial(4, 6) + 1 * multinomial(2, 3))
println("ステップ6: 結果 = ", (1 * multinomial(4, 6) + 1 * multinomial(2, 3)), " ÷ 10 = ", (1 * multinomial(4, 6) + 1 * multinomial(2, 3)) ÷ 10)
