# 浜松医科大2025年入試問題：サイコロによる円周率推定シミュレーション
# Author: Zenn Article
# Date: 2025-12-11

using Random
using StatsBase
using Plots
using Printf

# ======================================
# Part 1: サイコロによる均等分布生成
# ======================================

# 問題(1): 1〜5を均等に生成（6が出たらやり直し）
function saikoro5()
    a = rand(1:6)
    if a != 6
        return a
    else
        saikoro5()
    end
end

# 問題(1): 1〜10を均等に生成
function saikoro10()
    a = rand(1:6)
    if a <= 5
        return a
    else
        b = rand(1:6)
        if b <= 5
            return b + 5
        else
            saikoro10()
        end
    end
end

# 問題(2): 1〜100を均等に生成（4回振って6進数的に扱う）
function saikoro100()
    digits = [rand(1:6) for _ = 1:4]
    number = sum((digits[i] - 1) * 6^(i-1) for i = 1:4)

    if number < 100
        return number + 1
    else
        saikoro100()
    end
end

# おまけ: 1〜7を均等に生成（ゾロ目を利用）
function saikoro7()
    a, b = rand(1:6), rand(1:6)
    if a != b
        return a
    elseif a == b != 6
        return 7
    else
        saikoro7()
    end
end

# ======================================
# Part 2: モンテカルロ法による円周率推定
# ======================================

# 問題(3): 試行回数のみ増加（分割数固定）
function estimate_pi_fixed_grid(n_trials; max_value=100)
    Random.seed!(42)

    count_inside = 0
    radius_squared = max_value^2

    for _ = 1:n_trials
        x = rand(1:max_value)
        y = rand(1:max_value)

        if x^2 + y^2 <= radius_squared
            count_inside += 1
        end
    end

    return 4.0 * count_inside / n_trials
end

# 問題(4): 分割を細かくする（分解能を上げる）
function estimate_pi_with_resolution(n_trials, max_value)
    Random.seed!(42)

    count_inside = 0
    radius_squared = max_value^2

    for _ = 1:n_trials
        x = rand(1:max_value)
        y = rand(1:max_value)

        if x^2 + y^2 <= radius_squared
            count_inside += 1
        end
    end

    return 4.0 * count_inside / n_trials
end

# 総合シミュレーション：分割数と試行回数の両方を変化
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

# ======================================
# 可視化関数
# ======================================

# 格子点の可視化
function visualize_grid(max_value)
    x_grid = 1:max_value
    y_grid = 1:max_value

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

    p = scatter(inside_x, inside_y,
        label="Inside", markersize=2, color=:red, alpha=0.5)
    scatter!(outside_x, outside_y,
        label="Outside", markersize=2, color=:blue, alpha=0.3)

    θ = range(0, 2π, length=100)
    plot!(max_value .* cos.(θ), max_value .* sin.(θ),
        label="Circle (r=$(max_value))", linewidth=2, color=:black)

    plot!(aspect_ratio=:equal,
        title="Grid Approximation (resolution=$(max_value))",
        xlabel="x", ylabel="y",
        xlim=(0, max_value*1.1), ylim=(0, max_value*1.1))

    return p
end

# 誤差のヒートマップ作成
function plot_error_heatmap(resolutions, trials_list, results)
    errors = abs.(results .- π)

    p = heatmap(trials_list, resolutions, errors,
        xlabel="Number of Trials", ylabel="Resolution (1~n)",
        title="Error in Pi Estimation (|estimate - π|)",
        c=:viridis, colorbar_title="Error",
        xscale=:log10, yscale=:log10,
        size=(600, 500))

    return p
end

# ======================================
# メイン実行部分
# ======================================

