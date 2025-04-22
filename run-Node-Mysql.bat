echo ===== Setting up Node.js/mysql Backend =====
@echo off
:: Define the backend folder
set BACKEND_DIR=%~dp0backend

:: Define the Services and Routes directories
set SERVICES_DIR=%BACKEND_DIR%\Controllers
set ROUTES_DIR=%BACKEND_DIR%\Routes

:: Define file paths for mongodbService.js, dbConnection, apiRoutes.js and index.js
set SERVICE_FILE=%SERVICES_DIR%\mysqlService.js
set DB_CONNECTION=%SERVICES_DIR%\dbConnection.js

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
echo Creating package.json...
echo { > "%BACKEND_DIR%\package.json"
echo   "name": "backend", >> "%BACKEND_DIR%\package.json"
echo   "version": "1.0.0", >> "%BACKEND_DIR%\package.json"
echo   "main": "index.js", >> "%BACKEND_DIR%\package.json"
echo   "scripts": { >> "%BACKEND_DIR%\package.json"
echo     "test": "echo \"Error: no test specified\" && exit 1" >> "%BACKEND_DIR%\package.json"
echo   }, >> "%BACKEND_DIR%\package.json"
echo   "keywords": [], >> "%BACKEND_DIR%\package.json"
echo   "author": "", >> "%BACKEND_DIR%\package.json"
echo   "license": "ISC", >> "%BACKEND_DIR%\package.json"
echo   "description": "", >> "%BACKEND_DIR%\package.json"
echo   "dependencies": { >> "%BACKEND_DIR%\package.json"
echo     "express": "^5.1.0", >> "%BACKEND_DIR%\package.json"
echo     "mysql": "^2.18.1" >> "%BACKEND_DIR%\package.json"
echo   } >> "%BACKEND_DIR%\package.json"
echo } >> "%BACKEND_DIR%\package.json"


::---------------------------------------------------------
:: Create index.js

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
::creating mysqlService File:
echo Creating mysqlService.js...
echo const db = require('./dbConnection'); >>"%SERVICE_FILE%"


echo // function to delete Item in a table>>"%SERVICE_FILE%"
echo const deleteItem = (table, id, callback) =^> {>>"%SERVICE_FILE%"
echo   const query = `DELETE FROM ${table} WHERE id = ?`;>>"%SERVICE_FILE%"
echo   db.query(query, ^[id], ^(err, result) =^> {>>"%SERVICE_FILE%"
echo     if (err) return callback^(err);>>"%SERVICE_FILE%"
echo     if (result.affectedRows ^> 0) {>>"%SERVICE_FILE%"
echo       callback(null, { message: 'Item deleted successfully' });>>"%SERVICE_FILE%"
echo     } else {>>"%SERVICE_FILE%"
echo       callback(null, { message: 'Item not found' });>>"%SERVICE_FILE%"
echo     }>>"%SERVICE_FILE%"
echo   });>>"%SERVICE_FILE%"
echo };>>"%SERVICE_FILE%"

echo // function to delete  a table>>"%SERVICE_FILE%"
echo const deleteTable = (tableName, callback) =^> {>>"%SERVICE_FILE%"
echo   const query = `DROP TABLE IF EXISTS ??`;>>"%SERVICE_FILE%"
echo   db.query(query, [tableName], (err, result) =^> {>>"%SERVICE_FILE%"
echo     if (err) return callback(err);>>"%SERVICE_FILE%"
echo     callback(null, { message: `Table '${tableName}' deleted successfully.` });>>"%SERVICE_FILE%"
echo   });>>"%SERVICE_FILE%"
echo };>>"%SERVICE_FILE%"

echo module.exports = {deleteItem, deleteTable}; >>"%SERVICE_FILE%"


