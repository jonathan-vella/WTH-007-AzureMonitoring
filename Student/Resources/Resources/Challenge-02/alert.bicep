param actionGroupResourceId string = '/subscriptions/beae496e-0906-469f-8d32-8a11adb98c65/resourceGroups/pp4-rg-wth-monitor-d-eu/providers/microsoft.insights/actiongroups/wth-monitoring'
param vmLocation string = resourceGroup().location
param activityLogAlertNameVmStop string = 'alert-vm-stopped'
param metricAlertNameCPU string = 'alert-cpu-over-75-percent'
param metricDiskWriteOperationsName string = 'disk-write-operations-over-20'

resource activityLogAlertsVmStopped 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: activityLogAlertNameVmStop
  location: 'global'
  properties: {
    scopes: [
      resourceGroup().id
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'Administrative'
        }
        {
          field: 'operationName'
          equals: 'Microsoft.Compute/virtualMachines/deallocate/action'
        }
        {
          field: 'resourceType'
          equals: 'Microsoft.Compute/virtualMachines'
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: actionGroupResourceId
          webhookProperties: {}
        }
      ]
    }
    enabled: true
    description: 'Alert when a VM is deallocated'
  }
}

resource metricAlertCpu 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertNameCPU
  location: 'global'

  properties: {
    actions: [
      {
        actionGroupId: actionGroupResourceId
        webHookProperties: {}
      }
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: []
          metricName: 'Percentage CPU'
          name: 'MetricCPU'
          operator: 'GreaterThan'
          threshold: 75
          timeAggregation: 'Average'
        }
      ]
    }
    description: 'Alert for CPU Usage over 75 percent'
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      resourceGroup().id
    ]
    severity: 2
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: vmLocation
    windowSize: 'PT5M'
  }
}

resource metricDiskWriteOperations 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricDiskWriteOperationsName
  location: 'global'

  properties: {
    actions: [
      {
        actionGroupId: actionGroupResourceId
        webHookProperties: {}
      }
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: []
          metricName: 'Disk Write Operations/Sec'
          name: 'MetricDiskWriteOperations'
          operator: 'GreaterThan'
          threshold: 20
          timeAggregation: 'Average'
        }
      ]
    }
    description: 'Alert for Disk Write Operations/sec over 20'
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      resourceGroup().id
    ]
    severity: 2
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: vmLocation
    windowSize: 'PT5M'
  }
}

