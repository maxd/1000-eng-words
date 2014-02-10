<p align="center">
![1000-eng-words](http://maxd.github.io/1000-eng-words/screenshot-01.png)
</p>

# Install to oh-my-zsh

1. Clone repository to `~/.oh-my-zsh/plugins`

~~~
cd ~/.oh-my-zsh/plugins
git clone https://github.com/maxd/1000-eng-words.git
~~~

1. Enable plugin in `~/.zshrc`:

~~~
plugins=(..... 1000-eng-words .....)
~~~

1. Change command prompt in `~/.zshrc`:

~~~
PROMPT='$(thousand_eng_words_prompt) '$PROMPT
~~~