::creating the dbConnection File 
echo creating the dbConnection File ...
echo const mysql = require('mysql2'); >>"%DB_CONNECTION%"
echo const connection = mysql.createConnection({ >>"%DB_CONNECTION%"
echo   host: '%DB_URI%', >>"%DB_CONNECTION%"
echo   user: '%USERNAME%', >>"%DB_CONNECTION%"
echo   password: '%PASSWORD%',>>"%DB_CONNECTION%"
echo   database: '%DB_NAME%', >>"%DB_CONNECTION%"
echo   port: '%PORT%',>>"%DB_CONNECTION%
echo }); >>"%DB_CONNECTION%"
echo connection.connect(err =^> { >>"%DB_CONNECTION%"
echo   if (err) throw err; >>"%DB_CONNECTION%"
echo   console.log(' Connecté à la base de données MySQL'); >>"%DB_CONNECTION%"
echo }); >>"%DB_CONNECTION%"
echo module.exports = connection; >>"%DB_CONNECTION%"


::creating apiRoutes.js
echo creating apiRoutes.js ...
echo const express = require('express'); >> "%ROUTE_FILE%"
echo const router = express.Router(); >> "%ROUTE_FILE%"
echo const db = require('../Controllers/dbConnection'); >> "%ROUTE_FILE%"
echo const { deleteItem,deleteTable  } = require('../Controllers/mysqlService');>> "%ROUTE_FILE%"


echo router.get('/', (req, res) =^> { >> "%ROUTE_FILE%"
echo     res.send('Bienvenue sur ton API !'); >> "%ROUTE_FILE%"
echo   }); >> "%ROUTE_FILE%">> "%ROUTE_FILE%"

echo // Route pour récupérer les noms de toutes les tables>> "%ROUTE_FILE%"
echo router.get('/tablenames', (req, res) =^> {>> "%ROUTE_FILE%"
echo   // Requête pour obtenir les noms des tables>> "%ROUTE_FILE%"
echo   db.query('SHOW TABLES', (err, results) =^> {>> "%ROUTE_FILE%"
echo     if (err) {>> "%ROUTE_FILE%"
echo       return res.status(500).send('Erreur serveur lors de la récupération des tables');>> "%ROUTE_FILE%"
echo     }>> "%ROUTE_FILE%"

echo     // Extraire uniquement les noms des tables (en prenant les valeurs de la colonne "Tables_in_ma_base")>> "%ROUTE_FILE%"
echo     const tableNames = results.map(row =^> Object.values(row)[0]);>> "%ROUTE_FILE%"

echo     // Retourner les noms des tables en réponse>> "%ROUTE_FILE%"
echo     res.json(tableNames);>> "%ROUTE_FILE%"
echo   });>> "%ROUTE_FILE%"
echo });>> "%ROUTE_FILE%"



