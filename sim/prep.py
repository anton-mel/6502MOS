import sys


def netlist():
    rails = {}
    for line in open("6502.al"):
        f = line.split()
        if len(f) == 3:
            name = f[2].rsplit("/", 1)[-1]
            if name in ("GND!", "Vdd!"):
                rails[f[1]] = name
    out = []
    for line in open("6502.sim"):
        if line[:2] in ("n ", "p ", "C "):
            f = line.split(" ")
            last = 4 if line[0] != "C" else 3
            for i in range(1, last):
                f[i] = rails.get(f[i], f[i])
            line = " ".join(f)
        out.append(line)
    for line in open("6502.al"):
        f = line.split()
        if len(f) == 3:
            a, b = rails.get(f[1], f[1]), rails.get(f[2], f[2])
            if a != b:
                out.append(f"= {a} {b}\n")
    open("6502_full.sim", "w").writelines(out)


def cmd(step, power):
    out = [f"stepsize {step}"]
    if power:
        out += ["vsupply 1.8", "powtrace *", "powlogfile power.log"]
    for line in open("6502_final.irsim").read().split("\n"):
        t = line.strip()
        if not t or t.startswith(("ana", "#")):
            continue
        if t.startswith("setvector "):
            t = "set " + t[len("setvector "):]
        out.append(t)
        if t in ("c", "p"):
            out.append("d a d r-w_")
    if power:
        out.append("powlogfile")
    out.append("exit")
    print("\n".join(out))


if sys.argv[1] == "netlist":
    netlist()
else:
    cmd(sys.argv[2], len(sys.argv) > 3 and sys.argv[3] == "power")
