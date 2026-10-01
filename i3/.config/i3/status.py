#!/usr/bin/env python3
"""Add the GnuCash lock-file indicator to i3status's JSON stream."""

import json
from pathlib import Path
import signal
import subprocess
import sys
import threading


def gnucash_indicator():
    directory = Path.home() / 'Documents/Personal/Finance/gnucash/current'
    if any(directory.glob('*.LCK')):
        return [{'name': 'gnucash', 'full_text': '$', 'color': '#00FF00'}]
    return []


def handle_clicks():
    for line in sys.stdin:
        line = line.strip().lstrip(',')
        if line == '[':
            continue
        try:
            event = json.loads(line)
        except ValueError:
            continue
        if event.get('name') == 'gnucash' and event.get('button') == 1:
            subprocess.run(
                ['i3-msg', '[class="(?i)^gnucash$"] focus'],
                stdout=subprocess.DEVNULL,
                check=False,
            )


def stop(signum, frame):
    raise SystemExit(0)


def main():
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    config = Path(__file__).resolve().with_name('i3status.conf')
    process = subprocess.Popen(
        ['i3status', '-c', str(config)],
        stdout=subprocess.PIPE,
        text=True,
    )
    try:
        header = json.loads(process.stdout.readline())
        header['click_events'] = True
        print(json.dumps(header), flush=True)
        if process.stdout.readline().strip() != '[':
            raise SystemExit('Expected i3status JSON array')
        print('[', flush=True)
        threading.Thread(target=handle_clicks, daemon=True).start()
        separator = ''
        for line in process.stdout:
            blocks = json.loads(line.strip().lstrip(','))
            print(separator + json.dumps(gnucash_indicator() + blocks), flush=True)
            separator = ','
    except BrokenPipeError:
        pass
    finally:
        process.terminate()
        process.wait()


if __name__ == '__main__':
    main()
