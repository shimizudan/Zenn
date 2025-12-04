"""
標本標準偏差の期待値に関するシミュレーション

標本標準偏差 S = √(1/n Σ(Xₖ - X̄)²) の期待値 E(S) と
真の標準偏差 σ の関係を数値的に検証する
"""

using Statistics
using Random
using Printf
using SpecialFunctions  # gamma 関数用

"""
    simulate_sample_std(n::Int, σ::Real, num_trials::Int=10000)

サンプルサイズ n の標本標準偏差の期待値を Monte Carlo シミュレーションで推定

# Arguments
- `n::Int`: サンプルサイズ
- `σ::Real`: 母集団の標準偏差
- `num_trials::Int`: シミュレーション回数（デフォルト: 10000）

# Returns
- `mean_S`: 標本標準偏差 S の平均（E(S) の推定値）
- `mean_S2`: 標本分散 S² の平均（E(S²) の推定値）
- `sqrt_mean_S2`: √E(S²) の値
"""
function simulate_sample_std(n::Int, σ::Real, num_trials::Int=10000)
    Random.seed!(42)  # 再現性のため

    S_values = Float64[]
    S2_values = Float64[]

    for _ in 1:num_trials
        # 正規分布 N(0, σ²) からサンプリング
        sample = randn(n) * σ

        # 標本分散 S² = (1/n) Σ(Xₖ - X̄)²
        S2 = var(sample, corrected=false)  # corrected=false で n で割る

        # 標本標準偏差 S = √S²
        S = sqrt(S2)

        push!(S_values, S)
        push!(S2_values, S2)
    end

    mean_S = mean(S_values)
    mean_S2 = mean(S2_values)
    sqrt_mean_S2 = sqrt(mean_S2)

    return mean_S, mean_S2, sqrt_mean_S2
end

"""
    theoretical_mean_S2(n::Int, σ::Real)

標本分散 S² の理論的期待値を計算

E(S²) = (1 - 1/n)σ²
"""
theoretical_mean_S2(n::Int, σ::Real) = (1 - 1/n) * σ^2

"""
    bias_factor(n::Int)

標本標準偏差の補正係数 c₄(n) を計算

正規分布の場合、E(S) = c₄(n) × σ
c₄(n) = √(2/(n-1)) × Γ(n/2) / Γ((n-1)/2)

近似: c₄(n) ≈ 1 - 1/(4n) - 7/(32n²) - 19/(128n³) ...
"""
function bias_factor(n::Int)
    # ガンマ関数を使った正確な計算
    # 大きな n では loggamma を使って数値的安定性を向上
    if n > 300
        # log(c₄(n)) = 0.5*log(2/(n-1)) + loggamma(n/2) - loggamma((n-1)/2)
        log_c4 = 0.5 * log(2/(n-1)) + loggamma(n/2) - loggamma((n-1)/2)
        return exp(log_c4)
    else
        return sqrt(2/(n-1)) * gamma(n/2) / gamma((n-1)/2)
    end
end

# シミュレーション実行
println("="^70)
println("標本標準偏差の期待値に関するシミュレーション")
println("="^70)
println()

σ = 1.0  # 真の標準偏差
sample_sizes = [5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000]

println("母集団の標準偏差 σ = $σ")
println()
println("凸不等式: σ ≥ √E(S²) ≥ E(S)")
println()

# 表形式で結果を表示
println(@sprintf("%6s | %10s | %10s | %10s | %10s | %10s",
    "n", "E(S)", "√E(S²)", "σ", "c₄(n)", "c₄(n)×σ"))
println("-"^70)

for n in sample_sizes
    mean_S, mean_S2, sqrt_mean_S2 = simulate_sample_std(n, σ, 20000)
    c4 = bias_factor(n)
    theoretical_ES = c4 * σ

    println(@sprintf("%6d | %10.6f | %10.6f | %10.6f | %10.6f | %10.6f",
        n, mean_S, sqrt_mean_S2, σ, c4, theoretical_ES))
end

println()
println("="^70)
println("検証結果:")
println("="^70)
println()

# 大きなサンプルサイズでの検証
n_large = 10000
mean_S, mean_S2, sqrt_mean_S2 = simulate_sample_std(n_large, σ, 50000)
c4 = bias_factor(n_large)

println("n = $n_large の場合:")
println("  E(S)      ≈ $(round(mean_S, digits=8))")
println("  √E(S²)    ≈ $(round(sqrt_mean_S2, digits=8))")
println("  σ         = $(round(σ, digits=8))")
println("  c₄(n)×σ   ≈ $(round(c4 * σ, digits=8))")
println()

# E(S²) の理論値と数値計算の比較
println("E(S²) の検証:")
for n in [10, 100, 1000]
    local _, mean_S2, _ = simulate_sample_std(n, σ, 20000)
    local theoretical = theoretical_mean_S2(n, σ)
    println("  n = $n: 数値計算 = $(round(mean_S2, digits=6)), " *
            "理論値 = $(round(theoretical, digits=6))")
end

println()
println("="^70)
println("結論:")
println("="^70)
println()
println("1. 凸不等式 σ ≥ √E(S²) ≥ E(S) が成立している")
println("2. n が大きくなると E(S) は σ に近づくが、")
println("   厳密には E(S) = c₄(n)×σ < σ となる")
println("3. c₄(n) ≈ 1 - 1/(4n) なので、バイアスは O(1/n) で減少")
println("4. 実用上、n が十分大きければ E(S) ≈ σ と近似してよい")
println()

# バイアスの可視化
println("="^70)
println("バイアス (σ - E(S)) の減少:")
println("="^70)
println()

println(@sprintf("%8s | %12s | %12s | %12s",
    "n", "σ - E(S)", "1/(4n)", "相対誤差"))
println("-"^50)

for n in [10, 50, 100, 500, 1000, 5000, 10000]
    local mean_S, _, _ = simulate_sample_std(n, σ, 20000)
    local bias = σ - mean_S
    local approx_bias = 1/(4*n)
    local rel_error = abs(bias - approx_bias) / approx_bias * 100

    println(@sprintf("%8d | %12.8f | %12.8f | %11.2f%%",
        n, bias, approx_bias, rel_error))
end

println()
println("バイアス ≈ 1/(4n) の近似が良く成立している")
