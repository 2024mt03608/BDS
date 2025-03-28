#!/usr/bin/env python3
import sys

current_date = None
current_count = 0

for line in sys.stdin:
    date, count = line.strip().split('\t')
    count = int(count)

    if current_date == date:
        current_count += count
    else:
        if current_date is not None:
            print(f"{current_date}\t{current_count}")
        current_date = date
        current_count = count

# Print the last key-value pair
if current_date is not None:
    print(f"{current_date}\t{current_count}")
