using CairoMakie
using LinearAlgebra

# Mac標準の日本語フォントを設定
set_theme!(fonts = (regular = "Hiragino Sans", bold = "Hiragino Sans"))

# 複素数変換関数
f(z) = z * (z + 1)

# 格子の範囲設定
x_range = -3:0.5:3
y_range = -3:0.5:3

# 変換前の格子データ生成
function create_grid_lines(x_range, y_range)
    vertical_lines = []
    horizontal_lines = []

    # 垂直線（x = 定数）
    for x in x_range
        line_x = Float64[]
        line_y = Float64[]
        for y in range(minimum(y_range), maximum(y_range), length=100)
            push!(line_x, x)
            push!(line_y, y)
        end
        push!(vertical_lines, (line_x, line_y))
    end

    # 水平線（y = 定数）
    for y in y_range
        line_x = Float64[]
        line_y = Float64[]
        for x in range(minimum(x_range), maximum(x_range), length=100)
            push!(line_x, x)
            push!(line_y, y)
        end
        push!(horizontal_lines, (line_x, line_y))
    end

    return vertical_lines, horizontal_lines
end

# 格子を変換
function transform_grid(vertical_lines, horizontal_lines, transform_func)
    transformed_vertical = []
    transformed_horizontal = []

    for (xs, ys) in vertical_lines
        new_xs = Float64[]
        new_ys = Float64[]
        for (x, y) in zip(xs, ys)
            z = complex(x, y)
            w = transform_func(z)
            push!(new_xs, real(w))
            push!(new_ys, imag(w))
        end
        push!(transformed_vertical, (new_xs, new_ys))
    end

    for (xs, ys) in horizontal_lines
        new_xs = Float64[]
        new_ys = Float64[]
        for (x, y) in zip(xs, ys)
            z = complex(x, y)
            w = transform_func(z)
            push!(new_xs, real(w))
            push!(new_ys, imag(w))
        end
        push!(transformed_horizontal, (new_xs, new_ys))
    end

    return transformed_vertical, transformed_horizontal
end

# 格子生成
vertical_lines, horizontal_lines = create_grid_lines(x_range, y_range)

# 変換適用
transformed_vertical, transformed_horizontal = transform_grid(
    vertical_lines, horizontal_lines, f)

# プロット作成
fig = Figure(size=(1400, 600))

# 変換前の格子
ax1 = Axis(fig[1, 1],
    title="変換前: z = x + yi",
    xlabel="Real(z)",
    ylabel="Imag(z)",
    aspect=DataAspect())

# 垂直線を描画（青）
for (xs, ys) in vertical_lines
    lines!(ax1, xs, ys, color=:blue, linewidth=1)
end

# 水平線を描画（赤）
for (xs, ys) in horizontal_lines
    lines!(ax1, xs, ys, color=:red, linewidth=1)
end

# 変換後の格子
ax2 = Axis(fig[1, 2],
    title="変換後: w = f(z) = z(z+1)",
    xlabel="Real(w)",
    ylabel="Imag(w)",
    aspect=DataAspect())

# 変換された垂直線を描画（青）
for (xs, ys) in transformed_vertical
    lines!(ax2, xs, ys, color=:blue, linewidth=1)
end

# 変換された水平線を描画（赤）
for (xs, ys) in transformed_horizontal
    lines!(ax2, xs, ys, color=:red, linewidth=1)
end

# PNG画像として保存
save("images/complex_transformation_basic.png", fig)
println("基本の可視化画像を保存しました: images/complex_transformation_basic.png")
