#!/usr/bin/env python3
import sys

for line in sys.stdin:
    # Skip header if needed
    if line.startswith("Region,Country,Item Type"):
        continue

    fields = line.strip().split(',')
    if len(fields) < 6:
        continue

    order_date = fields[5]  # 6th column
    # Example: "1/27/2010" or "2010-01-27" – no time included in original dataset
    # We'll just emit the string as-is.
    print(f"{order_date}\t1")
