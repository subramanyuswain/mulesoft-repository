-- PostgreSQL Database Setup Script for Kafka-PostgreSQL Integration
-- This script creates the required database and table structure

-- Create database (run this as a superuser)
-- CREATE DATABASE usspoke_db;

-- Connect to the database and create the table
-- \c usspoke_db;

-- Create the main data table
CREATE TABLE IF NOT EXISTS usspoke_data_table (
    id VARCHAR(255) PRIMARY KEY,
    kafka_offset BIGINT NOT NULL,
    kafka_partition INTEGER NOT NULL,
    kafka_topic VARCHAR(255) NOT NULL,
    message_data TEXT,
    processed_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    message_key VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_kafka_offset ON usspoke_data_table(kafka_offset);
CREATE INDEX IF NOT EXISTS idx_kafka_partition ON usspoke_data_table(kafka_partition);
CREATE INDEX IF NOT EXISTS idx_kafka_topic ON usspoke_data_table(kafka_topic);
CREATE INDEX IF NOT EXISTS idx_processed_timestamp ON usspoke_data_table(processed_timestamp);
CREATE INDEX IF NOT EXISTS idx_message_key ON usspoke_data_table(message_key);

-- Create a composite index for offset and partition
CREATE INDEX IF NOT EXISTS idx_kafka_offset_partition ON usspoke_data_table(kafka_topic, kafka_partition, kafka_offset);

-- Add comments to the table and columns
COMMENT ON TABLE usspoke_data_table IS 'Table to store Kafka messages from usspoke-dualparty-data topic';
COMMENT ON COLUMN usspoke_data_table.id IS 'Unique identifier for each record (UUID)';
COMMENT ON COLUMN usspoke_data_table.kafka_offset IS 'Kafka message offset';
COMMENT ON COLUMN usspoke_data_table.kafka_partition IS 'Kafka partition number';
COMMENT ON COLUMN usspoke_data_table.kafka_topic IS 'Kafka topic name';
COMMENT ON COLUMN usspoke_data_table.message_data IS 'Actual message payload from Kafka';
COMMENT ON COLUMN usspoke_data_table.processed_timestamp IS 'Timestamp when the message was processed';
COMMENT ON COLUMN usspoke_data_table.message_key IS 'Kafka message key';
COMMENT ON COLUMN usspoke_data_table.created_at IS 'Record creation timestamp';
COMMENT ON COLUMN usspoke_data_table.updated_at IS 'Record last update timestamp';

-- Create a trigger to automatically update the updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_usspoke_data_table_updated_at 
    BEFORE UPDATE ON usspoke_data_table 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Create a view for monitoring purposes
CREATE OR REPLACE VIEW kafka_processing_stats AS
SELECT 
    kafka_topic,
    kafka_partition,
    COUNT(*) as message_count,
    MIN(kafka_offset) as min_offset,
    MAX(kafka_offset) as max_offset,
    MIN(processed_timestamp) as first_processed,
    MAX(processed_timestamp) as last_processed
FROM usspoke_data_table
GROUP BY kafka_topic, kafka_partition
ORDER BY kafka_topic, kafka_partition;

COMMENT ON VIEW kafka_processing_stats IS 'View to monitor Kafka message processing statistics';

-- Grant permissions (adjust as needed for your environment)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON usspoke_data_table TO your_application_user;
-- GRANT SELECT ON kafka_processing_stats TO your_application_user;

-- Sample queries for monitoring and troubleshooting:

-- Check latest processed messages
-- SELECT * FROM usspoke_data_table ORDER BY processed_timestamp DESC LIMIT 10;

-- Check processing statistics
-- SELECT * FROM kafka_processing_stats;

-- Find gaps in offset processing (useful for debugging)
-- SELECT 
--     kafka_offset + 1 as gap_start,
--     next_offset - 1 as gap_end
-- FROM (
--     SELECT 
--         kafka_offset,
--         LEAD(kafka_offset) OVER (ORDER BY kafka_offset) as next_offset
--     FROM usspoke_data_table
--     WHERE kafka_topic = 'usspoke-dualparty-data' AND kafka_partition = 0
-- ) t
-- WHERE next_offset > kafka_offset + 1;

-- Check duplicate messages (should be empty if everything works correctly)
-- SELECT kafka_offset, kafka_partition, COUNT(*) 
-- FROM usspoke_data_table 
-- GROUP BY kafka_offset, kafka_partition 
-- HAVING COUNT(*) > 1;
