param pServerName string
param pDBName string

resource rMySQLDB 'Microsoft.DBforMySQL/servers/databases@2017-12-01' = {
  name: '${pServerName}/${pDBName}'
}
