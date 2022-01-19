library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity dacGShifter is
    generic(n : integer := 8;
            m : integer := 3);
	 port(
		 S : in STD_LOGIC_VECTOR(m-1 downto 0);
       Din : in STD_LOGIC_VECTOR(n-1 downto 0);
		 Dout : out STD_LOGIC
	     );
end dacGShifter;

architecture dacGShifter of dacGShifter is
signal SH : std_logic_vector(n downto 0);
begin

   SH   <= Din & '0';
   Dout <= SH(n-conv_integer(S));

end dacGShifter;
