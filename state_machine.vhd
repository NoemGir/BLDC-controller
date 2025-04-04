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
entity state_machine is

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
        H               : in std_logic; 

		sig1 	        : out std_logic;
        sig2 	        : out std_logic; 
        sig3 	        : out std_logic;
        sig4 	        : out std_logic;
        sig5 	        : out std_logic;
        sig6 	        : out std_logic;

        state_change    : out std_logic
    );
end state_machine ;


architecture state_machine_arch of state_machine is
    constant PHASE_SHIFT : natural := MAX_CPT / 6;

    type state_type is (S1, S2, S3, S4, S5, S6);
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
                elsif current_state = S3 then
                        current_state <= S4;
                elsif current_state = S4 then
                    current_state <= S5;
                elsif current_state = S5 then
                    current_state <= S6;
                else
                    current_state <= S1;
                end if;
            end if;

            count <= count +1;
        end if;
    end process P_state;

    P_state_change : process (RST, clk)
    begin
        state_change <= '0';
        if rising_edge(clk) and EN = '0' and RST = '1' and count = PHASE_SHIFT-1 then
            state_change <= '1';
        end if;
    end process P_state_change;

    sig1 <= '1' when current_state = S1 else '0';
    sig2 <= '1' when current_state = S2 else '0';
    sig3 <= '1' when current_state = S3 else '0';
    sig4 <= '1' when current_state = S4 else '0';
    sig5 <= '1' when current_state = S5 else '0';
    sig6 <= '1' when current_state = S6 else '0';

end state_machine_arch;

