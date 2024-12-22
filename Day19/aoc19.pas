{ fpc aoc19.pas && ./aoc19 }
program Aoc19;

{ use system utilities }
uses
    SysUtils;

const
    MaxTowelLength = 100;
    MaxStripes = 1000;

var
    file_name: string;
    line: ansiString;  { we have very long strings in input file: string -> ansiString }
    file_handle: text;
    delimiter: string;
    stripes: array[1..MaxStripes] of string;
    stripes_size, pos_start, pos_delim: integer;
    towel_counter: integer;
    towel_comb_counter: int64;

{ try to build a towel from stripes }
function BuildTowel(const towel: string): boolean;
    var
        i: integer;
    begin
        { base case: no towel }
        if towel = '' then
        begin
            BuildTowel := True;
            Exit;
        end;

        { match each stripe at beginning }
        for i := 1 to stripes_size do
        begin
            //Writeln('Try to match: "', stripes[i], '" with beginning of "', towel, '"');
            if Length(stripes[i]) > Length(towel) then
                continue;
            if Copy(towel, 1, Length(stripes[i])) = stripes[i] then
            begin
                if BuildTowel(Copy(towel, Length(stripes[i]) + 1, Length(towel))) then
                begin
                    BuildTowel := True;
                    Exit;
                end;
            end;
        end;

        BuildTowel := False;
    end;

{ dynamic programming to find number of combinations }
function BuildTowelCombinations(const towel: string): int64;
    var
        dp: array[0..MaxTowelLength] of int64;
        i, j: integer;
 
    { do we have a match of end of substring (of towel) and stripe }
    function Matches(const sub_str, stripe: string): Boolean;
        begin
            Matches := Copy(sub_str, Length(sub_str) - Length(stripe) + 1, Length(stripe)) = stripe
        end;

    begin
        if Length(towel) > MaxTowelLength then
        begin
            Writeln('increse "MaxTowelLength" constant!');
            Exit;
        end;

        { initialize dp array }
        dp[0] := 1;
        for i := 1 to Length(towel) do
            dp[i] := 0;

        { fill dp array }
        for i := 1 to Length(towel) do
        begin
            for j := 1 to stripes_size do
            begin
                if (i >= Length(stripes[j])) and Matches(Copy(towel, 1, i), stripes[j]) then
                    dp[i] := dp[i] + dp[i - Length(stripes[j])];
            end;
        end;

        //Writeln('Number of combinations: ', dp[Length(towel)]);
        BuildTowelCombinations := dp[Length(towel)];
    end;


begin
    { Day 19 of AOC 2024 }
    Writeln('Day 19 of AOC 2024');
    { Part 1 & 2 }
    Writeln('Part 1 & 2');

    { open file }
    file_name := 'input.txt';
    Assign(file_handle, file_name);
    Reset(file_handle);

    { read possible stripes }
    Readln(file_handle, line);

    stripes_size := 0;
    pos_start := 1;
    delimiter := ', ';

    repeat
        pos_delim := Pos(delimiter, copy(line, pos_start, length(line) - pos_start + 1));
        if pos_delim = 0 then
            pos_delim := length(line) - pos_start + 2;

        Inc(stripes_size);
        if stripes_size > MaxStripes then
        begin
            Writeln('increase "MaxStripes" constant!');
            Exit;
        end;

        stripes[stripes_size] := Copy(line, pos_start, pos_delim - 1);
        pos_start := pos_start + pos_delim + Length(delimiter) - 1;
    until pos_start > length(line);

    {
    Writeln('Stripes are:');
    for pos_start := 1 to stripes_size do
        Writeln(stripes[pos_start]);
    Writeln('');
    }

    { read empty line }
    Readln(file_handle, line);

    { read combinations }
    towel_counter := 0;
    towel_comb_counter := 0;

    while not EOF(file_handle) do
    begin
        Readln(file_handle, line);
        //Writeln(line);

        towel_comb_counter += BuildTowelCombinations(line);

        if BuildTowel(line) then
        begin
            towel_counter += 1;
            //Writeln('Towel "', line, '" can be formed');
        end
        else
            //Writeln('Towel "', line, '" cannot be formed');

    end;
    { close file }
    Close(file_handle);

    { print number of combinations }
    Writeln('Part 1: Number of valid towels are: ', towel_counter);
    Writeln('Part 2: Number of valid towel combinations are: ', towel_comb_counter);
end.



