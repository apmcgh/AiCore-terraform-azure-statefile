# What

**git repo**: apmcgh/AiCore-terraform-azure-statefile   
**author**: Alain Culos   
**licence**: Copyleft   
**warranties**: None, use at your own risk, may involve costs for resource usage, borne by you.   

This repo aims to provide a complete working example of a terraform configuration to:
1. set-up the basic azure infrastructure, using the main account credentials,
   required to start any new terraform project under a pre-set SP (service principal)
   and RG (resource group), and SP credentials managed in a key vault.
1. set-up a sample project using SP credentials, with state file managed on azure storage,
   storage provide by basic set-up step, as above.

The **purpose** is to leave no place for manual configuration.

The **goal** is for this repo to be a simple community learning platform to understand the
fundamental principles and tools to manage credentials (create, store, retrieve) and
state file versioning on cloud storage.

To start with, this will use azure, but later versions may include equivalent constructs for
GCP and AWS.


## Principles:

+ repeatability: automate everything, from scratch, including basic pre-requisites.
+ separation of concerns: separate each logical part into its own directory.
+ keep it simple: a real life scenario might be vastly more complex and require
  multiple repositories. As this is a proof of concept, we keep it all under
  one roof.
+ secrets are secret: under no circumstance should secret credentials ever be stored
  in this repo. That is a key motivation for this experimental project.


## Structure:

The basic infra set-up is kept in directory `tf-infra-setup`.

The project files are kept in the root directory of this repo (`.`).


## Assumptions:

You have:
+ bash (or any shell compatible with the following)
+ git installed and configured
+ An azure account
+ Azure CLI installed
+ Azure CLI authentication completed
+ terraform installed


## Contributions:

Contributions and suggestions are welcome. This is a platform to learn best practices in:
+ terraform configuration and git management thereof
+ secrets management
+ terraform state file management
+ full automation (leave no manual step if it can be helped at all)
+ testing and validation of the above


# How to use this repo:

1. clone this repo.
1. login to your azure account with the CLI.
1. check `tf-infra-setup/variables.tf`, and modify according to your requirements.
1. set-up the basic infra:
   ```
   cd tf-infra-setup
   terraform init
   terraform validate
   terraform plan       # check that all is green
   terraform apply      # untested
   cd ..
   ```
1. set-up the project:
   ```
   # TBD
   echo TBD
   ```

---
---

# TODO

Find out how to use the credentials stored in the key vault to create and manage a
sample terraform project in the given RG, with the given SP.


---
---

# Command history

## Azure set-up

Create files:
```
.
├── main.tf             # work not started
├── README.md           # this file
├── .gitignore          # ignore state files and terraform generated files
└── tf-infra-setup
    ├── main.tf         # first version, untested
    └── variables.tf    # first version, untested
```

Validate infra files:
```
cd tf-infra-setup
terraform init
terraform validate
terraform plan      # all is green
cd ..
```

Create initial repo:
```
git init # branch master
git add .
git commit -m 'Create project AiCore learning - terraform state file on azure - set-up and use'
gh auth status
gh repo create --source . --push --public
```

Create develop branch:
```
git branch develop
git checkout develop
git add .
git commit -m 'Improve README'
```