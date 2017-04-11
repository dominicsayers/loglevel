Object.send(:remove_const, :ActiveRecord)     if Object.const_defined? :ActiveRecord
Object.send(:remove_const, :HttpLogger)       if Object.const_defined? :HttpLogger
Object.send(:remove_const, :Rails)            if Object.const_defined? :Rails
Object.send(:remove_const, :MyClass)          if Object.const_defined? :MyClass
Object.send(:remove_const, :MyDefaultLogger)  if Object.const_defined? :MyDefaultLogger
Object.send(:remove_const, :MyLogDevice)      if Object.const_defined? :MyLogDevice
