library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pulse_gen is
    generic(
        MAX : integer := 20000 --represente le nombre de tics dans un cycle 1MHz/50 Hz = 20000
    );
    Port (
        clk : in std_logic;
        rst : in std_logic;
        pulse : out std_logic 
    );
end pulse_gen;

architecture pulse_gen_arch of pulse_gen is
begin

    P_pulse : process(clk,rst)
        variable count : natural range 0 to MAX;
    begin
        if RST='0' then
            count := 0 ;
            pulse <= '0';
        elsif rising_edge(clk) then

            pulse <= '0';

            if count = 0 then 
                pulse <= '1';
            end if;

            count := count + 1;
            
            if count = MAX  then 
                count := 0 ;
            end if;
        end if;
    end process P_pulse;
        

end pulse_gen_arch;