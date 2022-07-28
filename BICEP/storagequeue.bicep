@minLength(3)
@maxLength(24)
param pStorageAccountName string
param pQueueName string


resource rContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${pStorageAccountName}/default/${pQueueName}'
}
