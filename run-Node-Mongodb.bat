echo ===== Setting up Node.js Backend Mongodb =====
@echo off
:: Define the backend folder
set BACKEND_DIR=%~dp0backend

:: Define the Services and Routes directories
set SERVICES_DIR=%BACKEND_DIR%\Services
set ROUTES_DIR=%BACKEND_DIR%\Routes

:: Define file paths for mongodbService.js and apiRoutes.js and index.js
set SERVICE_FILE=%SERVICES_DIR%\mongodbService.js
set ROUTE_FILE=%ROUTES_DIR%\apiRoutes.js
set INDEX_FILE=%BACKEND_DIR%\index.js

:: Check if Node.js is installed
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js is not installed! Please download it here: https://nodejs.org/
    exit /b
)

:: Create the backend folder
if not exist "%BACKEND_DIR%" (
    mkdir "%BACKEND_DIR%"
    echo Backend folder created.
) else (
    echo Backend folder already exists.
)

:: Create the Services and Routes folders
if not exist "%SERVICES_DIR%" (
    mkdir "%SERVICES_DIR%"
    echo Services folder created.
) else (
    echo Services folder already exists.
)

if not exist "%ROUTES_DIR%" (
    mkdir "%ROUTES_DIR%"
    echo Routes folder created.
) else (
    echo Routes folder already exists.
)

:: Capture parameters
set "DB_URI=%~1"
set "DB_NAME=%~2"
set "USERNAME=%~3"
set "PASSWORD=%~4"
set "PORT=%~5"



:: Debugging: Print values to confirm they are correct 
echo DB URI: %DB_URI%
echo Database Name: %DB_NAME%
echo Username: %USERNAME%
echo Password: %PASSWORD%
echo port: %PORT%



:: Create package.json
echo Creating package.json...
echo { > "%BACKEND_DIR%\package.json"
echo   "name": "backend", >> "%BACKEND_DIR%\package.json"
echo   "version": "1.0.0", >> "%BACKEND_DIR%\package.json"
echo   "main": "index.js", >> "%BACKEND_DIR%\package.json"
echo   "type": "commonjs", >> "%BACKEND_DIR%\package.json"
echo   "scripts": { >> "%BACKEND_DIR%\package.json"
echo     "start": "node index.js" >> "%BACKEND_DIR%\package.json"
echo   }, >> "%BACKEND_DIR%\package.json"
echo   "dependencies": { >> "%BACKEND_DIR%\package.json"
echo     "express": "^4.18.2", >> "%BACKEND_DIR%\package.json"
echo     "mongodb": "^5.5.0" >> "%BACKEND_DIR%\package.json"
echo   } >> "%BACKEND_DIR%\package.json"
echo } >> "%BACKEND_DIR%\package.json"

::---------------------------------------------------------
:: Creating index.js

echo Creating index.js...
echo const apiRoutes = require('./Routes/apiRoutes'); >> "%INDEX_FILE%"
echo const express = require('express'); >> "%INDEX_FILE%"
echo var cors = require('cors'); >> "%INDEX_FILE%"

echo const app = express(); >> "%INDEX_FILE%"
echo var corsOptions = {  >> "%INDEX_FILE%"
echo     origin: 'http://localhost:4200',  // No trailing slash >> "%INDEX_FILE%"
echo     methods: ['GET', 'POST', 'PUT', 'DELETE'],  // Allow necessary HTTP methods >> "%INDEX_FILE%"
echo     allowedHeaders: ['Content-Type', 'Authorization']  // Allow necessary headers >> "%INDEX_FILE%"
echo }; >> "%INDEX_FILE%"

echo app.use(cors(corsOptions)); >> "%INDEX_FILE%"

echo app.use(cors());  >> "%INDEX_FILE%"
echo app.use(express.json()); // Pour gérer les requêtes JSON >> "%INDEX_FILE%"

echo // Use the API routes. >> "%INDEX_FILE%"
echo app.use('/api', apiRoutes); >>"%INDEX_FILE%"

