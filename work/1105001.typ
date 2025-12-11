#set page(
margin: (x: 1.5cm, y: 1.5cm),
)
 
#set par(
  justify: true,
  leading: 1em,
)
 
#set text(
  font: ("New Computer Modern","BIZ UDPMincho")
)
 
#show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: "BIZ UDPGothic") 
#set text(lang: "ja")
 
#set enum(numbering: "(1)",)
 
#import "@preview/colorful-boxes:1.4.2": *
 
#let my_block(back_color, frame_color, title_color, content_color, title, content) = {
  block(width:auto,radius: 4pt, stroke: back_color + 3pt)[
    #block(width: 100%,fill: back_color, inset: (x: 20pt, y: 5pt), below: 0pt)[#text(title_color,font: ("New Computer Modern","BIZ UDPMincho"))[#title]]
   #block(radius: (
    bottom: 3pt,
  ),width: 100%, fill: frame_color, inset: (x: 20pt, y: 10pt))[#text(content_color)[#content]]
  ]
}
 
#my_block(olive,rgb(95%, 100%, 95%) , white, black, [\@HirokazuOHSAWAさんからの正方形の問題], [正方形ABCDの内部に点Pをとると、
 $"AP" =5$ , $"BP" =3$ , $"CP" =7$ となった。
この正方形の面積を求めよ。

  ])

Pの位置は下の図の場合のみ。四角形の面積は $ 7^2 + 3^2 = bold(58)$

