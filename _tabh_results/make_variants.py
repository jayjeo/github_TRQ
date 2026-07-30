# -*- coding: utf-8 -*-
"""
Generates the variant do files used for the paper's selected-horizon table.
Reads the four original do files and (1) redirects paths to the build folder,
(2) shrinks the h loop, (3) inserts CSV-recording code right after each regression,
(4) drops the graph blocks, (5) renames res.csv, and (6) for the G base spec only,
inserts the intensity-CSV extraction code.
Every substitution count is asserted and a unified diff against the original is kept.
The originals are only read, never modified.
"""
import difflib
import os

DEFAULT_SRC = r"D:\JJ Dropbox\KCTDI_Research\할당관세 정책이 소비자 물가에 미치는 영향\GItPublish_3rd_submit\260707 파인애플과거포함, no-smoothing- 대안 m1 및 방출량\IRF 그래프\DCDH 및 DUBE 논문 학습\Empirical Strategy LP-DiD"
SRC = os.environ.get("GRAPE_SRC", DEFAULT_SRC)
OUT = os.environ.get("GRAPE_OUT", r"C:\build\tabh")
STATA_OUT = OUT.replace("\\", "/")

# (source filename, spec tag, impulse?, G?)
FILES = [
    ("LPseparate_Gm4_CV1(95)ct.do",           "Gbase",      False, True),
    ("LPseparate_noGm4_CV1(95)ct.do",         "noGbase",    False, False),
    ("LPseparate_Gm4_CV1(95)ct_impulse.do",   "Gimpulse",   True,  True),
    ("LPseparate_noGm4_CV1(95)ct_impulse.do", "noGimpulse", True,  False),
]

def transform(lines, spec, impulse, is_G):
    out = []
    c = dict(cd=0, hloop=0, lterm=0, post1=0, post2=0, close=0,
             export=0, g1save=0, g2save=0)
    hset = "150 250" if impulse else "150"
    truncated = False
    for ln in lines:
        s = ln.strip()

        # (1) paths
        if s == 'cd "${path}"':
            out.append(f'cd "{STATA_OUT}"\n')
            c['cd'] += 1
            continue

        # (2) shrink the h loop (groups 1 and 2, twice in total)
        if s.startswith("forvalues h = -") and "Hpre" in s:
            out.append("foreach h in %s {\n" % hset)
            c['hloop'] += 1
            continue

        # (5) rename res.csv + (4) drop everything after this line (the graph block)
        if s.startswith("export delimited using") and "_res.csv" in s:
            out.append(ln.replace("_res.csv", "_res_TABHVAR.csv"))
            c['export'] += 1
            truncated = True
            break  # discard the remaining graph/keep lines

        # (3a) open the table-figures file + header (right after the lterm line)
        if s.startswith('local lterm "i.qcode#c.L365_temp_avg'):
            out.append(ln)
            out.append("* [TABH] table-number output file\n")
            out.append("capture file close _tabh\n")
            out.append('file open _tabh using "tabh_%s.csv", write replace\n' % spec)
            out.append('file write _tabh "spec,group,h,b,se,N,r2,r2_a,df_r,N_clust" _n\n')
            c['lterm'] += 1
            continue

        # (3b) insert the table-figures write before the else-branch post line (by group)
        if s.startswith("post `post1'") and "`bb'" in s:
            indent = ln[:len(ln) - len(ln.lstrip())]
            out.append(indent + 'file write _tabh "%s,1,`h\',`bb\',`ss\',`=e(N)\',`=e(r2)\',`=e(r2_a)\',`=e(df_r)\',`=e(N_clust)\'" _n\n' % spec)
            out.append(ln)
            c['post1'] += 1
            continue
        if s.startswith("post `post2'") and "`bb'" in s:
            indent = ln[:len(ln) - len(ln.lstrip())]
            out.append(indent + 'file write _tabh "%s,2,`h\',`bb\',`ss\',`=e(N)\',`=e(r2)\',`=e(r2_a)\',`=e(df_r)\',`=e(N_clust)\'" _n\n' % spec)
            out.append(ln)
            c['post2'] += 1
            continue

        # (3c) close the table-figures file (right after postclose post2)
        if s == "postclose `post2'":
            out.append(ln)
            out.append("* [TABH] close table-number file\n")
            out.append("file close _tabh\n")
            c['close'] += 1
            continue

        # (6) extract the intensity CSV for the G base spec only (after each group save)
        if is_G and not impulse and s == 'save "`g1base\'", replace':
            out.append(ln)
            out.append("* [TABH] intensity extraction (group1 = vegetables)\n")
            out.append("preserve\n")
            out.append("keep if d==1\n")
            out.append("collapse (mean) intensity TRQall, by(qcode q_item)\n")
            out.append("gen double tau = intensity + TRQall\n")
            out.append('export delimited using "tabh_intensity_veg.csv", replace\n')
            out.append("restore\n")
            c['g1save'] += 1
            continue
        if is_G and not impulse and s == 'save "`g2base\'", replace':
            out.append(ln)
            out.append("* [TABH] intensity extraction (group2 = fruits)\n")
            out.append("preserve\n")
            out.append("keep if d==1\n")
            out.append("collapse (mean) intensity TRQall, by(qcode q_item)\n")
            out.append("gen double tau = intensity + TRQall\n")
            out.append('export delimited using "tabh_intensity_fruit.csv", replace\n')
            out.append("restore\n")
            c['g2save'] += 1
            continue

        out.append(ln)

    # assert checks
    assert c['cd'] == 1,     "%s cd=%d" % (spec, c['cd'])
    assert c['hloop'] == 2,  "%s hloop=%d" % (spec, c['hloop'])
    assert c['lterm'] == 1,  "%s lterm=%d" % (spec, c['lterm'])
    assert c['post1'] == 1,  "%s post1=%d" % (spec, c['post1'])
    assert c['post2'] == 1,  "%s post2=%d" % (spec, c['post2'])
    assert c['close'] == 1,  "%s close=%d" % (spec, c['close'])
    assert c['export'] == 1, "%s export=%d" % (spec, c['export'])
    assert truncated,        "%s not truncated" % spec
    if is_G and not impulse:
        assert c['g1save'] == 1, "%s g1save=%d" % (spec, c['g1save'])
        assert c['g2save'] == 1, "%s g2save=%d" % (spec, c['g2save'])
    return out, c

def main():
    os.makedirs(OUT, exist_ok=True)
    summary = []
    for fname, spec, impulse, is_G in FILES:
        with open(os.path.join(SRC, fname), "r", encoding="utf-8") as f:
            orig = f.readlines()
        new, c = transform(list(orig), spec, impulse, is_G)
        outdo = os.path.join(OUT, "var_%s.do" % spec)
        with open(outdo, "w", encoding="utf-8", newline="") as f:
            f.writelines(new)
        # diff
        diff = difflib.unified_diff(orig, new, fromfile="orig/"+fname,
                                    tofile="var_%s.do" % spec, n=2)
        with open(os.path.join(OUT, "diff_%s.txt" % spec), "w",
                  encoding="utf-8", newline="") as f:
            f.writelines(diff)
        summary.append((spec, len(orig), len(new), c))
        print("OK %-11s orig=%d new=%d counts=%s -> %s" %
              (spec, len(orig), len(new), c, outdo))
    print("\nALL VARIANTS GENERATED")

if __name__ == "__main__":
    main()
