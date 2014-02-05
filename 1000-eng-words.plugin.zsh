THOUSAND_ENG_WORDS_FILE=$(cd "$(dirname "$0")"; pwd)/1000-eng-words.tsv

function thousand_eng_words_prompt() {
	echo "$(ruby -e "puts File.readlines('$THOUSAND_ENG_WORDS_FILE').sample" | awk -F"\t" '{ print "\033[33;40m" $1 " " $2 "\033[31;40m" " - " "\033[33;40m" $3 "\033[0m" }')"
}