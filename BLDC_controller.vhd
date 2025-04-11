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
	PHASE_CYCLE         : natural range 0 to 200 := 50;
    CLK_FREQUENCY       : natural range 1000 to 5000000 := 1000000; -- 1Khz to 5Mhz
    MIN_DUTY_PERCENT    : natural range 0 to 100 := 50;
    DUTY_SIZE           : natural range 1 to 16 := 8
	);

	-- definition des entrees/sorties
	port 	(
	--  Ports d'entré du controlleur'
	clk         : in std_logic; 
    EN          : in std_logic; 
    RST			: in std_logic; 
    DUTY        : in std_logic_vector(DUTY_SIZE-1 downto 0); -- Avec duty = 0 tOFF 100% et = MAX_CPT tOn = 100%
	-- Ports de sortie du controlleur 
    U			: out std_logic; 
    V			: out std_logic; 
    W			: out std_logic; 
    
    Wn			: out std_logic; 
    Vn			: out std_logic; 
    Un			: out std_logic
    );
end BLDC_controller;


architecture BLDC_controller_arch of BLDC_controller is   

    constant MAX_CPT : natural range 0 to CLK_FREQUENCY := CLK_FREQUENCY / PHASE_CYCLE;
    constant PHASE_SHIFT : natural range 1 to 16384 := MAX_CPT / 6;
    constant MAX_CMP_PWN : natural range 1 to 16384 := MAX_CPT / 192;

    type state_type is (S1, S2, S3, S4, S5, S6);
    signal current_state : state_type;
    signal count : natural range 0 to PHASE_SHIFT := 0;

    signal pwn_pos : std_logic;
    signal pwn_neg : std_logic;

begin

    P_state : process (RST, clk)
    begin
        if count = PHASE_SHIFT then
            count <= 0;
        end if;

        if RST = '0' then 
            current_state <= S1;
        elsif rising_edge(clk) and EN = '0'  then
            
            if count = PHASE_SHIFT-1 then
                case current_state is
                    when S1 => current_state <= S2;
                    when S2 => current_state <= S3;
                    when S3 => current_state <= S4;
                    when S4 => current_state <= S5;
                    when S5 => current_state <= S6;
                    when others => current_state <= S1;
                end case;
            end if;

            count <= count +1;
        end if;
    end process P_state;

    U <= pwn_pos when current_state = S1 or current_state = S2 else '0';
    V <= pwn_pos when current_state = S3 or current_state = S4 else '0';
    W <= pwn_pos when current_state = S5 or current_state = S6 else '0';

    Un <= pwn_neg when current_state = S5 or current_state = S4 else '0';
    Vn <= pwn_neg when current_state = S1 or current_state = S6 else '0';
    Wn <= pwn_neg when current_state = S2 or current_state = S3 else '0';

    P_duty_pos : entity work.pwm_manager(pwm_manager_arch)
    generic map(
        MAX_CPT => MAX_CPT,
        DUTY_SIZE => DUTY_SIZE,
        MIN_DUTY_PERCENT => MIN_DUTY_PERCENT,
        MODE =>  0,
        MAX_CMP_PWN => MAX_CMP_PWN
        )
    port map(
        clk => clk,
        DUTY => DUTY,
        rst => rst,
        en => en,
        pwm => pwn_pos
    );
    
    P_duty_neg : entity work.pwm_manager(pwm_manager_arch)
    generic map(
        MAX_CPT => MAX_CPT,
        DUTY_SIZE => DUTY_SIZE,
        MIN_DUTY_PERCENT => MIN_DUTY_PERCENT,
        MODE =>  1,
        MAX_CMP_PWN => MAX_CMP_PWN
        )
    port map(
        clk => clk,
        DUTY => DUTY,
        rst => rst,
        en => en,
        pwm => pwn_neg
    );


end BLDC_controller_arch;