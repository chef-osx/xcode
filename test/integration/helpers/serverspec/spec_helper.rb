require 'serverspec'

set :backend, :exec

::Dir[::File.join(::File.dirname(__FILE__), 'shared_examples/*.rb')].sort.each { |f| require f }
