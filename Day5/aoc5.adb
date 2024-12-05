-- gnatmake aoc5.adb && ./aoc5
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Aoc5 is
    -- define types
    type Integer_Array is array(Positive range <>) of Integer;

    -- define variables
    File : File_Type;
    File_Name : constant String := "input.txt";

    File_Line : String(1 .. 200);
    File_Line_Len : Integer;

    Flag_Do_Table : Boolean := True;

    Lookup_Table : Integer_Array(1 .. 2000);
    Lookup_Table_Len : Integer := 0;
    Lookup_First_Int, Lookup_Second_Int : Integer;

    Book_Pages : Integer_Array(1 .. 100);
    Book_Pages_Len : Integer;
    Middle_Page : Integer;

    Page_Counter_Valid : Integer := 0;
    Page_Counter_Invalid : Integer := 0;

    -- define procedues & functions

    -- print array
    procedure Print_Array(
        Arr: in Integer_Array;
        Len: in Integer    
    ) is
    begin
        for I in 1 .. Len loop
            Put(Integer'Image(Arr(I)) & " ");
        end loop;
        Put_Line("");
    end Print_Array;

    -- check if one value is less than another value based on the Lookup Table
    function Less(
        Value_1 : in Integer;
        Value_2 : in Integer;
        Lookup_Table : in Integer_Array;
        Lookup_Table_Len : in Integer
    ) return Boolean is
        Lookup : Integer;
    begin
        Lookup := Value_1 * 100 + Value_2;
        for I in 1 .. Lookup_Table_Len loop
            if Lookup = Lookup_Table(I) then
                return True;
            end if;
        end loop;
        return False;
    end Less;

    -- check if Book Pages are valid with Lookup Table and return middle page number if valid or -1 if not valid
    function Get_Book(
        Book_Pages : in Integer_Array;
        Book_Pages_Len : in Integer;
        Lookup_Table : in Integer_Array;
        Lookup_Table_Len : in Integer
    ) return Integer is
    begin
        for I in 1 .. Book_Pages_Len loop
            for J in I + 1 .. Book_Pages_Len loop
                if not Less(Book_Pages(I), Book_Pages(J), Lookup_Table, Lookup_Table_Len) then
                    return -1;
                end if;
            end loop;
        end loop;
        return Book_Pages((Book_Pages_Len + 1) / 2);
    end Get_Book;

    -- Swap two values
    procedure Swap(
        Arr : in out Integer_Array;
        I : in Positive;
        J : in Positive  
    ) is
        Tmp : Integer;
    begin
        Tmp := Arr(I);
        Arr(I) := Arr(J);
        Arr(J) := Tmp;
    end Swap;

    -- Bubble Sort
    procedure Bubble_Sort(
        Book_Pages : in out Integer_Array;
        Book_Pages_Len : in Integer;
        Lookup_Table : in Integer_Array;
        Lookup_Table_Len : in Integer
    ) is
    begin
        for N in reverse 1 .. Book_Pages_Len loop
            for I in 1 .. N - 1 loop
                if Less(Book_Pages(I + 1), Book_Pages(I), Lookup_Table, Lookup_Table_Len) then
                    Swap(Book_Pages, I, I + 1);
                end if;
            end loop;
        end loop;
    end Bubble_Sort;

begin
    -- Day 5 of AOC 2024
    Put_Line("Day 5 of AOC2024");

    -- Part 1 & 2
    Put_Line("Part 1 & 2");

    -- open input file
    Open(File, In_File, File_Name);

    --Put_Line("File contents:");
    while not End_Of_File(File) loop
        -- read each line
        Get_Line(File, File_Line, File_Line_Len);

        if File_Line_Len = 0 then
            --Put_Line("Skipping empty line");
            Flag_Do_Table := False;
        else
            declare
                Line : constant String := File_Line(1 .. File_Line_Len);
            begin
                --Put_Line(Line);

                -- fill LookupTable
                if Flag_Do_Table then
                    Lookup_First_Int := Integer'Value(Line(1 .. 2));
                    Lookup_Second_Int := Integer'Value(Line(4 .. 5));
                    --Put("Lookup_First_Int: ");
                    --Put(Lookup_First_Int);
                    --Put(", Lookup_Second_Int: ");
                    --Put(Lookup_Second_Int);
                    --Put(", Lookup Value: ");
                    --Put(Lookup_First_Int * 100 + Lookup_Second_Int);
                    --Put_Line("");
                    Lookup_Table_Len := Lookup_Table_Len + 1;
                    -- Firstnum(XY), Secondnum(AB) -> XYAB
                    Lookup_Table(Lookup_Table_Len) := Lookup_First_Int * 100 + Lookup_Second_Int;

                -- check pages
                else
                    -- fill book pages array
                    Book_Pages_Len := (File_Line_Len + 1) / 3;
                    for I in 1 .. Book_Pages_Len loop
                        Book_Pages(I) := Integer'Value(Line(3 * I - 2 .. 3 * I - 1));
                    end loop;

                    -- check if is valid
                    Middle_Page := Get_Book(Book_Pages, Book_Pages_Len, Lookup_Table, Lookup_Table_Len);
                    if Middle_Page /= -1 then
                        Page_Counter_Valid := Page_Counter_Valid + Middle_Page;

                    -- reorder until it is correct
                    else
                        --Print_Array(Book_Pages, Book_Pages_Len);
                        Bubble_Sort(Book_Pages, Book_Pages_Len, Lookup_Table, Lookup_Table_Len);
                        --Print_Array(Book_Pages, Book_Pages_Len);
                        Middle_Page := Get_Book(Book_Pages, Book_Pages_Len, Lookup_Table, Lookup_Table_Len);
                        Page_Counter_Invalid := Page_Counter_Invalid +  Middle_Page;
                    end if;
                end if;
            end;
        end if;
    end loop;

    -- close input file
    Close(File);

    -- print lookup table
    --Print_Array(Lookup_Table, Lookup_Table_Len);

    Put("Page counter (valid) | Part 1: ");
    Put(Page_Counter_Valid);
    Put_Line("");

    Put("Page counter (invalid) | Part 2: ");
    Put(Page_Counter_Invalid);
    Put_Line("");

end Aoc5;
















