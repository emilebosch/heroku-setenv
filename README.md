# Heroku SetEnv

### Proposal

Solves the pain of multiple env vars

- Allows setting env for services (prod/dev/staging/etc)
- Allows encryption fo env so safe to check in to git

To use:

- Define services (with staging/production/etc)
- Apply environments

### Update a environment with its dev

Update `development` with current services set all to `.dev`. This basically collects the .dev for the development. Does a diff. And then applies the changes in one go.

```
setenv apply development 
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
Staging runs:

- DB [PROD] * WARNING: Different! *
- Mailchimp [STAGING]
- ES [STAGING]

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
./env/mailchimp.production.yml
./env/mailchimp.staging.yml
./env/mailchimp.development.yml
```

