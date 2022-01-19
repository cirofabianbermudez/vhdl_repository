library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity dacGCount is   
    generic(n : integer := 8);
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 OPC : in STD_LOGIC_VECTOR(1 downto 0);
       K : in STD_LOGIC_VECTOR(n-1 downto 0);
		 EOC : out STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(n-1 downto 0)
	     );
end dacGCount;

architecture dacGCount of dacGCount is
signal Qn,Qp : std_logic_vector(n-1 downto 0);
begin

	Q   <= Qp;
	
	Mux: process(Qp,OPC)
	begin
		case OPC is
         when  "00"  => Qn <= Qp;
         when  "01"  => Qn <= Qp + 1;
         when others => Qn <= (others => '0');
      end case;
	end process Mux;
   
   Equ: process(Qp,K)
   begin
      if Qp = K then
         EOC <= '1';
      else
         EOC <= '0';
      end if;
   end process Equ;
	
	Reg: process(RST,CLK,Qn)
	begin			
		if RST = '1' then
			Qp <= (others =>'0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Reg;

end dacGCount;
