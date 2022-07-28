@minLength(3)
@maxLength(24)
param pStorageAccountName string

@allowed([
  'Blob'
  'Container'
  'None'
])
param pContainerAccess string
param pContainerName string

resource rContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${pStorageAccountName}/default/${pContainerName}'
  properties: {
    publicAccess: pContainerAccess
  }
}