echo //Démarrage du serveur  >> "%INDEX_FILE%"
echo const port = 3000; >> "%INDEX_FILE%"
echo app.listen(port, () =^> { >> "%INDEX_FILE%"
echo     console.log (`Server is running at http://localhost:${port}`);>> "%INDEX_FILE%"
echo }); >> "%INDEX_FILE%"




    
echo index.js created.

::----------------------------------------
::creating mongodbService File:
echo Creating mongodbService.js...
echo const express = require('express'); >>"%SERVICE_FILE%"
echo const router = express.Router();>>  "%SERVICE_FILE%"
echo const { MongoClient, ObjectId } = require('mongodb'); >>  "%SERVICE_FILE%"
echo const uri ='%DB_URI%'; >> "%SERVICE_FILE%"
echo const dbName ='%DB_NAME%'; >> "%SERVICE_FILE%"

echo // Asynchronous function that connects to MongoDB, retrieves data, and returns it.  >> "%APIFILE%"
echo async function fetchData() { >> "%SERVICE_FILE%"
echo     const client = new MongoClient(uri); >> "%SERVICE_FILE%"
echo     try { >> "%SERVICE_FILE%"
echo         await client.connect(); >> "%SERVICE_FILE%"
echo         console.log('Connected to MongoDB'); >> "%SERVICE_FILE%"
echo         const db = client.db(dbName); >> "%SERVICE_FILE%"
echo         const collections = await db.listCollections().toArray(); >> "%SERVICE_FILE%"

echo // loop through >> "%SERVICE_FILE%"
echo         let data = {}; >> "%SERVICE_FILE%"
echo         for (const collectionInfo of collections) { >> "%SERVICE_FILE%"
echo             const collectionName = collectionInfo.name; >> "%SERVICE_FILE%"
echo             const collection = db.collection(collectionName); >> "%SERVICE_FILE%"
echo             // Fetch all documents from the collection>> "%SERVICE_FILE%"
echo             const documents = await collection.find({}).toArray();>> ""%SERVICE_FILE%"
echo             //Store the documents in the data object>> "%SERVICE_FILE%"
echo             data[collectionName] = documents; >> "%SERVICE_FILE%"     
echo             } >> "%SERVICE_FILE%"
echo         return data; >>"%SERVICE_FILE%"
echo     } finally { >> "%SERVICE_FILE%"
echo         await client.close(); >> "%SERVICE_FILE%"
echo     } >> "%SERVICE_FILE%"
echo } >> "%SERVICE_FILE%"

echo // Function to retrieve only the table names >> "%SERVICE_FILE%" 
echo async function getTableNames() {  >> "%SERVICE_FILE%"
echo     const client = new MongoClient(uri);  >> "%SERVICE_FILE%"
echo     try {  >> "%SERVICE_FILE%"
echo         await client.connect();  >> "%SERVICE_FILE%"
echo         const db = client.db(dbName);  >> "%SERVICE_FILE%"
echo         // Retrieves a list of all collections in the database  >> "%SERVICE_FILE%"
echo         const collections = await db.listCollections().toArray(); >> "%SERVICE_FILE%"
        
echo         // Extracts only the names of the collections  >> "%SERVICE_FILE%"
echo         const tableNames = collections.map(collection =^> collection.name);  >> "%SERVICE_FILE%"
        
echo         // Returns an array with the table names >> "%SERVICE_FILE%"
echo         return tableNames; >> "%SERVICE_FILE%"
echo     } finally {  >> "%SERVICE_FILE%"
echo         await client.close();  >> "%SERVICE_FILE%"
echo     }  >> "%SERVICE_FILE%"
echo }  >> "%SERVICE_FILE%"
echo //function to delete a table
echo async function deleteCollection^(tableName) { >> "%SERVICE_FILE%"
echo     const client = new MongoClient^(uri); >> "%SERVICE_FILE%"
echo     try { >> "%SERVICE_FILE%"
echo         await client.connect^(); >> "%SERVICE_FILE%"
echo         const db = client.db(dbName); >> "%SERVICE_FILE%"
echo         const collections = await db.listCollections({ name: tableName }).toArray^(); >> "%SERVICE_FILE%"
echo         if (collections.length === 0) { >> "%SERVICE_FILE%"
echo             return { success: false, message: 'Table not found' }; >> "%SERVICE_FILE%"
echo         } >> "%SERVICE_FILE%"
echo         await db.collection(tableName).drop^(); >> "%SERVICE_FILE%"
echo         return { success: true, message: `Table '${tableName}' deleted successfully` }; >> "%SERVICE_FILE%"
echo     } catch (error) { >> "%SERVICE_FILE%"
echo         console.error(`Error deleting table '${tableName}':`, error); >> "%SERVICE_FILE%"
echo         throw error; >> "%SERVICE_FILE%"
echo     } finally { >> "%SERVICE_FILE%"
echo         await client.close^(); >> "%SERVICE_FILE%"
echo     } >> "%SERVICE_FILE%"
echo } >> "%SERVICE_FILE%"

