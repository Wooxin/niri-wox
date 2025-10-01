#!/usr/bin/env python3
import json
import subprocess
from typing import Dict, List

def get_workspaces() -> List[Dict]:
    try:
        result = subprocess.run(
            ["niri", "msg", "--json", "workspaces"],
            capture_output=True,
            text=True,
            timeout=5
        )
        
        if result.returncode != 0:
            return []
        
        data = json.loads(result.stdout)
        return data if isinstance(data, list) else []
        
    except Exception:
        return []

def format_workspace(ws: Dict) -> str:
    if ws.get("is_focused", False):
        icon = "●"
        color = "#ffffff"
    elif ws.get("is_active", False):
        icon = "○"
        color = "#aaaaaa"
    else:
        icon = "○"
        color = "#666666"
    
    return f"<span color='{color}'>{icon}</span>"

def main():
    workspaces = get_workspaces()
    
    if not workspaces:
        output = {
            "text": "○",
            "class": "workspaces",
            "tooltip": "niri not available"
        }
    else:
        sorted_workspaces = sorted(workspaces, key=lambda ws: ws.get("idx", 0))
        
        output = {
            "text": " ".join(format_workspace(ws) for ws in sorted_workspaces),
            "class": "workspaces",
            "tooltip": "\n".join(
                f"Workspace {ws.get('idx', '?')}: " +
                f"{'Focused' if ws.get('is_focused') else 'Active' if ws.get('is_active') else 'Inactive'}" +
                f" ({ws.get('window_count', 0)} windows)" 
                for ws in sorted_workspaces
            )
        }
    
    print(json.dumps(output))

if __name__ == "__main__":
    main()