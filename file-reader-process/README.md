# File Reader Process - MuleSoft Application

## 🎯 What Does This App Do? (Explained Like You're 5!)

Imagine you have a magic robot that:
1. **Wakes up every 15 minutes** (like an alarm clock)
2. **Looks for text files** in a special folder (like looking for toys in a toy box)
3. **Reads what's inside each file** (like reading a story book)
4. **Remembers everything** by writing it down in a special notebook (database)
5. **Puts the file away** in a "finished" folder so it doesn't read it again

That's exactly what this app does! It's like having a very organized friend who never forgets to check for new files and always remembers what was in them.

## 🏗️ How It Works (The Magic Behind the Scenes)

### The Main Characters:

1. **The Scheduler** 🕐
   - This is like an alarm clock that rings every 15 minutes
   - When it rings, it tells the app "Time to check for files!"

2. **The File Reader** 📖
   - This looks in the input folder for any `.txt` files
   - It opens each file and reads everything inside
   - Like a librarian who reads every book that comes in

3. **The Data Transformer** 🔄
   - Takes the file content and organizes it nicely
   - Adds extra information like:
     - When it was processed
     - How big the file was
     - A unique ID (like a barcode)

4. **The Database Writer** 💾
   - Saves all the information to a database table called `text_table`
   - Like writing in a permanent diary that never gets lost

5. **The File Organizer** 📁
   - Moves processed files to a "processed" folder
   - So we don't read the same file twice

## 🔐 Security Features

### Password Protection
- All database passwords are **encrypted** (scrambled like a secret code)
- Even if someone finds the password file, they can't read it without the special key
- It's like having a treasure chest with a combination lock!

### How Encryption Works:
1. Your real password gets scrambled using a secret key
2. Only the app knows how to unscramble it
3. The scrambled version is stored in `secure.properties`
4. The secret key is in `config.properties` (change this in production!)

## 📊 Database Table Structure

The app creates a table called `text_table` with these columns:

| Column Name | What It Stores | Example |
|-------------|----------------|---------|
| record_id | Unique ID for each record | "abc-123-def-456" |
| file_name | Name of the processed file | "my-document.txt" |
| content | The actual text from the file | "Hello, this is my file content" |
| processed_at | When it was processed | "2024-01-15 10:30:00" |
| file_size | Size of the content in characters | 150 |

## 🗂️ Folder Structure

```
📁 Your Computer
├── 📁 C:/temp/input/          ← Put your .txt files here
├── 📁 C:/temp/processed/      ← Processed files go here
└── 📁 C:/temp/                ← Working directory
```

## ⚙️ Configuration Files

### 1. `config.properties` - Main Settings
```properties
# Where to look for files
file.input.path=C:/temp/input

# Where to move processed files
file.processed.path=C:/temp/processed

# How often to check (15 minutes)
scheduler.frequency=15

# Database connection details
db.url=jdbc:h2:mem:testdb
db.username=sa
```

### 2. `secure.properties` - Secret Passwords
```properties
# Encrypted database password
db.password=![ENCRYPTED_VALUE_HERE]
```

## 🔄 The Complete Process Flow

```
⏰ Every 15 minutes
    ↓
📂 Check input folder for .txt files
    ↓
📖 Read each file's content
    ↓
🔄 Transform data (add timestamp, ID, etc.)
    ↓
💾 Save to database table
    ↓
📁 Move file to processed folder
    ↓
✅ Log success message
```

## 🧪 Testing (MUnit Tests)

The app includes automatic tests that check:

1. **Happy Path Test**: Everything works perfectly
   - Mocks (pretends) to find files
   - Mocks reading file content
   - Verifies database gets called
   - Confirms file gets moved

2. **Database Health Test**: Database connection works
   - Checks if database responds
   - Runs every hour automatically

3. **Error Handling Test**: What happens when things go wrong
   - Tests file not found scenarios
   - Verifies error messages are logged

## ?? How to Run the Application

### Prerequisites:
1. Java 17 installed
2. MuleSoft Anypoint Studio (optional, for development)
3. Create the required folders:
   ```
   C:/temp/input/
   C:/temp/processed/
   ```

### Steps:
1. **Build the project**:
   ```bash
   mvn clean package
   ```

2. **Run the application**:
   ```bash
   mvn mule:run
   ```

3. **Test it**:
   - Put a `.txt` file in `C:/temp/input/`
   - Wait up to 15 minutes
   - Check if file moved to `C:/temp/processed/`
   - Check database for the record

## 📝 Logs and Monitoring

The app logs everything it does:

- ✅ **INFO**: Normal operations (file found, processed, moved)
- ⚠️ **WARN**: Minor issues (empty files, etc.)
- ❌ **ERROR**: Problems (database down, file can't be read)

### Sample Log Messages:
```
INFO: Starting file processing at 2024-01-15T10:30:00
INFO: Processing file: my-document.txt
INFO: Data transformed for file: my-document.txt
INFO: Record inserted successfully for file: my-document.txt
INFO: File processing completed successfully
```

## 🛠️ Customization Options

### Change Processing Frequency:
In `config.properties`, modify:
```properties
scheduler.frequency=30  # Check every 30 minutes instead
```

### Support Different File Types:
In `config.properties`, modify:
```properties
supported.extensions=txt,log,csv  # Add more file types
```

### Change Database:
1. Update `config.properties` with new database URL
2. Add appropriate database driver to `pom.xml`
3. Update encrypted password in `secure.properties`

## 🔧 Troubleshooting

### Common Issues:

1. **Files not being processed**:
   - Check if folders exist: `C:/temp/input/` and `C:/temp/processed/`
   - Verify file extension is `.txt`
   - Check application logs for errors

2. **Database connection errors**:
   - Verify database is running
   - Check connection details in `config.properties`
   - Ensure password is correctly encrypted

3. **Permission errors**:
   - Make sure application has read/write access to folders
   - Run with appropriate user permissions

## 📈 Performance Considerations

- **File Size Limit**: Currently set to 10MB per file
- **Concurrent Processing**: Processes one file at a time (safe for database)
- **Memory Usage**: Loads entire file content into memory
- **Database Connections**: Uses connection pooling for efficiency

## 🔮 Future Enhancements

Possible improvements:
1. **Email Notifications**: Send alerts when processing fails
2. **File Archiving**: Compress old processed files
3. **Web Dashboard**: View processing statistics
4. **Multiple File Types**: Support PDF, Word documents
5. **Batch Processing**: Process multiple files simultaneously

## 📞 Support

If you need help:
1. Check the logs first
2. Verify configuration files
3. Test database connectivity
4. Review MUnit test results

---

**Remember**: This app is like having a reliable assistant that never sleeps and always remembers to check for new files every 15 minutes! 🤖✨
