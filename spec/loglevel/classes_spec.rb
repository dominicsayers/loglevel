RSpec.describe Loglevel::Classes do
  context 'default classes' do
    it 'is empty unless classes are available' do
      expect(Loglevel::Classes.new.classes).to be_empty
    end

    it 'returns available classes' do
      class Rails; end
      class HttpLogger; end

      classes = Loglevel::Classes.new
      expect(classes.classes).to include(Rails, HttpLogger)
      expect(classes.stringify).to include('Rails', 'HttpLogger')
      expect(classes.stringify).not_to include('ActiveRecord::Base')

      Object.send(:remove_const, :Rails)
      Object.send(:remove_const, :HttpLogger)
    end

    it 'defaults to Logger' do
      expect { Loglevel.new.send(:logger_class) }.to raise_error(
        Loglevel::Exception::BadLoggerClass,
        "Can't find logger class Logger - have you required it?"
      )
    end
  end

  context 'classes from environment variable' do
    before { ENV.store  Loglevel::ENV_VAR_CLASSES, 'String,Array , Hash,MyClass' } # the spacing is intentional
    after  { ENV.delete Loglevel::ENV_VAR_CLASSES }

    it 'returns classes that exist' do
      classes = Loglevel::Classes.new
      expect(classes.classes).to include(String, Array, Hash)
      expect(classes.stringify).not_to include('MyClass')
    end

    it 'returns defined classes' do
      class MyClass; end

      module ActiveRecord
        class Base; end
      end

      expect(Loglevel::Classes.new.classes).to include(ActiveRecord::Base, String, Array, Hash, MyClass)

      Object.send(:remove_const, :MyClass)
      Object.send(:remove_const, :ActiveRecord)
    end
  end
end
