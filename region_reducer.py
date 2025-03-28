#!/usr/bin/env python3
import sys

current_region = None
order_count = 0

for line in sys.stdin:
    region, count = line.strip().split('\t')
    count = int(count)

    if current_region == region:
        order_count += count
    else:
        if current_region is not None:
            print(f"{current_region}\t{order_count}")
        current_region = region
        order_count = count

# Print the last group
if current_region is not None:
    print(f"{current_region}\t{order_count}")
