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

entity tb_MPU6050 is
end tb_MPU6050;

architecture stimulus of tb_MPU6050 is

-- COMPONENTS --
	component MPU6050
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			TIC		: in	std_logic;
			SRST		: out	std_logic;
			DOUT		: out	std_logic_vector(7 downto 0);
			RD		: out	std_logic;
			WE		: out	std_logic;
			QUEUED		: in	std_logic;
			NACK		: in	std_logic;
			STOP		: in	std_logic;
			DATA_VALID		: in	std_logic;
			DIN		: in	std_logic_vector(7 downto 0);
			ADR		: out	std_logic_vector(3 downto 0);
			DATA		: out	std_logic_vector(7 downto 0);
			LOAD		: out	std_logic;
			COMPLETED		: out	std_logic;
			RESCAN		: in	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal TIC		: std_logic;
	signal SRST		: std_logic;
	signal DOUT		: std_logic_vector(7 downto 0);
	signal RD		: std_logic;
	signal WE		: std_logic;
	signal QUEUED		: std_logic;
	signal NACK		: std_logic;
	signal STOP		: std_logic;
	signal DATA_VALID		: std_logic;
	signal DIN		: std_logic_vector(7 downto 0);
	signal ADR		: std_logic_vector(3 downto 0);
	signal DATA		: std_logic_vector(7 downto 0);
	signal LOAD		: std_logic;
	signal COMPLETED		: std_logic;
	signal RESCAN		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_MPU6050_0 : MPU6050
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			TIC		=> TIC,
			SRST		=> SRST,
			DOUT		=> DOUT,
			RD		=> RD,
			WE		=> WE,
			QUEUED		=> QUEUED,
			NACK		=> NACK,
			STOP		=> STOP,
			DATA_VALID		=> DATA_VALID,
			DIN		=> DIN,
			ADR		=> ADR,
			DATA		=> DATA,
			LOAD		=> LOAD,
			COMPLETED		=> COMPLETED,
			RESCAN		=> RESCAN
		);

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
		wait for 1000 ns;
		nRST <= '1';

		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
