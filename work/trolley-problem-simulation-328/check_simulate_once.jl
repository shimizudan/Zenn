function simulate_once(n::Int; stable_threshold::Int=100)
    rounds = 0
    current = n
    stable_count = 0
    while stable_count < stable_threshold
        count_heads = sum(rand(0:1, current))
        count_tails = current - count_heads
        rounds += 1
        next = if count_heads > count_tails
            count_heads     # 表が多数派 → 裏を除外
        elseif count_tails > count_heads
            count_tails     # 裏が多数派 → 表を除外
        else
            current         # 同数（タイ）→ 全員残る
        end
        stable_count = (next == current) ? stable_count + 1 : 0
        current = next
    end
    # 収束判定のための100回分を引いて、実際に値が変化したラウンド数を返す
    return current, rounds - stable_threshold
end

# テスト
for n in [3, 5, 10, 20]
    final, rounds = simulate_once(n)
    println("n=$n → 最終人数: $final 人（$rounds ラウンド）")
end
