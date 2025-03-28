#!/usr/bin/env python3
import sys

current_country = None
sum_revenue = 0.0
order_count = 0

for line in sys.stdin:
    country, value = line.strip().split('\t')
    revenue_str, count_str = value.split(',')
    revenue_val = float(revenue_str)
    count_val = int(count_str)

    if current_country == country:
        sum_revenue += revenue_val
        order_count += count_val
    else:
        if current_country is not None and order_count > 0:
            avg_revenue = sum_revenue / order_count
            print(f"{current_country}\tOrders: {order_count}\tTotal_Revenue: {sum_revenue:.2f}\tAvg_Revenue: {avg_revenue:.2f}")

        current_country = country
        sum_revenue = revenue_val
        order_count = count_val

# Last country
if current_country is not None and order_count > 0:
    avg_revenue = sum_revenue / order_count
    print(f"{current_country}\tOrders: {order_count}\tTotal_Revenue: {sum_revenue:.2f}\tAvg_Revenue: {avg_revenue:.2f}")
