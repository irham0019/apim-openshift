# Pattern-1 Deployment 

![alt tag](https://github.com/irham0019/apim-openshift/blob/master/pattern-1/Architecture.jpg)

# Pattern-1 Configuration

#### Update the pattern-1/confs/apim-pub-store/repository/conf/deployment.toml as below
```
[database.shared_db]
type = "mssql"
url = "jdbc:sqlserver://<host>:<port>;databaseName=shared_db;SendStringParametersAsUnicode=false"
username = "<user>"
password = "<password>"
driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
validationQuery = "SELECT 1"

[database.apim_db]
type = "mssql"
url = "jdbc:sqlserver://<host>:<port>;databaseName=apimgtdb;SendStringParametersAsUnicode=false"
username = "<user>"
password = "<password>"
driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
validationQuery = "SELECT 1"
```

#### Update the pattern-1/confs/apim-km/repository/conf/deployment.toml as below
```
[database.shared_db]
type = "mssql"
url = "jdbc:sqlserver://<host>:<port>;databaseName=shared_db;SendStringParametersAsUnicode=false"
username = "<user>"
password = "<password>"
driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
validationQuery = "SELECT 1"

[database.apim_db]
type = "mssql"
url = "jdbc:sqlserver://<host>:<port>;databaseName=apimgtdb;SendStringParametersAsUnicode=false"
username = "<user>"
password = "<password>"
driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
validationQuery = "SELECT 1"
```