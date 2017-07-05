require_relative 'iputils'
require 'json'

class IPAddress

    include IP_utils;

    attr_reader :decimalAddress;

    def initialize(addr=nil)
        if addr == nil
            addr = 0
        end
        self.set(addr);
    end

    def to_ip
        decimalToIPNotation(@decimalAddress);
    end

    def to_s
        to_ip;
    end

    def to_i
        @decimalAddress
    end

    def set(addr)
        if addr.class == IPAddress
            @decimalAddress = addr.decimalAddress;
        elsif addr.class == Fixnum
            @decimalAddress = addr;
        elsif addr.class == String;
            @decimalAddress = IPNotationToDecimal(addr);
        end
    end

    def coerce(other)
        [IPAddress.new(other), self];
    end

end

#amazing! https://youtu.be/vwBpTgdZBDk?t=22m48s
RESOLVING_MEHTODS = [:+, :-, :*, :/, :>, :<, :>=, :<=, :==, :===]
RESOLVING_MEHTODS.each do |method|
    IPAddress.class_eval %{
        def #{method}(*args, &block)
            if args[0].class != IPAddress
                n = args[0];
            else
                n = args.shift.decimalAddress
            end
            IPAddress.new(
                @decimalAddress.#{method}(n, &block)
            )
        end
    }
end
