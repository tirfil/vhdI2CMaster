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

entity COMPARE is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		TIC		: in	std_logic;
		COMPLETED	: in    std_logic;
		RESCAN		: out   std_logic;
		XREG		: in	std_logic_vector(7 downto 0);
		YREG		: in	std_logic_vector(7 downto 0);
		ZREG		: in	std_logic_vector(7 downto 0);
		LEDX		: out	std_logic;
		LEDY		: out	std_logic;
		LEDZ		: out	std_logic;
		SIGN		: out	std_logic
	);
end COMPARE;

architecture rtl of COMPARE is
	function magnitude(a: in std_logic_vector(7 downto 0)) return std_logic_vector is
		variable ret : std_logic_vector(7 downto 0);
	begin
		if ( a(7)='1' ) then
			ret := std_logic_vector(unsigned(not(a)) + 1);
		else
			ret := a;
		end if;
		return ret;
	end magnitude;

	signal x2c : std_logic_vector(7 downto 0);
	signal y2c : std_logic_vector(7 downto 0);
	signal z2c : std_logic_vector(7 downto 0);

	signal xy : std_logic;
	signal xz : std_logic;
	signal yz : std_logic;

	signal ledx_a , ledy_a, ledz_a : std_logic;

begin

	x2c <= magnitude(XREG);
	y2c <= magnitude(YREG);
	z2c <= magnitude(ZREG);

	xy <= '1' when (x2c > y2c) else '0';
	xz <= '1' when (x2c > z2c) else '0';
	yz <= '1' when (y2c > z2c) else '0';

	ledx_a <= xy and xz;
	ledy_a <= not(xy) and yz;
	ledz_a <= not(xz) and not(yz);

	SYNC: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			LEDX <= '0';
			LEDY <= '0';
			LEDZ <= '0';
			SIGN <= '0';
			RESCAN <= '0';
		elsif (MCLK'event and MCLK = '1') then
			if ( TIC = '1' ) then
				if ( COMPLETED = '1' ) then
					LEDX <= ledx_a;
					LEDY <= ledy_a;
					LEDZ <= ledz_a;
					if (ledx_a = '1') then
						SIGN <= XREG(7);
					elsif (ledy_a = '1') then
						SIGN <= YREG(7);
					elsif (ledz_a = '1') then
						SIGN <= ZREG(7);
					end if;
					RESCAN <= '1';
				else
					RESCAN <= '0';
				end if;
			end if;
		end if;
	end process SYNC;

end rtl;

