----------------------------------------------------------------------------------------------------
--                                      Clean VHDL Example
--
-- Author: Jim Strieter
-- 08/20/2020
--
-- Dear Recent Grad,
--
-- There are many ways of making code look neat & easy to read, and no one example can illustrate
-- all of them. Some people cling to their coding standard with religious fervor, with good reason:
-- when you give someone code that isn't formatted the way they are used to seeing it, the code can 
-- feel difficult to read. Computers might lack emotions, but engineers most certainly do not. 
-- Few things are more unpleasant than putting 60+ hour weeks into a project for several months, 
-- only to watch your coworkers throw all your hard work in the garbage because you couldn't 
-- convince them your code was reliable. And they couldn't be sure that your code was beyond 
-- reproach because they found it so hard to read they don't know what you're trying to do. 
-- Your coworkers have projects* of their own, so they need to be able to look at your code and in 
-- a few seconds and know 3 things:
--
--      1) What are you trying to do?
--      2) Did you achieve that?
--      3) Did you achieve that safely? Does your code satisfy our organization's risk posture?
--
-- Whatever the convention at your company, learn it the best you can. I know it can feel annoying
-- to go through endless rounds of wordsmithing on something as banal as formatting your code, 
-- but the faster you pick up this skill, the more quickly you will earn your coworkers' trust. 
-- And it doesn't matter how awesome an engineer you are unless you can earn your colleagues'
-- confidence. 
-- 
-- So, to sum up, 
--
--      1) Learn how to make code look neat & consistent at your company. 
--         If your organization has no coding standard, this file provides practices that some 
--         organizations embrace, although it is by no means the only way to write clean code.
--         There are plenty of coding standards on the Internet; many of them tailored for a 
--         specific language, but most contain practices that make any language easier to read.
--
--      2) Remember that the coding standard doesn't ONLY help your colleagues - it also helps 
--         YOU. That's great that you hit a home run yesterday, but when your colleagues ask 
--         you to fix a bug 3 years from now, you will NOT remember what you did. (If your memory
--         is that good, you should have been a doctor. Or win $1M's in Jeopardy! or whatever.)
--         Adhering to a little ritual feels weird when you're getting used to it, but once you
--         own a 100k line codebase and coworkers are asking you tough questions about how it 
--         will work in untested situations, you will be grateful you followed a standard. 
--
--      3) The more quickly you master your organization's standard, or any reasonable standard,
--         the more quickly you earn their confidence. (You still have to make good design
--         decisions, test thoroughly, and nail the many other things that go into quality
--         code.) 
--  
-- Happy Coding!
--
-- Jim Strieter
--
--
--
-- *And young children, old children, children they didn't know they had until yesterday, elderly 
-- parents, marital strife, an overarching predisposition towards grouchiness, intact dreams, 
-- broken dreams, slowly dying dreams, contempt for the human race, and everything else that might 
-- detract from one's objectivity. Most of them are good people. Or at least they were. And life 
-- took its toll on them, just like it will on you. Muahahahahaha. 
----------------------------------------------------------------------------------------------------

-- Coding standards can look complicated (and sometimes they are quite complicated),
-- but that is because it takes nuance to make code look clean and consistent, especially
-- when a project has a lot of contributors. 
library IEEE;
use IEEE.std_logic_1164.all;

entity MyEntity is 
    generic (
        -- Notice that no signal widths are hard coded. 
        -- Instead, I have used a generic to define signal widths instead:
        data_width : integer := 8
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        -- Some companies use a convention in which inputs are prefixed with i_, and outputs
        -- are prefixed with o_. It seems silly in a file this small, but in 1000+ line 
        -- files it helps. You may notice that clk and rst do not have a prefix. That is because
        -- some companies do not require that convention for clocks and resets. 
        i_d : in std_logic_vector(data_width-1 downto 0);
        o_q : out std_logic_vector(data_width-1 downto 0)
    );
end MyEntity;

----------------------------------------------------------------------------------------------------
--                                          Section Heading
--
--                                   Say Important Things This Way
-- 
--
-- Notice the title is centered. Statements that follow are left justified.
-- 
-- Some companies put a limit on how long a line can be, typically 80, 100, or 120 characters.
-- I chose 100 for this demo. 
----------------------------------------------------------------------------------------------------

architecture behavioral_MyEntity of MyEntity is 
-- It is common to name every architecture behavioral, rtl, or something like that.
-- That is bad practice because under rare conditions (beyond the scope of this demo) it can 
-- allow the compiler to compile a different architecture than the one you intended. It can 
-- also make your code harder to read if you have multiple entities in the same file. It is better 
-- practice to name your architectures like this:
--
--      behavioral_EntityName
--
-- That way it's unambiguous which entity this architecture implements. 


-- Some companies use a convention in which signals are prefixed with s_. 
-- Again, it looks silly in a small file, but in large files it can help a lot:
signal s_q : std_logic_vector(data_width-1 downto 0);
-- Notice that our one signal has the same name as the output it drives, except 
-- for the prefix. s_q drives o_q. s_fred drives o_fred, etc. 

begin 

----------------------------------------------------------------------------------------------------
--                                            Business Logic
-- 
-- It's common, though certainly not universal, for an entity to be centered around a few lines. 
-- For example, let's say you want to implement a reusable vendor-agnostic Block RAM (BRAM). The 
-- lines that tell the synthesizer "infer a BRAM" are very small - like 1. The rest of the module
-- is telling the synthesizer whether outputs should be registered on a rising edge or falling, 
-- whether your reset is positive or negative, synchronous or asynchronous, etc. 
----------------------------------------------------------------------------------------------------
process(clk)
    -- If the process uses any variables, the variable declarations should 
    -- be indented:
    variable myVariable : std_logic := '0';
begin 
    if rising_edge(clk) then 
        if rst = '1' then 
            s_q <= '0';
            myVariable <= '0';
        else
            -- It is typically a bad practice to drive outputs directly. The reason
            -- is that if you later want to use whatever output, compilers pre-VHDL-2008
            -- will give you an error, because you cannot read outputs. I sometimes make
            -- exceptions and drive outputs directly, but I suggest the following:
            --      1) Don't make exceptions until you have > 5 years' experience. 
            --      2) If you are going to make an exception, only do so in a tiny file
            --         (< 100 lines) that you know for certain will never grow large.
            --      3) If there's even a chance that an architecture might grow > 200 lines, 
            --         do not make an exception. 
            s_q <= i_d;
            myVariable <= not myVariable;
        end if;
    end if;
end process;

----------------------------------------------------------------------------------------------------
--                                             Drive Outputs
----------------------------------------------------------------------------------------------------
-- I normally drive outputs at the end. There's nothing special about driving outputs this way, 
-- but if you do it consistently your code will be easier to read.
o_q <= s_q;

end behavioral_MyEntity;

