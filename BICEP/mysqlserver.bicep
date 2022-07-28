param pServerlocation string = resourceGroup().location
param pProperties object
param pSKU object
param pServerName string
param pTags object


//replace with 'Microsoft.DBforMySQL/flexibleServers@2021-05-01'  for flexible server
resource rMysqlServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: pServerName 
  location: pServerlocation
  tags: pTags
  sku: pSKU
  properties: pProperties
}

//Allow access to Azure services
resource rFirewall0 'Microsoft.DBforMySQL/servers/firewallRules@2017-12-01' = {
  name: 'Azure'
  parent: rMysqlServer
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource rFirewall 'Microsoft.DBforMySQL/servers/firewallRules@2017-12-01' = {
  name: 'MYSQL'
  parent: rMysqlServer
  properties: {
    endIpAddress: '1.1.1.1'
    startIpAddress: '1.1.1.1'
  }
}

