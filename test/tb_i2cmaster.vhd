--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
---- 2016/06/06 Add STOP
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_I2CMASTER is
end tb_I2CMASTER;

architecture stimulus of tb_I2CMASTER is

-- COMPONENTS --
	component I2CMASTER
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SRST		: in	std_logic;
			TIC		: in	std_logic;
			DIN		: in	std_logic_vector(7 downto 0);
			DOUT		: out	std_logic_vector(7 downto 0);
			RD		: in	std_logic;
			WE		: in	std_logic;
			NACK		: out	std_logic;
			QUEUED		: out	std_logic;
			DATA_VALID		: out	std_logic;
			STATUS		: out	std_logic_vector(2 downto 0);
			STOP		: out   std_logic;
			SCL_IN		: in	std_logic;
			SCL_OUT		: out	std_logic;
			SDA_IN		: in	std_logic;
			SDA_OUT		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SRST		: std_logic;
	signal TIC		: std_logic;
	signal DIN		: std_logic_vector(7 downto 0);
	signal DOUT		: std_logic_vector(7 downto 0);
	signal RD		: std_logic;
	signal WE		: std_logic;
	signal NACK		: std_logic;
	signal QUEUED		: std_logic;
	signal DATA_VALID		: std_logic;
	signal STATUS		: std_logic_vector(2 downto 0);
	signal STOP		: std_logic;
	signal SCL_IN		: std_logic;
	signal SCL_OUT		: std_logic;
	signal SDA_IN		: std_logic;
	signal SDA_OUT		: std_logic;
--
	signal RUNNING	: std_logic := '1';

	signal counter 	: std_logic_vector(7 downto 0);

begin

-- PORT MAP --
	I_I2CMASTER_0 : I2CMASTER
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SRST		=> SRST,
			TIC		=> TIC,
			DIN		=> DIN,
			DOUT		=> DOUT,
			RD		=> RD,
			WE		=> WE,
			NACK		=> NACK,
			QUEUED		=> QUEUED,
			DATA_VALID		=> DATA_VALID,
			STOP		=> STOP,
			STATUS		=> STATUS,
			SCL_IN		=> SCL_IN,
			SCL_OUT		=> SCL_OUT,
			SDA_IN		=> SDA_IN,
			SDA_OUT		=> SDA_OUT
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

	GO: process
	begin
		nRST <= '0';
		SRST <= '0';
		--DIN <= (others=>'0');
		DIN <= x"EE";
		RD <= '0';
		WE <= '1';
		SDA_IN <= '0';
		SCL_IN <= '0';
		wait for 1000 ns;
		nRST <= '1';
		wait until QUEUED'event and QUEUED = '0';
		WE <= '1';
		DIN <= x"AA";
		wait until QUEUED'event and QUEUED = '0';
		WE <= '0';
		RD <= '1';
		wait until QUEUED'event and QUEUED = '0';
		WE <= '0';
		RD <= '1';
		wait until DATA_VALID'event and DATA_VALID = '0';
		SDA_IN <= '1';
		wait until QUEUED'event and QUEUED = '0';
		WE <= '0';
		RD <= '0';	
		wait until DATA_VALID'event and DATA_VALID = '0';	
		wait for 100 uS;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
