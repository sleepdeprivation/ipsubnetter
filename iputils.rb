require_relative 'iputils'

module IP_utils
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

end
