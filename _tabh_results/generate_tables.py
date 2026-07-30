# -*- coding: utf-8 -*-
"""Generate the English and Korean selected-horizon TeX tables from one CSV."""

import csv
import math
import os
import sys


OUT = os.environ.get("GRAPE_OUT", r"C:\build\tabh")
TABLE_OUT = os.environ.get("GRAPE_TABLE_OUT", OUT)
CRITICALS = ((2.575829, "***"), (1.959964, "**"), (1.644854, "*"))


def read_rows():
    path = os.path.join(OUT, "table_regressions.csv")
    with open(path, "r", encoding="utf-8-sig", newline="") as handle:
        raw = list(csv.DictReader(handle))
    keyed = {}
    for row in raw:
        key = (row["spec"], int(float(row["group"])), int(float(row["h"])))
        if key in keyed:
            raise ValueError(f"duplicate table key: {key}")
        keyed[key] = row
    if len(keyed) != 12:
        raise ValueError(f"expected 12 table rows, found {len(keyed)}")
    return keyed


def star(b, se):
    statistic = abs(b / se)
    for cutoff, symbols in CRITICALS:
        if statistic >= cutoff:
            return symbols
    return ""


def display(row):
    b = float(row["b"])
    se = float(row["se"])
    n = int(float(row["N"]))
    r2 = float(row["r2"])
    r2_a = float(row["r2_a"])
    if not all(math.isfinite(value) for value in (b, se, r2, r2_a)) or se <= 0:
        raise ValueError("non-finite or non-positive table input")
    symbols = star(b, se)
    return {
        "b": f"{100*b:.3f}" + (rf"\sym{{{symbols}}}" if symbols else ""),
        "se": f"({100*se:.3f})",
        "N": str(n),
        "r2": f"{r2:.3f}",
        "r2_a": f"{r2_a:.3f}",
        "star": symbols,
    }


def panel(keyed, spec_base, horizon):
    no_g = "noG" + spec_base
    g = "G" + spec_base
    keys = [(no_g, 1, horizon), (no_g, 2, horizon), (g, 1, horizon), (g, 2, horizon)]
    return [display(keyed[key]) for key in keys]


def joined(cells, field):
    return " & ".join(cell[field] for cell in cells)


