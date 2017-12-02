USER = Hao
EXAMPLE_DIR = /user/$(USER)/lrs/
INPUT_DIR   = $(EXAMPLE_DIR)/input
INPUT2_DIR = $(EXAMPLE_DIR)/input2
OUTPUT_DIR  = $(EXAMPLE_DIR)/output
OUTPUT_FILE = $(OUTPUT_DIR)/part-00000
HADOOP_VERSION = 2.8.1

TOOLLIBS_DIR="/usr/local/Cellar/hadoop/2.8.1/libexec/share/hadoop/tools/lib"

run: inputs
	-hdfs dfs -rm -f -r $(OUTPUT_DIR)
	hadoop jar $(TOOLLIBS_DIR)/hadoop-streaming-$(HADOOP_VERSION).jar \
		-files ./map1.py,./reduce1.py \
		-mapper ./map1.py \
		-reducer ./reduce1.py \
		-input $(INPUT_DIR) \
		-output  $(OUTPUT_DIR) 
	hdfs dfs -cat $(OUTPUT_FILE) > input2/sorted_suffixes
	#cat sorted_suffixes
	hdfs dfs -rm -f -r $(OUTPUT_DIR)

	hdfs dfs -put input2/sorted_suffixes $(INPUT2_DIR)/sorted_suffixes

	hadoop jar $(TOOLLIBS_DIR)/hadoop-streaming-$(HADOOP_VERSION).jar \
		-D mapred.reduce.tasks=4 \
		-files ./map2.py,./reduce2.py \
		-mapper ./map2.py \
	    -reducer ./reduce2.py \
	    -input $(INPUT2_DIR) \
		-output  $(OUTPUT_DIR) 

	hdfs dfs -rm -f -r $(INPUT2_DIR)
	# hdfs dfs -cat $(OUTPUT_FILE) | sort -n > hist
	# cat hist

directories:
	hdfs dfs -test -e $(EXAMPLE_DIR) || hdfs dfs -mkdir $(EXAMPLE_DIR)
	hdfs dfs -test -e $(INPUT_DIR) || hdfs dfs -mkdir $(INPUT_DIR)
	hdfs dfs -test -e $(INPUT2_DIR) || hdfs dfs -mkdir $(INPUT2_DIR)
	hdfs dfs -test -e $(OUTPUT_DIR) || hdfs dfs -mkdir $(OUTPUT_DIR)

inputs: directories input/string
	hdfs dfs -test -e $(INPUT_DIR)/string \
	  || hdfs dfs -put input/string $(INPUT_DIR)/string

clean:
	-hdfs dfs -rm -f -r $(INPUT_DIR)
	-hdfs dfs -rm -f -r $(INPUT2_DIR)
	-hdfs dfs -rm -f -r $(OUTPUT_DIR)
	-hdfs dfs -rm -f -r $(EXAMPLE_DIR)

.PHONY: directories inputs clean run 