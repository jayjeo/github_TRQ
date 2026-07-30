# -*- coding: utf-8 -*-
"""
AD_stack.py - Phase 2: stacked event-time trajectories in the estimator's metric.

For each clean event e (item i_e, onset t_e):
  treated curve : dY_e(k) = ln s_price[i_e, t_e+k] - ybase[i_e, t_e]
  control curve : mean over never-treated items c of ( ln s_price[c, t_e+k] - ybase[c, t_e] )
Curves are averaged over events. No smoothing (7-day binned means provided as extra columns).

Adjusted version ("adj"): s_price replaced by s_price minus the item-specific climate
component, estimated per item by OLS on NON-treatment observations only
(TRQD==0 & prevtr120==0), with calendar-month and year dummies included in the
estimation (only the climate component is subtracted). ybase is recomputed as the
120-day trailing mean of the adjusted series. Climate regressors are the production
transforms already stored in AD_g*.dta (100-day trailing means + their L365 statics).

Inputs : AD_g1.dta, AD_g2.dta (m4 clean events)   [primary]
         AD_m1g1.dta, AD_m1g2.dta (m1 single onsets) [secondary, if present]
Outputs: AD_stack_{base}_{g}.csv, AD_stack_{base}_{g}.png (raw & adj panels)
Read-only with respect to all inputs.
"""
import os
import numpy as np
import pandas as pd

HERE = os.path.dirname(os.path.abspath(__file__))
K_MIN, K_MAX = -150, 30
MIN_ADJ_OBS = 200  # minimum non-treatment obs to estimate an item's climate coefficients

CLIM = ["temp_avg", "humidity_avg", "precipitation_daily", "sunshine_hours",
        "L365_temp_avg", "L365_humidity_avg", "L365_precipitation_daily", "L365_sunshine_hours"]


def trailing_mean(series_by_date, window=120):
    """120-day trailing mean over [t-120, t-1] for a daily-indexed Series (may contain NaN)."""
    s = series_by_date.sort_index()
    # shift by one day then rolling 120 days
    return s.shift(1).rolling(window=window, min_periods=1).mean()


