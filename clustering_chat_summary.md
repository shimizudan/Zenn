# k-means / クラスタリングやJuliaコードに関するやりとりまとめ

以下は、このチャットで行った内容をMarkdownとして整理したものです（要点＋最終的に動く形のコードを中心にまとめています）。

---

## 1. 4点をk-means（k=2）で2クラスタに分ける問題の説明

### 与えられた点
- A(2,3), B(3,3), C(6,5), D(8,8)
- クラスタ数 k=2
- 初期中心：A と D
- 距離：ユークリッド距離

### k-meansの基本手順
1. **割り当て（Assignment）**  
   各点を「最も近い中心のクラスタ」に入れる。
2. **中心更新（Update）**  
   各クラスタ内の点の平均を取り、新しい中心にする。
3. 割り当て・中心が変わらなくなるまで繰り返す（収束）。

### 計算結果（要約）
- 1回目割り当て：クラスタ1 {A,B} / クラスタ2 {C,D}
- 中心更新：
  - μ₁ = (2.5, 3)
  - μ₂ = (7, 6.5)
- 2回目割り当てで変化なし → 収束

**最終クラスタ**
- クラスタ1：A,B（中心(2.5,3)）
- クラスタ2：C,D（中心(7,6.5)）

---

## 2. 色分けの意味について

- プロットの色は **点数の高低ではなく「クラスタ番号」**を表す。
- **番号や色の割当自体に本質的意味はない**（毎回入れ替わる可能性あり）。
- **×印（中心）に一番近いどれかに割り当てられる**ルールで色が決まる。
- 境界は「中心間の垂直二等分線」に相当する直線なので、  
  **中心付近でも境界の反対側なら別色になることがある**。

---

## 3. 初期中心による結果の違い

- k-meansは局所最適（局所解）に収束するため、  
  **初期中心の選び方で最終クラスタが変わることがある**。
- 対策：
  - **k-means++（init=:kmpp）**
  - **複数回実行して最良の解を採用**（古いClustering.jlでは自前で実装）

---

## 4. 40人の数学・英語点数サンプル生成とクラスタリング

### サンプルデータの作り方
- 高・中・低の3層を混ぜた点数分布を乱数で作る。
- 0〜100点にclampして成績らしくする。

---

## 5. k-means / DBSCAN / 階層型 / GMM を同一図で比較するJuliaコード（最終修正版）

### 重要な互換対応ポイント
- **Clustering.jlの古い版には `repeats` がない**  
  → 自前で複数回回して `R.totalcost` 最小の解を採用。
- **古いDBSCANは距離行列入力**  
  → `pairwise(Euclidean(), X; dims=2)` を作って渡す。
- **古いGaussianMixtures.jlの `gmmposterior` はタプルを返す場合がある**  
  → タプルなら1要素目だけ使う。

### 最終コード
```julia
using Random, Statistics, LinearAlgebra
using Clustering
using GaussianMixtures
using Plots
using Distances

# -----------------------------
# 1) サンプルデータ（40人×2科目）作成
# -----------------------------
Random.seed!(42)

n_high, n_mid, n_low = 12, 16, 12

math = vcat(
    clamp.(randn(n_high).*6 .+ 85, 0, 100),
    clamp.(randn(n_mid ).*8 .+ 65, 0, 100),
    clamp.(randn(n_low ).*7 .+ 45, 0, 100)
)
eng = vcat(
    clamp.(randn(n_high).*6 .+ 83, 0, 100),
    clamp.(randn(n_mid ).*8 .+ 62, 0, 100),
    clamp.(randn(n_low ).*7 .+ 48, 0, 100)
)

X = Matrix(hcat(math, eng)')   # 2×40（Clustering.jl用）
data = hcat(math, eng)         # 40×2（GMM用）

pal = [:red, :blue, :green, :orange, :purple]

# -----------------------------
# 2) k-means を複数回回して最良解を採用
# -----------------------------
function best_kmeans(X, k; trials=20, init=:kmpp, maxiter=100, tol=1e-6, seed=0)
    best_R = nothing
    best_cost = Inf
    rng = MersenneTwister(seed)

    for t in 1:trials
        R = kmeans(X, k; init=init, maxiter=maxiter, tol=tol, rng=rng)
        if R.totalcost < best_cost
            best_cost = R.totalcost
            best_R = R
        end
    end
    return best_R
end

k = 3
R_km = best_kmeans(X, k; trials=20, init=:kmpp, seed=1)
labels_km  = R_km.assignments
centers_km = R_km.centers

# -----------------------------
# 3) DBSCAN（距離行列渡し仕様対応）
# -----------------------------
D_db = pairwise(Euclidean(), X; dims=2)  # 40×40
db = dbscan(D_db, 8.0, 3)               # eps=8.0, minpts=3
labels_db = db.assignments              # ノイズは 0

# -----------------------------
# 4) 階層型クラスタリング（Ward法）
# -----------------------------
D_hc = pairwise(Euclidean(), X; dims=2)
hc = hclust(D_hc; linkage=:ward)
labels_hc = cutree(hc; k=k)

# -----------------------------
# 5) GMM（版違い吸収）
# -----------------------------
gmm = GMM(k, data; method=:kmeans, kind=:diag, nIter=30)
tmp = gmmposterior(gmm, data)
resp = tmp isa Tuple ? tmp[1] : tmp   # n×k

labels_gmm = [argmax(resp[i, :]) for i in 1:size(data,1)]

μ = gmm.μ
centers_gmm = size(μ,1) == k ? μ : μ'  # k×2 に整形

# -----------------------------
# 6) 2×2 比較プロット
# -----------------------------
plt1 = scatter(math, eng; group=labels_km, palette=pal[1:k],
    xlabel="Math", ylabel="English", title="k-means (best of 20, k=$k)", legend=false)
scatter!(plt1, centers_km[1,:], centers_km[2,:];
    markershape=:x, color=:black, markersize=10)

plt2 = scatter(math, eng; group=labels_db, palette=pal,
    xlabel="Math", ylabel="English", title="DBSCAN (eps=8, minpts=3)", legend=false)

plt3 = scatter(math, eng; group=labels_hc, palette=pal[1:k],
    xlabel="Math", ylabel="English", title="Hierarchical (Ward, cut k=$k)", legend=false)

plt4 = scatter(math, eng; group=labels_gmm, palette=pal[1:k],
    xlabel="Math", ylabel="English", title="GMM (k=$k)", legend=false)
scatter!(plt4, centers_gmm[:,1], centers_gmm[:,2];
    markershape=:x, color=:black, markersize=10)

plot(plt1, plt2, plt3, plt4; layout=(2,2), size=(900,700))
```

---

## 6. 途中で出たエラーと対応まとめ

### (1) `repeats` が使えない
**原因**：Clustering.jl 旧版で未対応  
**対応**：自前で複数回 `kmeans` 実行し最小コストを採用。

### (2) DBSCANの `minpts` キーワードが使えない／距離行列要求
**原因**：DBSCAN旧仕様  
**対応**：
- `dbscan(X, eps, minpts)` の位置引数版
- さらに座標入力不可の場合は **距離行列入力**へ変更。

### (3) `gmmposterior` がタプルを返す
**原因**：GaussianMixtures.jl旧仕様  
**対応**：`tmp isa Tuple ? tmp[1] : tmp` で責務行列だけ取り出す。

---

以上です。必要なら、このmdを教材用に整形（図や補足付き）した版も作れます。