echo // Route to fetch all data from all tables in the database >> "%ROUTE_FILE%"
echo router.get('/getall', (req, res) =^> { >> "%ROUTE_FILE%"
echo   // Étape 1 : Récupérer les noms de toutes les tables >> "%ROUTE_FILE%"
echo     db.query('SHOW TABLES', (err, tables) =^> { >> "%ROUTE_FILE%"
echo       if (err) { >> "%ROUTE_FILE%"
echo         return res.status(500).send('Erreur serveur lors de la récupération des tables'); >> "%ROUTE_FILE%"
echo       } >> "%ROUTE_FILE%"

echo       // Extraire uniquement les noms des tables >> "%ROUTE_FILE%"
echo       const tableNames = tables.map(table =^> Object.values(table)[0]); >> "%ROUTE_FILE%"

echo       // Étape 2 : Pour chaque table, récupérer ses données >> "%ROUTE_FILE%"
echo       const promises = tableNames.map(table =^> { >> "%ROUTE_FILE%"
echo         return new Promise((resolve, reject) =^> { >> "%ROUTE_FILE%"
echo           // Récupérer les données de chaque  >> "%ROUTE_FILE%"
echo           db.query(`SELECT * FROM ${table}`, (err, data) =^> { >> "%ROUTE_FILE%"
echo             if (err) { >> "%ROUTE_FILE%"
echo               reject(`Erreur avec la table ${table}: ${err}`); >> "%ROUTE_FILE%"
echo             } else { >> "%ROUTE_FILE%"
echo               resolve({ table, data }); >> "%ROUTE_FILE%"
echo             } >> "%ROUTE_FILE%"
echo           }); >> "%ROUTE_FILE%"
echo         }); >> "%ROUTE_FILE%"
echo       }); >> "%ROUTE_FILE%"

echo       // Étape 3 : Attendre que toutes les données des tables soient récupérées >> "%ROUTE_FILE%"
echo       Promise.all(promises) >> "%ROUTE_FILE%"
echo         .then(results =^> { >> "%ROUTE_FILE%"
echo           // Créer un objet avec les données de toutes les tables >> "%ROUTE_FILE%"
echo           const allTablesData = results.reduce((acc, { table, data }) =^> { >> "%ROUTE_FILE%"
echo             acc[table] = data; >> "%ROUTE_FILE%"
echo             return acc; >> "%ROUTE_FILE%"
echo           }, {}); >> "%ROUTE_FILE%"

echo           // Retourner les données de toutes les tables en réponse >> "%ROUTE_FILE%"
echo           res.json(allTablesData); >> "%ROUTE_FILE%"
echo         }) >> "%ROUTE_FILE%"
echo         .catch(err =^> { >> "%ROUTE_FILE%"
echo           res.status(500).send(`Erreur lors de la récupération des données des tables: ${err}`); >> "%ROUTE_FILE%"
echo   }); >> "%ROUTE_FILE%"
echo     }); >> "%ROUTE_FILE%"
echo   }); >> "%ROUTE_FILE%"


echo // Route to delete an item from a specified table by id >> "%ROUTE_FILE%"
echo router.delete('/delete/:table/:id', (req, res) =^> { >> "%ROUTE_FILE%"
echo   const { table, id } = req.params; >> "%ROUTE_FILE%"
echo     deleteItem(table, id, (err, result) =^> { >> "%ROUTE_FILE%"
echo     if (err) {>> "%ROUTE_FILE%"
echo       return res.status(500).json({ message: 'Error deleting item', error: err });>> "%ROUTE_FILE%"
echo     }>> "%ROUTE_FILE%"
echo     return res.status(200).json(result);>> "%ROUTE_FILE%"
echo   });>> "%ROUTE_FILE%"
echo });>> "%ROUTE_FILE%"

echo // Route to delete a table>> "%ROUTE_FILE%"
echo router.delete('/deleteTable/:tableName', (req, res) =^> {>> "%ROUTE_FILE%"
echo   const { tableName } = req.params;>> "%ROUTE_FILE%"
echo   console.log^(`Demande de suppression de la table : ${tableName}`^);  >> "%ROUTE_FILE%"
echo   deleteTable(tableName, (err, result) =^> {>> "%ROUTE_FILE%"
echo     if (err) {>> "%ROUTE_FILE%"
echo       console.error('Erreur lors de la suppression de la table:', err); >> "%ROUTE_FILE%"
echo       return res.status(500).json({ message: 'Error deleting table', error: err });>> "%ROUTE_FILE%"
echo     }>> "%ROUTE_FILE%"
echo     console.log('Table supprimée avec succès:', result); >> "%ROUTE_FILE%"
echo     res.status(200).json(result);>> "%ROUTE_FILE%"
echo   });>> "%ROUTE_FILE%"
echo });>> "%ROUTE_FILE%"

