Below is an **end-to-end action plan** for analyzing your **“50000 Sales Records.csv”** using **Hadoop Map‑Reduce**, based on the column names visible in your screenshot. We’ll assume the CSV has **14 columns** in the following order (exact field names from the top row):

1. **Region**  
2. **Country**  
3. **Item Type**  
4. **Sales Channel**  
5. **Order Priority**  
6. **Order Date** (format: YYYY‑MM‑DD)  
7. **Order ID**  
8. **Ship Date**  
9. **Units Sold**  
10. **Unit Price**  
11. **Unit Cost**  
12. **Total Revenue**  
13. **Total Cost**  
14. **Total Profit**

> **Note**: If the actual column order differs in your CSV, adjust the **indices** in the mapper scripts accordingly.

---

## 1. Problem Statement & Objectives

**Problem Statement:**  
Your sales dataset contains 50,000 records of orders, including details about region, country, item type, revenue, and more. You want to derive key insights that help optimize operations, evaluate product performance, and understand regional or country-level segmentation.

**Objectives:**  
Using **Hadoop Map‑Reduce** on **“50000 Sales Records.csv,”** you will:

1. **Temporal Sales Analysis:** Identify order volumes by date.  
2. **Region Sales Analysis:** Determine which regions generate the most orders.  
3. **Revenue Analysis:** Aggregate total revenue by date and compute average revenue per day.  
4. **Product Performance Evaluation:** Rank item types by total revenue and average revenue.  
5. **Country Segmentation Analysis:** Aggregate orders and revenue by country.

---

## 2. Analysis Tasks & Expected Outputs

### Task 1: Temporal Sales Analysis
- **Input Columns:** Order Date (column 6).  
- **Task:** Parse the date and count how many orders occur on each date.  
- **Output:** `(order_date, order_count)`

### Task 2: Region Sales Analysis
- **Input Columns:** Region (column 1).  
- **Task:** Group by region and count the number of orders.  
- **Output:** `(region, order_count)`

### Task 3: Revenue Analysis
- **Input Columns:** Order Date (column 6), Total Revenue (column 12).  
- **Task:** Group by date, sum the total revenue, count the number of orders, and compute the average revenue per order.  
- **Output:** `(order_date, total_revenue, order_count, avg_revenue)`

### Task 4: Product Performance Evaluation
- **Input Columns:** Item Type (column 3), Total Revenue (column 12).  
- **Task:** Group by item type, sum total revenue, count the orders, and compute the average revenue.  
- **Output:** `(item_type, total_revenue, order_count, avg_revenue)`

### Task 5: Country Segmentation Analysis
- **Input Columns:** Country (column 2), Total Revenue (column 12).  
- **Task:** Group by country, sum total revenue, count orders, and compute the average revenue per order.  
- **Output:** `(country, total_orders, total_revenue, avg_revenue)`

---

## 3. Map‑Reduce Flow Diagrams

### Diagram 1: Temporal Sales Analysis
```
[Input CSV]
      │
      ▼  (Mapper: extract Order Date → emit (date, 1))
[Shuffle/Sort: group by date]
      │
      ▼  (Reducer: sum counts per date)
[Output] → (date, order_count)
```

### Diagram 2: Region Sales Analysis
```
[Input CSV]
      │
      ▼  (Mapper: extract Region → emit (region, 1))
[Shuffle/Sort: group by region]
      │
      ▼  (Reducer: sum counts per region)
[Output] → (region, order_count)
```

### Diagram 3: Revenue Analysis
```
[Input CSV]
      │
      ▼  (Mapper: extract date & total_revenue → emit (date, "revenue,1"))
[Shuffle/Sort: group by date]
      │
      ▼  (Reducer: sum revenue & counts; compute avg_revenue)
[Output] → (date, total_revenue, order_count, avg_revenue)
```

### Diagram 4: Product Performance Evaluation
```
[Input CSV]
      │
      ▼  (Mapper: extract item_type & total_revenue → emit (item_type, "revenue,1"))
[Shuffle/Sort: group by item_type]
      │
      ▼  (Reducer: sum revenue & counts; compute avg_revenue)
[Output] → (item_type, total_revenue, order_count, avg_revenue)
```

### Diagram 5: Country Segmentation Analysis
```
[Input CSV]
      │
      ▼  (Mapper: extract country & total_revenue → emit (country, "revenue,1"))
[Shuffle/Sort: group by country]
      │
      ▼  (Reducer: sum revenue & counts; compute avg_revenue)
[Output] → (country, total_orders, total_revenue, avg_revenue)
```

---

## 4. Pseudo Code & Functional Code

Below are **Python** mapper and reducer scripts for each of the five tasks. **Adjust file paths** or **column indices** as needed if your CSV differs.

---

### Task 1: Temporal Sales Analysis

**Pseudo Code:**
```
For each record:
    parse line by splitting on commas
    order_date = fields[5]  # 6th column
    emit (order_date, 1)

For each order_date group:
    sum up the counts
    emit (order_date, total_count)
```

**Mapper (temporal_mapper.py):**
```python
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
```

**Reducer (temporal_reducer.py):**
```python
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
```

---

### Task 2: Region Sales Analysis

**Pseudo Code:**
```
For each record:
    region = fields[0]
    emit (region, 1)

For each region group:
    sum the counts
    emit (region, order_count)
```

**Mapper (region_mapper.py):**
```python
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
```

**Reducer (region_reducer.py):**
```python
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
```

---

### Task 3: Revenue Analysis

