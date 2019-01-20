library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test is 
end test;

architecture Behavioral of test is

component top is port ( 
    d			: in std_logic_vector(7 downto 0);
    start       : in std_logic;
    reset       : in std_logic;
    clk         : in std_logic;
    dreq        : in std_logic;
    rxrdy       : in std_logic;
    serialData  : out std_logic;
    done        : out std_logic;
    state       : out STD_LOGIC_vector(2 downto 0)
);
end component;

signal d            : std_logic_vector(7 downto 0) := "10000110";
signal state        : std_logic_vector(2 downto 0) := "000";
signal start 		: std_logic := '0';
signal reset 		: std_logic := '1';
signal clk   		: std_logic := '0';
signal dreq			: std_logic := '0';
signal rxrdy		: std_logic := '0';
signal serial   	: std_logic := '0';

begin

	comp1: top PORT MAP (
		d 				=> d,
		start			=> start,
		reset			=> reset,
		clk   			=> clk,
		dreq			=> dreq,
		rxrdy			=> rxrdy,
		serialData	    => serial,
		state           => state
	);
	
	process
	begin
	   wait for 25ns;
	   clk <= not clk;
    end process;
	
	process
	begin
		rxrdy <= '0';
		wait for 25ns;
		
		reset <= '0';
		wait for 50ns;
		
		start <= '1';
		dreq <= '1';
		wait for 100ns;
	end process;
	
end Behavioral;