using Statistics

# ── simulate_once ──────────────────────────────────────────────
function simulate_once(n::Int; stable_threshold::Int=100)
    rounds = 0
    current = n
    stable_count = 0
    while stable_count < stable_threshold
        count_heads = sum(rand(0:1, current))
        count_tails = current - count_heads
        rounds += 1
        next = if count_heads > count_tails
            count_heads
        elseif count_tails > count_heads
            count_tails
        else
            current
        end
        stable_count = (next == current) ? stable_count + 1 : 0
        current = next
    end
    return current, rounds - stable_threshold
end

println("=== テスト ===")
for n in [3, 5, 10, 20]
    final, rounds = simulate_once(n)
    println("n=$n → 最終人数: $final 人（$rounds ラウンド）")
end

# ── simulate_many ──────────────────────────────────────────────
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

println("\n=== 多数回シミュレーション (n=10, trials=10000) ===")
n = 10
trials = 10000
final_counts, round_counts = simulate_many(n, trials)
println("n=$n, 試行回数=$trials")
println("最終人数の平均: ", round(mean(final_counts), digits=3))
println("ラウンド数の平均: ", round(mean(round_counts), digits=3))
println("ラウンド数の最大: ", maximum(round_counts))

# ── n を変えてラウンド数の期待値を調べる ──────────────────────
println("\n=== n を変えてラウンド数の期待値を調べる ===")
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

# ── 対数フィッティング ─────────────────────────────────────────
println("\n=== 対数フィッティング ===")
ns_fit = collect(3:100)
trials_fit = 5000
avg_rounds_fit = Float64[]
for n in ns_fit
    _, rc = simulate_many(n, trials_fit)
    push!(avg_rounds_fit, mean(rc))
end
log2_ns = log2.(ns_fit)
A = hcat(log2_ns, ones(length(log2_ns)))
coeffs = A \ avg_rounds_fit
a, b = coeffs
println("フィット結果：E[ラウンド数] ≈ $(round(a, digits=3)) × log₂(n) + $(round(b, digits=3))")

# ── simulate_trace ─────────────────────────────────────────────
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

println("\n=== simulate_trace (n=30, 3試行) ===")
for i in 1:3
    trace = simulate_trace(30)
    println("試行$i: $(length(trace)-1) ラウンド → 最終 $(trace[end]) 人  推移: $trace")
end
