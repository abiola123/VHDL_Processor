library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
  type state_type is (fetch1,fetch2,decode,r_op,store,break,load1,load2,i_op)
  signal s_current_state,s_next_state : state_type;

begin

flip_flop : process(clk,reset_n) is
  begin
    if(reset_n = '0') then
      s_current_state <= fetch1;
    elsif(rising_edge(clk)) then
      s_current_state<= s_next_state;
    end if;

  end process flip_flop;

output : process(s_current_state) is
  begin
    case (s_current_state) is
      when fetch1 =>   ;
      when fetch2 => pc_en <=1;
      when i_op =>
    end case;
  end process output;


  s_next_state <= fetch2 when s_current_state = fetch1 else
                  decode when s_current_state = fetch2 else
                  r_op when ((s_current_state = decode) and (op = 0X"3A") and (opx = 0X"0E")
                  i_op when ((s_current_state = decode) and (op = 0X"04")
                  load when ((s_current_state = decode) and (op = 0X"17")
                  store when ((s_current_state = decode) and (op = 0X"15")
                  break when ((s_current_state = break) or ((s_current_state=decode) and (op = 0X"3A") and (opx = 0X"34"))) else
                  load2 when s_current_state = load1
                  fetch1 when ((s_current_state = r_op) or (s_current_state = store) or (s_current_state = load2) or (s_current_state = i_op))


end synth;
