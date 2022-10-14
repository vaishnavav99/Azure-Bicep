param pVMname string 
param pAdminUser string 
param pSubnet string 
param pzone string
param pTier string

@secure()
param pAdminPassword string 

param pLocation string = resourceGroup().location
param pTags object

resource rPublicIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: '${pVMname}-ip'
  location: pLocation
  tags: pTags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties:{
    publicIPAllocationMethod: 'Static'
  }
}

resource rSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${pVMname}-nsg'
  location: pLocation
  properties: {
    securityRules: [
      {
        name: 'allow-22'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource rnetworkinterface 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: '${pVMname}-nic'
  location: pLocation
  tags: pTags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: rPublicIP.id
          }
          subnet: {
            id: pSubnet
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: rSecurityGroup.id
      }
    }
  }

  resource rDataDisk 'Microsoft.Compute/disks@2022-03-02' = {
    name: 'disks_${pVMname}_DataDisk'
    location: pLocation
    tags: {
      CreatedBy: 'vaishnavav@carestack.com'
      'Ticket Number': 'CS-120909'
      Comment: 'Kafka Non Prod'
    }
    sku: {
      name: 'StandardSSD_LRS'
      tier: 'Standard'
    }
    zones: [
      pzone
    ]
    properties: {
      creationData: {
        createOption: 'Empty'
      }
      diskSizeGB: 128
      diskIOPSReadWrite: 500
      diskMBpsReadWrite: 60
      encryption: {
        type: 'EncryptionAtRestWithPlatformKey'
      }
      networkAccessPolicy: 'AllowAll'
      publicNetworkAccess: 'Enabled'
      diskState: 'Reserved'
    }
  }


resource rVM 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: pVMname
  location: pLocation
  tags: pTags
  zones: [
    pzone
  ]
  properties: {
    hardwareProfile: {
      vmSize: pTier
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${pVMname}_OsDisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
      }
      dataDisks: [
        {
          lun: 0
          name: 'disks_${pVMname}_DataDisk'
          createOption: 'Attach'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          managedDisk: {
            id: rDataDisk.id
          }
          deleteOption: 'Detach'
          toBeDetached: false
        }
      ]
    }
    osProfile: {
      computerName: pVMname
      adminUsername: pAdminUser
      adminPassword: pAdminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true

    }
    networkProfile: {
      networkInterfaces: [
        {
          id: rnetworkinterface.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
  }
}

