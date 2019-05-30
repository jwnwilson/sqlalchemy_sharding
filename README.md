# SQL Sharding


## Setup

```
brew install pyenv
brew install direnv
brew install pyenv-virtualenv

direnv allow
```

Playing around with sharding from this example I found:

https://gist.github.com/ziplus4/3bf8cc14541a16c65206

Looking at horizontal scaling of database data across multiple db nodes

## How this code works:

This snippet will setup 6 database "nodes" which are just sqlite files these could be sustituted for postgres servers. These are setup with binds which is a key map for sqlalchemy for databases.

The Notice model is matched to the global database node in a straight forward fashion. The user and log models have a regex binding pattern, they are bound to the user and log database nodes. This code expects context managers to be used to set which database nodes to use in the session, when accessing a model or writing the scoped session will attempt to look for a bind in the context stack that matches the model regex. In simple terms a model regex is used to select the possible databases we can use and then hashing on user values gives us the selection of the available databases to use for the data.

I've added a write arguement so that if we need write access available we can select are limited to master nodes, users should be stored randonly across the 2 master nodes. The slaves should not be used in this example as they would be replicated by database mechanisms.

This means we have vertical and horizontal scaling in our sqlalchemy snippet.

### get_tables_for_bind()

This is used to add tables for each database, if a `__bind__` regex pattern matches the name of a database that table will be added to the database, so for example:

```
class User(db.Model):
    __bind_key__ = db.BindingKeyPattern('[^_]+_user_\d\d')

will be added to :
    'master_user_01': 'sqlite:///./master_user_01.db',
    'master_user_02': 'sqlite:///./master_user_02.db',
    'slave_user': 'sqlite:///./slave_user.db',
```

## Setup

To setup python 3 environment for project first install direnv and pyenv on your machine:

brew install pyenv
brew install direnv
brew install pyenv-virtualenv
Copy this .direnvrc to your home directory.

Now when loading a project run direnv allow and a virtual python environment should be setup for the project.

This works with pyenv-virtualenv wrapper: https://github.com/direnv/direnv/wiki/Python#pyenv-virtualenv

We manage our python versions using pyenv: https://github.com/pyenv/pyenv
