#!/bin/sh

# Define HDFS directories
HDFS_INPUT_DIR="/home/centos/input"
HDFS_OUTPUT_DIR="/home/centos/output"
LOCAL_INPUT_FILE="50000_Sales_Records.csv"

# Ensure Hadoop services are running
echo "====== Starting Hadoop Services ======"
sudo systemctl start hadoop.service 2>/dev/null || echo "Skipping systemctl (not applicable). Starting manually..."
start-dfs.sh
start-yarn.sh

# Exit Safe Mode if enabled
hdfs dfsadmin -safemode leave

# Ensure the input directory exists in HDFS
echo "====== Setting up HDFS Directories ======"
hdfs dfs -mkdir -p "$HDFS_INPUT_DIR"

# Upload the dataset if not already present
if ! hdfs dfs -test -e "$HDFS_INPUT_DIR/$(basename $LOCAL_INPUT_FILE)"; then
    echo "Uploading input file to HDFS..."
    hdfs dfs -put "$LOCAL_INPUT_FILE" "$HDFS_INPUT_DIR/"
else
    echo "Input file already exists in HDFS. Skipping upload."
fi

# Ensure the output directory is removed before the job runs
if hdfs dfs -test -d "$HDFS_OUTPUT_DIR"; then
    echo "Output directory already exists. Removing..."
    hdfs dfs -rm -r "$HDFS_OUTPUT_DIR"
fi

# Run Hadoop Streaming Job
echo "====== Running MapReduce Job ======"
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -files $(pwd)/country_mapper.py,$(pwd)/country_reducer.py \
    -mapper "country_mapper.py" \
    -reducer "country_reducer.py" \
    -input "$HDFS_INPUT_DIR/$(basename $LOCAL_INPUT_FILE)" \
    -output "$HDFS_OUTPUT_DIR"

echo "====== MapReduce Job Completed ======"

# Display results
echo "====== Output Preview ======"
hdfs dfs -cat "$HDFS_OUTPUT_DIR/part-00000" | head -20