echo // services/mongodbService.js >> "%SERVICE_FILE%"
echo module.exports = { >> "%SERVICE_FILE%"
echo     fetchData, >> "%SERVICE_FILE%"
echo     getTableNames,deleteCollection >> "%SERVICE_FILE%"
echo }; >> "%SERVICE_FILE%"



::creating apiRoutes.js
echo const { deleteCollection } = require('../services/mongodbService');>> "%ROUTE_FILE%"

echo const express = require('express'); >> "%ROUTE_FILE%"
echo const router = express.Router();>>  "%ROUTE_FILE%"
echo const { MongoClient, ObjectId } = require('mongodb'); >>  "%ROUTE_FILE%"
echo const uri ='%DB_URI%'; >> "%ROUTE_FILE%"
echo const dbName ='%DB_NAME%';>> "%ROUTE_FILE%"
echo const {>> "%ROUTE_FILE%"
echo    fetchData,>> "%ROUTE_FILE%"
echo    getTableNames,>> "%ROUTE_FILE%"
echo } = require('../services/mongodbService');>> "%ROUTE_FILE%"
echo // API to retrieve the table names >> "%ROUTE_FILE%"
echo router.get^('/tableNames', async ^(req, res^) =^> { >> "%ROUTE_FILE%"
echo     try {  >> "%ROUTE_FILE%"
echo         const tableNames = await getTableNames();  >> "%ROUTE_FILE%"
echo         res.json^(tableNames^);  // Returns the table names as an array  >> "%ROUTE_FILE%"
echo     } catch ^(err^) {  >> "%ROUTE_FILE%"
echo         console.error('Error in /api/tableNames:', err);  >> "%ROUTE_FILE%"
echo         res.status^(500^).json^({ error: 'Internal Server Error' }^);  >> "%ROUTE_FILE%"
echo     }  >> "%ROUTE_FILE%"
echo }); >> "%ROUTE_FILE%"


echo // Route to retrieve all data >> "%ROUTE_FILE%"
echo router.get^('/getall', async ^(req, res^) =^> {  >> "%ROUTE_FILE%"
echo     try { >> "%ROUTE_FILE%"
echo         const data = await fetchData^(^);   >> "%ROUTE_FILE%"
echo         res.json^(data^); >> "%ROUTE_FILE%"
echo     } catch ^(err^) { >> "%ROUTE_FILE%"
echo         console.error^('Error in /api/getall:', err^); >> "%ROUTE_FILE%"
echo         res.status^(500^).json^({ error: 'Internal Server Error' }^); >> "%ROUTE_FILE%"
echo     } >> "%ROUTE_FILE%"
echo }); >> "%ROUTE_FILE%"

