-- Nome: Vinicius Moralis
-- Modulo: HC05
-- Versão: 0.0.1 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity hc05 is
   Port ( clk : in  STD_LOGIC;
          rst : in  STD_LOGIC;
			 dout : in   STD_LOGIC_VECTOR (7 downto 0);
			 din : out  STD_LOGIC_VECTOR (7 downto 0);
			 addr : out  STD_LOGIC_VECTOR (7 downto 0);
			 rw : out  STD_LOGIC;
			 a : inout STD_LOGIC_VECTOR (7 downto 0));
end hc05;

architecture Behavioral of hc05 is
	--controle de estados
	signal estado : STD_LOGIC_VECTOR (2 downto 0);

	--Declaração dos Estados
	constant RESET1  : STD_LOGIC_VECTOR (2 downto 0) := "000";
	constant RESET2  : STD_LOGIC_VECTOR (2 downto 0) := "001";
	constant BUSCA   : STD_LOGIC_VECTOR (2 downto 0) := "010";
	constant DECODE  : STD_LOGIC_VECTOR (2 downto 0) := "011";
	constant EXECUTA : STD_LOGIC_VECTOR (2 downto 0) := "100";
	
	signal PC : STD_LOGIC_VECTOR (7 downto 0);
	signal OPCODE : STD_LOGIC_VECTOR (7 downto 0);
	signal fase : STD_LOGIC_VECTOR (1 downto 0);
	
begin
	addr <= PC;
	process(clk,rst)
	begin
		if rst='1' then
			PC <= "00000000";
			estado <= RESET1;
			
		elsif clk'event and clk='1' then
			case estado is
				when RESET1 =>
						PC <= "00000000"; --Primeiro endereço
						RW <= '0'; -- modo leitura
						estado <= RESET2; -- avança estado
				when RESET2 =>
						estado <= BUSCA;
				when BUSCA =>
						OPCODE <= dout; -- codigo da instruçao
						estado <= DECODE;
				when DECODE =>
					case OPCODE is
						when "10100001" =>  --LDA A  A1
							if fase = "00" then
								PC <= PC + 1;
								fase <= "01";
							else 
								A <= dout;
								ESTADO <= EXECUTA;
							end if;
							
						when "10100011" =>  --DEC A  A3
							A <= A - 1;
							estado <= EXECUTA;
							
						when others => null;	
					end case;
					
				when EXECUTA =>
					PC <= PC+1;
					estado <= BUSCA;
					
				when others => null;
				
			end case;
		end if;
	end process;

end Behavioral;
