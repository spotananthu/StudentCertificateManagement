# **README – Apache Kafka 3.6.0 Setup & Basic Commands (KRaft Mode)**

This guide explains how to download, configure, start, and use Apache Kafka **3.6.0 in KRaft mode** (no ZooKeeper).
Includes topic creation, listing, and basic CLI operations.

---

# **Prerequisites**

* macOS or Linux Terminal
* Java 11+ installed
* Apache Kafka 3.6.0 (Scala 2.12)

---

# **Step 1: Download & Navigate to Kafka Directory**

Download Kafka 3.6.0 from:
👉 [https://kafka.apache.org/downloads](https://kafka.apache.org/downloads)

Extract it, then open a terminal and run:

```bash
cd /Users/<your_user>/Downloads/kafka_2.12-3.6.0
cd bin
```

---

# **Step 2: Generate Kafka Cluster ID**

Kafka KRaft mode requires a cluster ID before the server starts.

```bash
CLUSTER_ID=$(./kafka-storage.sh random-uuid)
echo $CLUSTER_ID
```

Example output:

```
nDWy1cdUS7qK5Z2rB0XY7Q
```

---

# **Step 3: Format Kafka Storage (Required for First Run)**

```bash
./kafka-storage.sh format -t $CLUSTER_ID -c ../config/kraft/server.properties
```
Expected output:

```
Formatting /tmp/kraft-combined-logs
```

---

# **Step 4: Start Kafka Server (KRaft Mode)**

```bash
./kafka-server-start.sh ../config/kraft/server.properties
```

Kafka will now start and run without ZooKeeper.

---

# **Step 5: Create a Kafka Topic**

Run this from the `bin` directory (or use the full path):

```bash
./kafka-topics.sh --create \
  --topic email_notifications \
  --bootstrap-server localhost:9092
```

---

# **Step 6: List All Kafka Topics**

```bash
./kafka-topics.sh --list --bootstrap-server localhost:9092
```

---

# **Notes**

* All scripts must be run inside the Kafka `bin` folder or with a full path.
* Ensure Kafka is running before executing topic commands.
* KRaft mode does not require ZooKeeper.

---
