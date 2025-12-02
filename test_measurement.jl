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
