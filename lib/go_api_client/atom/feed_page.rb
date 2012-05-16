module GoApiClient
  module Atom
    class FeedPage
      attr_accessor :updated_at, :next_page, :url, :entries

      def initialize(root)
        @root = root
      end

      def parse!
        self.updated_at = @root.xpath('xmlns:updated').first.content
        self.next_page  = href_from(@root.xpath("xmlns:link[@rel='next']"))
        self.url        = href_from(@root.xpath("xmlns:link[@rel='self']"))
        self.entries    = @root.xpath("xmlns:entry").collect do |entry|
          Entry.new(entry).parse!
        end
        self
      end

      def entries_after(entry_or_id)
        index = if entry_or_id.is_a?(String)
                  entries.find_index {|e| e.id == entry_or_id}
                else
                  entries.find_index {|e| e == entry_or_id}
                end

        entries[0..index-1]
      end

      def contains_entry?(entry_or_id)
        if entry_or_id.is_a?(String)
          entries.find {|e| e.id == entry_or_id}
        else
          entries.include?(entry_or_id)
        end
      end

      def href_from(xml)
        xml.first.attribute('href').value unless xml.empty?
      end
    end
  end
end