echo // Route to update a document in a collection >> "%ROUTE_FILE%"
echo router.put^('/update/:table/:id', async ^(req, res^) =^> { >> "%ROUTE_FILE%"
echo     const client = new MongoClient^(uri^); >> "%ROUTE_FILE%"
echo     try { >> "%ROUTE_FILE%"
echo         await client.connect^(^); >> "%ROUTE_FILE%"
echo         const db = client.db^(dbName^); >> "%ROUTE_FILE%"
echo         const { table, id } = req.params; >> "%ROUTE_FILE%"

echo         console.log(`Received update request for table: ${table}, ID: ${id}`); >> "%ROUTE_FILE%"
echo         console.log(`Data received for update:`, req.body); >> "%ROUTE_FILE%"

echo        // Convert ID to ObjectId >> "%ROUTE_FILE%"
echo         let objectId; >> "%ROUTE_FILE%"
echo         try { >> "%ROUTE_FILE%"
echo             objectId = new ObjectId^(id^); >> "%ROUTE_FILE%"
echo         } catch ^(error^) { >> "%ROUTE_FILE%"
echo             return res.status^(400^).json^({ error: 'Invalid ID format' }^); >> "%ROUTE_FILE%"
echo         } >> "%ROUTE_FILE%"

echo         const collection = db.collection^(table^); >> "%ROUTE_FILE%"

echo         // Remove _id from update data >> "%ROUTE_FILE%"
echo         const updateData = { ...req.body }; >> "%ROUTE_FILE%"
echo         delete updateData._id;  >> "%ROUTE_FILE%"

echo         const result = await collection.updateOne^( >> "%ROUTE_FILE%"
echo             { _id: objectId },  >> "%ROUTE_FILE%"
echo             { $set: updateData } >> "%ROUTE_FILE%"
echo         ^); >> "%ROUTE_FILE%"

echo         if ^(result.matchedCount === 0^) { >> "%ROUTE_FILE%"
echo             return res.status^(404^).json^({ error: 'Document not found' }^); >> "%ROUTE_FILE%"
echo         } >> "%ROUTE_FILE%"

echo         res.json^({ message: 'Update successful' }^); >> "%ROUTE_FILE%"
echo     } catch ^(err^) { >> "%ROUTE_FILE%"
echo         console.error^(`Error in /api/update:`, err^); >> "%ROUTE_FILE%"
echo         res.status^(500^).json^({ error: 'Internal Server Error' }^); >> "%ROUTE_FILE%"
echo     } finally { >> "%ROUTE_FILE%"
echo         await client.close^(^); >>"%ROUTE_FILE%"
echo  } >> "%ROUTE_FILE%"
echo }); >> "%ROUTE_FILE%"

echo // Route to fetch a single item by ID >>"%ROUTE_FILE%"
echo router.get^('/:table/:id', async ^(req, res^) =^> { >> "%ROUTE_FILE%"
echo     const client = new MongoClient^(uri^); >> "%ROUTE_FILE%"
echo     try { >> "%ROUTE_FILE%"
echo         await client.connect^(^); >> "%ROUTE_FILE%"
echo         const db = client.db^(dbName^); >>"%ROUTE_FILE%"
echo         const { table, id } = req.params; >> "%ROUTE_FILE%"

echo         console.log^(`Fetching from table: ${table}, ID: ${id}`^); >> "%ROUTE_FILE%"

echo // Convert ID to ObjectId >> "%ROUTE_FILE%"
echo         let objectId; >>"%ROUTE_FILE%"
echo         try { >> "%ROUTE_FILE%"
echo             objectId = new ObjectId^(id^); >> "%ROUTE_FILE%"
echo         } catch ^(error^) { >> "%ROUTE_FILE%"
echo             return res.status^(400^).json^({ error: 'Invalid ID format' }^); >> "%ROUTE_FILE%"
echo         } >>"%ROUTE_FILE%"

echo         const collection = db.collection^(table^); >>"%ROUTE_FILE%"
echo         const document = await collection.findOne^({ _id: objectId }^); >>"%ROUTE_FILE%"

echo         if ^(document^) { >> "%ROUTE_FILE%"
echo             res.json^(document^); >> "%ROUTE_FILE%"
echo         } else { >> "%ROUTE_FILE%"
echo             res.status^(404^).json^({ error: 'Item not found' }^); >> "%ROUTE_FILE%"
echo         } >> "%ROUTE_FILE%"
echo     } catch ^(err^) { >>"%ROUTE_FILE%"
echo         console.error^(`Error fetching ${req.params.table} data:`, err^); >>"%ROUTE_FILE%"
echo         res.status^(500^).json^({ error: 'Internal Server Error' }^); >> "%ROUTE_FILE%"
echo     } finally { >> "%ROUTE_FILE%"
echo         await client.close^(^); >>"%ROUTE_FILE%"
echo  } >> "%ROUTE_FILE%"
echo }); >> "%ROUTE_FILE%"

