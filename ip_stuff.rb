include Enumerable;
require_relative 'ipMixins'


#module IP_utils
    class IPAddress
        @decimalAddress = 0;

        include IP_utils;

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

        def set(addr)
            if addr.class == Fixnum
                @decimalAddress = addr;
            elsif addr.class == String;
                p "string ip"
            end
        end
    end
#end
p IPAddress.new.to_s;




"""
    given a list of required numbers of hosts for each subnet,
    and a base IP and a default subnet mask
    perform a subnetting task
"""
def doSubnetting(baseIP, defaultMask, reqs)
    #these things make more sense in our native decimal
    dBaseIP = IPNotationToDecimal(baseIP);
    dDefaultMask = IPNotationToDecimal(defaultMask);
    reqs = reqs.sort.reverse
    reqs.inject(Array.new){|list, x|
        startingIP = dBaseIP + 1;
        endingIP = dBaseIP + 2**(Math.log2(x + 1)).ceil - 2
        broadcastAddress = endingIP + 1;
        p "x: #{x}";
        list.push({Network: decimalToIPNotation(dBaseIP),
                    Range:  decimalToIPNotation(startingIP)+" - "+
                            decimalToIPNotation(endingIP),
                    Broadcast:  decimalToIPNotation(broadcastAddress),
                    Mask:   decimalToIPNotation(getNHostSubnetMask(x))});
        dBaseIP = broadcastAddress + 1;
        list
    }
end




performTests();



#performTests()
