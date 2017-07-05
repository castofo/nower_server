module Expandable
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :allowed_expands

    private
      def expandable_attrs(*attrs)
        @allowed_expands = attrs
      end
  end

  private
    def expand_attrs
      expands_array.select { |elem| allowed_expands.include?(elem) }
    end

    def expands_array
      params[:expand].blank? ? [] : params[:expand].strip.split(',').map(&:to_sym)
    end

    def allowed_expands
      self.class.allowed_expands || []
    end
end
