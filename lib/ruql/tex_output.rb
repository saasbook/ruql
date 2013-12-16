module TexOutput

  @@tex_replace = {
    /_/ => '\textunderscore{}',
    Regexp.new('<tt>([^<]+)</tt>', Regexp::IGNORECASE) => "\\texttt{\\1}",
    Regexp.new('<pre>(.*?)</pre>', Regexp::MULTILINE | Regexp::IGNORECASE) => "\\begin{Verbatim}\\1\\end{Verbatim}",
  }

  @@tex_escape = Regexp.new '\$|&|%|#|\{|\}'

  def to_tex(str)
    str = str.gsub(@@tex_escape) { |match| "\\#{match}" }
    @@tex_replace.each_pair do |match, replace|
      str = str.gsub(match, replace)
    end
    str
  end
end
