library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use work.sevenseg_pkg.all;

entity demo3 is
    port(
        A1 : in  std_logic_vector(3 downto 0); -- 十位BCD
        A0 : in  std_logic_vector(3 downto 0); -- 個位BCD
        B1 : in  std_logic_vector(3 downto 0); -- 十位BCD
        B0 : in  std_logic_vector(3 downto 0); -- 個位BCD
        H0 : out std_logic_vector(6 downto 0); -- 個位顯示
        H1 : out std_logic_vector(6 downto 0)  -- 十位顯示
    );
end demo3;

architecture structural of demo3 is
    signal s0, s1 : std_logic_vector(3 downto 0);
    signal c0, c1 : std_logic;
begin
    -- 個位 BCD 加法
    D0: bcd4 port map('0', A0, B0, s0, c0);

    -- 十位 BCD 加法 (加上個位進位)
    D1: bcd4 port map(c0, A1, B1, s1, c1);

    H0 <= hex_to_7seg(s0);
    H1 <= hex_to_7seg(s1);

    -- 若 c1='1' 代表結果超過 99，需要第 3 位顯示器
end structural;
