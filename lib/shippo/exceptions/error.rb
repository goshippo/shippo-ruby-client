module Shippo
  module Exceptions

    class Error < StandardError
      attr_accessor :message

      def initialize(thing = nil)
        if thing.is_a?(String)
          self.message = thing
        elsif thing.respond_to?(:message)
          self.message = thing.message
        else
          super(thing)
        end
      end

      def to_s_members
        %i()
      end

      def to_s
        out = super
        out << " (#{message}) " if message
        to_s_members.each do |member|
          out << member_to_s(member)
        end
        out
      end

      private

      def member_to_s(member)
        out   = ''
        value = self.send(member)
        out << "\n#{sprintf('%21s', member)}: '#{value}', " if value && (value != '')
        out
      end


    end
  end
end
