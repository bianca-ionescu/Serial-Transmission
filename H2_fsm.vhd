library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity H2_fsm is
    Port (
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
end H2_fsm;

architecture Behavioral of H2_fsm is
    type state_type is (S0, S1, S2, S3, S4, S5);
    signal state : state_type := S0;
begin
    process(clk, start, reset, num12, rxrdy, dreq)
    begin
        if (reset = '1') then
            rdy <= '1';
            load <= '0';
            ddisp <= '0';
            txrdy <= '0';
            depl <= '0';
        elsif (rising_edge(clk)) then
            case state is
                when S0 =>
                    rdy <= '0';
                    load <= '1';
                    if (start = '1') then
                        state <= S1;
                    end if;
                    
                when S1 =>
                    load <= '0';
                    ddisp <= '1';
                    state <= S2;
                    
                when S2 =>
                    if (dreq = '1') then
                        ddisp <= '0';
                        depl <= '1';
                        state <= S3;
                    end if;
                    
                when S3 =>
                    depl <= '1';
                    state <= S4;
                    
                when S4 =>
                    if (num12 = '1') then
                        depl <= '0';
                        txrdy <= '1';
                        state <= S5;
                    end if;
                    
                when S5 =>
                    if (rxrdy = '1') then
                        txrdy <= '0';
                        state <= S0;
                    end if;
                    
                when others => NULL;
            end case;
        end if;
    end process;
    
    with state select st <=
        "000" when S0,
        "001" when S1,
        "010" when S2,
        "011" when S3,
        "100" when S4,
        "101" when S5;
end Behavioral;
