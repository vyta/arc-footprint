param location string = resourceGroup().location
param identityId string
param stagingResourceGroupName string
//param imageVersionNumber string
param runOutputName string = 'arc_footprint_image'
param imageTemplateName string

param galleryImageId string

param publisher string
param offer string
param sku string
param version string
param vmSize string

output id string = azureImageBuilderTemplate.id

resource azureImageBuilderTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-02-14' = {
  name: imageTemplateName
  location: location
  tags: {}
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityId}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 180
    customize: [
      {
        type: 'Shell'
        name: 'Install nfs-common'
        inline: [
          'sudo apt-get update'
          'sudo apt-get install -y nfs-common'
        ]
      }
      {
        type: 'Shell'
        name: 'Increase the user watch/instance and file descriptor limits'
        inline: [
          'echo fs.inotify.max_user_instances=8192 | sudo tee -a /etc/sysctl.conf'
          'echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf'
          'echo fs.file-max = 100000 | sudo tee -a /etc/sysctl.conf'
          'sudo sysctl -p'
        ]
      }
      {
        type: 'Shell'
        name: 'Install Azure CLI'
        inline: [
          'curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash'
        ]
      }
      {
        type: 'Shell'
        name: 'Hostmem Collection'
        inline: [
          'sudo mkdir $HOME/hostmem'
          'cat > cgroup_mem.sh <<EOF'
          '#!/bin/bash'
          ''
          '# Output CSV file'
          'output_file="$HOME/hostmem/cgroup_memory_usage.csv"'
          ''
          '# Write CSV header'
          'echo "Cgroup,Memory Usage (bytes),Total Cache (bytes),Container Name,Pod Name, Namespace, Timestamp" > "$output_file"'
          ''
          'timestamp=$(date +"%Y-%m-%d %H:%M:%S")'
          ''
          '# Iterate through cgroups and get memory usage'
          'for cgroup in $(sudo find /sys/fs/cgroup/memory/ -type d); do'
          '    # Extract cgroup name and parent cgroup'
          '    cgroup_name=$(basename "$cgroup")'
          ''
          '    # Get memory usage using systemctl'
          '    memory_usage=$(sudo systemctl show --property=MemoryCurrent "$cgroup_name" 2>/dev/null | awk -F= \'{print $2}\')'
          '    if [ -z "$memory_usage" ]; then'
          '        memory_usage=0'
          '    fi'
          ''
          '    # Get total cache '
          '    if [ -e "$cgroup/memory.stat" ]; then'
          '        total_cache=$(sudo cat "$cgroup/memory.stat" | grep "total_cache" | awk \'{print $2}\')'
          '    else'
          '        total_cache=0'
          '    fi'
          ''
          '    # Check if container'
          '    if [[ "$cgroup_name" == *"cri-containerd"* ]]; then'
          '            # Get container ID'
          '            container_id=$(basename "$cgroup" | awk -F \'cri-containerd-\' \'{print $2}\' | cut -d\'.\' -f1)'
          '      container_name=$(sudo ctr container info $container_id --format=json | jq -r .Image)'
          '      pod_name=$(sudo ctr container info $container_id --format=json | jq -r \'.Labels."io.kubernetes.pod.name"\')'
          '            namespace=$(sudo ctr container info $container_id --format=json | jq -r \'.Labels."io.kubernetes.pod.namespace"\')'
          ''
          '            echo "$cgroup_name,$memory_usage,$total_cache,$container_name,$pod_name,$namespace, $timestamp" >> "$output_file"'
          '    else'
          '        echo "$cgroup_name,$memory_usage,$total_cache,,,$timestamp" >> "$output_file"'
          '    fi'
          'done'
          'EOF'
          'chmod +x cgroup_mem.sh'
          'sudo mv cgroup_mem.sh $HOME/hostmem'
          'echo "*/5 * * * * $HOME/hostmem/cgroup_mem.sh" >> /etc/crontab'
        ]
      }
    ]
    distribute: [
      {
        type: 'SharedImage'
        runOutputName: runOutputName
        galleryImageId: galleryImageId
        replicationRegions: [
          location
        ]
        storageAccountType: 'Standard_LRS'
      }
    ]
    stagingResourceGroup: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${stagingResourceGroupName}'
    source: {
      type: 'PlatformImage'
      publisher: publisher
      offer: offer
      sku: sku
      version: version
    }
    validate: {}
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: 0
    }
  }
}
