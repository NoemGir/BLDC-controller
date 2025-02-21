--------------------------------------------------------------------------------
-- Banc Memoire pour processeur RISC
-- THIEBOLT Francois le 08/03/04
--------------------------------------------------------------------------------

---------------------------------------------------------
-- Lors de la phase RESET, permet la lecture d'un fichier
-- passe en parametre generique.
---------------------------------------------------------

-- Definition des librairies
library IEEE;
library STD;
library WORK;

-- Definition des portee d'utilisation
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;

-- -----------------------------------------------------------------------------
-- Definition de l'entite
-- -----------------------------------------------------------------------------
entity memory is

	-- definition des parametres generiques
	generic	(
		-- largeur du bus de donnees par defaut
		DBUS_WIDTH : natural := 32;

		-- nombre d'elements dans le cache exprime en nombre de mots
		MEM_SIZE : natural := 8;

		-- front actif par defaut
		ACTIVE_FRONT : std_logic := '1'
		
		);

	-- definition des entrees/sorties
	port 	(
		-- signaux de controle du controller
		CLK      		: in std_logic; 
		
        EN				: in std_logic; 
        RST				: in std_logic; 
        
        
		-- bus d'adresse du cache
		DUTY	    	: in std_logic_vector(DBUS_WIDTH downto 0);

		-- Ports sortie du controlleur 
        U				: in std_logic; 
        V				: in std_logic; 
        W				: in std_logic; 
        
        Wn				: in std_logic; 
        Vn				: in std_logic; 
        Un				: in std_logic
    );
end memory;


-- -----------------------------------------------------------------------------
-- Definition de l'architecture du banc de registres
-- -----------------------------------------------------------------------------
architecture behavior of memory is

	-- definitions de types (index type default is integer)
	type FILE_REG_typ is array (0 to (2**DBUS_WIDTH)-1) of std_logic_vector (DBUS_WIDTH-1 downto 0);

	-- definition des ressources internes

	-- registres
	signal REGS : FILE_REG_typ; -- le banc de registres interne de la fifo

	-- pointeurs lecture et ecriture
	signal W_ADR,R_ADR	: std_logic_vector (DBUS_WIDTH-1 downto 0);

begin
--------------------------------------------
-- Affectations dans le domaine combinatoire


-------------------


end behavior;

