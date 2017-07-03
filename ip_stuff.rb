include Enumerable

"""
    Take an ip address written out in decimal,
    and convert it to the IP address notation commonly used,
    with each octet seperated by .'s and written in decimal notation
"""
def decimalToIPNotation(dec)
    retval = "";
    paddedBinary = dec.to_s(2)
                    .rjust(32, '0')
    for i in (0..31).step(8)
        retval +=   paddedBinary[i..(i+7)]
                    .to_i(2)
                    .to_s();
        retval += "."
    end
    return retval.chomp('.');
end

"""
    take an ip address written in common IP address notation,
    and turn it into a large decimal number
    This is the inverse operation of decimalToIPNotation
"""
def IPNotationToDecimal(ipString)
    retval = ipString
        .split('.')
        .reduce(""){ |m, o|
            l = o.to_i().to_s(2).rjust(8, "0");
            m + l;
        }
    retval = retval.to_i(2);
    return retval
end

"""
    Generate a random ipv4 address in common IP address notation
"""
def generateRandomIPAddress()
    ip = (1..4).reduce(""){|m, o|
        m + rand(256).to_s + "."
    }
    return ip.chomp('.');
end

"""
    Return the subnet mask commonly expressed as '/n',
    expressed in decimal
"""
def getSubnetMask(n)
    return  ("1"*n).ljust(32, "0").to_i(2)
end

"""
    Get the subnet mask for n hosts,
    ie if n is 54, we want the smallest subnet
    mask that can hold 54 hosts
    again, in decimal
"""
def getNHostSubnetMask(n)
    return getSubnetMask(32 - (Math.log2(n)).ceil);
end

"""
    Test whether the IP conversion functions are actually inverses of each other
"""
def testIPConversions()
    success = true; #optimism
    #one way
    for i in 1..5000
        ip = generateRandomIPAddress();
        conv = decimalToIPNotation(IPNotationToDecimal(ip));
        if(ip != conv)
            puts "FAILED! ", ip,conv;
            success = false;
        end

    end
    #or the other
    for k in 1..5000
        dec = rand(4294967295 + 1)
        conv = IPNotationToDecimal(decimalToIPNotation(dec))
        if(dec != conv)
            puts "FAILED! ", dec,conv;
            success = false;
        end
    end
    if(success)
        puts "IP Conversion test succeeded!"
    end
end


def subnetMaskTest(n)
    puts "subnet mask test /"+n.to_s+": ", decimalToIPNotation(getSubnetMask(n))
end

def subnetMaskTestNHost(n)
    puts "subnet mask test "+n.to_s+": ", decimalToIPNotation(getNHostSubnetMask(n))
end

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


def performTests()
    puts "performing inverse test";
    testIPConversions();
    puts ""
    [32, 24, 16, 27].each { |x| subnetMaskTest(x) };
    puts ""
    [60,25,5].each{ |x| subnetMaskTestNHost(x) };
    puts ""
    [125,28,13].each { |x| subnetMaskTestNHost(x) }

    p doSubnetting("172.29.0.0", "255.255.252.0", [260,177,50,20,2,2,2]);

end

performTests();



#performTests()
