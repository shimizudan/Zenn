println("=" ^ 50)
println("■ 全探索")
println("=" ^ 50)

solutions = Int[]
for L in 0:160
    honest_count = count(n -> L % n == 0, 1:160)
    liar_count = 160 - honest_count
    if liar_count == L
        push!(solutions, L)
    end
end
println("解: ", solutions)

println()
println("=" ^ 50)
println("■ 解の詳細")
println("=" ^ 50)

for L in solutions
    divisors_in_range = filter(n -> L % n == 0, 1:160)
    println("=== 嘘つきの人数: L = $L ===")
    println("  正直者の数: ", 160 - L, " 人")
    println("  正直者（Lの約数）: ", divisors_in_range)
    println()
end

println("=" ^ 50)
println("■ 約数の個数（Primes）")
println("=" ^ 50)

using Primes

X = []
for x in 1:160
    append!(X, divisors(x) |> length)
end
@show union!(X)
println("最大値: ", maximum(union!(X)))

println()
X2 = 160 .- [7, 8, 9, 12, 15, 16]
println("[divisors(x) for x in X2]:")
for (d, x) in zip([7,8,9,12,15,16], X2)
    divs = divisors(x)
    println("  d=$(d), L=$(x): 約数の個数=$(length(divs)), 一致=$(length(divs)==d ? "✓" : "✗")")
end

println()
println("=" ^ 50)
println("■ x=1〜1000 全探索")
println("=" ^ 50)

results = Dict{Int, Vector{Int}}()
for x in 1:1000
    sols_x = Int[]
    for L in 0:x
        honest_count = count(n -> L % n == 0, 1:x)
        liar_count = x - honest_count
        if liar_count == L
            push!(sols_x, L)
        end
    end
    results[x] = sols_x
end
println("x=160: ", results[160])
println("x=50:  ", results[50])

println()
println("=" ^ 50)
println("■ 解の個数の集計")
println("=" ^ 50)

using Printf
println("解の個数  該当する x の一覧")
println("-" ^ 60)
for k in sort(unique(length(v) for v in values(results)))
    xs = sort([x for (x, v) in results if length(v) == k])
    println("解が $(k) 個 : x = $(xs)")
end
println()
println("解が 0 のケース（解なし）:")
no_sol = sort([x for (x, v) in results if isempty(v)])
println(no_sol)

println()
println("=" ^ 50)
println("■ x=50 詳細")
println("=" ^ 50)

x = 50
solutions_50 = Int[]
for L in 0:x
    honest_count = count(n -> L % n == 0, 1:x)
    liar_count = x - honest_count
    if liar_count == L
        push!(solutions_50, L)
    end
end
println("=== x = $x のとき ===")
println("解: ", solutions_50)
println()
for L in solutions_50
    divs = filter(n -> L % n == 0, 1:x)
    println("--- L = $L ---")
    println("  正直者の数: $(x - L) 人")
    println("  約数（1〜$(x) 内）: $(divs)  → $(length(divs)) 個")
    println("  $(x) - $(L) = $(x - L)  vs  約数の個数 = $(length(divs))  → $(length(divs) == x - L ? "一致 ✓" : "不一致 ✗")")
    println()
end

println("=" ^ 50)
println("■ x>1000 篩（let ブロック版）")
println("=" ^ 50)

MAX_L = 2_000_000
println("約数の個数を篩で計算中 (MAX_L = $MAX_L)...")
d = zeros(Int32, MAX_L)
for k in 1:MAX_L
    for m in k:k:MAX_L
        d[m] += 1
    end
end
println("完了")

sol_dict = Dict{Int, Vector{Int}}()
for L in 1:MAX_L
    s = L + Int(d[L])
    if s > 1000
        push!(get!(sol_dict, s, Int[]), L)
    end
end

let current_max = 5
    println("\nx > 1000 で解の個数が最大値を更新するもの（初期最大値 = $current_max）")
    println("-" ^ 70)
    for x in sort(collect(keys(sol_dict)))
        ls = sol_dict[x]
        n_sols = 1 + length(ls)
        if n_sols > current_max
            current_max = n_sols
            println("x = $(lpad(x,8)) : 解の個数 = $n_sols, 解 L = $(sort([0; ls]))")
        end
    end
    println("\n最終的な最大解の個数: $current_max")
end
