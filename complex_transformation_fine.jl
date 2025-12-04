using CairoMakie
using LinearAlgebra

# Mac標準の日本語フォントを設定
set_theme!(fonts = (regular = "Hiragino Sans", bold = "Hiragino Sans"))

# 複素数変換関数
f(z) = z * (z + 1)

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

# より細かい格子での可視化
x_range_fine = -2:0.25:2
y_range_fine = -2:0.25:2

vertical_lines_fine, horizontal_lines_fine = create_grid_lines(
    x_range_fine, y_range_fine)
transformed_vertical_fine, transformed_horizontal_fine = transform_grid(
    vertical_lines_fine, horizontal_lines_fine, f)

fig2 = Figure(size=(1400, 600))

ax3 = Axis(fig2[1, 1],
    title="変換前（細かい格子）",
    xlabel="Real(z)",
    ylabel="Imag(z)",
    aspect=DataAspect())

for (xs, ys) in vertical_lines_fine
    lines!(ax3, xs, ys, color=(:blue, 0.6), linewidth=0.5)
end

for (xs, ys) in horizontal_lines_fine
    lines!(ax3, xs, ys, color=(:red, 0.6), linewidth=0.5)
end

ax4 = Axis(fig2[1, 2],
    title="変換後（細かい格子）",
    xlabel="Real(w)",
    ylabel="Imag(w)",
    aspect=DataAspect())

for (xs, ys) in transformed_vertical_fine
    lines!(ax4, xs, ys, color=(:blue, 0.6), linewidth=0.5)
end

for (xs, ys) in transformed_horizontal_fine
    lines!(ax4, xs, ys, color=(:red, 0.6), linewidth=0.5)
end

# PNG画像として保存
save("images/complex_transformation_fine.png", fig2)
println("細かい格子の可視化画像を保存しました: images/complex_transformation_fine.png")
