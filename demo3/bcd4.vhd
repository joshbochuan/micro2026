library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.adder_package.all;

entity bcd4 is
    port(
        cin  : in  std_logic;
        A    : in  std_logic_vector(3 downto 0);
        B    : in  std_logic_vector(3 downto 0);
        S    : out std_logic_vector(3 downto 0);
        cout : out std_logic
    );
end bcd4;

architecture structural of bcd4 is
    signal sum_raw  : std_logic_vector(3 downto 0);
    signal sum_fix  : std_logic_vector(3 downto 0);
    signal c_raw    : std_logic;
    signal c_fix    : std_logic;
    signal need_fix : std_logic;
begin
    -- 第一次: A + B + cin
    U0: adder4
        port map(cin, A, B, sum_raw, c_raw);

    -- 是否需要 BCD 修正(+6)
    need_fix <= c_raw or (sum_raw(3) and sum_raw(2)) or (sum_raw(3) and sum_raw(1));

    -- 第二次: 若需要則 +0110
    U1: adder4
        port map('0', sum_raw, "0110", sum_fix, c_fix);

    -- 輸出選擇
    S(0) <= (need_fix and sum_fix(0)) or ((not need_fix) and sum_raw(0));
    S(1) <= (need_fix and sum_fix(1)) or ((not need_fix) and sum_raw(1));
    S(2) <= (need_fix and sum_fix(2)) or ((not need_fix) and sum_raw(2));
    S(3) <= (need_fix and sum_fix(3)) or ((not need_fix) and sum_raw(3));

    -- BCD 進位
    cout <= need_fix;
end structural;
