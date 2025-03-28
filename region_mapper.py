#!/usr/bin/env python3
import sys

for line in sys.stdin:
    if line.startswith("Region,Country,Item Type"):
        continue

    fields = line.strip().split(',')
    if len(fields) < 1:
        continue

    region = fields[0]  # 1st column
    print(f"{region}\t1")
