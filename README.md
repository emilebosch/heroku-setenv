# Heroku SetEnv

WARNING: This is still under development. I wouldn't recommend using it right now.

Dependencies:

- GPG
- Heroku Toolbelt
- Git


### Usage

```
gem install setenv
```
Lets then init. This creates an env directory, adds env to gitignore and epports the existing yamls.

```
setenv init
```

This will create `./env/$remote-name.yml` witht the Heroku config of each remote.

Go to `./env/` edit there on of the production yamls

Then run a plan, to let it figure out what to update, remove or delete.

```
bundle exec setenv plan staging
```

It will write a plan file. Check if you're cool with the changes.

Then run:

```
bundle exec setenv apply staging
```

Then when this is all done:

```
bundle exec setenv encrypt
```

Check in your stuff :)