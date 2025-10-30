-- Database Setup Script for File Reader Process
-- This script creates the necessary table structure for storing file content

-- Create the text_table to store processed file information
CREATE TABLE IF NOT EXISTS text_table (
    record_id VARCHAR(255) PRIMARY KEY,
    file_name VARCHAR(500) NOT NULL,
    content CLOB,
    processed_at TIMESTAMP NOT NULL,
    file_size INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_file_name (file_name),
    INDEX idx_processed_at (processed_at)
);

-- Create a sequence for generating unique IDs (if needed for other databases)
-- CREATE SEQUENCE text_table_seq START WITH 1 INCREMENT BY 1;

-- Insert sample data for testing (optional)
INSERT INTO text_table (record_id, file_name, content, processed_at, file_size) VALUES 
('sample-001', 'sample-file.txt', 'This is sample content for testing purposes.', CURRENT_TIMESTAMP, 45);

-- Create an audit table to track processing history
CREATE TABLE IF NOT EXISTS file_processing_audit (
    audit_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(500) NOT NULL,
    processing_status VARCHAR(50) NOT NULL, -- SUCCESS, ERROR, SKIPPED
    error_message TEXT,
    processing_start_time TIMESTAMP,
    processing_end_time TIMESTAMP,
    file_size INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_audit_file_name ON file_processing_audit (file_name);
CREATE INDEX IF NOT EXISTS idx_audit_status ON file_processing_audit (processing_status);
CREATE INDEX IF NOT EXISTS idx_audit_date ON file_processing_audit (created_date);

-- View to get processing statistics
CREATE VIEW IF NOT EXISTS processing_stats AS
SELECT 
    DATE(created_date) as processing_date,
    processing_status,
    COUNT(*) as file_count,
    AVG(file_size) as avg_file_size,
    SUM(file_size) as total_file_size
FROM file_processing_audit 
GROUP BY DATE(created_date), processing_status
ORDER BY processing_date DESC;

-- View to get recent processing activity
CREATE VIEW IF NOT EXISTS recent_activity AS
SELECT 
    file_name,
    processing_status,
    error_message,
    processing_start_time,
    processing_end_time,
    TIMESTAMPDIFF(SECOND, processing_start_time, processing_end_time) as processing_duration_seconds
FROM file_processing_audit 
ORDER BY created_date DESC 
LIMIT 100;

-- Comments for documentation
COMMENT ON TABLE text_table IS 'Main table storing processed file content and metadata';
COMMENT ON COLUMN text_table.record_id IS 'Unique identifier for each processed file record';
COMMENT ON COLUMN text_table.file_name IS 'Original name of the processed file';
COMMENT ON COLUMN text_table.content IS 'Full text content of the processed file';
COMMENT ON COLUMN text_table.processed_at IS 'Timestamp when the file was processed';
COMMENT ON COLUMN text_table.file_size IS 'Size of the file content in characters';

COMMENT ON TABLE file_processing_audit IS 'Audit trail for all file processing attempts';
COMMENT ON COLUMN file_processing_audit.processing_status IS 'Status of processing: SUCCESS, ERROR, or SKIPPED';
COMMENT ON COLUMN file_processing_audit.error_message IS 'Error details if processing failed';

-- Grant permissions (adjust as needed for your database)
-- GRANT SELECT, INSERT, UPDATE ON text_table TO mule_app_user;
-- GRANT SELECT, INSERT ON file_processing_audit TO mule_app_user;
-- GRANT SELECT ON processing_stats TO mule_app_user;
-- GRANT SELECT ON recent_activity TO mule_app_user;

-- Sample queries for monitoring and troubleshooting:

-- 1. Check recent processing activity
-- SELECT * FROM recent_activity;

-- 2. Get processing statistics for today
-- SELECT * FROM processing_stats WHERE processing_date = CURRENT_DATE;

-- 3. Find files that failed processing
-- SELECT file_name, error_message, processing_start_time 
-- FROM file_processing_audit 
-- WHERE processing_status = 'ERROR' 
-- ORDER BY processing_start_time DESC;

-- 4. Get total files processed today
-- SELECT COUNT(*) as files_processed_today 
-- FROM text_table 
-- WHERE DATE(processed_at) = CURRENT_DATE;

-- 5. Find duplicate file processing attempts
-- SELECT file_name, COUNT(*) as processing_attempts 
-- FROM file_processing_audit 
-- GROUP BY file_name 
-- HAVING COUNT(*) > 1;

-- 6. Check database health
-- SELECT 1 as health_check;
