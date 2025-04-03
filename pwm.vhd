library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm_control is
    generic(
        MAX_CPT : integer := 20000 --represente le nombre de tics dans un cycle 1MHz/50 Hz = 20000
    );
    Port (
        clk : in std_logic;

        duty : in integer range 0 to MAX_CPT; -- Avec duty = 0 tOFF 100% et = MAX_CPT tOn = 100%
        en : in std_logic;
        rst : in std_logic;
        pwm : out std_logic;
        NegPwm : out std_logic 
    );
end pwm_control;

architecture pwm_control_arch of pwm_control is
    signal counter : integer range 0 to MAX_CPT := 0;
begin
    process (clk, rst)
    begin

        if rst = '0' then
            counter <= 0;
            pwm <= '0';
            NegPwm <= '1';
        elsif rising_edge(clk) and en = '0' then
            -- traitement du signal pwn
            if counter < duty then
                pwm <= '1';
                NegPwm <= '0';
            else
                pwm <= '0';
                NegPwm <= '1';
            end if;

            if counter < MAX_CPT -1 then
                counter <= counter + 1;
            else
                counter <= 0;
            end if;
                
        end if;
    end process;
end pwm_control_arch;