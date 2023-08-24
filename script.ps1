#################################################################
#list all teams with less than X owners
#Martin Löffler 
#24.08.2023
#################################################################

# connect to teams with teams admin role 
Connect-MicrosoftTeams 

# get owner limit
$ownersLimit = Read-Host "List all teams with less or equal amount of owners (for teams without owners enter 0)"

# get all teams
$teams = Get-Team

# all teams with matching the limit
$result = New-Object System.Data.Datatable
[void]$result.Columns.Add("TeamName")
[void]$result.Columns.Add("OwnersCount")
[void]$result.Columns.Add("TotalMembersCount")
[void]$result.Columns.Add("TeamVisibility")
[void]$result.Columns.Add("TeamArchived")
[void]$result.Columns.Add("TeamDescription")
[void]$result.Columns.Add("TeamGroupId")

Write-Host "`nscript is running. please wait because it will take a while...`n"

foreach ($team in $teams){
 $teamMember = Get-TeamUser -GroupId $team.GroupId -Role Owner
 if ($teamMember.Count -le $ownersLimit){
   Write-Host "team found matching your search criteria"
   $totalTeamMembers = Get-TeamUser -GroupId $team.GroupId
   [void]$result.Rows.Add($team.DisplayName,$teamMember.Count,$totalTeamMembers.Count,$team.Visibility,$team.Archived,$team.Description,$team.GroupId)
 }
}

# print result table 
$result | Format-Table -AutoSize -Force -Wrap

Write-Host $result.TeamName.Count "Teams gefunden"

# export as csv
$result | Export-Csv C:\temp\TeamsWithTooLessOwners.csv -NoType

Write-Host "`nscript finished`n"