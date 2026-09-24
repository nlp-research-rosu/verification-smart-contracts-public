#!/bin/sh
set -eu
cd "$(dirname "$0")"
exec python3 - <<'PY'
import json
from pathlib import Path
import shutil
import subprocess

package = Path.cwd()
config = json.loads((package / "replay.json").read_text())
session = json.loads(subprocess.check_output([
    "kprover", "session", "start", "--project", str(package), "--semantics", "evm"
], text=True))
if not session["semantics"]["commit"].startswith("4f4c3843076c"):
    raise SystemExit("Semantics revision differs from the recorded proof; no proof submitted.")
inputs = Path(session["workspaceDir"]) / "inputs"
inputs.mkdir(parents=True, exist_ok=True)

def prove(name, module):
    shutil.copyfile(package / name, inputs / name)
    subprocess.run([
        "kprover", "prove", "--session", session["sessionId"],
        "--spec", "inputs/" + name, "--spec-module", module,
        "--verification", "inputs/verification.k",
        "--verification-module", config["verificationModule"],
    ], check=True)

shutil.copyfile(package / "verification.k", inputs / "verification.k")
prove("spec.k", config["specModule"])
for name, module in config["additionalSpecs"]:
    prove(name, module)

# The dependency specs import verification.k but were proved with this separate
# exact-bytecode definition; give it the imported name in the session workspace.
shutil.copyfile(package / "verification-pause.k", inputs / "verification.k")
for name, module in config["pauseSpecs"]:
    prove(name, module)
PY
