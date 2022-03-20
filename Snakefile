runs = {
    f"run_cu{p[0]}_td{p[1]}": f"FP_CORE_UTIL={p[0]},PL_TARGET_DENSITY={p[1]}"
    for p in [(40,0.45),
              (32,0.37),
              (30,0.35),
              (28,0.33),
              (40,0.3),
              (25,0.45)]
}

rule all:
     input:
       expand([
           "runs/{run}/reports/final_summary_report.csv",
           "runs/{run}/results/final/gds/wrapped_silife.gds"
       ], run=runs.keys())

rule harden:
     output:
       ["runs/{run}/reports/final_summary_report.csv",
        "runs/{run}/results/final/gds/wrapped_silife.gds"]
     params:
       override_env=lambda wildcards: runs[wildcards.run]
     conda:
       "environment.yml"
     shell:
       "TERM=xterm PDK_ROOT=$CONDA_PREFIX/share/pdk TCLLIBPATH=$CONDA_PREFIX/lib/tcllib1.20/ OpenLane/flow.tcl -design . -tag {wildcards.run} -override_env {params.override_env} -overwrite"
