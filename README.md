# Install

![1000-eng-words](http://maxd.github.io/1000-eng-words/screenshot-01.png)

1. Enable plugin in `~/.zshrc`:

~~~
plugins=(..... 1000-eng-words .....)
~~~

1. Change command prompt in `~/.zshrc`:

~~~
PROMPT='$(thousand_eng_words_prompt) '$PROMPT
~~~