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
    m = count(isodd, a)

    if m ≤ 2
        t += multinomial(q...)
    end

    return t ÷ 2
end

println("=== 基本版の実行例 ===")
println()

# 小さい数の例
println("円順列 enkan([4, 6]) = ", enkan([4, 6]))        # 22
println("数珠順列 juzu([4, 6]) = ", juzu([4, 6]))        # 16
println()

println("円順列 enkan([3, 2, 2]) = ", enkan([3, 2, 2]))  # 36
println("数珠順列 juzu([3, 2, 2]) = ", juzu([3, 2, 2]))  # 18
println()

println("円順列 enkan([3, 3, 3]) = ", enkan([3, 3, 3]))  # 188
println("数珠順列 juzu([3, 3, 3]) = ", juzu([3, 3, 3]))  # 94
println()

# 約数を求める関数（BigInt対応）
function divisors_big(n::T) where T<:Integer
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
function multinomial_big(args...)
    T = promote_type(typeof.(args)...)
    n = sum(args)
    result = factorial(big(n))
    for k in args
        result ÷= factorial(big(k))
    end
    return T(result)
end

# 円順列（BigInt対応）
function enkan_big(a::Vector{T}) where T<:Integer
    l = gcd(a)
    N = sum(a)
    p = zero(BigInt)

    for k in divisors_big(l)
        q = div.(a, k)
        p += totient(k) * multinomial_big(q...)
    end

    return T(p ÷ N)
end

# 数珠順列（BigInt対応）
function juzu_big(a::Vector{T}) where T<:Integer
    N = sum(a)
    t = BigInt(enkan_big(a))
    q = div.(a, 2)
    m = count(isodd, a)

    if m ≤ 2
        t += multinomial_big(q...)
    end

    return T(t ÷ 2)
end

println("=== BigInt版の実行例 ===")
println()

# 大きな数の例（BigInt使用）
a_big = big.([50, 50, 50])
println("円順列（大）enkan($a_big) = ", enkan_big(a_big))
println("数珠順列（大）juzu($a_big) = ", juzu_big(a_big))
println()

# さらに大きな例
a_huge = big.([100, 100, 100, 100])
result = juzu_big(a_huge)
result_str = string(result)
if length(result_str) > 60
    println("数珠順列（巨大）juzu($a_huge) = ", result_str[1:60], "... (", length(result_str), " 桁)")
else
    println("数珠順列（巨大）juzu($a_huge) = ", result)
end
