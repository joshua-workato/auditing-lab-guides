#!/usr/bin/env bash
# Resolves a bare Workato folder id (e.g. copied from a browser URL's
# `fid=` param) to its containing project and full folder path, by
# walking the folder tree with the active `wk` auth profile.
#
# Prefer asking the requester for the exact project/folder name, or the
# full browser URL (which at least confirms the workspace), instead of a
# bare fid -- this script is a fallback for when a bare fid is all you
# have. It can take dozens of `wk folders list` calls (one per folder
# visited, breadth-first from the workspace root) to find a match, and it
# can only find folders visible to the active auth profile.
#
# Requires: `wk` installed and authenticated (this skill assumes it
# already is), Python 3 on PATH.
#
# Usage: resolve_folder_id.sh <folder-id>
#   e.g. resolve_folder_id.sh 32627913
set -euo pipefail
FID="${1:?Usage: resolve_folder_id.sh <folder-id>}"

if ! command -v wk >/dev/null 2>&1; then
  echo "wk CLI not found on PATH. Install and authenticate it first before running this script." >&2
  exit 1
fi

python3 - "$FID" <<'PYEOF'
import subprocess, json, sys

target = int(sys.argv[1])

def wk_json(*args):
    out = subprocess.run(['wk', *args, '--json'], capture_output=True, text=True, timeout=30)
    if out.returncode != 0:
        sys.stderr.write(out.stderr)
        sys.exit(1)
    return json.loads(out.stdout)

top = wk_json('folders', 'list')

visited = set()
queue = [(f['id'], [(f['id'], f['name'])]) for f in top]
calls = 0
found_path = None

while queue:
    fid, path = queue.pop(0)
    if fid in visited:
        continue
    visited.add(fid)
    if fid == target:
        found_path = path
        break
    calls += 1
    children = wk_json('folders', 'list', '--parent', str(fid))
    for c in children:
        if c['id'] not in visited:
            queue.append((c['id'], path + [(c['id'], c['name'])]))

if found_path is None:
    sys.stderr.write(
        f"Folder id {target} not found in this workspace's folder tree "
        f"(searched {calls} folders under the active auth profile). "
        f"Either it's in a different workspace/profile, or the active "
        f"profile doesn't have visibility into it -- don't guess, ask "
        f"the person to confirm the workspace or the project name "
        f"directly.\n"
    )
    sys.exit(1)

project_id, project_name = found_path[0]
subpath = [name for _, name in found_path[1:]]

print(f"project: {project_name}  (top-level folder id {project_id})")
if subpath:
    print("path within project: " + " / ".join(subpath))
    sync_path = "/".join([project_name] + subpath)
    print(f'Suggested: wk init --sync "{sync_path}"')
else:
    print(f'Suggested: wk init --project "{project_name}"')
sys.stderr.write(f"(resolved via {calls} folder-list calls)\n")
PYEOF
