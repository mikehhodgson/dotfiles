#!/usr/bin/env python3
"""CPU and memory labels for the migrated Waybar command widgets."""

import json
import os
from pathlib import Path
import sys
import time


def cpu_sample():
    values = list(map(int, Path('/proc/stat').read_text().splitlines()[0].split()[1:9]))
    return sum(values), values[3] + values[4]


def cpu_text():
    cache = Path(os.environ.get('XDG_CACHE_HOME', Path.home() / '.cache')) / 'omarchy' / 'bar-cpu.json'
    current = cpu_sample()
    try:
        previous = json.loads(cache.read_text())
    except (OSError, ValueError):
        previous = current
        time.sleep(0.05)
        current = cpu_sample()
    elapsed = current[0] - previous[0]
    busy = elapsed - (current[1] - previous[1])
    usage = round(100 * busy / elapsed) if elapsed > 0 else 0
    cache.parent.mkdir(parents=True, exist_ok=True)
    temporary = cache.with_name(f'{cache.name}.{os.getpid()}.tmp')
    temporary.write_text(json.dumps(current))
    temporary.replace(cache)
    return f'{max(0, min(100, usage))}% 󰍛'


def memory_text():
    memory = {}
    for line in Path('/proc/meminfo').read_text().splitlines():
        key, value = line.split(':', 1)
        memory[key] = int(value.split()[0])
    total = memory['MemTotal'] / 1024**2
    used = (memory['MemTotal'] - memory['MemAvailable']) / 1024**2
    return f'{used:.1f}G/{total:.1f}G'


if __name__ == '__main__':
    if len(sys.argv) != 2 or sys.argv[1] not in ('cpu', 'memory'):
        raise SystemExit('Usage: status.py cpu|memory')
    label = cpu_text() if sys.argv[1] == 'cpu' else memory_text()
    print(json.dumps({'text': label}))
