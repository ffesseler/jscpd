
TokenizerCoffee = require './TokenizerCoffee'
TokenizerCodeMirror = require './TokenizerCodeMirror'

class TokenizerFactory

  tokenizers: {}

  LANGUAGES:
    javascript: ['js']
    coffeescript: ['coffee']
    ruby: ['rb']
    php: ['php', 'phtml']
    python: ['py']
    less: ['less']
    java: ['java']
    csharp: ['cs']
    csrc: ['c']
    "c++src": ['cpp']


  getLanguageByExtension: (extension) ->
    for language of TokenizerFactory::LANGUAGES
      return language if extension in TokenizerFactory::LANGUAGES[language]
    return no

  getExtensionsByLanguages: (languages) ->
    languages = [languages] if typeof languages is 'string'
    result = []
    result.push TokenizerFactory::LANGUAGES[language]... for language of TokenizerFactory::LANGUAGES when language in languages
    return result

  makeTokenizer: (filename, supportedLanguages) ->
    matches = filename.match /\.(\w*)$/
    extension = matches[1]?.toLowerCase()

    language = TokenizerFactory::getLanguageByExtension extension

    return off if language not in supportedLanguages

    if language not of TokenizerFactory::tokenizers
      switch language
        when "coffeescript"
          TokenizerFactory::tokenizers[language] = new TokenizerCoffee()
        when "csharp", "java", "csrc", "c++src"
          TokenizerFactory::tokenizers[language] =  new TokenizerCodeMirror()
          TokenizerFactory::tokenizers[language].setType "text/x-#{language}"
        else
          TokenizerFactory::tokenizers[language] = new TokenizerCodeMirror()
          TokenizerFactory::tokenizers[language].setType language

    TokenizerFactory::tokenizers[language]

module.exports = TokenizerFactory