# Kafka to PostgreSQL Integration - MuleSoft Application

This MuleSoft application provides a robust integration solution that consumes messages from a Kafka topic and stores them in a PostgreSQL database with batch processing, offset management, and comprehensive error handling.

## Overview

The application listens to the Kafka topic `usspoke-dualparty-data` and processes messages in batches of 100. It maintains offset tracking using a persistent object store to ensure exactly-once processing and includes comprehensive error handling and monitoring capabilities.

## Features

- **Batch Processing**: Processes messages when batch size reaches 100
- **Offset Management**: Tracks and persists Kafka offsets using Object Store
- **Manual Commit**: Uses manual commit strategy for better control
- **Error Handling**: Comprehensive error handling with retry mechanisms
- **Data Transformation**: Transforms Kafka messages to database-compatible format
- **Monitoring**: Extensive logging and monitoring capabilities
- **Unit Testing**: Complete MUnit test suite with 9 test cases

## Architecture

### Flow Structure

1. **kafka-consumer-flow**: Main entry point that consumes Kafka messages
2. **process-kafka-messages-flow**: Orchestrates the message processing workflow
3. **insert-database-flow**: Handles database insertion operations
4. **get-last-offset-flow**: Retrieves last processed offset from object store
5. **update-offset-flow**: Updates the last processed offset in object store
6. **error-notification-flow**: Centralized error handling and notification

### Key Components

- **Kafka Consumer**: Configured with manual commit strategy
- **PostgreSQL Database**: Stores processed messages with metadata
- **Persistent Object Store**: Maintains offset tracking
- **DataWeave Transformations**: Message format conversion
- **Error Handlers**: Multi-level error handling strategy

## Prerequisites

- MuleSoft Runtime 4.4.0 or higher
- Apache Kafka cluster
- PostgreSQL database
- Java 8 or higher
- Maven 3.6 or higher

## Configuration

### Database Setup

1. Create the PostgreSQL database:
```sql
CREATE DATABASE usspoke_db;
```

2. Run the database setup script:
```bash
psql -U postgres -d usspoke_db -f src/main/resources/database-setup.sql
```

### Application Configuration

Update the `src/main/resources/config.properties` file with your environment-specific values:

```properties
# Kafka Configuration
kafka.bootstrap.servers=your-kafka-server:9092
kafka.topic.name=usspoke-dualparty-data
kafka.consumer.group.id=usspoke-consumer-group
kafka.batch.size=100

# PostgreSQL Database Configuration
db.host=your-db-host
db.port=5432
db.database=usspoke_db
db.username=your-username
db.password=your-password
db.table.name=usspoke-data-table

# Object Store Configuration
objectstore.persistent=true
objectstore.offset.key=kafka_last_offset
```

## Installation and Deployment

### Local Development

1. Clone the repository
2. Update configuration properties
3. Build the application:
```bash
mvn clean package
```

4. Deploy to local Mule runtime:
```bash
mvn mule:deploy
```

### CloudHub Deployment

1. Build the application:
```bash
mvn clean package
```

2. Deploy using Anypoint CLI or Anypoint Studio

## Database Schema

The application creates the following table structure:

```sql
CREATE TABLE usspoke_data_table (
    id VARCHAR(255) PRIMARY KEY,
    kafka_offset BIGINT NOT NULL,
    kafka_partition INTEGER NOT NULL,
    kafka_topic VARCHAR(255) NOT NULL,
    message_data TEXT,
    processed_timestamp TIMESTAMP NOT NULL,
    message_key VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Message Processing Flow

1. **Message Consumption**: Kafka consumer receives messages from the topic
2. **Batch Size Check**: Verifies if batch size (100) is reached
3. **Offset Retrieval**: Gets last processed offset from object store
4. **Data Transformation**: Converts Kafka messages to database format
5. **Database Insertion**: Bulk inserts messages into PostgreSQL
6. **Offset Update**: Updates last processed offset in object store
7. **Commit**: Commits Kafka offset to mark messages as processed

## Error Handling Strategy

### Error Types Handled

- **Kafka Connection Errors**: Automatic retry with exponential backoff
- **Database Connection Errors**: Connection pooling and retry mechanisms
- **Data Transformation Errors**: Validation and error logging
- **Object Store Errors**: Fallback to default offset values

### Error Recovery

- Failed messages are logged with full context
- Offset tracking prevents message loss
- Manual commit ensures no data duplication
- Comprehensive error notifications for monitoring

## Monitoring and Logging

### Key Metrics Tracked

- Messages processed per batch
- Processing timestamps
- Offset progression
- Error rates and types
- Database insertion statistics

### Log Levels

- **INFO**: Normal processing flow
- **WARN**: Non-critical issues (e.g., offset retrieval failures)
- **ERROR**: Critical errors requiring attention

### Monitoring Queries

Check processing statistics:
```sql
SELECT * FROM kafka_processing_stats;
```

Find latest processed messages:
```sql
SELECT * FROM usspoke_data_table ORDER BY processed_timestamp DESC LIMIT 10;
```

## Testing

### Running MUnit Tests

Execute the complete test suite:
```bash
mvn test
```

### Test Coverage

The application includes 9 comprehensive test cases:

1. **Batch Size Reached**: Tests processing when batch size is met
2. **Batch Size Not Reached**: Verifies no processing when batch is incomplete
3. **Process Messages Flow**: Tests the complete processing workflow
4. **Database Insertion**: Validates database operations
5. **Offset Retrieval**: Tests offset management
6. **Offset Update**: Verifies offset persistence
7. **Error Notification**: Tests error handling flows
8. **Data Transformation**: Validates message transformation
9. **Error Handling**: Tests error recovery mechanisms

## Performance Considerations

### Optimization Settings

- **Batch Size**: Configured for optimal throughput (100 messages)
- **Connection Pooling**: Database connections are pooled
- **Bulk Inserts**: Uses bulk insert for better performance
- **Indexing**: Database indexes on key columns for fast queries

### Scaling Recommendations

- **Horizontal Scaling**: Deploy multiple instances with different consumer groups
- **Partition Strategy**: Ensure proper Kafka topic partitioning
- **Database Optimization**: Monitor and optimize database performance
- **Memory Management**: Configure appropriate heap sizes

## Troubleshooting

### Common Issues

1. **Kafka Connection Issues**
   - Verify bootstrap servers configuration
   - Check network connectivity
   - Validate consumer group settings

2. **Database Connection Issues**
   - Verify database credentials
   - Check database server availability
   - Validate connection string format

3. **Offset Management Issues**
   - Check object store configuration
   - Verify persistent storage settings
   - Monitor offset progression

### Debug Mode

Enable debug logging by updating log4j2.xml:
```xml
<Logger name="com.mycompany" level="DEBUG"/>
```

## Security Considerations

- **Database Credentials**: Use encrypted properties or secure vaults
- **Kafka Security**: Configure SSL/SASL authentication as needed
- **Network Security**: Ensure secure network connections
- **Access Control**: Implement proper database access controls

## Maintenance

### Regular Tasks

- Monitor offset progression
- Check error logs regularly
- Validate database performance
- Review processing statistics

### Backup Strategy

- Regular database backups
- Object store backup for offset data
- Configuration backup

## Support and Documentation

For additional support:
- Check MuleSoft documentation
- Review application logs
- Monitor database performance metrics
- Use provided monitoring queries

## Version History

- **v1.0.0**: Initial release with basic Kafka to PostgreSQL integration
- Features: Batch processing, offset management, error handling, MUnit tests

## License

This project is licensed under the MIT License - see the LICENSE file for details.