echo // Route to delete a document >> "%ROUTE_FILE%"
echo router.delete^('/delete/:table/:id', async ^(req, res^) =^> { >>"%ROUTE_FILE%"
echo     const client = new MongoClient^(uri^); >>"%ROUTE_FILE%"
echo     try { >> "%ROUTE_FILE%"
echo         await client.connect^(^); >>"%ROUTE_FILE%"
echo         const db = client.db^(dbName^); >> "%ROUTE_FILE%"
echo         const { table, id } = req.params; >> "%ROUTE_FILE%"
echo         console.log^(`Received delete request for table: ${table}, ID: ${id}`^); >>"%ROUTE_FILE%"

echo         let objectId; >> "%ROUTE_FILE%"
echo         try { >> "%ROUTE_FILE%"
echo             objectId = new ObjectId^(id^);  // Ensure the ID is valid >> "%ROUTE_FILE%"
echo         } catch ^(error^) { >> "%ROUTE_FILE%"
echo             return res.status^(400^).json^({ error: 'Invalid ID format' }^); >> "%ROUTE_FILE%"
echo         } >> "%ROUTE_FILE%"

echo         const collection = db.collection^(table^); >> "%ROUTE_FILE%"
echo         const result = await collection.deleteOne^({ _id: objectId }^); >> "%ROUTE_FILE%"

echo         if ^(result.deletedCount === 0^) { >> "%ROUTE_FILE%"
echo             return res.status^(404^).json^({ error: 'Document not found' }^); >>"%ROUTE_FILE%"
echo         } >> "%ROUTE_FILE%"

echo         res.json^({ message: 'Delete successful' }^); >> "%ROUTE_FILE%"
echo     } catch ^(err^) { >> "%ROUTE_FILE%"
echo         console.error^('Error in /api/delete:', err^); >>"%ROUTE_FILE%"
echo         res.status^(500^).json^({ error: 'Internal Server Error' }^); >> "%ROUTE_FILE%"
echo     } finally { >> "%ROUTE_FILE%"
echo        await client.close^(^); >> "%ROUTE_FILE%"
echo     } >> "%ROUTE_FILE%"
echo }^); >> "%ROUTE_FILE%"
echo //route to delete a table
echo router.delete('/delete/:table', async (req, res) =^> { >> "%ROUTE_FILE%"
echo     const { table } = req.params; >> "%ROUTE_FILE%"
echo     try { >> "%ROUTE_FILE%"
echo         const result = await deleteCollection(table); >> "%ROUTE_FILE%"
echo         if (!result.success) { >> "%ROUTE_FILE%"
echo             return res.status(404).json({ error: result.message }); >> "%ROUTE_FILE%"
echo         } >> "%ROUTE_FILE%"
echo         res.json({ message: result.message }); >> "%ROUTE_FILE%"
echo     } catch (err) { >> "%ROUTE_FILE%"
echo         res.status(500).json({ error: 'Internal Server Error' }); >> "%ROUTE_FILE%"
echo     } >> "%ROUTE_FILE%"
echo }); >> "%ROUTE_FILE%"

echo module.exports = router; >>"%ROUTE_FILE%"
echo apiRoutes created

cd /d "%BACKEND_DIR%"
echo // Installing dependencies, please wait!

:: Run npm install and ensure the script continues
call npm install

echo Dependencies installed successfully!

:: Define script path
set "SCRIPT_PATH=%~dp0backend"


:: Check if index.js exists
if not exist "%SCRIPT_PATH%" (
    echo Script file not found: %SCRIPT_PATH%
    exit /b
)

:: Start the Node.js server
echo Starting the Node.js server...
start node index.js

echo Server is running at http://localhost:3000