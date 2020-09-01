class ConditionalUglifier < Uglifier
    def really_compile(source, generate_map)
      # Skip any optimization (e.g. for shims)
      if source =~ /^\/\/= skip/
        source.gsub!(/\/\/= ?skip(\n)*;(\n)*\z/, "")
      else
        super
      end
    end
  end