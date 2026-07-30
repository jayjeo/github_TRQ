# -*- coding: utf-8 -*-
"""Combine the table figures, strictly compare them against the reference res.csv, and build the intensity table.

Verification-gate design:
- Key completeness: exactly 12 (spec, group, h) cells must exist.
- Vegetables (group 1): the sample is unchanged, so raw |db| < 1e-10 is required (no rounded
  comparison); the se tolerance is 5e-9 because the reference CSV stores rounded CI endpoints;
  N, df, and cluster counts must match exactly as integers.
- Fruits (group 2): small coefficient shifts are expected because grapes left the control pool,
  so those cells are marked EXPECTED_CHANGE, but N and cluster counts must still match exactly.
- Any failure exits with code 1 (stops the pipeline).
"""
import csv, os, sys

OUT = os.environ.get("GRAPE_OUT", r"C:\build\tabh")
SRC = os.environ.get("GRAPE_SRC", os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
Z = 1.959964
B_TOL_VEG = 1e-10
SE_TOL = 5e-9

SPECS = ["Gbase", "noGbase", "Gimpulse", "noGimpulse"]
H_BY_SPEC = {"Gbase": ["150"], "noGbase": ["150"], "Gimpulse": ["150", "250"], "noGimpulse": ["150", "250"]}
EXPECTED_KEYS = {(s, g, h) for s in SPECS for g in ("1", "2") for h in H_BY_SPEC[s]}
# Expected sample structure (41 items, re-estimated without grapes)
EXPECT = {}
for s in SPECS:
    for h in H_BY_SPEC[s]:
        n_veg = {"150": 33678 if "base" in s and not s.endswith("impulse") else 33682, "250": 30154}[h]
        if s in ("Gbase", "noGbase"):
            n_veg = 33678
        EXPECT[(s, "1", h)] = {"N": n_veg, "df_r": 35, "N_clust": 36}
        n_fruit = {"150": 45026 if s in ("Gbase", "noGbase") else 45030, "250": 41530}[h]
        EXPECT[(s, "2", h)] = {"N": n_fruit, "df_r": 34, "N_clust": 35}

REF = {
    "Gbase":      "LPseparate_Gm4_CV1(95)ct_res.csv",
    "noGbase":    "LPseparate_noGm4_CV1(95)ct_res.csv",
    "Gimpulse":   "LPseparate_Gm4_CV1(95)ct_impulse_res.csv",
    "noGimpulse": "LPseparate_noGm4_CV1(95)ct_impulse_res.csv",
}

def read_csv(path):
    with open(path, "r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))

# ---------- 1) combine the regression table ----------
GROUP_NAME = {"1": "vegetables(채소)", "2": "fruits(과일)"}
rows = []
for spec in SPECS:
    rows.extend(read_csv(os.path.join(OUT, "tabh_%s.csv" % spec)))

keys = [(r["spec"], r["group"], r["h"]) for r in rows]
assert len(keys) == len(set(keys)), "duplicate (spec,group,h) keys"
assert set(keys) == EXPECTED_KEYS, "key mismatch: missing=%s extra=%s" % (
    sorted(EXPECTED_KEYS - set(keys)), sorted(set(keys) - EXPECTED_KEYS))

with open(os.path.join(OUT, "table_regressions.csv"), "w", encoding="utf-8-sig", newline="") as f:
    w = csv.writer(f)
    w.writerow(["spec","group","group_name","h","b","se","N","r2","r2_a","df_r","N_clust"])
    for r in rows:
        w.writerow([r["spec"], r["group"], GROUP_NAME[r["group"]], r["h"],
                    r["b"], r["se"], r["N"], r["r2"], r["r2_a"], r["df_r"], r["N_clust"]])

# ---------- 2) reference comparison (vegetables strict / fruits EXPECTED_CHANGE) ----------
ref_data = {}
for spec, fn in REF.items():
    ref_data[spec] = {r["h"]: r for r in read_csv(os.path.join(SRC, fn))}

lines = ["spec        grp h    status          db          dse         N      df_r  N_clust"]
fail = False
for r in rows:
    key = (r["spec"], r["group"], r["h"])
    ref = ref_data[r["spec"]][r["h"]]
    lp, lb, ub = ("LP1","lb1","ub1") if r["group"] == "1" else ("LP2","lb2","ub2")
    db = abs(float(r["b"]) - float(ref[lp]))
    dse = abs(float(r["se"]) - (float(ref[ub]) - float(ref[lb])) / (2*Z))
    exp = EXPECT[key]
    ints_ok = (int(r["N"]) == exp["N"] and int(r["df_r"]) == exp["df_r"]
               and int(r["N_clust"]) == exp["N_clust"])
    if r["group"] == "1":
        ok = db < B_TOL_VEG and dse < SE_TOL and ints_ok
        status = "PASS" if ok else "FAIL"
        fail = fail or not ok
    else:
        status = "EXPECTED_CHANGE" if ints_ok else "FAIL"
        fail = fail or not ints_ok
    lines.append("%-11s %s   %-4s %-15s %.3e   %.3e   %-6s %-5s %s" %
                 (r["spec"], r["group"], r["h"], status, db, dse, r["N"], r["df_r"], r["N_clust"]))
lines.append("")
lines.append("OVERALL: %s (채소 원시 일치·정수 표본 구조 / 과일 EXPECTED_CHANGE·정수 표본 구조)" %
             ("FAIL" if fail else "PASS"))
with open(os.path.join(OUT, "verification.txt"), "w", encoding="utf-8", newline="") as f:
    f.write("\n".join(lines))
print("\n".join(lines))

# ---------- 3) intensity table in English (11 items) ----------
KR2EN = {"배추":"napa cabbage","양배추":"cabbage","무":"radish","당근":"carrot",
         "양파":"onion","대파":"green onion","망고":"mango","참다래":"kiwifruit",
         "바나나":"banana","아보카도":"avocado","파인애플":"pineapple"}
ORDER = ["배추","양배추","무","당근","양파","대파",
         "망고","참다래","바나나","아보카도","파인애플"]
GROUP_OF = {k:("vegetables" if i<6 else "fruits") for i,k in enumerate(ORDER)}

intens = {}
for fn in ["tabh_intensity_veg.csv", "tabh_intensity_fruit.csv"]:
    for r in read_csv(os.path.join(OUT, fn)):
        intens[r["q_item"]] = r
assert set(intens) == set(ORDER), "intensity 품목 불일치: %s" % sorted(set(intens) ^ set(ORDER))

with open(os.path.join(OUT, "intensity_by_item.csv"), "w", encoding="utf-8-sig", newline="") as f:
    w = csv.writer(f)
    w.writerow(["item_en","item_kr","group","qcode","intensity_pp","quota_tariff_rate_pct","tau_pct"])
    for kr in ORDER:
        r = intens[kr]
        w.writerow([KR2EN[kr], kr, GROUP_OF[kr], r["qcode"],
                    r["intensity"], r["TRQall"], r["tau"]])

print("\n=== intensity_by_item.csv (%d items) ===" % len(ORDER))
for kr in ORDER:
    r = intens[kr]
    print("%-14s %-8s intensity=%8.2f  quotaTariff=%5.1f  tau=%8.2f" %
          (KR2EN[kr], kr, float(r["intensity"]), float(r["TRQall"]), float(r["tau"])))
print("\nDONE" if not fail else "\nFAILED")
sys.exit(1 if fail else 0)