**Pseudo Code:**
```
For each record:
    parse order_date = fields[5]
    parse total_revenue = fields[11]
    emit (order_date, "revenue,1")

For each order_date group:
    sum total revenue, sum counts
    compute average
    emit (order_date, total_revenue, order_count, avg_revenue)
```

**Mapper (revenue_mapper.py):**
```python
#!/usr/bin/env python3
import sys

for line in sys.stdin:
    if line.startswith("Region,Country,Item Type"):
        continue

    fields = line.strip().split(',')
    if len(fields) < 12:
        continue

    order_date = fields[5]   # 6th column
    total_revenue_str = fields[11]  # 12th column

    try:
        total_revenue = float(total_revenue_str)
    except ValueError:
        continue

    # Emit (date, "revenue,1")
    print(f"{order_date}\t{total_revenue},1")
```

**Reducer (revenue_reducer.py):**
```python
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
```

---

### Task 4: Product Performance Evaluation

**Pseudo Code:**
```
For each record:
    item_type = fields[2]
    total_revenue = fields[11]
    emit (item_type, "revenue,1")

For each item_type group:
    sum total_revenue, sum counts
    compute average
    emit (item_type, total_revenue, order_count, avg_revenue)
```

**Mapper (product_mapper.py):**
```python
#!/usr/bin/env python3
import sys

for line in sys.stdin:
    if line.startswith("Region,Country,Item Type"):
        continue

    fields = line.strip().split(',')
    if len(fields) < 12:
        continue

    item_type = fields[2]      # 3rd column
    total_revenue_str = fields[11]  # 12th column

    try:
        total_revenue = float(total_revenue_str)
    except ValueError:
        continue

    print(f"{item_type}\t{total_revenue},1")
```

**Reducer (product_reducer.py):**
```python
#!/usr/bin/env python3
import sys

current_item = None
sum_revenue = 0.0
order_count = 0

for line in sys.stdin:
    item_type, value = line.strip().split('\t')
    revenue_str, count_str = value.split(',')
    revenue_val = float(revenue_str)
    count_val = int(count_str)

    if current_item == item_type:
        sum_revenue += revenue_val
        order_count += count_val
    else:
        if current_item is not None and order_count > 0:
            avg_revenue = sum_revenue / order_count
            print(f"{current_item}\tTotal_Revenue: {sum_revenue:.2f}\tOrders: {order_count}\tAvg_Revenue: {avg_revenue:.2f}")

        current_item = item_type
        sum_revenue = revenue_val
        order_count = count_val

# Last item type
if current_item is not None and order_count > 0:
    avg_revenue = sum_revenue / order_count
    print(f"{current_item}\tTotal_Revenue: {sum_revenue:.2f}\tOrders: {order_count}\tAvg_Revenue: {avg_revenue:.2f}")
```

---

### Task 5: Country Segmentation Analysis

**Pseudo Code:**
```
For each record:
    country = fields[1]
    total_revenue = fields[11]
    emit (country, "revenue,1")

For each country group:
    sum total_revenue, sum counts
    compute average
    emit (country, total_orders, total_revenue, avg_revenue)
```

**Mapper (country_mapper.py):**
```python
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
```

**Reducer (country_reducer.py):**
```python
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
```

---

## 5. Execution & Final Deliverables

### Running the Jobs

1. **Upload CSV to HDFS** (example paths):
   ```bash
   hadoop fs -mkdir -p /user/centos/sales_input
   hadoop fs -put /local/path/50000\ Sales\ Records.csv /user/centos/sales_input/
   ```

2. **Set Executable Permissions** on mapper/reducer files:
   ```bash
   chmod +x temporal_mapper.py temporal_reducer.py
   chmod +x region_mapper.py region_reducer.py
   chmod +x revenue_mapper.py revenue_reducer.py
   chmod +x product_mapper.py product_reducer.py
   chmod +x country_mapper.py country_reducer.py
   ```

3. **Run Hadoop Streaming** (example for Task 1: Temporal Sales Analysis):
   ```bash
   hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
     -input /user/centos/sales_input/50000\ Sales\ Records.csv \
     -output /user/centos/sales_output/task1_temporal \
     -mapper temporal_mapper.py \
     -reducer temporal_reducer.py \
     -file temporal_mapper.py \
     -file temporal_reducer.py
   ```

   Repeat similarly for **Tasks 2–5**, using the appropriate mapper/reducer scripts and unique output directories.

### Gathering Execution Statistics

For each Map‑Reduce job, document:
- **Number of Map & Reduce Tasks** (from job logs or Hadoop UI)
- **Memory Consumption per Task**
- **Data Shuffle Volume** (bytes transferred)
- **Execution Time** (start-to-finish)

### Final PDF Deliverables

1. **Problem Statement & Analysis Tasks**  
2. **Dataset & Source Information** (including the column layout of “50000 Sales Records.csv”)  
3. **Map‑Reduce Diagrams** for each of the five tasks  
4. **Pseudo Code & Functional Code** for all mapper and reducer scripts  
5. **Execution Statistics** in a summary table

---

## Conclusion

By following this **action plan** and using the **sample mapper/reducer scripts** above, you will be able to:

1. **Analyze temporal sales trends** (Task 1)  
2. **Identify top-performing regions** by order count (Task 2)  
3. **Aggregate daily revenue** and compute average sales per day (Task 3)  
4. **Evaluate product performance** based on total revenue (Task 4)  
5. **Segment countries** by total orders and average revenue (Task 5)

Adjust any **file paths** or **column indices** as needed to match your environment and the exact structure of the CSV.
