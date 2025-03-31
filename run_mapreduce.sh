#!/bin/bash

# Set environment variables (modify paths as necessary)
HDFS_INPUT_DIR="/home/centos/input"
HDFS_OUTPUT_DIR="/home/centos/output"
LOCAL_INPUT_FILE="50000_Sales_Records.csv"
MAPPER_SCRIPT="country_mapper.py"
REDUCER_SCRIPT="country_reducer.py"

# Start Hadoop Services (Only if necessary)
echo "====== Starting Hadoop Services ======"
sudo systemctl start hadoop.service  # Modify as per your setup

# Ensure HDFS is running
hdfs dfsadmin -safemode leave

# Check if the input directory exists, create if not
hdfs dfs -test -d "$HDFS_INPUT_DIR"
if [ $? -ne 0 ]; then
    echo "Creating HDFS input directory: $HDFS_INPUT_DIR"
    hdfs dfs -mkdir -p "$HDFS_INPUT_DIR"
fi

# Upload input file if not already in HDFS
hdfs dfs -test -e "$HDFS_INPUT_DIR/shakespeare.txt"
if [ $? -ne 0 ]; then
    echo "Uploading input file to HDFS..."
    hdfs dfs -put "$LOCAL_INPUT_FILE" "$HDFS_INPUT_DIR/"
fi

# Ensure the output directory does not exist (delete if it does)
hdfs dfs -test -d "$HDFS_OUTPUT_DIR"
if [ $? -eq 0 ]; then
    echo "Removing previous output directory..."
    hdfs dfs -rm -r "$HDFS_OUTPUT_DIR"
fi

# Run the Hadoop Streaming MapReduce Job
echo "====== Running Hadoop MapReduce Job ======"
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -files "$MAPPER_SCRIPT","$REDUCER_SCRIPT" \
    -mapper "python3 $MAPPER_SCRIPT" \
    -reducer "python3 $REDUCER_SCRIPT" \
    -input "$HDFS_INPUT_DIR/50000_Sales_Records.csv" \
    -output "$HDFS_OUTPUT_DIR"

# Check if the job completed successfully
if [ $? -eq 0 ]; then
    echo "====== Job Completed Successfully! ======"
    echo "====== Output Preview ======"
    hdfs dfs -cat "$HDFS_OUTPUT_DIR/part-00000" | head -20
else
    echo "====== Job Failed. Check Hadoop Logs. ======"
fi
