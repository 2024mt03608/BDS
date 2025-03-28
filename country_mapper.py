#!/usr/bin/env python3
import sys

for line in sys.stdin:
    if line.startswith("Region,Country,Item Type"):
        continue

    fields = line.strip().split(',')
    if len(fields) < 12:
        continue

    country = fields[1]        # 2nd column
    total_revenue_str = fields[11]  # 12th column

    try:
        total_revenue = float(total_revenue_str)
    except ValueError:
        continue

    print(f"{country}\t{total_revenue},1")
