# Pattern-2 Deployment 

![alt tag](https://github.com/irham0019/apim-openshift/blob/master/pattern-2/Architecture.jpg)


# Pattern-2 Configuration

#### Update the pattern-2/confs/apim-pub-store/repository/conf/deployment.toml as below
```
[database.shared_db]
type = "mysql"
url = "jdbc:mysql://apim-rdbms:3306/shareddb?autoReconnect=true&amp;useSSL=false"
username = "root"
password = "root"

[database.apim_db]
type = "mysql"
url = "jdbc:mysql://apim-rdbms:3306/apimgtdb?autoReconnect=true&amp;useSSL=false"
username = "root"
password = "root"
```

#### Update the pattern-1/confs/apim-km/repository/conf/deployment.toml as below
```
[database.shared_db]
type = "mysql"
url = "jdbc:mysql://apim-rdbms:3306/shareddb?autoReconnect=true&amp;useSSL=false"
username = "root"
password = "root"

[database.apim_db]
type = "mysql"
url = "jdbc:mysql://apim-rdbms:3306/apimgtdb?autoReconnect=true&amp;useSSL=false"
username = "root"
password = "root"
```