def render(keyed, language):
    panels = [
        ("A", 150, panel(keyed, "base", 150)),
        ("B", 150, panel(keyed, "impulse", 150)),
        ("C", 250, panel(keyed, "impulse", 250)),
    ]
    korean = language == "ko"
    caption = "대표 지평에서의 국소투영 이중차분 추정치" if korean else "Local Projection Difference-in-Differences Estimates at Selected Horizons"
    status = "할당관세 처치 여부" if korean else "Quota Tariff Treatment Status"
    intensity = "할당관세 처치 강도 (1\\%p)" if korean else "Quota Tariff Treatment Intensity (1\\%p)"
    group = "그룹" if korean else "Group"
    veg = "채소" if korean else "Vegetables"
    fruit = "과일" if korean else "Fruits"
    shock = "할당관세 충격" if korean else "Quota Tariff Shock"
    obs = "관측치 수" if korean else "Observations"
    adj = "조정 \\(R^{2}\\)" if korean else "Adjusted \\(R^{2}\\)"
    panel_titles = {
        "A": "지속처치" if korean else "Persistent treatment",
        "B": "처치 개시(충격반응)" if korean else "Initiation (impulse)",
        "C": "처치 개시(충격반응)" if korean else "Initiation (impulse)",
    }

    lines = [
        r"\begin{table}[h!]\centering",
        r"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}",
        rf"\caption{{\label{{tab:QuotaTariff_table}}{caption}}}",
        r"\makebox[1\textwidth]{",
        r"\resizebox{1.0\textwidth}{!}{",
        r"\begin{tabular}{l*{4}{>{\centering\arraybackslash}p{3.6cm}}}",
        r"\hline\hline",
        r"                    &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}\\",
        rf"                    &\multicolumn{{2}}{{c}}{{{status}}}&\multicolumn{{2}}{{c}}{{{intensity}}}\\\cmidrule(lr){{2-3}}\cmidrule(lr){{4-5}}",
        rf"                    &\multicolumn{{1}}{{c}}{{{group} 1}}&\multicolumn{{1}}{{c}}{{{group} 2}}&\multicolumn{{1}}{{c}}{{{group} 1}}&\multicolumn{{1}}{{c}}{{{group} 2}}\\",
        rf"                    &\multicolumn{{1}}{{c}}{{({veg})}}&\multicolumn{{1}}{{c}}{{({fruit})}}&\multicolumn{{1}}{{c}}{{({veg})}}&\multicolumn{{1}}{{c}}{{({fruit})}}\\",
        r"\hline",
    ]
    markers = []
    for tag, horizon, cells in panels:
        marker = "|".join(joined(cells, field) for field in ("b", "se", "N", "r2", "r2_a"))
        markers.append(f"% GENERATED-CELLS {tag}: {marker}")
        lines.extend([
            rf"\multicolumn{{5}}{{l}}{{\textit{{{'패널' if korean else 'Panel'} {tag}: {panel_titles[tag]}, $h={horizon}$}}}}\\",
            f"{shock:<20} & {joined(cells, 'b')}" + r" \\",
            f"{'':20} & {joined(cells, 'se')}" + r" \\",
            f"{obs:<20} & {joined(cells, 'N')}" + r" \\",
            rf"\(R^{{2}}\){'':13} & {joined(cells, 'r2')}" + r" \\",
            f"{adj:<20} & {joined(cells, 'r2_a')}" + r" \\",
            markers[-1],
            r"\hline" if tag != "C" else r"\hline\hline",
        ])

    if korean:
        notes = [
            "가독성을 위해 계수와 표준오차에 100을 곱하였다. 괄호 안은 품목 단위로 클러스터링한 표준오차이다",
            "(1)$\\cdot$(3)열은 36개 클러스터, (2)$\\cdot$(4)열은 35개 클러스터; 처치 채소 6개 품목, 처치 과일 5개 품목.",
            "유의성은 그림의 신뢰대역에 사용한 정규분포 임계값에 근거한다.",
            "패널 A는 처치가 $h$까지 유지되는 조건을 부과하며, 패널 B와 C는 이후 경로와 무관하게 개시를 추적한다.",
        ]
    else:
        notes = [
            "Coefficients and standard errors multiplied by 100 for readability; standard errors, in parentheses, clustered by product",
            "36 clusters in columns 1 and 3, 35 in columns 2 and 4; 6 treated vegetable products, 5 treated fruit products.",
            "Significance is based on the normal critical values used for the confidence bands in the figures.",
            "Panel A conditions on treatment persisting through $h$; Panels B and C track initiations regardless of the subsequent path.",
        ]
    lines.extend(rf"\multicolumn{{5}}{{l}}{{\footnotesize {note}}}\\" for note in notes)
    lines.extend([
        r"\multicolumn{5}{l}{\footnotesize \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)}\\",
        r"\end{tabular}",
        r"}}",
        r"\end{table}",
        "",
    ])
    return "\n".join(lines), markers


def main():
    os.makedirs(TABLE_OUT, exist_ok=True)
    keyed = read_rows()
    english, markers_en = render(keyed, "en")
    korean, markers_ko = render(keyed, "ko")
    if markers_en != markers_ko:
        raise AssertionError("English and Korean numeric table cells differ")

    outputs = {
        "QuotaTariff_table_eng.tex": english,
        "QuotaTariff_table.tex": korean,
        "QuotaTariff_table_eng_mirror.tex": english,
    }
    for filename, content in outputs.items():
        path = os.path.join(TABLE_OUT, filename)
        with open(path, "w", encoding="utf-8", newline="") as handle:
            handle.write(content)
        print(f"wrote {path}")
    print("TABLE VERIFICATION: PASS (x100, 3 decimals, stars recomputed, EN/KO cells identical)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