echo // Route to update  >>"%ROUTE_FILE%"
echo router.put^('/update/:table/:id', ^(req, res^) =^> { >>"%ROUTE_FILE%"
echo  const { table, id } = req.params; >>"%ROUTE_FILE%"
echo  const updateData = req.body; >>"%ROUTE_FILE%"

echo console.log(` Mise à jour demandée dans ${table} pour l'id ${id}`); >>"%ROUTE_FILE%"
echo console.log(' Données reçues :', updateData); >>"%ROUTE_FILE%"

echo  // Vérifie qu'on a bien des données à mettre à jour >>"%ROUTE_FILE%"
echo  if ^(^!updateData ^|^| Object.keys^(updateData^).length === 0^) { >>"%ROUTE_FILE%"
echo   return res.status(400).json({ error: 'Aucune donnée à mettre à jour' }); >>"%ROUTE_FILE%"
echo  } >>"%ROUTE_FILE%"
echo  // Préparer les colonnes et les valeurs pour l’UPDATE >>"%ROUTE_FILE%"
echo  const columns = Object.keys(updateData).map(key =^> `${key} = ?`).join(', '); >>"%ROUTE_FILE%"
echo  const values = Object.values(updateData); >>"%ROUTE_FILE%"
echo  // Construire la requête SQL >>"%ROUTE_FILE%"
echo  const sql = `UPDATE \`${table}\` SET ${columns} WHERE id = ?`; >>"%ROUTE_FILE%"
echo  const db = require('../Controllers/dbConnection'); >>"%ROUTE_FILE%"
echo  db.query(sql, [...values, id], (err, result) =^> { >>"%ROUTE_FILE%"
echo   if (err) { >>"%ROUTE_FILE%"
echo    return res.status(500).json({ message: 'Erreur lors de la mise à jour', error: err }); >>"%ROUTE_FILE%"
echo   } >>"%ROUTE_FILE%"
echo   if (result.affectedRows === 0) { >>"%ROUTE_FILE%"
echo    return res.status(500).json({ message: 'Erreur lors de la mise à jour', error: err }); >>"%ROUTE_FILE%"
echo   } >>"%ROUTE_FILE%"
echo   if (result.affectedRows === 0) { >>"%ROUTE_FILE%"
echo    return res.status(404).json({ message: 'Aucun enregistrement trouvé avec cet ID' }); >>"%ROUTE_FILE%"
echo   } >>"%ROUTE_FILE%"
echo   res.status(200).json({ message: 'Mise à jour réussie', result }); >>"%ROUTE_FILE%"
echo  }); >>"%ROUTE_FILE%"
echo }); >>"%ROUTE_FILE%"

echo // Route pour récupérer un seul item dans une table par ID >>"%ROUTE_FILE%"
echo router.get^('/:table/:id', ^(req, res^) =^> { >>"%ROUTE_FILE%"
echo  const { table, id } = req.params; >>"%ROUTE_FILE%"
echo  const sql = `SELECT * FROM \`${table}\` WHERE id = ?`; >>"%ROUTE_FILE%"

echo  db.query^(sql, [id], ^(err, results^) =^> { >>"%ROUTE_FILE%"
echo    if ^(err^) { >>"%ROUTE_FILE%"
echo      return res.status^(500^).json^({ message: 'Erreur serveur', error: err }^); >>"%ROUTE_FILE%"
echo    } >>"%ROUTE_FILE%"

echo    if ^(results.length === 0^) { >>"%ROUTE_FILE%"
echo      return res.status^(404^).json^({ message: 'Aucun item trouvé avec cet ID' }^); >>"%ROUTE_FILE%"
echo    } >>"%ROUTE_FILE%"

echo    res.status^(200^).json^(results[0]^); >>"%ROUTE_FILE%"
echo  }^); >>"%ROUTE_FILE%"
echo }^); >>"%ROUTE_FILE%"


echo module.exports = router; >> "%ROUTE_FILE%"
echo apiRoutes created

cd /d "%BACKEND_DIR%"
echo // Installing dependencies, please wait!

:: Run npm install and ensure the script continues
call npm install cors mysql2
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