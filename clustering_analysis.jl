using Pkg
# パッケージが未インストールの場合はコメントを外して実行してください
# Pkg.add("Clustering")
# Pkg.add("GaussianMixtures")
# Pkg.add("Plots")
# Pkg.add("Distances")

using Random, Statistics, LinearAlgebra
using Clustering
using Distances
using GaussianMixtures
using Plots

# ランダムシード設定
Random.seed!(42)

# === サンプルデータの作成 ===
# 高・中・低の3層
n_high, n_mid, n_low = 12, 16, 12

# 数学の点数
math = vcat(
    clamp.(randn(n_high).*6 .+ 85, 0, 100),  # 高得点層: 平均85点
    clamp.(randn(n_mid ).*8 .+ 65, 0, 100),  # 中得点層: 平均65点
    clamp.(randn(n_low ).*7 .+ 45, 0, 100)   # 低得点層: 平均45点
)

# 英語の点数
eng = vcat(
    clamp.(randn(n_high).*6 .+ 83, 0, 100),
    clamp.(randn(n_mid ).*8 .+ 62, 0, 100),
    clamp.(randn(n_low ).*7 .+ 48, 0, 100)
)

# データ形式の準備
X = Matrix(hcat(math, eng)')   # 2×40（Clustering.jl用）
data = hcat(math, eng)         # 40×2（GMM用）

# === k-meansクラスタリングの実装 ===
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

# k=3でクラスタリング実行
k = 3
R_km = best_kmeans(X, k; trials=20, init=:kmpp, seed=1)
labels_km  = R_km.assignments
centers_km = R_km.centers

println("k-means clustering completed")
println("Total cost: ", R_km.totalcost)

# === DBSCANによるクラスタリング ===
# 距離行列を作成（古いバージョン対応）
D_db = pairwise(Euclidean(), X; dims=2)  # 40×40
db = dbscan(D_db, 8.0, 3)               # eps=8.0, minpts=3
labels_db = db.assignments              # ノイズは 0

println("DBSCAN completed")
println("Number of clusters: ", maximum(labels_db))

# === 階層型クラスタリング ===
D_hc = pairwise(Euclidean(), X; dims=2)
hc = hclust(D_hc; linkage=:ward)
labels_hc = cutree(hc; k=k)

println("Hierarchical clustering completed")

# === GMMによるクラスタリング ===
gmm = GMM(k, data; method=:kmeans, kind=:diag, nIter=30)
tmp = gmmposterior(gmm, data)
resp = tmp isa Tuple ? tmp[1] : tmp   # バージョン対応

labels_gmm = [argmax(resp[i, :]) for i in 1:size(data,1)]

μ = gmm.μ
centers_gmm = size(μ,1) == k ? μ : μ'  # k×2 に整形

println("GMM clustering completed")

# === 4つの手法を比較可視化 ===
pal = [:red, :blue, :green, :orange, :purple]

# k-means
plt1 = scatter(math, eng; group=labels_km, palette=pal[1:k],
    xlabel="Math", ylabel="English", title="k-means (best of 20, k=$k)", legend=false)
scatter!(plt1, centers_km[1,:], centers_km[2,:];
    markershape=:x, color=:black, markersize=10)

# DBSCAN
plt2 = scatter(math, eng; group=labels_db, palette=pal,
    xlabel="Math", ylabel="English", title="DBSCAN (eps=8, minpts=3)", legend=false)

# 階層型
plt3 = scatter(math, eng; group=labels_hc, palette=pal[1:k],
    xlabel="Math", ylabel="English", title="Hierarchical (Ward, cut k=$k)", legend=false)

# GMM
plt4 = scatter(math, eng; group=labels_gmm, palette=pal[1:k],
    xlabel="Math", ylabel="English", title="GMM (k=$k)", legend=false)
scatter!(plt4, centers_gmm[:,1], centers_gmm[:,2];
    markershape=:x, color=:black, markersize=10)

# 2×2レイアウトで表示・保存
p = plot(plt1, plt2, plt3, plt4; layout=(2,2), size=(900,700))

# 画像を保存
savefig(p, "images/clustering_comparison.png")
println("Plot saved to images/clustering_comparison.png")

# データの散布図（元データの可視化）も作成
plt_data = scatter(math, eng,
    xlabel="Math Score", ylabel="English Score",
    title="Student Test Scores (n=40)",
    legend=false, markersize=6, alpha=0.7,
    size=(600,500))
savefig(plt_data, "images/data_scatter.png")
println("Data scatter plot saved to images/data_scatter.png")

println("\nAll visualizations completed successfully!")
