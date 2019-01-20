library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is port ( 
    d				: in std_logic_vector(7 downto 0);
    start			: in std_logic;
    reset			: in std_logic;
    clk 			: in std_logic;
	dreq			: in std_logic;
	rxrdy			: in std_logic;
    serialData	    : out std_logic;
    done        	: out std_logic;
    state           : out STD_LOGIC_vector(2 downto 0)
);
end top;

architecture Behavioral of top is

component cb4cle is port (
    clr	: in std_logic;
    l	: in std_logic;
    ce	: in std_logic;
    clk	: in std_logic;
    d	: in std_logic_vector(3 downto 0);
    q	: out std_logic_vector(3 downto 0);
    tc	: out std_logic;
    ceo	: out std_logic
);
end component;

component fdce is port (
    clr	: in std_logic;
    ce	: in std_logic;
    d	: in std_logic;
    clk	: in std_logic;
    q	: out std_logic
);
end component;

component fdrse is port (
    r	: in std_logic;
    s	: in std_logic;
    ce	: in std_logic;
    d	: in std_logic;
    clk	: in std_logic;
    q	: out std_logic
);
end component;

component parity_generator is port (
    d	: in std_logic_vector(7 downto 0);
    par	: out std_logic
);
end component;

component x74_194 is port (
    clr		: in std_logic;
    s1		: in std_logic;
    s0		: in std_logic;
    sri		: in std_logic;
    sli		: in std_logic;
    clk		: in std_logic;
    abcd	: in std_logic_vector(3 downto 0);
    qabcd	: out std_logic_vector(3 downto 0)
);
end component;

component h2_fsm is port (
    start   : in std_logic;
    reset   : in std_logic;
    clk     : in std_logic;
    num12   : in std_logic;
    rxrdy   : in std_logic;
    dreq    : in std_logic;
    
    txrdy   : out std_logic;
    rdy     : out std_logic;
    load    : out std_logic;
    depl    : out std_logic;
    ddisp   : out std_logic;
    st      : out STD_LOGIC_vector(2 downto 0)
);
end component;

signal gnd      :std_logic := '0'; 
signal vcc      :std_logic := '1';

signal s0 		: std_logic;
signal s1		: std_logic;
signal par		: std_logic;
signal load 	: std_logic;
signal depl 	: std_logic;
signal ddisp 	: std_logic;
signal sli1		: std_logic;
signal sli2		: std_logic;
signal sri1		: std_logic;
signal sri2		: std_logic;
signal rdy  	: std_logic;
signal txrdy	: std_logic;
signal ceo  	: std_logic;
signal tc   	: std_logic;
signal r       	: std_logic;
signal s       	: std_logic;
signal resetn  	: std_logic;
signal clr  	: std_logic;
signal num12  	: std_logic;
signal done1 	: std_logic;
signal st       : std_logic_vector(2 downto 0);
signal q1 		: std_logic_vector(3 downto 0);
signal q2 		: std_logic_vector(3 downto 0);
signal q3 		: std_logic_vector(3 downto 0);

begin
    r       <= load and (not par);
    s       <= load and par;
    s1      <= depl or load;
    resetn  <= not reset;
	clr     <= reset or done1;
	num12   <= q3(3) and q3(2) and (not q3(1)) and (not q3(0));
	done    <= done1;   

	comp1: parity_generator PORT MAP (
		d 	=> d,
		par => par
	);
	
	comp2: fdrse PORT MAP (
		r 	=> r,
		s 	=> s,
		ce 	=> depl,
		d 	=> vcc,
		clk => clk,
		q 	=> sli1
	);
	
	comp3: x74_194 PORT MAP (
		clr		=> resetn,
		s1 		=> s1,
		s0 		=> load,
		sri 	=> gnd,
		sli 	=> sli1,
		clk 	=> clk,
		abcd(3)	=> d(4),
		abcd(2)	=> d(5),
		abcd(1)	=> d(6),
		abcd(0)	=> d(7),
		qabcd 	=> q1
	);
	
	comp4: x74_194 PORT MAP (
		clr		=> resetn,
		s1		=> s1,
		s0		=> load,
		sri		=> gnd,
		sli 	=> q1(3),
		clk		=> clk,
		abcd(3)	=> d(0),
		abcd(2)	=> d(1),
		abcd(1)	=> d(2),
		abcd(0)	=> d(3),
		qabcd	=> q2
	);
	
	comp5: fdrse PORT MAP (
		r 	=> load,
		s 	=> reset,
		ce  => depl,
		d   => q2(3),
		clk => clk,
		q   => serialData
	);
	
	comp6: cb4cle PORT MAP (
		clr	=> clr,
		l 	=> gnd,
		ce  => depl,
		clk => clk,
		d 	=> "0000",
		q   => q3,
		ceo => ceo,
		tc  => tc
	);
	
	comp7: h2_fsm PORT MAP (
		start 	=> start,
		rxrdy	=> '1',
		reset	=> reset,
		num12	=> num12,
		dreq	=> dreq,
		clk		=> clk,
		txrdy	=> txrdy,
		rdy		=> open,
		load	=> load,
		depl	=> depl,
		ddisp 	=> open,
		st      => state
	);
	
	comp8: fdce PORT MAP (
		clr	=> reset,
		ce	=> txrdy,
		d	=> vcc,
		clk => clk,
		q	=> done1
	);
	
end Behavioral;