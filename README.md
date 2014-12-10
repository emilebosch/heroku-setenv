# Heroku SetEnv

**OBJECTIVE:** Make environment management easy to manage and prevent clusterfucks. Additionally encrypt enviroment so we can just version it.

- Allows setting env for services (prod/dev/staging/etc)
- Make visible what teh enviroments are runing
- Allows encryption fo env so safe to check in to git
- Optionally prevent boot when env are not set
- Infer environmetns from git heroku remotes

To use:

- Define services (with staging/production/etc)
- Apply environments

### Setting up

```
gem install setenv
```
Lets then init. This creates an env directory and you can setup a password to decrypt.

```
setenv init
```

### Update a environment with its dev ENV variables

Update `development` with current services set all to `.dev`. This basically collects the `.dev` for the development. Does a diff. And then applies the changes in one go.

```
setenv reset development 
```

### Set the staging db to production db.

It wil warn you fail you try to set something to production when you are on an other enviroment than production. You' can skip this
when you add the `--confirm`.

```
setenv set staging db production
```

### Show what staging is running

```
setenv show staging 
```

Output will be:

```
Staging is running:

- DB [PROD] * WARNING: Different! *
- Mailchimp [STAGING]
- ES [STAGING]

Run: `senenv reset staging` to update staging to defaults.

```

### Encrypting

Adding `/env/*.yml` to your gitignore. Makes sure you dont have accidental checkins.
checkins. 

Zips and encrypts the settings with your idrsa

```
setenv crypt
```

Decrypts the settings

```
setenv decrypt
```

## To figure out

Services:

```
- db
- mailchimp
- s3
- es/bonsay
- mandril
- slack
```

Dir structure

```
./env/mailchimp.template.yml
./env/mailchimp.production.yml
./env/mailchimp.staging.yml
./env/mailchimp.development.yml
```

