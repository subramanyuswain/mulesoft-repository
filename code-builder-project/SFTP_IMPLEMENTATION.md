# Kafka to SFTP Implementation

## Overview
This implementation adds SFTP functionality to the existing Kafka-PostgreSQL integration project. The application now consumes Kafka messages, stores them in PostgreSQL database, and also writes them to SFTP files in CSV format.

## Features Added

### 1. SFTP Connector Integration
- Added SFTP connector dependency in `pom.xml`
- Configured SFTP connection in `global.xml`
- Added SFTP configuration properties in `config.properties`

### 2. SFTP Flow Implementation
- **Flow Name**: `write-kafka-to-sftp-flow`
- **Purpose**: Transforms Kafka records to CSV format and writes to SFTP server
- **File Format**: CSV with headers
- **File Naming**: `kafka_records_YYYYMMDD_HHMMSS.csv`

### 3. Data Transformation
The Kafka records are transformed to CSV format with the following columns:
- ID (UUID)
- Kafka_Offset
- Kafka_Partition
- Kafka_Topic
- Message_Data
- Processed_Timestamp
- Message_Key

### 4. Configuration Properties
Added the following SFTP configuration properties:
```properties
# SFTP Configuration
sftp.host=localhost
sftp.port=22
sftp.username=sftpuser
sftp.password=sftppassword
sftp.working.directory=/uploads
sftp.file.name.prefix=kafka_records_
sftp.file.extension=.csv
```

## Flow Architecture

### Main Processing Flow
1. **Kafka Consumer** → Consumes messages from Kafka topic
2. **Batch Processing** → Processes messages when batch size is reached
3. **Data Transformation** → Transforms messages to structured format
4. **Database Insert** → Stores records in PostgreSQL
5. **SFTP Write** → Writes records to SFTP as CSV file
6. **Offset Management** → Updates processed offset in object store
7. **Kafka Commit** → Commits Kafka offset

### SFTP Flow Details
1. **Input**: Transformed Kafka records (Java objects)
2. **CSV Transformation**: Converts records to CSV format with headers
3. **Filename Generation**: Creates unique filename with timestamp
4. **SFTP Write**: Uploads CSV file to SFTP server
5. **Error Handling**: Comprehensive error handling with logging

## Error Handling
- Each flow has dedicated error handlers
- Errors are logged with detailed information
- Failed operations trigger error notification flow
- SFTP write errors are handled separately to prevent data loss

## File Structure
```
code-builder-project/
├── src/main/mule/
│   ├── code-builder-project.xml (Main flows with SFTP integration)
│   └── global.xml (Configurations including SFTP)
├── src/main/resources/
│   └── config.properties (Updated with SFTP properties)
└── pom.xml (Updated with SFTP connector dependency)
```

## Usage
1. Configure SFTP server details in `config.properties`
2. Ensure SFTP server is accessible and credentials are correct
3. Start the Mule application
4. Send messages to the configured Kafka topic
5. Monitor logs for processing status
6. Check SFTP server for generated CSV files

## Dependencies Added
- `mule-sftp-connector` version 2.0.0

## Benefits
- **Dual Storage**: Data is stored both in database and SFTP files
- **CSV Format**: Easy to read and process by external systems
- **Timestamped Files**: Unique filenames prevent overwrites
- **Error Resilience**: Robust error handling ensures data integrity
- **Configurable**: All SFTP settings are externalized in properties file

## Monitoring
- All operations are logged with appropriate log levels
- File creation and upload status are tracked
- Error conditions are logged with detailed error messages
- Processing metrics are available through application logs
