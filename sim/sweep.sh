#!/bin/sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
B=${BUILD:-$ROOT/sim/build}
IRSIM=${IRSIM:-irsim}
STEPS=${STEPS:-"10 5 4 3.5 3.25 3"}
mkdir -p "$B"
cp "$ROOT"/magic/*.mag "$B"/
cp "$ROOT"/DRC.tech27 "$B"/scmos.tech
cp "$ROOT"/magic/g180.prm "$ROOT"/magic/6502_final.irsim "$B"/
cd "$B"
magic -dnull -noconsole -T ./scmos.tech "$ROOT"/sim/extract.tcl > extract.log 2>&1
python3 "$ROOT"/sim/prep.py netlist
trace() {
  python3 "$ROOT"/sim/prep.py cmd "$1" > run_"$1".cmd
  "$IRSIM" g180.prm 6502_full.sim -run_"$1".cmd 2>/dev/null | grep -E '^a=|^r-w_' > trace_"$1".txt
}
trace 400
best=
for s in $STEPS; do
  trace "$s"
  if cmp -s trace_400.txt trace_"$s".txt; then r=pass; best=$s; else r=FAIL; fi
  awk -v s="$s" -v r="$r" 'BEGIN { printf "step %5s ns  period %6.2f ns  %6.1f MHz  %s\n", s, 4*s, 250/s, r }'
done
[ -n "$best" ] || exit 1
python3 "$ROOT"/sim/prep.py cmd "$best" power > power.cmd
"$IRSIM" g180.prm 6502_full.sim -power.cmd 2>/dev/null | grep "Dynamic power"
