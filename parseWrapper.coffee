#!/usr/bin/env coffee

# ref http://kapeli.com/docsets

fs = require 'fs'
path = require 'path'
glob = require 'glob'
xpath = require 'xpath'
Dom = require('xmldom').DOMParser
sqlite3 = require('sqlite3').verbose()

{
  parse,
  filePattern,
  parseFile,
  parseContent
} = require process.cwd() + '/parse'
docsetName = process.env.DOCSET_NAME
docsFolder = process.env.DOCSET_DOCS_FOLDER
console.error process.cwd() + '/' + process.env.DOCSET_SQL_DB
db = new sqlite3.Database process.cwd() + '/' + process.env.DOCSET_SQL_DB

unless filePattern?
  filePattern = "*.html"
  parseFile ?= (content) ->
    new Dom().parseFromString content, 'text/html'

makeInsertFun = ({db, filename, root}) ->
  defaultRoot = root
  ({root, x, type, nameFun, typeFun, pathFun}) ->
    root ?= defaultRoot
    nodes = xpath.select x, root
    stmt = db.prepare 'INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?, ?, ?);'
    for node in nodes
      values = {}
      try values.name = nameFun node
      catch e
        console.log e
        continue

      try values.type = typeFun node
      catch e
        console.log e
        continue

      try values.path = filename + '#' + pathFun node
      catch e
        console.log e
        continue

      stmt.on 'error', (err) -> console.log err
      stmt.run [values.name, values.type, values.path]
    stmt.finalize()


#

parse ?= ({docsetName, db, docsFolder, filePattern}) ->
  filenames = glob.sync "#{docsFolder}/#{filePattern}"

  db.serialize () ->
    db.run 'DROP TABLE IF EXISTS searchIndex;'
    db.run 'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);'
    db.run 'CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);'

    for filename in filenames
      relativeFilename = path.relative docsFolder, filename
      insert = makeInsertFun {
        db
        filename: relativeFilename
        root: parseFile fs.readFileSync filename, 'ascii'
      }

      parseContent {docsetName, db, docsFolder, filename: relativeFilename, root, insert, xpath}


  db.close()


parse {docsetName, db, docsFolder, filePattern}
