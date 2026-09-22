#!/usr/bin/env python3
"""Replay one package with a fresh, revision-checked kprover session."""
import json
from pathlib import Path
import shutil
import subprocess
import sys

package = Path(sys.argv[1]).resolve()
config = json.loads((package / "replay.json").read_text())
session = json.loads(subprocess.check_output([
    "kprover", "session", "start", "--project", str(package), "--semantics", "evm"
], text=True))
if not session["semantics"]["commit"].startswith("4f4c3843076c"):
    sys.exit("Semantics revision differs from the recorded proof; no proof submitted.")
inputs = Path(session["workspaceDir"]) / "inputs"
inputs.mkdir(parents=True, exist_ok=True)
for name in ["spec.k", "verification.k", *config["sources"]]:
    target = inputs / name
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(package / name, target)
command = [
    "kprover", "prove", "--session", session["sessionId"],
    "--spec", "inputs/spec.k", "--spec-module", config["specModule"],
    "--verification", "inputs/verification.k",
    "--verification-module", config["verificationModule"],
]
for name in config["sources"]:
    command.extend(["--source", "inputs/" + name])
sys.exit(subprocess.call(command))
