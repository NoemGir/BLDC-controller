-- Definition des librairies
library IEEE;
library WORK;

-- Definition des portee d'utilisation
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- -----------------------------------------------------------------------------
-- Definition de l'entite
-- -----------------------------------------------------------------------------
entity BLDC_controller is

	-- definition des parametres generiques
	generic	(
		-- largeur du bus de donnees par defaut
		MAX_CPT : integer := 20000
	);

	-- definition des entrees/sorties
	port 	(
		--  Ports d'entré du controlleur'
		clk      		: in std_logic; 
        EN				: in std_logic; 
        RST				: in std_logic; 
		DUTY	    	: in integer range 0 to MAX_CPT; -- Avec duty = 0 tOFF 100% et = MAX_CPT tOn = 100%

		-- Ports de sortie du controlleur 
        U				: out std_logic; 
        V				: out std_logic; 
        W				: out std_logic; 
        
        Wn				: out std_logic; 
        Vn				: out std_logic; 
        Un				: out std_logic
    );
end BLDC_controller;


architecture BLDC_controller_arch of BLDC_controller is
    constant PHASE_SHIFT : integer := MAX_CPT / 3; -- 120 degrés de décalage
    signal rst_1 : std_logic := '0';
    signal rst_2 : std_logic := '0';
    signal rst_3 : std_logic := '0';

    signal sig1 : std_logic;
    signal sig2 : std_logic; 
    signal sig3 : std_logic;

    signal duty_1 : integer range 0 to MAX_CPT;
    signal duty_2 : integer range 0 to MAX_CPT;
    signal duty_3 : integer range 0 to MAX_CPT;
begin

    P_HALL_sensor :  entity work.hall_sensor(hall_sensor_arch)
    generic map(MAX_CPT)
    port map(
       clk => clk,
       en => en,
       rst => rst,
       sig1 => sig1,
       sig2 => sig2,
       sig3 => sig3
    );

    rst_1 <= RST when (sig1'event and sig1 = '1');
    rst_2 <= RST when (sig2'event and sig2 = '1');
    rst_3 <= RST when (sig3'event and sig3 = '1');

    duty_1 <= DUTY when (sig1'event and sig1 = '1');
    duty_2 <= DUTY when (sig2'event and sig2 = '1');
    duty_3 <= DUTY when (sig3'event and sig3 = '1');
    

    PWM_1 : entity work.pwm_control(pwm_control_arch)
         generic map(MAX_CPT)
         port map(
            clk => clk,
            duty => duty_1,
            en => en,
            rst => rst_1,
            pwm => U,
            NegPwm => Un
         );

    PWM_2 : entity work.pwm_control(pwm_control_arch)
         generic map(MAX_CPT)
         port map(
            clk => clk,
            duty => duty_2,
            en => en,
            rst => rst_2,
            pwm => V,
            NegPwm => Vn
         );

    PWM_3 : entity work.pwm_control(pwm_control_arch)
         generic map(MAX_CPT)
         port map(
            clk => clk,
            duty => duty_3,
            en => en,
            rst => rst_3,
            pwm => W,
            NegPwm => Wn
         );

end BLDC_controller_arch;

