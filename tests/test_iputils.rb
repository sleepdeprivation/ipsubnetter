require "test/unit"
require_relative "../iputils"

class TestIP_Utils < Test::Unit::TestCase

    include IP_utils;

    """
        Test whether the IP conversion functions are actually inverses of each other
    """
    def testIPConversions()
        success = true; #optimism
        #one way
        for i in 1..5000
            ip = generateRandomIPAddress();
            conv = decimalToIPNotation(IPNotationToDecimal(ip));
            assert_equal(ip, conv);
            if(ip != conv)
                puts "FAILED! ", ip,conv;
                success = false;
            end

        end
        #or the other
        for k in 1..5000
            dec = rand(4294967295 + 1)
            conv = IPNotationToDecimal(decimalToIPNotation(dec))
            assert_equal(dec, conv);
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
end
