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
entity test_BLDC_controller is
end test_BLDC_controller;


architecture test_BLDC_controller_arch of test_BLDC_controller is
	
	-- definition des constantes
	constant clk_pulse : time := 500 ns;
	constant TIMEOUT : time := 100 ms;
	constant DUTY_SIZE : integer := 8;
	constant max_duty_vector : std_logic_vector(DUTY_SIZE-1 downto 0) := (others => '1');
	constant PHASE_CYCLE : integer := 50 ;
	constant CLK_FREQUENCY : integer := 1000000 ;


	constant MIN_DUTY_PERCENT : integer := 50;

	-- definition des signaux
	signal E_clk : std_logic; 
	signal E_EN : std_logic; 
	signal E_RST : std_logic; 
	signal E_DUTY : std_logic_vector(DUTY_SIZE-1 downto 0);
	signal E_H : std_logic;
	signal E_U : std_logic; 
	signal E_V : std_logic; 
	signal E_W : std_logic; 
	signal E_Un : std_logic; 
	signal E_Vn : std_logic; 
	signal E_Wn : std_logic; 

begin
	
	P_TIMEOUT : process
	begin
		wait for TIMEOUT;
		assert FALSE report "TIMEOUT SIMULATION !!!" severity FAILURE;
	end process P_TIMEOUT;

		-- création de l'horloge et TIMEOUT
		P_CLK : process
		begin
			E_clk <= '1';
			wait for clk_pulse;
			E_clk <= '0';
			wait for clk_pulse;
		end process P_CLK ;
	
	-- instanciation et mapping du composant BLDC_controller
	P_BLDC_controller : entity work.BLDC_controller(BLDC_controller_arch)
			generic map (PHASE_CYCLE,CLK_FREQUENCY,MIN_DUTY_PERCENT, DUTY_SIZE)
			port map (E_clk, E_EN, E_RST, E_DUTY, E_H, E_U, E_V, E_W, E_Un, E_Vn, E_Wn);

	-- realisation des test

	P_TEST : process 
	begin 

		E_EN <= '1';
		E_RST <= '0';
		E_H <= '0';
		E_DUTY <= max_duty_vector;
		

		wait for clk_pulse * 4 ;
		E_EN <= '0';

		E_RST <= '1';
		wait for 70 ms ; 

		wait until E_clk = '1';
		E_EN  <= '1';

		wait for 1 ms ;
		assert FALSE report "FIN DE SIMULATION" severity FAILURE;

	
	end process P_TEST;
	
	
end test_BLDC_controller_arch;

