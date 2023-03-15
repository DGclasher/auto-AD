
param([Parameter(Mandatory=$true)] $OutputJSON,[Parameter(Mandatory=$true)] $domain ,[Parameter(Mandatory=$true)] $groupNames, [Parameter(Mandatory=$true)] $firstNames, [Parameter(Mandatory=$true)] $lastNames, [Parameter(Mandatory=$true)] $Passwords)

$group_names = [System.Collections.ArrayList](Get-Content $groupNames) 
$first_names = [System.Collections.ArrayList](Get-Content $firstNames)
$last_names = [System.Collections.ArrayList](Get-Content $lastNames)
$passwords= [System.Collections.ArrayList](Get-Content $Passwords)

write-host $group_names

$groups = @()         
$users = @()
$num_groups = $group_names.Count
$num_users = $first_names.Count

for( $i=0; $i -lt $num_groups; $i++ ){
    $new_group = (Get-Random -InputObject $group_names)
    $groups += @{ "name" = "$new_group"}
    $group_names.Remove($new_group)
}

for( $i=0; $i -lt $num_users; $i++ ){
    $full_name = (Get-Random -InputObject $first_names) + " " + (Get-Random -InputObject $last_names)
    $password = (Get-Random -InputObject $passwords)
    $temp_list = @()
    $new_user = @{
        "name"="$full_name";
        "password"="$password";
        "groups"=$temp_list + ( Get-Random -InputObject $groups.name )
    }
    $users += $new_user
    $first_names.Remove($new_user.name.Split(" ")[0])
    $last_names.Remove($new_user.name.Split(" ")[1])
}

@{
    "domain"=$domain
    "groups"=$groups
    "users"=$users
} | ConvertTo-JSON | Out-File $OutputJSON

