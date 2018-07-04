library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axistream_unsigned_adder is
  generic (
    bitWidth : natural := 8;
    edge     : std_ulogic := '1'--! '1' when rising clk, '0' when falling
    );
  port (
    clk         : in std_ulogic;
    src_tvalid  : in std_ulogic;
    src_tready  : out std_ulogic;
    src_tdata_a : in unsigned(bitWidth - 1 downto 0);
    src_tdata_b : in unsigned(bitWidth - 1 downto 0);
    src_tlast   : in std_ulogic;
    dest_tvalid : out std_ulogic;
    dest_tready : in  std_ulogic;
    dest_tdata  : out unsigned(bitWidth downto 0);
    dest_tlast  : out std_ulogic
    );
end entity axistream_unsigned_adder;

architecture behavioral of axistream_unsigned_adder is
  
  signal src_tready_cpy : std_ulogic;
  signal dest_tvalid_cpy : std_ulogic;
  signal dest_tlast_cpy : std_ulogic := '0';
  
  signal queued : boolean := false;
  
begin
  src_tready <= src_tready_cpy;
  dest_tvalid <= dest_tvalid_cpy;
  dest_tlast <= dest_tlast_cpy;
  
  src_tready_cpy <= '1' when not queued or dest_tready = '1' else '0';
  dest_tvalid_cpy <= '1' when queued else '0';
  
  process(clk)
  begin
    if clk'event and clk = edge and clk'last_value = not edge then
      if src_tvalid = '1' and src_tready_cpy = '1' then

        dest_tdata <= resize(src_tdata_a, bitWidth + 1)
                      + resize(src_tdata_b, bitWidth + 1);
        
        dest_tlast_cpy <= src_tlast;
        queued <= true;
        
      elsif dest_tvalid_cpy = '1' and dest_tready = '1'
        and src_tvalid = '0' then
        
        queued <= false;
        dest_tlast_cpy <= '0';

      end if;
    end if;
  end process;
  
end architecture behavioral;
