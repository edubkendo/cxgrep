require 'parallel'
#require "cxgrep/version"

class CXGrep
  def initialize(options)
    @stack = options[:stack]
    @filepath = options[:filepath]
    @grep = %("#{options[:grep]}")
    @zgrep_flags = options[:zgrep_flags] ? "-#{options[:zgrep_flags]}" : ''
  end

  def call
    Parallel.each(servers) do |server|
      puts `cx run -s #{@stack} --server #{server} 'zgrep #{@zgrep_flags} #{@grep} #{@filepath}'`
    end
  end

  def servers
    `(cx servers list -s #{@stack}| awk '{print $1}')`.split("\n")
  end
end
