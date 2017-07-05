require "test/unit"
require_relative "../ipaddress"

class TestIP_Address < Test::Unit::TestCase

    def arithmeticTest(&block)
        magic_number1 = rand(5096);
        magic_number2 = rand(5096);
        magicSum = yield(magic_number1, magic_number2);

        ip1 = IPAddress.new(magic_number1);
        ip2 = IPAddress.new(magic_number2);
        ipSum = yield(ip1 , ip2);

        assert_equal(ipSum, magicSum)

        assert_equal(yield(ip1 , magic_number2), magicSum )

        assert_equal(ipSum, magicSum)

        assert_equal(yield(ip2 , magic_number1), magicSum )
    end

    def testArithmetic
        for i in 1..5096
            arithmeticTest{ |a,b| a + b }
            arithmeticTest{ |a,b| a > b ? a - b : b - a }
            arithmeticTest{ |a,b| a * b }
        end
    end

end
