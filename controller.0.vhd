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
use STD.textio.all;

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
		ACTIVE_FRONT : std_logic := '1';

		-- fichier d'initialisation
		FILENAME : string := "" );

	-- definition des entrees/sorties
	port 	(
		-- signaux de controle du cache
		RST			: in std_logic; -- actifs a l'etat bas
		CLK,RW		: in std_logic; -- R/W*
		AS				: in std_logic; -- Address Strobe (sorte de /CS)

		-- bus d'adresse du cache
		ADR			: in std_logic_vector(DBUS_WIDTH downto 0);

		-- Ports entree/sortie du cache
		D				: in std_logic_vector(DBUS_WIDTH downto 0);
		Q				: out std_logic_vector(DBUS_WIDTH downto 0) );

end memory;


-- -----------------------------------------------------------------------------
-- Definition de l'architecture du banc de registres
-- -----------------------------------------------------------------------------
architecture behavior of memory is

	-- definition de constantes

	-- definitions de types (index type default is integer)
	type FILE_REGS is array (0 to DBUS_WIDTH) of std_logic_vector (DBUS_WIDTH-1 downto 0);

	-- declaration des ressources locales
	signal REGS : FILE_REGS; -- le banc memoire

begin
--------------------------------------------
-- Affectations dans le domaine combinatoire


-------------------


end behavior;

