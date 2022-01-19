library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity dacGTimer is
    generic(n : integer := 8);
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 EN : in STD_LOGIC; 
		 K : in STD_LOGIC_VECTOR(n-1 downto 0);
		 Tout : out STD_LOGIC
	     );
end dacGTimer;

architecture dacGTimer of dacGTimer is
signal Qn,Qp : std_logic_vector(n-1 downto 0);
begin
	
	Mux: process(Qp,EN,K)
	begin
		if EN = '1' then
         if Qp = K then 
            Qn   <= (others => '0');
            Tout <= '1';
         else           
            Qn   <= Qp + 1;
            Tout <= '0';
         end if;
      else
         Qn <= (others => '0');
         Tout <= '0';
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
   
end dacGTimer;
