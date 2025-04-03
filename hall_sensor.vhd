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
entity hall_sensor is

	-- definition des parametres generiques
	generic	(
		-- largeur du bus de donnees par defaut
		MAX_CPT : integer := 20000
	);

	-- definition des entrees/sorties
	port 	(
		clk      		: in std_logic; 
        EN				: in std_logic; 
        RST				: in std_logic; 

		sig1 	        : out std_logic;
        sig2 	        : out std_logic; 
        sig3 	        : out std_logic
    );
end hall_sensor ;


architecture hall_sensor_arch of hall_sensor is
    constant PHASE_SHIFT : natural := MAX_CPT /3;

    type state_type is (S1, S2, S3);
    signal current_state : state_type;
    signal count : natural range 0 to PHASE_SHIFT := 0;
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
                if current_state = S1 then
                    current_state <= S2;
                elsif current_state = S2 then
                    current_state <= S3;
                else 
                    current_state <= S1;
                end if;

            end if;

            count <= count +1;
        end if;
    end process P_state;

    sig1 <= '1' when current_state = S1 else '0';
    sig2 <= '1' when current_state = S2 else '0';
    sig3 <= '1' when current_state = S3 else '0';

end hall_sensor_arch;

