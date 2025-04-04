library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm_control is
    generic(
        MAX_DUTY_VALUE : natural := 8;
        PWN_COUNT : natural := 22
    );
    Port (
        clk : in std_logic;
        duty : in natural range 0 to MAX_DUTY_VALUE;
        en : in std_logic;
        rst : in std_logic;
        pwm : out std_logic;
        pulse : out std_logic
    );
end pwm_control;

architecture pwm_control_arch of pwm_control is
    signal counter : natural range 0 to PWN_COUNT := 0;
    signal tOn_limit : natural range 0 to PWN_COUNT;
begin

    tOn_limit <= conv_integer(duty) * PWN_COUNT / MAX_DUTY_VALUE;
    pulse <= '1' when counter = 0 and rst /= '0' else '0';


    process (clk, rst)
        -- variable tOn_limit : natural := conv_integer(duty) * PWN_COUNT / MAX_DUTY_VALUE;
    begin
        
        if rst = '0' then
            counter <= 0;
            pwm <= '0';
        elsif rising_edge(clk) and en = '0' then
            -- traitement du signal pwn
            if counter < tOn_limit then
                pwm <= '1';
            else
                pwm <= '0';
            end if;

            if counter < PWN_COUNT then
                counter <= counter + 1;
            else
                counter <= 0;
            end if;
                
        end if;
    end process;
end pwm_control_arch;