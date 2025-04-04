library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity duty_control is
    generic(
        MAX_CPT : integer := 20000; --represente le nombre de tics dans un cycle 1MHz/50 Hz = 20000
        DUTY_SIZE : integer := 8;
        MIN_DUTY_PERCENT : integer := 50;
        MAX_CMP_PWN : integer := 833
    );
    port (
        clk : in std_logic;
        DUTY : in std_logic_vector(DUTY_SIZE-1 downto 0); -- Avec duty = 0 tOFF 100% et = MAX_CPT tOn = 100%
        rst : in std_logic;
        en : in std_logic;
        pwm : out std_logic
    );
end duty_control;

architecture duty_control_arch of duty_control is

    constant INTERVAL : integer := MAX_CPT / 3;
    constant MAX_DUTY_VECTOR : std_logic_vector(DUTY_SIZE-1 downto 0) := (others => '1');
    constant MAX_DUTY_VALUE : integer := conv_integer(max_duty_vector);
    constant MIN_DUTY : integer := MAX_DUTY_VALUE * MIN_DUTY_PERCENT / 100;
    constant stop_rise : integer := INTERVAL / 2 ;

    signal adapted_duty : integer range 0 to MAX_DUTY_VALUE+1;

    signal step : integer range 0 to MAX_DUTY_VALUE := 1;

    signal count : integer range 0 to INTERVAL+1 := 0;
    signal pulse : std_logic;

    signal duty_integer : integer range 0 to MAX_DUTY_VALUE+1 := MIN_DUTY;

begin

    duty_integer <= MIN_DUTY when conv_integer(DUTY) < MIN_DUTY else conv_integer(DUTY);

    P_duty : process (pulse, rst, duty) 
    begin 

    step <= (duty_integer - MIN_DUTY) / ( INTERVAL / (MAX_CMP_PWN * 2) );


        if rst = '0' then 
            adapted_duty <= MIN_DUTY;
        elsif rising_edge(pulse) and en = '0' then
            if count < stop_rise and adapted_duty + step <= duty_integer  then
                adapted_duty <= adapted_duty +  step;
            elsif count >= stop_rise and adapted_duty - step >= MIN_DUTY then
                adapted_duty <= adapted_duty - step;
            end if;
        end if;
    end process P_duty;


    P_PWM : entity work.pwm_control(pwm_control_arch)
    generic map(MAX_DUTY_VALUE, MAX_CMP_PWN)
    port map(
        clk => clk,
        duty => adapted_duty,
        en => en,
        rst => rst,
        pwm => pwm,
        pulse => pulse
    );

    P_pulse : entity work.pwm_control(pwm_control_arch)
    generic map(MAX_DUTY_VALUE, MAX_CMP_PWN)
    port map(
        clk => clk,
        duty => adapted_duty,
        en => en,
        rst => rst,
        pwm => pwm,
        pulse => pulse
    );

    P_count : process(clk,rst)
    begin
        if RST='0' then
            count <= 0 ;
        elsif rising_edge(clk) then

            count <= count + 1;
            
            if count = INTERVAL  then 
                count <= 0 ;
            end if;
        end if;
    end process P_count;
    
end duty_control_arch;