#import "@preview/cetz:0.4.2"
#figure(
cetz.canvas(length:2.0cm,{
  import cetz.draw: *
  import cetz.vector
  import cetz.angle

  let A = (0, 0)
  let B = (calc.sqrt(58), 0)
  let C = (calc.sqrt(58), calc.sqrt(58))
  let D = (0, calc.sqrt(58))
  let P = (calc.sqrt(58)-21/calc.sqrt(58), calc.sqrt(58)-49/calc.sqrt(58))
  let Q = (49/calc.sqrt(58), calc.sqrt(58)-21/calc.sqrt(58))
  let R = (21/calc.sqrt(58), 49/calc.sqrt(58))
  let S = (calc.sqrt(58)-49/calc.sqrt(58), 21/calc.sqrt(58))

  let size = 0.2
  let psize = 0.2

  // 矩形ABCD
  line(A, B, C, D, close: true, stroke: (paint: black, thickness: 2pt))

  line(C, P, stroke: (paint: black, thickness: 2pt))
  line(D, Q, stroke: (paint: black, thickness: 2pt))
  line(A, R, stroke: (paint: black, thickness: 2pt))
  line(B, S, stroke: (paint: black, thickness: 2pt))
  
  // AP を結ぶ線
  line(A, P, stroke: (paint: black, thickness: 2pt))

  // A の直角記号
  line((size, 0), (size, size), stroke: black)
  line((0, size), (size, size), stroke: black)

  // B の直角記号
  line((calc.sqrt(58) - size, 0), (calc.sqrt(58) - size, size), stroke: black)
  line((calc.sqrt(58), size), (calc.sqrt(58) - size, size), stroke: black)

  // C の直角記号
  line((calc.sqrt(58) - size, calc.sqrt(58)), (calc.sqrt(58) - size, calc.sqrt(58) - size), stroke: black)
  line((calc.sqrt(58), calc.sqrt(58) - size), (calc.sqrt(58) - size, calc.sqrt(58) - size), stroke: black)

  // D の直角記号
  line((size, calc.sqrt(58)), (size, calc.sqrt(58) - size), stroke: black)
  line((0, calc.sqrt(58) - size), (size, calc.sqrt(58) - size), stroke: black)

  let (px, py) = P
  let (qx, qy) = Q
  let (rx, ry) = R
  let (sx, sy) = S

  // P の直角記号（SP と PQ に沿って）
  let v_sp = vector.sub(P, S)
  let v_pq = vector.sub(Q, P)
  let u_sp = vector.scale(v_sp, psize / vector.len(v_sp))
  let u_pq = vector.scale(v_pq, psize / vector.len(v_pq))

  line(vector.add(P, u_sp), vector.add(vector.add(P, u_sp), u_pq), stroke: black)
  line(vector.add(P, u_pq), vector.add(vector.add(P, u_sp), u_pq), stroke: black)

  // Q の直角記号（PQ と QR に沿って）
  let v_pq_q = vector.sub(Q, P)
  let v_qr = vector.sub(R, Q)
  let u_pq_q = vector.scale(v_pq_q, psize / vector.len(v_pq_q))
  let u_qr = vector.scale(v_qr, psize / vector.len(v_qr))

  line(vector.add(Q, u_pq_q), vector.add(vector.add(Q, u_pq_q), u_qr), stroke: black)
  line(vector.add(Q, u_qr), vector.add(vector.add(Q, u_pq_q), u_qr), stroke: black)

  // R の直角記号（QR と RS に沿って）
  let v_qr_r = vector.sub(R, Q)
  let v_rs = vector.sub(S, R)
  let u_qr_r = vector.scale(v_qr_r, psize / vector.len(v_qr_r))
  let u_rs = vector.scale(v_rs, psize / vector.len(v_rs))

  line(vector.add(R, u_qr_r), vector.add(vector.add(R, u_qr_r), u_rs), stroke: black)
  line(vector.add(R, u_rs), vector.add(vector.add(R, u_qr_r), u_rs), stroke: black)

  // S の直角記号（RS と SP に沿って）
  let v_rs_s = vector.sub(S, R)
  let v_sp_s = vector.sub(P, S)
  let u_rs_s = vector.scale(v_rs_s, psize / vector.len(v_rs_s))
  let u_sp_s = vector.scale(v_sp_s, psize / vector.len(v_sp_s))

  line(vector.add(S, u_rs_s), vector.add(vector.add(S, u_rs_s), u_sp_s), stroke: black)
  line(vector.add(S, u_sp_s), vector.add(vector.add(S, u_rs_s), u_sp_s), stroke: black)

  // PQの中点に「4」を表示（白い背景付き）
  let mid_pq = vector.lerp(P, Q, 0.5)
  let (mid_pq_x, mid_pq_y) = mid_pq
  rect((mid_pq_x - 0.6, mid_pq_y - 0.2), (mid_pq_x + 0.6, mid_pq_y + 0.2),
       fill: white, stroke: none)
  content(mid_pq, text(fill: blue, size: 14pt, [4]))

  // QRの中点に「4」を表示
  let mid_qr = vector.lerp(Q, R, 0.5)
  let (mid_qr_x, mid_qr_y) = mid_qr
  rect((mid_qr_x - 0.2, mid_qr_y - 0.2), (mid_qr_x + 0.2, mid_qr_y + 0.2),
       fill: white, stroke: none)
  content(mid_qr, text(fill: blue, size: 14pt, [4]))

  // RSの中点に「4」を表示
  let mid_rs = vector.lerp(R, S, 0.5)
  let (mid_rs_x, mid_rs_y) = mid_rs
  rect((mid_rs_x - 0.6, mid_rs_y - 0.2), (mid_rs_x + 0.6, mid_rs_y + 0.2),
       fill: white, stroke: none)
  content(mid_rs, text(fill: blue, size: 14pt, [4]))

  // SPの中点に「4」を表示
  let mid_sp = vector.lerp(S, P, 0.5)
  let (mid_sp_x, mid_sp_y) = mid_sp
  rect((mid_sp_x - 0.2, mid_sp_y - 0.2), (mid_sp_x + 0.2, mid_sp_y + 0.2),
       fill: white, stroke: none)
  content(mid_sp, text(fill: blue, size: 14pt, [4]))

  // ASの中点に「3」を表示
  let mid_as = vector.lerp(A, S, 0.5)
  let (mid_as_x, mid_as_y) = mid_as
  rect((mid_as_x - 0.3, mid_as_y - 0.2), (mid_as_x + 0.6, mid_as_y + 0.2),
       fill: white, stroke: none)
  content(mid_as, text(fill: blue, size: 14pt, [3]))

  // BPの中点に「3」を表示
  let mid_bp = vector.lerp(B, P, 0.5)
  let (mid_bp_x, mid_bp_y) = mid_bp
  rect((mid_bp_x - 0.2, mid_bp_y - 0.2), (mid_bp_x + 0.2, mid_bp_y + 0.2),
       fill: white, stroke: none)
  content(mid_bp, text(fill: blue, size: 14pt, [3]))

  // CQの中点に「3」を表示
  let mid_cq = vector.lerp(C, Q, 0.5)
  let (mid_cq_x, mid_cq_y) = mid_cq
  rect((mid_cq_x - 0.6, mid_cq_y - 0.2), (mid_cq_x + 0.3, mid_cq_y + 0.2),
       fill: white, stroke: none)
  content(mid_cq, text(fill: blue, size: 14pt, [3]))

  // DRの中点に「3」を表示
  let mid_dr = vector.lerp(D, R, 0.5)
  let (mid_dr_x, mid_dr_y) = mid_dr
  rect((mid_dr_x - 0.2, mid_dr_y - 0.2), (mid_dr_x + 0.2, mid_dr_y + 0.2),
       fill: white, stroke: none)
  content(mid_dr, text(fill: blue, size: 14pt, [3]))

  // APの中点に「5」を表示
  let mid_ap = vector.lerp(A, P, 0.5)
  let (mid_ap_x, mid_ap_y) = mid_ap
  rect((mid_ap_x - 0.2, mid_ap_y - 0.2), (mid_ap_x + 0.2, mid_ap_y + 0.2),
       fill: white, stroke: none)
  content(mid_ap, text(fill: blue, size: 14pt, [5]))

  // 頂点ラベル
  content(A, anchor: "north-east", padding: 5pt, text(fill: black, size: 16pt, [A]))
  content(B, anchor: "north-west", padding: 5pt, text(fill: black, size: 16pt, [B]))
  content(C, anchor: "south-west", padding: 5pt, text(fill: black, size: 16pt, [C]))
  content(D, anchor: "south-east", padding: 5pt, text(fill: black, size: 16pt, [D]))
  content(P, anchor: "north", padding: 5pt, text(fill: black, size: 16pt, [P]))
})
)
