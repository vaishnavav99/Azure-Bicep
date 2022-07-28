param pServerlocation string = resourceGroup().location
param pAdminName string
param PAdminPassword string
param pServerName string
param pTags object

param pIPName string
param pStartIP string
param pEndIP string
param pSID string
param pLoginName string

// Sql server
resource rSqlServer 'Microsoft.Sql/servers@2021-11-01-preview' ={
  name: pServerName
  location: pServerlocation
  properties: {
    administratorLogin: pAdminName
    administratorLoginPassword: PAdminPassword
  }
  tags: pTags
}


//AD admin
resource rAD 'Microsoft.Sql/servers/administrators@2021-11-01-preview' = {
  name: 'ActiveDirectory'
  parent:  rSqlServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: pLoginName
    sid: pSID
 
  }
}

//azureADOnlyAuthentications
resource rToggle 'Microsoft.Sql/servers/azureADOnlyAuthentications@2021-11-01-preview' = {
  name: 'Default'
  parent: rSqlServer
  properties: {
    azureADOnlyAuthentication: false
  }
}

// whitelisting the azure ip
resource rSqlServerFirewallRules0 'Microsoft.Sql/servers/firewallRules@2020-11-01-preview' = {
  parent: rSqlServer
  name: pIPName
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// whitelisting the ip address or allowing ip address to access
resource rSqlServerFirewallRules 'Microsoft.Sql/servers/firewallRules@2020-11-01-preview' = {
  parent: rSqlServer
  name: pIPName
  properties: {
    startIpAddress: pStartIP
    endIpAddress: pEndIP
  }
}
