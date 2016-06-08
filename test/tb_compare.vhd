--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_COMPARE is
end tb_COMPARE;

architecture stimulus of tb_COMPARE is

-- COMPONENTS --
	component COMPARE
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			TIC		: in	std_logic;
			COMPLETED		: in	std_logic;
			RESCAN		: out	std_logic;
			XREG		: in	std_logic_vector(7 downto 0);
			YREG		: in	std_logic_vector(7 downto 0);
			ZREG		: in	std_logic_vector(7 downto 0);
			LEDX		: out	std_logic;
			LEDY		: out	std_logic;
			LEDZ		: out	std_logic;
			SIGN		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal TIC		: std_logic;
	signal COMPLETED	: std_logic;
	signal RESCAN		: std_logic;
	signal XREG		: std_logic_vector(7 downto 0);
	signal YREG		: std_logic_vector(7 downto 0);
	signal ZREG		: std_logic_vector(7 downto 0);
	signal LEDX		: std_logic;
	signal LEDY		: std_logic;
	signal LEDZ		: std_logic;
	signal SIGN		: std_logic;

--
	signal RUNNING	: std_logic := '1';

	signal counter 	: std_logic_vector(7 downto 0);

begin

-- PORT MAP --
	I_COMPARE_0 : COMPARE
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			TIC		=> TIC,
			COMPLETED	=> COMPLETED,
			RESCAN		=> RESCAN,
			XREG		=> XREG,
			YREG		=> YREG,
			ZREG		=> ZREG,
			LEDX		=> LEDX,
			LEDY		=> LEDY,
			LEDZ		=> LEDZ,
			SIGN		=> SIGN
		);

	TIC <= counter(7) and counter(5); -- 2.56 + 0.64 uS (~300 khz ) for ~100 kbit

	GEN: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			counter <= (others=>'0');
		elsif (MCLK'event and MCLK='1') then
			if (TIC = '1') then
				counter <= (others=>'0');
			else
				counter <= std_logic_vector(to_unsigned(to_integer(unsigned( counter )) + 1, 8));
			end if;
		end if;
	end process GEN;
--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	GO: process
	begin
		nRST <= '0';
		XREG <= "00000000";
		YREG <= "10000000";
		ZREG <= "10000001";
		COMPLETED <= '1';
		wait for 1000 ns;
		nRST <= '1';
		wait for 4000 ns;
		XREG <= "00000001";
		YREG <= "00000010";
		ZREG <= "00000011";
		wait for 4000 ns;
		XREG <= "10000001";
		YREG <= "10000010";
		ZREG <= "10000011";
		wait for 4000 ns;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
