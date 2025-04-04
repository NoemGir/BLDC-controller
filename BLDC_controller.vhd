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
		PHASE_CYCLE : integer := 50;
        CLK_FREQUENCY : integer := 1000000;
        MIN_DUTY_PERCENT : integer range 0 to 100;
        DUTY_SIZE : integer
	);

	-- definition des entrees/sorties
	port 	(
		--  Ports d'entré du controlleur'
		clk      		: in std_logic; 
        EN				: in std_logic; 
        RST				: in std_logic; 
		DUTY	    	: in std_logic_vector(DUTY_SIZE-1 downto 0); -- Avec duty = 0 tOFF 100% et = MAX_CPT tOn = 100%

        H              : in std_logic; 
        
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

    constant MAX_CPT : integer range 0 to CLK_FREQUENCY := CLK_FREQUENCY / PHASE_CYCLE;

    signal sig1 : std_logic;
    signal sig2 : std_logic;
    signal sig3 : std_logic;
    signal sig4 : std_logic;
    signal sig5 : std_logic;
    signal sig6 : std_logic;

    signal state_change : std_logic;

    signal decaled_en : std_logic;
    signal decaled_rst : std_logic;

    signal pwn_pos : std_logic;
    signal pwn_neg : std_logic;

begin

    P_State : entity work.state_machine(state_machine_arch)
    generic map(MAX_CPT)
    port map(
        clk => clk,
        EN => en,
        RST	=> rst,
        H => H,

		sig1 => sig1,
        sig2 => sig2,
        sig3 => sig3,
        sig4 => sig4,
        sig5 => sig5,
        sig6 => sig6,

        state_change => state_change
    );

    U <= pwn_pos when sig1 = '1' or sig2 = '1' else '0';
    V <= pwn_pos when sig3 = '1' or sig4 = '1' else '0';
    W <= pwn_pos when sig5 = '1' or sig6 = '1' else '0';

    Un <= pwn_neg when sig5 = '1' or sig4 = '1' else '0';
    Vn <= pwn_neg when sig1 = '1' or sig6 = '1' else '0';
    Wn <= pwn_neg when sig2 = '1' or sig3 = '1' else '0';

    decaled_en <= '1' when rising_edge(state_change) and en = '1' else '0' when rising_edge(state_change) and en = '0';
    decaled_rst <= '1' when rising_edge(state_change) and rst = '1' else '0' when rising_edge(state_change) and rst = '0';

    P_duty_pos : entity work.duty_control(duty_control_arch)
    generic map(
        MAX_CPT => MAX_CPT,
        DUTY_SIZE => DUTY_SIZE,
        MIN_DUTY_PERCENT => MIN_DUTY_PERCENT,
        MAX_CMP_PWN => MAX_CPT / 192
        )
    port map(
        clk => clk,
        DUTY => DUTY,
        rst => rst,
        en => en,
        pwm => pwn_pos
    );
    
    P_duty_neg : entity work.duty_control(duty_control_arch)
    generic map(
        MAX_CPT => MAX_CPT,
        DUTY_SIZE => DUTY_SIZE,
        MIN_DUTY_PERCENT => MIN_DUTY_PERCENT,
        MAX_CMP_PWN => MAX_CPT / 192
        )
    port map(
        clk => clk,
        DUTY => DUTY,
        rst => decaled_rst,
        en => decaled_en,
        pwm => pwn_neg
    );


end BLDC_controller_arch;

