Object.send(:remove_const, :HttpLogger)     if Object.const_defined? :HttpLogger
Object.send(:remove_const, :ActiveRecord)   if Object.const_defined? :ActiveRecord
Object.send(:remove_const, :Rails)          if Object.const_defined? :Rails
Object.send(:remove_const, :SpecLoggable)   if Object.const_defined? :SpecLoggable
Object.send(:remove_const, :ActiveSupport)  if Object.const_defined? :ActiveSupport
Object.send(:remove_const, :SpecLogDevice)  if Object.const_defined? :SpecLogDevice
