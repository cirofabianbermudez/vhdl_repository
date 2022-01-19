library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity dacGReg is
	 generic(n : integer := 8);
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 LDR : in STD_LOGIC;
		 Din : in STD_LOGIC_VECTOR(n-1 downto 0);
		 Dout : out STD_LOGIC_VECTOR(n-1 downto 0)
	     );
end dacGReg;

architecture dacGReg of dacGReg is
signal Qn,Qp : std_logic_vector(n-1 downto 0);
begin

	Dout <= Qp;
	
	Mux: process(Qp,LDR,Din)
	begin
		if LDR = '1' then
			Qn <= Din;
		else
			Qn <= Qp;
		end if;
	end process Mux;
	
	Reg: process(RST,CLK,Qn)
	begin			
		if RST = '1' then
			Qp <= (others =>'0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Reg;

end dacGReg;
