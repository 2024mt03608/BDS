Below is a step‑by‑step guide with exact commands to execute the Map‑Reduce analysis for your "50000 Sales Records.csv" file in a Nuvepro lab environment.

---

### **Step 1: Log into Nuvepro and Open a Terminal**

1. Open your web browser and log into your Nuvepro account.
2. Launch your lab workspace (virtual machine) that has Hadoop installed.
3. Open a terminal window in your Nuvepro lab.

---

### **Step 2: Upload the CSV File to HDFS**

Assume your CSV file is already on your Nuvepro VM at a known local path (e.g., `/home/centos/50000 Sales Records.csv`).

1. Create an input directory in HDFS:
   ```bash
   hdfs dfs -mkdir -p /user/centos/sales_input
   ```
2. Upload the CSV file to HDFS:
   ```bash
   hdfs dfs -put "/home/centos/50000 Sales Records.csv" /user/centos/sales_input/
   ```

---

### **Step 3: Clone Your GitHub Repository Containing the Map‑Reduce Scripts**

1. Navigate to your workspace directory:
   ```bash
   cd /home/centos
   ```
2. Clone the repository:
   ```bash
   git clone https://github.com/nbinwal/BDS.git
   ```
3. Change into the repository directory:
   ```bash
   cd BDS
   ```

---

### **Step 4: Set Execute Permissions on All Python Scripts**

Make sure all mapper and reducer scripts are executable:
```bash
chmod +x *.py
```

---

### **Step 5: Run Each Map‑Reduce Task Using Hadoop Streaming**

Below are example commands for each task. (Replace `/usr/lib/hadoop-mapreduce/hadoop-streaming.jar` with your actual Hadoop streaming JAR path if different.)

#### **Task 1: Temporal Sales Analysis**

1. Run the Temporal Sales Analysis job:
   ```bash
   hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
     -input /user/centos/sales_input/50000\ Sales\ Records.csv \
     -output /user/centos/sales_output/temporal_sales_analysis \
     -mapper temporal_mapper.py \
     -reducer temporal_reducer.py \
     -file temporal_mapper.py \
     -file temporal_reducer.py
   ```

#### **Task 2: Region Sales Analysis**

2. Run the Region Sales Analysis job:
   ```bash
   hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
     -input /user/centos/sales_input/50000\ Sales\ Records.csv \
     -output /user/centos/sales_output/region_sales_analysis \
     -mapper region_mapper.py \
     -reducer region_reducer.py \
     -file region_mapper.py \
     -file region_reducer.py
   ```

#### **Task 3: Revenue Analysis**

3. Run the Revenue Analysis job:
   ```bash
   hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
     -input /user/centos/sales_input/50000\ Sales\ Records.csv \
     -output /user/centos/sales_output/revenue_analysis \
     -mapper revenue_mapper.py \
     -reducer revenue_reducer.py \
     -file revenue_mapper.py \
     -file revenue_reducer.py
   ```

#### **Task 4: Product Performance Evaluation**

4. Run the Product Performance Evaluation job:
   ```bash
   hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
     -input /user/centos/sales_input/50000\ Sales\ Records.csv \
     -output /user/centos/sales_output/product_performance \
     -mapper product_mapper.py \
     -reducer product_reducer.py \
     -file product_mapper.py \
     -file product_reducer.py
   ```

#### **Task 5: Country Segmentation Analysis**

5. Run the Country Segmentation Analysis job:
   ```bash
   hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
     -input /user/centos/sales_input/50000\ Sales\ Records.csv \
     -output /user/centos/sales_output/country_segmentation \
     -mapper country_mapper.py \
     -reducer country_reducer.py \
     -file country_mapper.py \
     -file country_reducer.py
   ```

---

### **Step 6: Verify the Output**

After each job completes, you can check the results stored in HDFS. For example, to view the output of the Temporal Sales Analysis job:
```bash
hdfs dfs -ls /user/centos/sales_output/temporal_sales_analysis
hdfs dfs -cat /user/centos/sales_output/temporal_sales_analysis/part-00000
```
Repeat similar commands for the output directories of the other tasks.

---

### **Step 7: Gather Execution Statistics**

Review the Hadoop job logs or use the ResourceManager web interface to record:
- Number of Map and Reduce tasks.
- Memory consumption per task.
- Data shuffled (bytes transferred).
- Job execution time.

Document these details for your final submission.

---

### **Final Deliverables**

Prepare a final PDF that includes:
1. **Problem Statement & Objectives** (as described above).
2. **Dataset Details & Column Layout**.
3. **Map‑Reduce Flow Diagrams** for each task.
4. **Pseudo Code & Functional Python Scripts** (provided above).
5. **Execution Statistics Summary**.

By following these exact steps in your Nuvepro lab environment, you can run the complete Map‑Reduce analysis on your sales dataset.
