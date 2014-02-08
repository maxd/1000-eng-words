APP=$(cd "$(dirname "$0")"; pwd)/app/main.rb

function thousand_eng_words_prompt() {
	ruby $APP random --color
}

alias exclude-word='ruby $APP exclude'