class GobbleAll
  include GobbleShare
  
  def initialize( rails_root, type, options )
    @rails_root = rails_root
    @options = options
    @text_extractor_type = type
  end

  def execute
    puts "Processing all of: #{@rails_root}"
    puts ""

    if( @text_extractor_type == 'tr8n' )
      execute_tr8n
    else
      execute_i18n      
    end
    
  end
  
  def valid?
    @options.empty?
  end


  private

  def execute_tr8n
    rails_view_directory = "#{@rails_root}/app/views"
    text_extractor = Tr8nTextExtractor.new
    
    Dir["#{rails_view_directory}/**/*html.erb" ].each do |full_erb_file_path|
      
      erb_file = full_erb_file_path.gsub( @rails_root, '' )
      erb_file = ErbFile.load( full_erb_file_path )
      erb_file.extract_text( text_extractor )

      File.open(full_erb_file_path, 'w') {|f| f.write(erb_file.to_s) }
      puts "Wrote #{full_erb_file_path}"
    end

  end
  
  def execute_i18n
    language_code = "en"
    
    rails_view_directory = "#{@rails_root}/app/views"
    
    Dir.glob("#{rails_view_directory}/**/*.html.erb").group_by { |x| File.dirname(x) }.each do |directory, files|
      directory_path = File.dirname(directory)
      yml_name = File.basename(directory)+".yml"

      full_yml_file_path = "#{@rails_root}/config/locales/#{language_code}/#{directory_path}/#{yml_name}"

      rails_translation_store = if File.exists?(full_yml_file_path)
        RailsTranslationStore.load_from_file( full_yml_file_path )
      else
        RailsTranslationStore.new
      end

      text_extractor = RailsTextExtractor.new( rails_translation_store )

      files.each do |full_erb_file_path|
        erb_file = full_erb_file_path.gsub( @rails_root, '' )
        rails_translation_store.start_new_context( convert_path_to_key_path( erb_file.to_s ) )
        erb_file = ErbFile.load( full_erb_file_path )
        erb_file.extract_text( text_extractor )

        File.open(full_erb_file_path, 'w') {|f| f.write(erb_file.to_s) }
        puts "Wrote #{full_erb_file_path}"

        File.open(full_yml_file_path, 'w') {|f| f.write(rails_translation_store.serialize) }
        puts "Wrote #{full_yml_file_path}"
      end
    end
  end
  
end
