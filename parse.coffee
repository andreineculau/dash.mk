module.exports =
  parse: undefined # ({docsetName, db, docsFolder, filePattern}) ->
  filePattern: undefined # '*.html'
  parseFile: undefined # (content) ->
  parseContent: ({db, docsFolder, filename, root, insert, xpath}) ->
    ###
    # Section H2
    insert {
      x: '//h2[contains(@class,"title")][a[@name]]'
      nameFun: (node) ->
        xpath.select('text()', node)[0].nodeValue
      typeFun: (node) ->
        'Section'
      pathFun: (node) ->
        xpath.select('a[1]/@name', node)[0].nodeValue
    }


    # Section H3
    insert {
      x: '//h3[contains(@class,"title")][a[@name]]'
      nameFun: (node) ->
        xpath.select('text()', node)[0].nodeValue
      typeFun: (node) ->
        'Section'
      pathFun: (node) ->
        xpath.select('a[1]/@name', node)[0].nodeValue
    }


    # Example
    insert {
      x: '//div[contains(@class,"example")][a[@name]]'
      nameFun: (node) ->
        xpath.select('p[contains(@class,"title")]/b/text()', node)[0].nodeValue
      typeFun: (node) ->
        'Sample'
      pathFun: (node) ->
        xpath.select('a[1]/@name', node)[0].nodeValue
    }


    # Figure
    insert {
      x: '//div[contains(@class,"figure")][a[@name]]'
      nameFun: (node) ->
        xpath.select('p[contains(@class,"title")]/b/text()', node)[0].nodeValue
      typeFun: (node) ->
        'Guide'
      pathFun: (node) ->
        xpath.select('a[1]/@name', node)[0].nodeValue
    }
    ###
