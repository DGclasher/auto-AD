param([Parameter(Mandatory=$true)] $JSONfile)

function CreateADGroup(){
	param([Parameter(Mandatory=$true)] $groupObject)
	$name = $groupObject.name
	New-ADGroup -name $name -GroupScope Global
}

function CreateADUser(){
	param([Parameter(Mandatory=$true)] $userObject)

	$name =$userObject.name
	$password = $userObject.password

	# Retrieve the first name last name
	$firstname, $lastname = $name.Split(" ")
	$username = $firstname.ToLower()

	$SamAccountName = $username
	$principalname = $username

	# Create AD user objects
	New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount 
	
	# Add user to groups
	foreach($group_name in $userObject.groups){
		try{
			Get-ADGroup -Identity "$group_name"
			Add-ADGroupMember -Identity $group_name -Members $username
		}
		catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
		{	
			Write-Warning "User $name could'nt be added to the group $group_name cuz it doesn't exists"
		}
	}
}

$json = Get-Content $JSONfile | ConvertFrom-JSON
$Global:Domain = $json.domain

# Loop through gruops and create them
foreach($group in $json.groups){
    CreateADGroup $group
} 

# Loop through users and create them
foreach($user in $json.users){
    CreateADUser $user
} 
