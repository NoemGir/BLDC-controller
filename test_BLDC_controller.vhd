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
	constant clk_pulse : time := 5 ns;
	constant E_MAX_CPT : natural := 6;
	constant TIMEOUT : time := 1000 ns;

	-- definition des signaux
	signal E_clk : std_logic; 
	signal E_EN : std_logic; 
	signal E_RST : std_logic; 
	signal E_DUTY : integer range 0 to E_MAX_CPT := 0; 

	signal E_U : std_logic; 
	signal E_V : std_logic; 
	signal E_W : std_logic; 
	signal E_Un : std_logic; 
	signal E_Vn : std_logic; 
	signal E_Wn : std_logic; 

begin

	-- création de l'horloge et TIMEOUT
	P_CLK : process
	begin
		E_clk <= '1';
		wait for clk_pulse;
		E_clk <= '0';
		wait for clk_pulse;
	end process P_CLK;
	
	P_TIMEOUT : process
	begin
		wait for TIMEOUT;
		assert FALSE report "TIMEOUT SIMULATION !!!" severity FAILURE;
	end process P_TIMEOUT;
	
	-- instanciation et mapping du composant BLDC_controller
	BLDC_controller : entity work.BLDC_controller(BLDC_controller_arch)
			generic map (E_MAX_CPT)
			port map (E_clk, E_EN, E_RST, E_DUTY, E_U, E_V, E_W, E_Un, E_Vn, E_Wn);

	-- realisation des test
	
	P_TEST : process 
	begin 

		E_EN <= '0';
		E_RST <= '0';

		wait for clk_pulse * 3 ;
		E_RST <= '1';

		wait until E_clk = '1';

		for i in 0 to E_MAX_CPT-1 loop
			wait for clk_pulse * 2 * E_MAX_CPT ;
			E_DUTY <= E_DUTY + 1;
			end loop;
		
		wait for clk_pulse * 4 * E_MAX_CPT ;
		wait until E_clk = '1';

		for i in E_MAX_CPT-1 downto 0 loop
			wait for clk_pulse * 2 * E_MAX_CPT ;
			E_DUTY <= E_DUTY - 1;
			end loop;

		wait for clk_pulse * 6 ;
		assert FALSE report "FIN DE SIMULATION" severity FAILURE;

	
	end process P_TEST;
end test_BLDC_controller_arch;

