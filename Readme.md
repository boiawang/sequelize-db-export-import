# Sequelize-DB-Export-Import

[![Build Status][travis-image]][travis-url]

Generate models files from db or generate tables from models.

Only mysql

## Install

```
npm install -g sequelize-db-export-import
```

## Usage

```
seq-ei Create models by database or Create tables by models

-h, --help            output usage information
-V, --version         output the version number
-r, --reverse         is generate model files or generate tables
-H, --host <n>        host ip default: 127.0.0.1
-u, --user <n>        host user default: root
-p, --password <n>    host password. default: ""
-d, --database <n>    database name
-o, --output <dir>    select models dir
-m, --dialect <n>     db type
-P, --port <n>        db port. default: 3306
-e, --compile <type>  model file type
-c, --config <file>   config file
-s, --space <n>       you can select 2 space or 4 space
```

### export models from db

```
seq-ei -H 192.168.1.220 -u root -p 123 -d test -o ./models -m mysql -P 3306 -e coffee -s 2
```

### import tables from model files

```
seq-ei -r -H 192.168.1.220 -u root -p 123 -d test -o ./models -m mysql -P 3306 -e coffee -s 2
```

### also use config file

config.json
```
{
  "user": "root",
  "password": "",
  "host": "127.0.0.1",
  "database": "test",
  "dir": "./models",
  "port": 3306,
  "compile": "coffee",
  "logging": false,
  "space": 2,
  "reverse": false
}
```

```
seq-ei -c config.json
```

## Test

```
# test all
make test

# test coverage
make test-cov

# test watch
make test-watch
```

### Todo

* postgres
* add cmd color
* add table output

## License

The MIT License

[travis-image]: https://travis-ci.org/boiawang/sequelize-db-export-import.svg
[travis-url]: https://travis-ci.org/boiawang/sequelize-db-export-import
[coveralls-image]: https://img.shields.io/coveralls/boiawang/sequelize-db-export-import.svg?style=flat
[coveralls-url]: https://coveralls.io/r/boiawang/sequelize-db-export-import?branch=master
