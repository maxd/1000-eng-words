require 'optparse'

class ApplicationSettings

  def initialize
    settings_directory = File.expand_path('~/.1000-eng-words')
    Dir.mkdir(settings_directory) unless Dir.exists?(settings_directory)

    @last_word_file = File.join(settings_directory, 'last_word')
    @excluded_words_file = File.join(settings_directory, 'excluded_words')
  end

  def last_word
    @last_word ||= (File.exists?(@last_word_file) ? File.read(@last_word_file).strip : nil)
  end

  def last_word=(val)
    File.write(@last_word_file, val)
    @last_word = val
  end

  def last_word_modified_recently?
    File.exists?(@last_word_file) ? Time.now - File.mtime(@last_word_file) < 0.4 : false
  end

  def excluded_words
    @excluded_words ||= (File.exists?(@excluded_words_file) ? File.readlines(@excluded_words_file).map(&:strip) : [])
  end

  def excluded_words=(val)
    File.write(@excluded_words_file, val.join("\n"))
    @excluded_words = val
  end

end

class Application

  def initialize(argv)
    @options = {
        color: false
    }

    @options_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: main.rb <COMMAND> [options]'

      opts.separator ''
      opts.separator 'Commands:'
      opts.separator '        random [--color]             Display random English word'
      opts.separator '        exclude                      Exclude last English word'
      opts.separator ''
      opts.separator 'Options:'

      opts.on '--color', 'Highlight English word' do
        @options[:color] = true
      end
    end

    @options[:command] = (argv[0] || '').to_sym

    @options_parser.parse!
  end

  def run
    settings = ApplicationSettings.new

    case @options[:command]
      when :random
        random_command(settings)
      when :exclude
        exclude_command(settings)
      else
        puts @options_parser
        exit 1
    end
  end

  def random_command(settings)
    dictionary_file = File.expand_path('../../dictionaries/top-1000.tsv', __FILE__)
    dictionary = File.readlines(dictionary_file)

    word = nil
    transcription = nil
    translation = nil

    if settings.last_word_modified_recently?
      word, transcription, translation = dictionary.find {|line| line.start_with?(settings.last_word + "\t") }.strip.split(/\t/)
    else
      10.times do
        word, transcription, translation = dictionary.sample.strip.split(/\t/)
        break unless settings.excluded_words.include?(word)
      end
    end

    if @options[:color]
      yellow = "\e[33m"
      red = "\e[31m"
      reset = "\e[0m"

      print "#{yellow}#{word}#{reset} #{yellow}#{transcription}#{reset} #{red}-#{reset} #{yellow}#{translation}#{reset}"
    else
      print "#{word} #{transcription} - #{translation}"
    end

    settings.last_word = word
  end

  def exclude_command(settings)
    settings.excluded_words = (settings.excluded_words + [settings.last_word]).uniq
  end

end

Application.new(ARGV).run