function main()
    println("="^70)
    println("浜松医科大2025年入試問題：サイコロシミュレーション")
    println("="^70)

    # Part 1: サイコロによる均等分布生成のテスト
    println("\n【Part 1】サイコロによる均等分布生成")
    println("-"^70)

    println("\n1-1. 1〜5の均等生成（500万回試行）")
    result5 = [saikoro5() for _ = 1:5*10^6] |> countmap
    for k in sort(collect(keys(result5)))
        @printf("  %d => %7d (%.4f%%)\n", k, result5[k], 100*result5[k]/(5*10^6))
    end

    println("\n1-2. 1〜7の均等生成（700万回試行）")
    result7 = [saikoro7() for _ = 1:7*10^6] |> countmap
    for k in sort(collect(keys(result7)))
        @printf("  %d => %7d (%.4f%%)\n", k, result7[k], 100*result7[k]/(7*10^6))
    end

    # Part 2: モンテカルロ法による円周率推定
    println("\n【Part 2】モンテカルロ法による円周率推定")
    println("-"^70)

    println("\n2-1. 問題(3)の方法：試行回数のみ増加（分割数=100固定）")
    trials_list = [100, 1000, 10000, 100000]
    for n in trials_list
        pi_est = estimate_pi_fixed_grid(n)
        error = abs(pi_est - π)
        @printf("  試行回数: %6d → π推定値: %.6f, 誤差: %.6f\n", n, pi_est, error)
    end

    println("\n2-2. 問題(4)の方法：分割を細かくする（試行回数=10万固定）")
    resolutions = [10, 100, 1000, 10000]
    n_trials = 100000
    for max_val in resolutions
        pi_est = estimate_pi_with_resolution(n_trials, max_val)
        error = abs(pi_est - π)
        @printf("  分割数: %5d (格子点: %10d) → π推定値: %.6f, 誤差: %.6f\n",
                max_val, max_val^2, pi_est, error)
    end

    println("\n2-3. 総合シミュレーション結果（π推定値）")
    resolutions_comp, trials_comp, results = comprehensive_simulation()

    @printf("\n%10s", "分割\\試行")
    for n in trials_comp
        @printf("%10d", n)
    end
    println()
    println("-"^70)

    for (i, res) in enumerate(resolutions_comp)
        @printf("%10d", res)
        for j = 1:length(trials_comp)
            @printf("%10.4f", results[i, j])
        end
        println()
    end

    @printf("\n真のπ値: %.10f\n", π)

    # 可視化
    println("\n【Part 3】可視化の生成中...")

    # 格子点の可視化（異なる分割数）
    p1 = visualize_grid(10)
    p2 = visualize_grid(50)
    p3 = visualize_grid(100)
    plot_grids = plot(p1, p2, p3, layout=(1, 3), size=(1500, 400))
    savefig(plot_grids, "grid_visualization.png")
    println("  格子点の可視化を保存: grid_visualization.png")

    # 誤差のヒートマップ
    heatmap_plot = plot_error_heatmap(resolutions_comp, trials_comp, results)
    savefig(heatmap_plot, "error_heatmap.png")
    println("  誤差のヒートマップを保存: error_heatmap.png")

    # 試行回数による収束の様子
    trials_range = [10, 50, 100, 500, 1000, 5000, 10000, 50000]
    pi_estimates_100 = [estimate_pi_fixed_grid(n, max_value=100) for n in trials_range]
    pi_estimates_1000 = [estimate_pi_with_resolution(n, 1000) for n in trials_range]

    p_conv = plot(trials_range, pi_estimates_100,
        label="Resolution=100 (Method 3)", marker=:circle, xscale=:log10,
        xlabel="Number of Trials", ylabel="Pi Estimate", title="Convergence Comparison")
    plot!(trials_range, pi_estimates_1000,
        label="Resolution=1000 (Method 4)", marker=:square)
    hline!([π], label="True π", linestyle=:dash, linewidth=2, color=:black)

    savefig(p_conv, "convergence_comparison.png")
    println("  収束比較グラフを保存: convergence_comparison.png")

    println("\n"*"="^70)
    println("シミュレーション完了！")
    println("="^70)
end

# スクリプトとして実行された場合のみmain()を呼ぶ
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
