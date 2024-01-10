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

var akseeVersion = '1.5.203.0'

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
    buildTimeoutInMinutes: 120
    customize: [
      // {
      //   type: 'PowerShell'
      //   name: 'InstallWindosPerformanceToolkit'
      //   runElevated: true
      //   inline: [
      //     'Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=2165884 -OutFile \'C:\\Program Files\\adksetup.exe\''
      //     'cd \'C:\\Program Files\'; .\\adksetup.exe /quiet /installpath "C:\\Program Files\\ADK" /features OptionId.WindowsPerformanceToolkit'
      //     'do {'
      //     '    if (-not (Test-Path \'C:\\Program Files (x86)\\ADK\')) {'
      //     '        Write-Host "Not here yet..."'
      //     '        Start-Sleep -s 5'
      //     '        Set-Location "C:\\Program Files\\"'
      //     '        .\\adksetup.exe /quiet /installpath "C:\\Program Files\\ADK" /features OptionId.WindowsPerformanceToolkit'
      //     '    }'
      //     '} until (Test-Path \'C:\\Program Files (x86)\\ADK\');'
      //   ]
      // }
      {
        type: 'PowerShell'
        name: 'ConfigureHostmemUsageCollector'
        runElevated: true
        inline: [
          'New-Item -Path "C:\\" -Name "HostmemLogs" -ItemType Directory'
          'New-Item -Path "C:\\HostmemLogs\\" -Name "traces" -ItemType Directory'
          // '$wpaProfile=@"'
          // '<?xml version="1.0" encoding="utf-8"?>'
          // '<WpaProfileContainer xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="2" xmlns="http://tempuri.org/SerializableElement.xsd">'
          // '  <Content xsi:type="WpaProfile2">'
          // '    <Sessions>'
          // '      <Session Index="0">'
          // '        <FileReferences />'
          // '      </Session>'
          // '    </Sessions>'
          // '    <Views>'
          // '      <View Guid="e9d4eb40-90b4-44f4-a13a-8f1ed5f40ebc" IsVisible="true" Title="Analysis">'
          // '        <Graphs>'
          // '          <Graph Guid="00c2282d-6788-482d-8528-36c079eabbd5" LayoutStyle="All" GraphHeight="41" IsMinimized="false" IsShown="true" IsExpanded="false">'
          // '            <Preset Name="Default" GraphChartType="StackedBars" BarGraphIntervalCount="50" IsThreadActivityTable="false" GraphColumnCount="24" KeyColumnCount="8" LeftFrozenColumnCount="0" RightFrozenColumnCount="22" InitialFilterQuery="[MMList]:=&quot;Active&quot; AND [Description]:~!&quot;Etw&quot; AND [Page Category]:&lt;&gt;&quot;DriverLockedSystemPage&quot;" InitialFilterShouldKeep="true" InitialSelectionQuery="[Process]:&lt;&gt;&quot;N/A&quot; AND [Process]:~!&quot;Unknown&quot;" GraphFilterColumnGuid="6e63a987-cd12-5a9a-5e70-9088e2257c22" GraphFilterTopValue="0" GraphFilterThresholdValue="0">'
          // '              <MetadataEntries>'
          // '                <MetadataEntry Guid="178499e0-0b63-50e3-a0eb-069a4f238b50" Name="Snapshot Time" ColumnMetadata="StartTime" />'
          // '              </MetadataEntries>'
          // '              <HighlightEntries />'
          // '              <Columns>'
          // '                <Column Guid="62ce55c1-be7f-5593-c162-f7835bfe68b9" Name="Snapshot Description" SortPriority="1" Width="300" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="12a20458-b588-5d3f-a154-c23d2902d52f" Name="Process Name" SortPriority="2" Width="150" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="60269832-0d29-5f0f-a9b2-c65ee9d0b1cf" Name="Process" SortPriority="3" Width="150" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="15a3f76b-6dc3-5d57-4b45-39f86b2c4314" Name="MMList" SortPriority="4" Width="72" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="681c68ba-3371-59d2-d155-641aa268d2a9" Name="Page Category" SortPriority="5" Width="150" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="c7de38ec-9f55-55ef-e8f9-8a031772672e" Name="Description" SortPriority="6" Width="438" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="3034dcdd-0329-58bc-61f2-115fcd84fe55" Name="Page Priority" SortPriority="7" TextAlignment="Right" Width="85" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="cb796d44-2927-5ac1-d231-4b71904c18f5" Name="Thread Name" SortPriority="8" Width="80" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="82ddfdff-ee93-5f35-08ac-4705069618dc" Name="Thread Activity Tag" SortPriority="9" Width="80" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="2818954f-2d30-5569-4510-dade0a5a605c" Name="Annotation" SortPriority="10" Width="80" IsVisible="false">'
          // '                  <AnnotationsOptionsParameter>'
          // '                    <AnnotationQueryEntries />'
          // '                  </AnnotationsOptionsParameter>'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="6e63a987-cd12-5a9a-5e70-9088e2257c22" Name="Page Count" AggregationMode="Count" SortPriority="11" TextAlignment="Right" Width="100" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="f4f584e0-33bc-5517-77bd-dae2f940ac00" Name="Virtual Address" SortPriority="12" TextAlignment="Right" Width="145" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="42df8dc9-60e7-59c2-ecae-fda0952dd2f1" Name="Path Tree" SortPriority="13" Width="200" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="aa70bdc4-c2a7-5d49-36f4-1e250efe3af8" Name="File Offset" SortPriority="14" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="0763aa32-188b-58b3-4e4c-d04cc8df47eb" Name="Thread Id" SortPriority="15" TextAlignment="Right" Width="120" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="841e7647-2e80-5a6f-e5a6-4a74ff30e620" Name="Session Key" SortPriority="16" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="c398ca4c-ed67-5897-3a88-ff8ed176f82b" Name="Pinned" SortPriority="17" TextAlignment="Right" Width="70" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="c872a259-e76f-5ab5-5ebb-72d4f61304ad" Name="Page Frame Number" SortPriority="19" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="f6473d30-eeb7-5497-d5d6-5ebc6e8d2798" Name="In Use/Standby" SortPriority="20" Width="100" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="cdaaa064-27ac-52e3-5570-a62011511464" Name="Extra Info" SortPriority="21" Width="70" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="178499e0-0b63-50e3-a0eb-069a4f238b50" Name="Snapshot Time" AggregationMode="Min" SortPriority="18" TextAlignment="Right" Width="100" CellFormat="sN" IsVisible="true">'
          // '                  <DateTimeTimestampOptionsParameter DateTimeEnabled="true" DateTimeMode="LocalTrace" />'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="5af4cb99-abdf-4ced-b092-440160c940c2" Name="Size" AggregationMode="Sum" SortOrder="Descending" SortPriority="0" TextAlignment="Right" Width="70" CellFormat="MB" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '              </Columns>'
          // '            </Preset>'
          // '          </Graph>'
          // '          <Graph Guid="cb079a8b-de14-4516-9f83-6c5695b0845a" LayoutStyle="All" GraphHeight="125" IsMinimized="false" IsShown="true" IsExpanded="false">'
          // '            <Preset Name="Utilization by Category" BarGraphIntervalCount="50" IsThreadActivityTable="false" GraphColumnCount="9" KeyColumnCount="2" LeftFrozenColumnCount="1" RightFrozenColumnCount="8" InitialFilterShouldKeep="true" InitialSelectionQuery="([Series Name]:=&quot;Category&quot; AND ([Category]:=&quot;In Use List&quot; OR [Category]:=&quot;Modified List&quot; OR [Category]:=&quot;Zero and Free Lists&quot; OR [Category]:=&quot;Standby Lists (Total)&quot;))" GraphFilterColumnGuid="4cab50d6-c78a-51ef-4034-ced3dca9b5ce" GraphFilterTopValue="0" GraphFilterThresholdValue="0">'
          // '              <MetadataEntries>'
          // '                <MetadataEntry Guid="8cce8904-07d9-57f3-a2e7-45aefe82cd8d" Name="Time" ColumnMetadata="StartTime" />'
          // '                <MetadataEntry Guid="4cab50d6-c78a-51ef-4034-ced3dca9b5ce" Name="Duration" ColumnMetadata="Duration" />'
          // '              </MetadataEntries>'
          // '              <HighlightEntries />'
          // '              <Columns>'
          // '                <Column Guid="2716c11d-010e-5e24-4943-6e4e772bc63a" Name="Category" SortOrder="Ascending" SortPriority="0" Width="150" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="8cce8904-07d9-57f3-a2e7-45aefe82cd8d" Name="Time" AggregationMode="Min" SortPriority="1" TextAlignment="Right" Width="100" IsVisible="true">'
          // '                  <DateTimeTimestampOptionsParameter DateTimeEnabled="true" DateTimeMode="LocalTrace" />'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="cb796d44-2927-5ac1-d231-4b71904c18f5" Name="Thread Name" SortPriority="2" Width="80" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="82ddfdff-ee93-5f35-08ac-4705069618dc" Name="Thread Activity Tag" SortPriority="3" Width="80" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="2818954f-2d30-5569-4510-dade0a5a605c" Name="Annotation" SortPriority="4" Width="80" IsVisible="false">'
          // '                  <AnnotationsOptionsParameter>'
          // '                    <AnnotationQueryEntries />'
          // '                  </AnnotationsOptionsParameter>'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="4cab50d6-c78a-51ef-4034-ced3dca9b5ce" Name="Duration" AggregationMode="Sum" SortPriority="5" TextAlignment="Right" Width="100" IsVisible="false">'
          // '                  <DurationInViewOptionsParameter TimeStampColumnGuid="8cce8904-07d9-57f3-a2e7-45aefe82cd8d" TimeStampType="Start" InViewEnabled="false" />'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="251239f0-e61e-578d-4898-fcb4ab76b5cf" Name="Size" AggregationMode="Max" SortPriority="6" TextAlignment="Right" Width="100" CellFormat="MB" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '              </Columns>'
          // '            </Preset>'
          // '          </Graph>'
          // '          <Graph Guid="00c2282d-6788-482d-8528-36c079eabbd5" LayoutStyle="All" GraphHeight="125" IsMinimized="false" IsShown="true" IsExpanded="false">'
          // '            <Preset Name="Default" GraphChartType="StackedBars" BarGraphIntervalCount="50" IsThreadActivityTable="false" GraphColumnCount="24" KeyColumnCount="8" LeftFrozenColumnCount="0" RightFrozenColumnCount="22" InitialFilterQuery="[MMList]:=&quot;Active&quot; AND [Description]:~&lt;&quot;Etw&quot; AND [Page Category]:&lt;&gt;&quot;DriverLockedSystemPage&quot;" InitialFilterShouldKeep="true" InitialSelectionQuery="[Process]:&lt;&gt;&quot;N/A&quot; AND [Process]:~!&quot;Unknown&quot;" GraphFilterColumnGuid="6e63a987-cd12-5a9a-5e70-9088e2257c22" GraphFilterTopValue="0" GraphFilterThresholdValue="0">'
          // '              <MetadataEntries>'
          // '                <MetadataEntry Guid="178499e0-0b63-50e3-a0eb-069a4f238b50" Name="Snapshot Time" ColumnMetadata="StartTime" />'
          // '              </MetadataEntries>'
          // '              <HighlightEntries />'
          // '              <Columns>'
          // '                <Column Guid="62ce55c1-be7f-5593-c162-f7835bfe68b9" Name="Snapshot Description" SortPriority="1" Width="300" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="12a20458-b588-5d3f-a154-c23d2902d52f" Name="Process Name" SortPriority="2" Width="150" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="60269832-0d29-5f0f-a9b2-c65ee9d0b1cf" Name="Process" SortPriority="3" Width="150" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="15a3f76b-6dc3-5d57-4b45-39f86b2c4314" Name="MMList" SortPriority="4" Width="72" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="681c68ba-3371-59d2-d155-641aa268d2a9" Name="Page Category" SortPriority="5" Width="150" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="c7de38ec-9f55-55ef-e8f9-8a031772672e" Name="Description" SortPriority="6" Width="438" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="3034dcdd-0329-58bc-61f2-115fcd84fe55" Name="Page Priority" SortPriority="7" TextAlignment="Right" Width="85" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="cb796d44-2927-5ac1-d231-4b71904c18f5" Name="Thread Name" SortPriority="8" Width="80" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="82ddfdff-ee93-5f35-08ac-4705069618dc" Name="Thread Activity Tag" SortPriority="9" Width="80" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="2818954f-2d30-5569-4510-dade0a5a605c" Name="Annotation" SortPriority="10" Width="80" IsVisible="false">'
          // '                  <AnnotationsOptionsParameter>'
          // '                    <AnnotationQueryEntries />'
          // '                  </AnnotationsOptionsParameter>'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="6e63a987-cd12-5a9a-5e70-9088e2257c22" Name="Page Count" AggregationMode="Count" SortPriority="11" TextAlignment="Right" Width="100" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="f4f584e0-33bc-5517-77bd-dae2f940ac00" Name="Virtual Address" SortPriority="12" TextAlignment="Right" Width="145" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="42df8dc9-60e7-59c2-ecae-fda0952dd2f1" Name="Path Tree" SortPriority="13" Width="200" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="aa70bdc4-c2a7-5d49-36f4-1e250efe3af8" Name="File Offset" SortPriority="14" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="0763aa32-188b-58b3-4e4c-d04cc8df47eb" Name="Thread Id" SortPriority="15" TextAlignment="Right" Width="120" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="841e7647-2e80-5a6f-e5a6-4a74ff30e620" Name="Session Key" SortPriority="16" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="c398ca4c-ed67-5897-3a88-ff8ed176f82b" Name="Pinned" SortPriority="17" TextAlignment="Right" Width="70" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="c872a259-e76f-5ab5-5ebb-72d4f61304ad" Name="Page Frame Number" SortPriority="19" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="f6473d30-eeb7-5497-d5d6-5ebc6e8d2798" Name="In Use/Standby" SortPriority="20" Width="100" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="cdaaa064-27ac-52e3-5570-a62011511464" Name="Extra Info" SortPriority="21" Width="70" IsVisible="false">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="178499e0-0b63-50e3-a0eb-069a4f238b50" Name="Snapshot Time" AggregationMode="Min" SortPriority="18" TextAlignment="Right" Width="100" CellFormat="sN" IsVisible="true">'
          // '                  <DateTimeTimestampOptionsParameter DateTimeEnabled="true" DateTimeMode="LocalTrace" />'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '                <Column Guid="5af4cb99-abdf-4ced-b092-440160c940c2" Name="Size" AggregationMode="Sum" SortOrder="Descending" SortPriority="0" TextAlignment="Right" Width="70" CellFormat="MB" IsVisible="true">'
          // '                  <ColorQueryEntries />'
          // '                </Column>'
          // '              </Columns>'
          // '            </Preset>'
          // '          </Graph>'
          // '        </Graphs>'
          // '        <SessionIndices>'
          // '          <SessionIndex>0</SessionIndex>'
          // '        </SessionIndices>'
          // '      </View>'
          // '    </Views>'
          // '    <ModifiedGraphs>'
          // '      <GraphSchema Guid="00c2282d-6788-482d-8528-36c079eabbd5">'
          // '        <ModifiedPresets />'
          // '        <PersistedPresets>'
          // '          <Preset Name="Default" GraphChartType="StackedBars" BarGraphIntervalCount="50" IsThreadActivityTable="false" GraphColumnCount="24" KeyColumnCount="8" LeftFrozenColumnCount="0" RightFrozenColumnCount="22" InitialFilterQuery="[MMList]:=&quot;Active&quot; AND [Description]:~&lt;&quot;Etw&quot; AND [Page Category]:&lt;&gt;&quot;DriverLockedSystemPage&quot;" InitialFilterShouldKeep="true" InitialSelectionQuery="[Process]:&lt;&gt;&quot;N/A&quot; AND [Process]:~!&quot;Unknown&quot;" GraphFilterColumnGuid="6e63a987-cd12-5a9a-5e70-9088e2257c22" GraphFilterTopValue="0" GraphFilterThresholdValue="0">'
          // '            <MetadataEntries>'
          // '              <MetadataEntry Guid="178499e0-0b63-50e3-a0eb-069a4f238b50" Name="Snapshot Time" ColumnMetadata="StartTime" />'
          // '            </MetadataEntries>'
          // '            <HighlightEntries />'
          // '            <Columns>'
          // '              <Column Guid="62ce55c1-be7f-5593-c162-f7835bfe68b9" Name="Snapshot Description" SortPriority="1" Width="300" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="12a20458-b588-5d3f-a154-c23d2902d52f" Name="Process Name" SortPriority="2" Width="150" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="60269832-0d29-5f0f-a9b2-c65ee9d0b1cf" Name="Process" SortPriority="3" Width="150" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="15a3f76b-6dc3-5d57-4b45-39f86b2c4314" Name="MMList" SortPriority="4" Width="72" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="681c68ba-3371-59d2-d155-641aa268d2a9" Name="Page Category" SortPriority="5" Width="150" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="c7de38ec-9f55-55ef-e8f9-8a031772672e" Name="Description" SortPriority="6" Width="438" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="3034dcdd-0329-58bc-61f2-115fcd84fe55" Name="Page Priority" SortPriority="7" TextAlignment="Right" Width="85" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="cb796d44-2927-5ac1-d231-4b71904c18f5" Name="Thread Name" SortPriority="8" Width="80" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="82ddfdff-ee93-5f35-08ac-4705069618dc" Name="Thread Activity Tag" SortPriority="9" Width="80" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="2818954f-2d30-5569-4510-dade0a5a605c" Name="Annotation" SortPriority="10" Width="80" IsVisible="false">'
          // '                <AnnotationsOptionsParameter>'
          // '                  <AnnotationQueryEntries />'
          // '                </AnnotationsOptionsParameter>'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="6e63a987-cd12-5a9a-5e70-9088e2257c22" Name="Page Count" AggregationMode="Count" SortPriority="11" TextAlignment="Right" Width="100" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="f4f584e0-33bc-5517-77bd-dae2f940ac00" Name="Virtual Address" SortPriority="12" TextAlignment="Right" Width="145" CellFormat="x" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="42df8dc9-60e7-59c2-ecae-fda0952dd2f1" Name="Path Tree" SortPriority="13" Width="200" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="aa70bdc4-c2a7-5d49-36f4-1e250efe3af8" Name="File Offset" SortPriority="14" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="0763aa32-188b-58b3-4e4c-d04cc8df47eb" Name="Thread Id" SortPriority="15" TextAlignment="Right" Width="120" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="841e7647-2e80-5a6f-e5a6-4a74ff30e620" Name="Session Key" SortPriority="16" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="c398ca4c-ed67-5897-3a88-ff8ed176f82b" Name="Pinned" SortPriority="17" TextAlignment="Right" Width="70" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="c872a259-e76f-5ab5-5ebb-72d4f61304ad" Name="Page Frame Number" SortPriority="19" TextAlignment="Right" Width="100" CellFormat="x" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="f6473d30-eeb7-5497-d5d6-5ebc6e8d2798" Name="In Use/Standby" SortPriority="20" Width="100" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="cdaaa064-27ac-52e3-5570-a62011511464" Name="Extra Info" SortPriority="21" Width="70" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="178499e0-0b63-50e3-a0eb-069a4f238b50" Name="Snapshot Time" AggregationMode="Min" SortPriority="18" TextAlignment="Right" Width="100" CellFormat="sN" IsVisible="true">'
          // '                <DateTimeTimestampOptionsParameter DateTimeEnabled="true" DateTimeMode="LocalTrace" />'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="5af4cb99-abdf-4ced-b092-440160c940c2" Name="Size" AggregationMode="Sum" SortOrder="Descending" SortPriority="0" TextAlignment="Right" Width="70" CellFormat="MB" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '            </Columns>'
          // '          </Preset>'
          // '        </PersistedPresets>'
          // '      </GraphSchema>'
          // '      <GraphSchema Guid="cb079a8b-de14-4516-9f83-6c5695b0845a">'
          // '        <ModifiedPresets />'
          // '        <PersistedPresets>'
          // '          <Preset Name="Utilization by Category" BarGraphIntervalCount="50" IsThreadActivityTable="false" GraphColumnCount="9" KeyColumnCount="2" LeftFrozenColumnCount="1" RightFrozenColumnCount="8" InitialFilterShouldKeep="true" InitialSelectionQuery="([Series Name]:=&quot;Category&quot; AND ([Category]:=&quot;In Use List&quot; OR [Category]:=&quot;Modified List&quot; OR [Category]:=&quot;Zero and Free Lists&quot; OR [Category]:=&quot;Standby Lists (Total)&quot;))" GraphFilterColumnGuid="4cab50d6-c78a-51ef-4034-ced3dca9b5ce" GraphFilterTopValue="0" GraphFilterThresholdValue="0">'
          // '            <MetadataEntries>'
          // '              <MetadataEntry Guid="8cce8904-07d9-57f3-a2e7-45aefe82cd8d" Name="Time" ColumnMetadata="StartTime" />'
          // '              <MetadataEntry Guid="4cab50d6-c78a-51ef-4034-ced3dca9b5ce" Name="Duration" ColumnMetadata="Duration" />'
          // '            </MetadataEntries>'
          // '            <HighlightEntries />'
          // '            <Columns>'
          // '              <Column Guid="2716c11d-010e-5e24-4943-6e4e772bc63a" Name="Category" SortOrder="Ascending" SortPriority="0" Width="150" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="8cce8904-07d9-57f3-a2e7-45aefe82cd8d" Name="Time" AggregationMode="Min" SortPriority="1" TextAlignment="Right" Width="100" IsVisible="true">'
          // '                <DateTimeTimestampOptionsParameter DateTimeEnabled="true" DateTimeMode="LocalTrace" />'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="cb796d44-2927-5ac1-d231-4b71904c18f5" Name="Thread Name" SortPriority="2" Width="80" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="82ddfdff-ee93-5f35-08ac-4705069618dc" Name="Thread Activity Tag" SortPriority="3" Width="80" IsVisible="false">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="2818954f-2d30-5569-4510-dade0a5a605c" Name="Annotation" SortPriority="4" Width="80" IsVisible="false">'
          // '                <AnnotationsOptionsParameter>'
          // '                  <AnnotationQueryEntries />'
          // '                </AnnotationsOptionsParameter>'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="4cab50d6-c78a-51ef-4034-ced3dca9b5ce" Name="Duration" AggregationMode="Sum" SortPriority="5" TextAlignment="Right" Width="100" IsVisible="false">'
          // '                <DurationInViewOptionsParameter TimeStampColumnGuid="8cce8904-07d9-57f3-a2e7-45aefe82cd8d" TimeStampType="Start" InViewEnabled="false" />'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '              <Column Guid="251239f0-e61e-578d-4898-fcb4ab76b5cf" Name="Size" AggregationMode="Max" SortPriority="6" TextAlignment="Right" Width="100" CellFormat="MB" IsVisible="true">'
          // '                <ColorQueryEntries />'
          // '              </Column>'
          // '            </Columns>'
          // '          </Preset>'
          // '        </PersistedPresets>'
          // '      </GraphSchema>'
          // '    </ModifiedGraphs>'
          // '  </Content>'
          // '</WpaProfileContainer>'
          // '"@'
          'Set-content -Path C:\\HostmemLogs\\traces\\hostmemusage.wpaProfile -Value $wpaProfile -Force'
        ]
      }
      {
        type: 'PowerShell'
        name: 'RegisterHostMemCollectorScript'
        runElevated: true
        inline: [
          'Register-ScheduledJob -Name "Collect-HostmemUsage" -RunEvery (New-TimeSpan -Minutes 4) -ScriptBlock {'
             'wpr -start ResidentSet'
             'Start-sleep -Seconds 60'
             'wpr -stop C:\\HostmemLogs\\traces\\residentset.etl'
             'wpaexporter C:\\HostmemLogs\\traces\\residentset.etl -profile C:\\HostmemLogs\\traces\\hostmemusage.wpaProfile -outputFolder C:\\HostmemLogs -delimiter "|"'
          '}'
        ]
      }
      {
        type: 'PowerShell'
        name: 'InstallAzureCLI'
        runElevated: true
        inline: [
          '$ProgressPreference = \'SilentlyContinue\'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList \'/I AzureCLI.msi /quiet\'; Remove-Item .\\AzureCLI.msi'
        ]
      }
      // {
      //   type: 'PowerShell'
      //   runElevated: true
      //   name: 'AzSetup'
      //   inline: [
      //     'Invoke-WebRequest -Uri https://secure.globalsign.net/cacert/Root-R1.crt -OutFile c:\\globalsignR1.crt'
      //     'Import-Certificate -FilePath c:\\globalsignR1.crt -CertStoreLocation Cert:\\LocalMachine\\Root'
      //   ]
      // }
      // {
      //   type: 'PowerShell'
      //   name: 'DownloadAksEdgeModules'
      //   runElevated: true
      //   inline: [
      //     '$ProgressPreference = \'SilentlyContinue\''
      //     'Set-ExecutionPolicy Bypass -Scope LocalMachine -Force'
      //     '$installDir=\'C:\\scripts\\aksedge\'; New-Item -Path "$installDir" -ItemType Directory | Out-Null'          
      //     'Write-Host "Step 1 : Azure/AKS-Edge repo setup"'
      //     '$outFile = $installDir + \'\\AKS-Edge.zip\'; Invoke-WebRequest -Uri https://github.com/Azure/AKS-Edge/archive/refs/tags/${akseeVersion}.zip -OutFile $outFile'
      //     'Expand-Archive -Path $outFile -DestinationPath $installDir -Force'
      //     '$aksedgeShell = (Get-ChildItem -Path "$installDir" -Filter AksEdgeShell.ps1 -Recurse).FullName; . $aksedgeShell'
      //   ]
      // }
      // {
      //   type: 'PowerShell'
      //   name: 'PrepAksEEConfig'
      //   runElevated: true
      //   inline: [
      //     'Write-Host "Step 2 : Create config files"'
      //     '$installDir=\'C:\\scripts\\aksedge\''
      //     '$productName = "AKS Edge Essentials - K3s"'
      //     '$networkplugin = "flannel"'
      //     '$aksedgeConfig = @"'
      //     '{'
      //         '"SchemaVersion": "1.9",'
      //         '"Version": "1.0",'
      //         '"DeploymentType": "SingleMachineCluster",'
      //         '"Init": {'
      //             '"ServiceIPRangeSize": 10'
      //         '},'
      //         '"Network": {'
      //             '"NetworkPlugin": "$networkplugin",'
      //             '"InternetDisabled": false'
      //         '},'
      //         '"User": {'
      //             '"AcceptEula": true,'
      //             '"AcceptOptionalTelemetry": true'
      //         '},'
      //         '"Machines": ['
      //             '{'
      //                 '"LinuxNode": {'
      //                     '"CpuCount": 4,'
      //                     '"MemoryInMB": 8192,'
      //                     '"DataSizeInGB": 30,'
      //                     '"LogSizeInGB": 4'
      //                 '}'
      //             '}'
      //         ']'
      //     '}'
      //     '"@'
      //     '$aksConfigPath=$installDir+\'\\aksedge-config.json\''
      //     'Set-Content -Path $aksConfigPath -Value $aksedgeConfig -Force'
      //     '$aideuserConfig = @"'
      //     '{'
      //         '"SchemaVersion": "1.1",'
      //         '"Version": "1.0",'
      //         '"AksEdgeProduct": "$productName",'
      //         '"AksEdgeProductUrl": "",'
      //         '"Azure": {'
      //             '"SubscriptionName": "",'
      //             '"SubscriptionId": "",'
      //             '"TenantId": "",'
      //             '"ResourceGroupName": "aksedge-rg",'
      //             '"ServicePrincipalName": "aksedge-sp",'
      //             '"Location": "",'
      //             '"CustomLocationOID":"",'
      //           ' "Auth":{'
      //                 '"ServicePrincipalId":"",'
      //                 '"Password":""'
      //             '}'
      //         '},'
      //         '"AksEdgeConfigFile": "C:\\\\scripts\\\\aksedge\\\\aksedge-config.json"'
      //     '}'
      //     '"@'
      //     '$aideuserConfigPath=$installDir+\'\\aide-userconfig.json\''
      //     'Set-Content -Path $aideuserConfigPath -Value $aideuserConfig -Force'
      //   ]
      // }
      // {
      //   type: 'WindowsRestart'
      //   name: 'StartAKSEdgeInstall-EnableHyperV'
      //   restartTimeout: '15m'
      //   restartCommand: 'powershell.exe $installDir=\'C:\\scripts\\aksedge\'; $aksedgeShell = (Get-ChildItem -Path "$installDir" -Filter AksEdgeShell.ps1 -Recurse).FullName; . $aksedgeShell; Start-AideWorkflow -jsonFile C:\\scripts\\aksedge\\aide-userconfig.json'
      // }
      // {
      //   type: 'PowerShell'
      //   name: 'ResumeInstall'
      //   runElevated: true
      //   inline: [
      //     '$ConfirmPreference = \'None\'; $ErrorActionPreference = \'Stop\''
      //     '$installDir=\'C:\\scripts\\aksedge\''
      //     'Write-Host "Resume Step 3: install of AKS Edge Essentials after restart"'
      //     '$aksedgeShell = (Get-ChildItem -Path "$installDir" -Filter AksEdgeShell.ps1 -Recurse).FullName; . $aksedgeShell;'
      //     'Start-AideWorkflow -jsonFile C:\\scripts\\aksedge\\aide-userconfig.json'
      //   ]
      // }
      // {
      //   type: 'PowerShell'
      //   runElevated: true
      //   name: 'SaveKubeConfig-InstallLocalPathProv'
      //   inline: [
      //     'Write-Host "Step 4: Save kubeconfig to c:\\scripts"'
      //     'Get-AksEdgeKubeConfig -KubeConfigPath C:\\Scripts -Confirm:$false'
      //     'kubectl get pods -A --kubeconfig C:\\Scripts\\config'
      //     'kubectl get nodes --kubeconfig C:\\Scripts\\config'
      //     'kubectl apply -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/local-path-storage.yaml --kubeconfig C:\\Scripts\\config'
      //   ]
      // }
      // {
      //   type: 'PowerShell'
      //   runElevated: true
      //   name: 'CleanupAksRepo'
      //   inline: [
      //     'Write-Host "Step 5: Cleanup repo files. Leave config files"'
      //     'Remove-Item -LiteralPath C:\\scripts\\aksedge\\AKS-Edge-${akseeVersion} -Force -Recurse'
      //     'Remove-Item -LiteralPath C:\\scripts\\aksedge\\AKS-Edge.zip -Force'
      //   ]
      // }
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