def build_curves(df, label, out_prefix):
    df = df.sort_values(["qcode", "date"]).reset_index(drop=True)
    df["TRQD"] = df["TRQD"].fillna(0)

    # clean events
    g = df.groupby("qcode", sort=False)
    lag = g["TRQD"].shift(1)
    ev = (df["TRQD"] == 1) & (lag == 0) & (df["d"] == 1) & (df["prevtr120"] == 0)
    events = df.loc[ev, ["qcode", "q_item", "date"]].reset_index(drop=True)
    print(f"[{label}] clean events: {len(events)}")
    for _, r in events.iterrows():
        print("   ", r["q_item"], r["date"].date())

    # adjusted price series
    df["s_adj"] = df["s_price"].astype(float)
    adj_items = {}
    for q, sub in df.groupby("qcode", sort=False):
        mask = (sub["TRQD"] == 0) & (sub["prevtr120"] == 0) & sub["s_price"].notna()
        est = sub.loc[mask].dropna(subset=CLIM)
        if len(est) < MIN_ADJ_OBS:
            adj_items[q] = False
            continue
        X_clim = est[CLIM].to_numpy(float)
        month_d = pd.get_dummies(est["month"], prefix="m", drop_first=True)
        year_d = pd.get_dummies(est["year"], prefix="y", drop_first=True)
        X = np.column_stack([X_clim, month_d.to_numpy(float), year_d.to_numpy(float),
                             np.ones(len(est))])
        y = est["s_price"].to_numpy(float)
        beta, *_ = np.linalg.lstsq(X, y, rcond=None)
        b_clim = beta[: len(CLIM)]
        full = sub.dropna(subset=CLIM)
        comp = pd.Series(full[CLIM].to_numpy(float) @ b_clim, index=full.index)
        comp = comp - comp.mean()
        df.loc[comp.index, "s_adj"] = df.loc[comp.index, "s_price"] - comp
        adj_items[q] = True
    n_adj = sum(v for v in adj_items.values())
    print(f"[{label}] items with climate adjustment: {n_adj}/{len(adj_items)}")

    # wide matrices: date x qcode
    wide_raw = df.pivot(index="date", columns="qcode", values="s_price")
    wide_adj = df.pivot(index="date", columns="qcode", values="s_adj")
    # raw variant uses the STORED production ybase (exact estimator consistency);
    # adjusted variant recomputes the same trailing mean on the adjusted series.
    ybase_raw = df.pivot(index="date", columns="qcode", values="ybase")
    ybase_adj = wide_adj.apply(trailing_mean)
    # consistency check: recomputed trailing mean must match stored ybase
    chk = wide_raw.apply(trailing_mean)
    dmax = (chk - ybase_raw).abs().max().max()
    print(f"[{label}] ybase replication max abs diff = {dmax:.3e}")

    never = sorted(df.loc[df["never_tr"] == 1, "qcode"].unique())

    ks = np.arange(K_MIN, K_MAX + 1)
    rows = []
    for _, e in events.iterrows():
        qi, t0 = int(e["qcode"]), e["date"]
        for wide, ybase, tag in ((wide_raw, ybase_raw, "raw"), (wide_adj, ybase_adj, "adj")):
            if qi not in wide.columns or t0 not in ybase.index:
                continue
            yb_t = ybase.loc[t0]
            for k in ks:
                t = t0 + pd.Timedelta(days=int(k))
                if t not in wide.index:
                    continue
                tr = wide.at[t, qi] - yb_t[qi]
                cvals = wide.loc[t, never].to_numpy(float) - yb_t[never].to_numpy(float)
                cvals = cvals[~np.isnan(cvals)]
                rows.append({"variant": tag, "event_item": e["q_item"],
                             "onset": t0.date(), "k": int(k),
                             "treated": tr, "control": np.nanmean(cvals) if len(cvals) else np.nan,
                             "n_ctrl_items": len(cvals)})
    per_event = pd.DataFrame(rows)
    per_event.to_csv(os.path.join(HERE, f"{out_prefix}_per_event.csv"),
                     index=False, encoding="utf-8-sig")

    # paired difference per event (NaN where either side missing, e.g. retail price gaps)
    per_event["pair_diff"] = per_event["treated"] - per_event["control"]
    agg = (per_event.groupby(["variant", "k"])
           .agg(treated=("treated", "mean"), control=("control", "mean"),
                diff=("pair_diff", "mean"),
                n_events=("pair_diff", lambda s: s.notna().sum()))
           .reset_index())
    # 7-day binned means (transparent, no smoothing)
    agg["kbin"] = (agg["k"] // 7) * 7 + 3
    binned = (agg.groupby(["variant", "kbin"])[["treated", "control", "diff"]]
              .mean().reset_index().rename(columns={"kbin": "k"}))
    agg.to_csv(os.path.join(HERE, f"{out_prefix}_agg.csv"), index=False, encoding="utf-8-sig")
    binned.to_csv(os.path.join(HERE, f"{out_prefix}_binned.csv"), index=False, encoding="utf-8-sig")

    # plot
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        fig, axes = plt.subplots(1, 2, figsize=(13, 5), sharey=True)
        for ax, tag, ttl in zip(axes, ["raw", "adj"], ["Unadjusted", "Climate-adjusted"]):
            a = agg[agg["variant"] == tag]
            ax.plot(a["k"], a["treated"], color="crimson", lw=1.2, label="Treated")
            ax.plot(a["k"], a["control"], color="black", lw=1.2, label="Clean controls")
            ax.plot(a["k"], a["diff"], color="royalblue", lw=1.0, ls="--", label="Difference")
            ax.axvline(0, color="gray", ls=":", lw=1)
            ax.axhline(0, color="gray", lw=0.6)
            ax.set_title(f"{ttl} ({label})")
            ax.set_xlabel("Days relative to onset")
        axes[0].set_ylabel("ln price − 120-day pre-onset mean")
        axes[0].legend(frameon=False, fontsize=9)
        fig.tight_layout()
        fig.savefig(os.path.join(HERE, f"{out_prefix}.png"), dpi=150)
        plt.close(fig)
        print(f"[{label}] wrote {out_prefix}.png")
    except Exception as exc:  # matplotlib absent or font issue: CSVs still produced
        print(f"[{label}] plot skipped: {exc}")

    return per_event, agg


def main():
    jobs = [("AD_g1.dta", "veg-m4", "AD_stack_m4_g1"),
            ("AD_g2.dta", "fruit-m4", "AD_stack_m4_g2"),
            ("AD_m1g1.dta", "veg-m1", "AD_stack_m1_g1"),
            ("AD_m1g2.dta", "fruit-m1", "AD_stack_m1_g2")]
    for fn, label, pref in jobs:
        path = os.path.join(HERE, fn)
        if not os.path.exists(path):
            print(f"skip {fn} (missing)")
            continue
        cols = ["qcode", "q_item", "date", "TRQD", "d", "prevtr120", "never_tr",
                "s_price", "ybase", "year", "month"] + CLIM
        df = pd.read_stata(path, columns=cols, convert_categoricals=False)
        build_curves(df, label, pref)


if __name__ == "__main__":
    main()
