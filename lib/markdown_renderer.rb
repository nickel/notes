# frozen_string_literal: true

require "redcarpet"
require "coderay"

class MarkdownRenderer
  class Markdownray < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  def self.convert_markdown(text)
    rndr = Markdownray.new(filter_html: true, hard_wrap: true)
    options = {
      fenced_code_blocks: true,
      strikethrough: true,
      no_intra_emphasis: true,
      autolink: true,
      lax_html_blocks: true,
      highlight: true
    }
    markdown_to_html = Redcarpet::Markdown.new(rndr, options)
    markdown_to_html.render(text)
  end
end
