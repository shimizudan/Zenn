# Work Directory - Zenn記事の作業ファイル

このディレクトリには、Zenn記事作成に使用した作業ファイルが記事ごとに分類されています。

## ディレクトリ構成

### dice-pi-estimation/
**関連記事**: `articles/dice-simulation-pi-estimation.md`

浜松医科大2025年入試問題を題材にした、サイコロによる円周率推定のシミュレーション

**ファイル:**
- `dice_pi_simulation.jl` - メインシミュレーションコード（英語ラベル）
- `1210001.ipynb` - 元のJupyterノートブック
- `1210001.pdf` - 元のPDFドキュメント
- `hamamatsu2025.jpeg` - 浜松医科大の問題画像
- `grid_visualization.png` - 格子点による円の近似（図1）
- `convergence_comparison.png` - 収束比較グラフ（図2）
- `error_heatmap.png` - 誤差のヒートマップ（図3）
- `dice-simulation-pi-estimation-summary.md` - 記事サマリー

**実行方法:**
```bash
cd dice-pi-estimation
julia dice_pi_simulation.jl
```

**重要な知見:**
- 問題(3)の方法（試行回数のみ増加）では精度が根本的に向上しない
- 問題(4)の方法（分割を細かくする）が効果的

### complex-transformation/
**関連記事**: `articles/julia-complex-transformation-visualization.md`

Juliaによる複素数変換の可視化

**ファイル:**
- `complex_transformation.ipynb` - Jupyterノートブック
- `complex_transformation_basic.jl` - 基本的な可視化コード
- `complex_transformation_fine.jl` - 詳細な可視化コード

### circular-necklace/
**関連記事**: `articles/circular-necklace-permutation-formula.md`

円順列・ネックレス順列の公式に関する検証コード

**ファイル:**
- `test_circular_necklace.jl` - メインテストコード
- `debug_circular.jl` - デバッグ用コード

### measurement-error/
**関連記事**: `articles/measurement-error-log-precision.md`, `articles/sample-std-expectation.md`

測定誤差と対数精度、サンプル標準偏差に関するシミュレーション

**ファイル:**
- `measurement-error-log-precision.ipynb` - Jupyterノートブック
- `sample_std_simulation.jl` - サンプル標準偏差シミュレーション
- `test_measurement.jl` - 測定テストコード

### clustering/
データクラスタリング分析

**ファイル:**
- `clustering_analysis.jl` - クラスタリング分析コード
- `clustering_chat_summary.md` - 会話サマリー

### typst-templates/
**関連記事**: 複数のTypst記事

Typstテンプレート集

**ファイル:**
- `kyotsu-test-math-template.typ` - 共通テスト数学テンプレート
- `1105001.typ` - 円順列・ネックレス順列の問題
- `38.typ` - 立方体の幾何学問題
- `811001.typ` - その他の問題
- `cetz-perspective-demo.typ` - CeTZ perspective デモ
- 各種PDFファイル

### misc/
その他の画像ファイル

**ファイル:**
- `F3fDhgobgAAT-QQ.jpeg`
- `F3fEsGkaMAA3Frl.jpeg`

## 使用方法

各ディレクトリには、対応するZenn記事の作業ファイルが含まれています。
Juliaコードを実行する場合は、各ディレクトリに移動してから実行してください。

```bash
cd <directory-name>
julia <script-name>.jl
```

## 必要なパッケージ

### Julia
```julia
using Pkg
Pkg.add(["Random", "StatsBase", "Plots", "Printf", "CairoMakie"])
```

### Jupyter
```bash
pip install jupyter
```

### Typst
```bash
# Typstのインストール
# https://github.com/typst/typst
```
