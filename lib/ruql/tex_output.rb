module TexOutput

  def add_newlines(str)
    str.gsub(Regexp.new('<pre>(.*?)</pre>', Regexp::MULTILINE | Regexp::IGNORECASE) ) do |code_section|
      code_section.gsub!("\n"){"\\\\"}
      code_section.gsub!("  "){"\\hspace*{2em}"}      
    end
  end
  
  @@tex_replace = {
    /_/ => '\textunderscore{}',
    Regexp.new('<tt>([^<]+)</tt>', Regexp::IGNORECASE) => "\\texttt{\\1}",
    Regexp.new('<pre>(.*?)</pre>', Regexp::MULTILINE | Regexp::IGNORECASE) => "\\texttt{\\1}",
  }

  @@tex_escape = Regexp.new '\$|&|%|#|\{|\}'

  def to_tex(str)
    str = str.gsub(@@tex_escape) { |match| "\\#{match}" }
    str = add_newlines(str)
    
    @@tex_replace.each_pair do |match, replace|
      str = str.gsub(match, replace)
    end
    str
  end
end
