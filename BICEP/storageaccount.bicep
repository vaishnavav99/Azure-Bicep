param pStorageAccountName string
param pStorageAccountSku string
param pStorageAccountaccessTier string
param pTags object 
param pStorageAccountLocation string= resourceGroup().location


resource rStorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: pStorageAccountName
  location: pStorageAccountLocation
  sku:  {
    name: pStorageAccountSku
  }
  kind:'StorageV2'
  properties:{
    accessTier: pStorageAccountaccessTier
  }
  tags: pTags
}
