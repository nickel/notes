# frozen_string_literal: true

atom_feed do |feed|
  feed.title("Juan Gallego IV's notes")
  feed.updated(@notes[0].created_at) unless @notes.empty?

  @notes.each do |note|
    feed.entry(note) do |entry|
      entry.title(note.title)
      entry.intro(MarkdownRenderer.convert_markdown(note.intro), type: "html")
      entry.content(MarkdownRenderer.convert_markdown(note.content), type: "html")
      entry.pubDate note.created_at.rfc822
      entry.link note_url(note)
      entry.guid note_url(note)

      entry.author do |author|
        author.name("Juan Gallego IV")
        author.uri("https://juan.gallegoiv.com")
      end
    end
  end
end
