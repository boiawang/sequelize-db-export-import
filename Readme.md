# Sequelize-DB-Export-Import

Generate models files from db

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
-s, --space <n>       you can select 2 space or 4 space
```

### export models from db

```
seq-ei -H 192.168.1.220 -u root -p 123 -d test -o ./models -m mysql -P 3306 -e coffee -s 2
```

## import tablse from model files

```
seq-ei -r -H 192.168.1.220 -u root -p 123 -d test -o ./models -m mysql -P 3306 -e coffee -s 2
```

## Test

```
make test 或 npm run test
```

