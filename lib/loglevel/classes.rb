module Loglevel
  class Classes
    attr_reader :classes

    def stringify
      @stringify ||= classes.map(&:name)
    end

    private

    def initialize
      @classes = class_names.map do |class_name|
        begin
          Object.const_get("::#{class_name}")
        rescue NameError # Uninitialized constant
          nil
        end
      end.compact
    end

    def class_names
      @class_names ||= passed_class_names | %w(Rails ActiveRecord::Base HttpLogger)
    end

    def passed_class_names
      @passed_class_names ||= ENV.fetch(Loglevel::ENV_VAR_CLASSES, '').gsub(/[[:space:]]/, '').split(',')
    end
  end
end
