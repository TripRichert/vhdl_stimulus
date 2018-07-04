library ieee;
use ieee.std_logic_1164.all;

--! takes in data, waits stall_duration clock cycles, then outputs data.
entity axistream_stall is
  generic (
    bitWidth       : natural := 8;
    edge           : std_ulogic := '1';--! '1' when rising clk, '0' when falling
    stall_duration : natural := 8
    );
  port (
    clk         : in std_ulogic;
    src_tvalid  : in std_ulogic;
    src_tready  : out std_ulogic;
    src_tdata   : in  std_ulogic_vector(bitWidth - 1 downto 0);
    src_tlast   : in std_ulogic;
    dest_tvalid : out std_ulogic;
    dest_tready : in  std_ulogic;
    dest_tdata  : out std_ulogic_vector(bitWidth - 1 downto 0);
    dest_tlast  : out std_ulogic
    );
end entity axistream_stall;

architecture behavioral of axistream_stall is

  type pipelineType is array(stall_duration downto 0)
    of std_ulogic_vector(bitWidth + 1 downto 0);
  signal pipeline : pipelineType := (others => (others => '0'));
  
  signal src_tready_cpy : std_ulogic;
  signal dest_tvalid_cpy : std_ulogic;
  signal dest_tlast_cpy : std_ulogic := '0';
  
begin
  
  src_tready <= src_tready_cpy;
  dest_tvalid <= dest_tvalid_cpy;
  dest_tlast <= dest_tlast_cpy;

  src_tready_cpy <= '1' when dest_tready = '1' or dest_tvalid_cpy /= '1'
                    else '0';
  
  pipeline(0) <= (src_tlast and src_tvalid and src_tready_cpy)
                 & (src_tvalid and src_tready_cpy) & src_tdata;
  
  dest_tvalid_cpy <= pipeline(stall_duration)(bitWidth);
  dest_tlast_cpy  <= pipeline(stall_duration)(bitWidth + 1);
  dest_tdata  <= pipeline(stall_duration)(bitWidth - 1 downto 0);
  
  process(clk)
  begin
    if clk'event and clk = edge and clk'last_value = not edge then
      if dest_tready = '1' or dest_tvalid_cpy = '0' then
        pipeline(stall_duration downto 1)
          <= pipeline(stall_duration - 1 downto 0);
      end if;
    end if;
  end process;
  
end architecture behavioral;
