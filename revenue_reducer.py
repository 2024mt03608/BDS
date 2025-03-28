#!/usr/bin/env python3
import sys

current_date = None
sum_revenue = 0.0
order_count = 0

for line in sys.stdin:
    date, value = line.strip().split('\t')
    revenue_str, count_str = value.split(',')
    revenue_val = float(revenue_str)
    count_val = int(count_str)

    if current_date == date:
        sum_revenue += revenue_val
        order_count += count_val
    else:
        # Output for the previous date
        if current_date is not None and order_count > 0:
            avg_revenue = sum_revenue / order_count
            print(f"{current_date}\tTotal_Revenue: {sum_revenue:.2f}\tOrders: {order_count}\tAvg_Revenue: {avg_revenue:.2f}")

        current_date = date
        sum_revenue = revenue_val
        order_count = count_val

# Last date
if current_date is not None and order_count > 0:
    avg_revenue = sum_revenue / order_count
    print(f"{current_date}\tTotal_Revenue: {sum_revenue:.2f}\tOrders: {order_count}\tAvg_Revenue: {avg_revenue:.2f}")
