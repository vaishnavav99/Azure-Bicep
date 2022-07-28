param pLocation string = resourceGroup().location
param pServerName string 
param pSqlDbName string 
param pTags object
param pSKU object

@allowed([
  'Geo'
  'Local'
  'Zone'
])
param pBackupStorageRedundancy string
param pReadScaleout string

// Sql Server Database
resource rSqlServerDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  name: '${pServerName}/${pSqlDbName}'
  location: pLocation
  sku: pSKU
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    readScale: pReadScaleout
    requestedBackupStorageRedundancy: pBackupStorageRedundancy
  }
  tags: pTags
}
