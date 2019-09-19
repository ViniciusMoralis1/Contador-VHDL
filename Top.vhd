library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
entity TOP is
Port ( CLK : in STD_LOGIC;
		 RST : in STD_LOGIC;
		 a : in STD_LOGIC;
		 red_out : out std_logic;
		 green_out : out std_logic;
		 blue_out : out std_logic;
		 hs_out : out std_logic;
		 vs_out : out std_logic
);
end TOP;

architecture Behavioral of TOP is
-- components
-- RAM
component ram is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (7 downto 0);
           din : in  STD_LOGIC_VECTOR (7 downto 0);
           rw : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component hc05 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           dout : in  STD_LOGIC_VECTOR (7 downto 0);
           din : out  STD_LOGIC_VECTOR (7 downto 0);
			  addr : out  STD_LOGIC_VECTOR (7 downto 0);
           rw : out  STD_LOGIC;
			  a : inout STD_LOGIC_VECTOR (7 downto 0));
end component;

--Clock div
component divclk is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clkdiv : out  STD_LOGIC);
end component;

--signal controle	
signal sclkdiv  : STD_LOGIC;
signal srw   : STD_LOGIC;
signal sdin  : STD_LOGIC_VECTOR (7 downto 0);
signal sdout : STD_LOGIC_VECTOR (7 downto 0);
signal saddr : STD_LOGIC_VECTOR (7 downto 0);
signal sa    : STD_LOGIC_VECTOR (7 downto 0);

-- CONTROLE DE CLOCK E TELA

signal clk50, clk25 : STD_LOGIC;
signal horizontal_counter : std_logic_vector (9 downto 0);
signal vertical_counter : std_logic_vector (9 downto 0);

begin

process (clk, rst)

begin
		
	if CLK'EVENT and CLK = '1' then
		-- CLOCK PARA CONTROLE DA TELA
		if (clk50 = '0') then
			clk50 <= '1';
		else
			clk50 <= '0';
		end if;
		
	end if;
end process;

-- DIMINUI CLOCK PARA EXIBIÇÃO DA TELA
process (clk50)
begin
	if clk50'event and clk50='1' then
		if (clk25 = '0') then
			clk25 <= '1';
		else
			clk25 <= '0';
		end if;
	end if;
end process;
-- CONTROLE DA EXIBIÇÃO NA TELA
process (clk25)
variable printa: integer range 0 to 10;
begin
	if clk25'event and clk25 = '1' then
	-- TAMANHO DO JOGO: 400x400 --> 50 PARA CADA BIT DA RAM
		if (horizontal_counter >= "0001111000" ) -- 120
		and (horizontal_counter < "1110011100" ) -- 520
		and (vertical_counter >= "0000101000" ) -- 40
		and (vertical_counter < "1100111110" ) -- 440
		then
			printa := 1;
-- MOSTRANDO OS OBSTÁCULOS (CADA IF DO VERTICAL_COUNTER REPRESENTA
--UMA LINHA DA TELA, CADA IF INTERNO, DO HORIZONTAL_COUNTER, REPRESENTA UMA COLUNA
--DESTA LINHA)
		
		if vertical_counter >= 100 AND vertical_counter < 275 then --superior direita
			if horizontal_counter >= 550 AND horizontal_counter < 585 then
				printa := 0;
			end if;	
		end if;
		
		if vertical_counter >= 280 AND vertical_counter < 455 then --inferior direita
			if horizontal_counter >= 550 AND horizontal_counter < 585 then
				printa := 0;
			end if;	
		end if;
		
		if vertical_counter >= 100 AND vertical_counter < 275 then --superior daquele lado
			if horizontal_counter >= 335 AND horizontal_counter < 370 then
				printa := 0;
			end if;	
		end if;
		
		if vertical_counter >= 280 AND vertical_counter < 455 then --inferior daquele lado
			if horizontal_counter >= 335 AND horizontal_counter < 370 then
				printa := 0;
			end if;	
		end if;
		
		if vertical_counter >= 75 AND vertical_counter < 125 then --superior 
			if horizontal_counter >= 375 AND horizontal_counter < 545 then
				printa := 0;
			end if;	
		end if;
		
		if vertical_counter >= 430 AND vertical_counter < 478 then --inferior
			if horizontal_counter >= 375 AND horizontal_counter < 545 then
				printa := 0;
			end if;	
		end if;
		
		if vertical_counter >= 250 AND vertical_counter < 300 then --meio
			if horizontal_counter >= 375 AND horizontal_counter < 545 then
				printa := 0;
			end if;	
		end if;
		
		
-- ESCOLHE COR QUE APARECERÁ NA TELA -> 0 PARA BRANCO (FUNDO
---DO JOGO), 1 PARA VERMELHO (OBSTÁCULOS) E 2 PARA AZUL (JOGADOR)
			if printa= 0 then
				red_out <= '1';
				green_out <= '1';
				blue_out <= '1';
			elsif printa= 1 then
				red_out <= '0';
				green_out <= '0';
				blue_out <= '0';
			else
				red_out <= '1';
				green_out <= '0';
				blue_out <= '0';
			end if;
		else
-- ESCOLHE COR PRETA PARA RESTO DA TELA
			red_out <= '0';
			green_out <= '0';
			blue_out <= '0';
		end if;
	
end if;
end process;

--Instancias RAM, HC05 e DIVCLK
divclk1 : divclk  port map (clk, rst, sclkdiv); 
ram1    : ram     port map (sclkdiv, rst, saddr, sdin, srw, sdout);
hc051   : hc05    port map (sclkdiv, rst, sdout, sdin, saddr, srw, sa);

end Behavioral;