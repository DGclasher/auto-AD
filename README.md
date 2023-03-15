# Automate User and Group Creation in AD

## Description

These scripts are intended to be used in Active Directory testing environment where one can create multiple users and groups provided the JSON schema, dont't use these scripts in actual AD environments. 

## User Creation

+ The [gen_users.ps1](./scripts/create_users/gen_users.ps1) creates users on Domain Controller taking the inputs from a JSON file,  sample JSON file [here](./scripts/create_users/sample_ad_schema.json) 

    ```
    ./gen_users.ps1 [JSON File] 
    ```

## Generate JSON file with random data from given list

+ The [randomize.ps1](./scripts/randomize_user_creation/randomize.ps1) creates a JSON file in format of the requirements of [gen_users.ps1](./scripts/create_users/gen_users.ps1) with arguements as domain name, group names list, first name list, last name list and passwords list

    ```
    ./randomize.ps1 [Output File Name].json [Domain Name] [Group Names].txt [First Names].txt [Last Names].txt [Passwords].txt
    ```
