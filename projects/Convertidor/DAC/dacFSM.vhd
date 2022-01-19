library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity dacFSM is
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 WR : in STD_LOGIC;
		 EOW : out STD_LOGIC;
		 EOC : in STD_LOGIC;
		 EOS : in STD_LOGIC;
		 EOT : in STD_LOGIC; 
		 ENC : out STD_LOGIC_VECTOR(1 downto 0);
		 ENS : out STD_LOGIC_VECTOR(1 downto 0);
		 ENT : out STD_LOGIC;
		 SYNC : out STD_LOGIC;
		 SCLK : out STD_LOGIC
	     );
end dacFSM;

architecture dacFSM of dacFSM is
signal Qn,Qp : std_logic_vector(3 downto 0);
begin

   Comb: process(Qp,WR,EOC,EOS,EOT)
	begin
		case Qp is
         when "0000" => if WR = '1' then
                           Qn <= "0001";   
                        else
                           Qn <= Qp;
                        end if;     
                        SYNC <= '1';
                        SCLK <= '1';
                        EOW  <= '0';
                        ENT  <= '0';
                        ENC  <= "11";
                        ENS  <= "11";
         when "0001" => if EOT = '1' then
                           Qn <= "0010";
                        else
                           Qn <= Qp;
                        end if;     
                        SYNC <= '0';
                        SCLK <= '1';
                        EOW  <= '0';
                        ENT  <= '1';
                        ENC  <= "00";
                        ENS  <= "00";
         when "0010" => if EOT = '1' then
                           Qn <= "0011";
                        else
                           Qn <= Qp;
                        end if;     
                        SYNC <= '0';
                        SCLK <= '0';
                        EOW  <= '0';
                        ENT  <= '1';
                        ENC  <= "00";
                        ENS  <= "00";
         when "0011" => if EOS = '1' then
                           Qn <= "0100";
                        else
                           Qn <= "0001";
                        end if;     
                        SYNC <= '0';
                        SCLK <= '1';
                        EOW  <= '0';
                        ENT  <= '1';
                        ENC  <= "00";
                        ENS  <= "01";
         when "0100" => if EOC = '1' then
                           Qn <= "0111";
                        else
                           Qn <= "0101";
                        end if;     
                        SYNC <= '0';
                        SCLK <= '1';
                        EOW  <= '0';
                        ENT  <= '0';
                        ENC  <= "01";
                        ENS  <= "11";  
         when "0101" => if EOT = '1' then
                           Qn <= "0110";
                        else
                           Qn <= Qp;
                        end if;     
                        SYNC <= '1';
                        SCLK <= '1';
                        EOW  <= '0';
                        ENT  <= '1';
                        ENC  <= "00";
                        ENS  <= "00"; 
         when "0110" => Qn <= "0001";
                        SYNC <= '1';
                        SCLK <= '1';
                        EOW  <= '0';
                        ENT  <= '0';
                        ENC  <= "00";
                        ENS  <= "00";
         when "0111" => if EOT = '1' then
                           Qn <= "1000";
                        else
                           Qn <= Qp;
                        end if;
                        SYNC <= '1';
                        SCLK <= '1';
                        EOW  <= '0';
                        ENT  <= '1';
                        ENC  <= "00";
                        ENS  <= "00";
         when others => Qn <= "0000";
                        SYNC <= '1';
                        SCLK <= '1';
                        EOW  <= '1';
                        ENT  <= '0';
                        ENC  <= "00";
                        ENS  <= "00";
      end case;
	end process Comb;
	
	Sec: process(RST,CLK,Qn)
	begin			
		if RST = '1' then
			Qp <= (others =>'0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sec;

end dacFSM;
