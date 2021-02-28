library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity i2s_in is
    generic (
        i2s       : STD_LOGIC := '1';
        bits      : natural range 16 to 24
    );
    port (
        clk               : in  STD_LOGIC := '0';

        in_R              : out std_logic_vector(bits-1 downto 0) := (others => '0');
        in_L              : out std_logic_vector(bits-1 downto 0) := (others => '0');
        
        sck               : in  STD_LOGIC := '0';
        ws                : in  STD_LOGIC := '0';
        sd                : in  STD_LOGIC := '0'
    );
end i2s_in;

architecture Behavioral of i2s_in is
    signal l_ws  : STD_LOGIC := '0';
    signal rx_bit : natural range 0 to bits := 0;
    signal d      : std_logic_vector(bits-1 downto 0) := (others => '0');
begin

    in_proc: process (clk)
    begin
        if rising_edge(sck) then
            if (ws /= l_ws) then
                if (i2s = '1') then
                    rx_bit <= bits;
                    l_ws <= ws;
                else
                    rx_bit <= bits-1;
                    d (bits-1) <= sd;
                    l_ws <= ws;
                end if;
            else
                if (rx_bit > 0) then
                    d (rx_bit-1) <= sd;
                    rx_bit <= rx_bit - 1;
                else
                    if (ws = '0') then
                        in_L <= d;
                    else
                        in_R <= d;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;