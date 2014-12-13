# Heroku SetEnv

Manage heroku environment variables a bit easier. 

Dependencies:

- GPG
- Heroku Toolbelt
- Git


## Usage

Add this to your bundle and run `bundle install`

```
gem 'setenv'
```

To init:

```
bundle exec setenv init
```

This creates an `env` directory, adds env to `.gitignore` and exports the existing heroku configuration settings to yaml files. It will infer your apps from your existing git remotes using magic.

Now, let's say you want to update a variable on your heroku remote staging. Go and edit `./env/staging.yaml` to include your changes. 

Then run `plan`, to let `setnenv` it figure out what to update, remove or delete from your existing heroku environment variables.

```
bundle exec setenv plan staging
```

It will write out a plan file, hashed with the remote and local config in order to ensure that when the plan file runs. It's in the same state as when it's made. 

Then run:

```
bundle exec setenv apply staging
```

to update the environment.

Then when this is all done, and you are done with 

```
bundle exec setenv encrypt
```

Check in your stuff :)

And next time you can run `bundle exec setenv decrypt`

