-- compile: ghc aoc3.hs && ./aoc3
import Data.Char (isDigit)
import Data.Maybe (mapMaybe)
import Data.List (isInfixOf)

main :: IO()
main = do
    print "Day 3 of AOC 2024"

    -- Part 1
    print "Part 1"

    -- read file
    file <- readFile "input.txt"
    --print "File:"    
    --print file
    --print ""

    -- split on "mul(" into array
    let mulStrsAll = splitStr "mul(" file
    let mulStrs = tail mulStrsAll
    --print "mulStrs:"
    --print mulStrs
    --print ""

    -- process if we got a valid "X,Y)" at the start of each element
    let mulStrsP = processMulStrs mulStrs
    --print "mulStrsP:"
    --print mulStrsP
    --print ""

    -- multiply pairs
    let muls = processPairs mulStrsP
    --print "muls:"
    --print muls
    --print ""

    -- sum up multiplication numbers
    let mulsSum = sum (muls)
    print "Sum of multiplications:"
    print mulsSum
    print ""
    
    -- Part 2
    print "Part 2"

    -- split on "don't()" into an array
    let dontSplit = splitStr "don\'t()" file
    --print "dontSplit:"
    --print dontSplit
    --print ""

    -- check each element (except first) if "do()" occurs and split on it, taking only text afterwards
    let dontSplitP = processDonts dontSplit
    --print "dontSplitP:"
    --print dontSplitP
    --print ""

    -- concat array into new text
    let fileDo = concat dontSplitP
    --print "fileDo:"
    --print fileDo
    --print ""

    -- process as in Part 1
    -- split on "mul(" into array
    let mulStrsAllDo = splitStr "mul(" fileDo
    let mulStrsDo = tail mulStrsAllDo
    --print "mulStrsDo:"
    --print mulStrsDo
    --print ""

    -- process if we got a valid "X,Y)" at the start of each element
    let mulStrsPDo = processMulStrs mulStrsDo
    --print "mulStrsPDo:"
    --print mulStrsPDo
    --print ""

    -- multiply pairs
    let mulsDo = processPairs mulStrsPDo
    --print "mulsDo:"
    --print mulsDo
    --print ""

    -- sum up multiplication numbers
    let mulsSumDo = sum (mulsDo)
    print "Sum of multiplications (only after \"do()\"):"
    print mulsSumDo
    print ""



-- split a string
splitStr :: String -> String -> [String]
splitStr _ [] = [""]
splitStr delimiter str
    | delimiter == "" = error "Provide delimiter"
    | otherwise = let del = delimiter in splitStrH del str
        where
            delimiterLen = length delimiter
            -- helper function
            splitStrH :: String -> String -> [String]
            splitStrH _ [] = [""]
            splitStrH del s
                | del `startsWith` s = "" : splitStrH del (drop delimiterLen s)
                | otherwise =
                    let (currChar : rest) = s
                        (curr : remaining) = splitStrH del rest
                    in (currChar : curr) : remaining

-- check if string is prefix of another
startsWith :: String -> String -> Bool
startsWith [] _ = True
startsWith _ [] = False
startsWith (x:xs) (y:ys) = x == y && startsWith xs ys


-- process mulStrs: split on ")" and only include them if a ")" was present in the first place
processMulStrs :: [String] -> [String]
processMulStrs mulStr = [head (splitStr ")" str) | str <- mulStr, ')' `elem` str]

-- process "X,Y" pairs
processPairs :: [String] -> [Int]
processPairs = map (\(x, y) -> x * y) . mapMaybe parsePair
    where
        -- helper function: parse a pair
        parsePair :: String -> Maybe (Int, Int)
        parsePair str = case span(/= ',') str of
            (x, ',' : y) | all isDigit x && all isDigit y -> Just (read x, read y)
            _ -> Nothing

-- process the list such tat first element will be same
-- the others will only contain string after first "do()"
-- elements not containing "do()" will be deleted
processDonts :: [String] -> [String]
processDonts (x:xs) = x : mapAfterDo xs
    where
        -- helper function: process elements after first one
        mapAfterDo :: [String] -> [String]
        mapAfterDo [] = []
        mapAfterDo (y:ys)
            | "do()" `isInfixOf` y = let (before, after) = splitAtDel "do()" y in after : mapAfterDo ys
            | otherwise = mapAfterDo ys

-- split the string at the first occurence of the delimiter
splitAtDel :: String -> String -> (String, String)
splitAtDel delimiter str = go (tails str)
    where
        -- helper function: uses tails and startsWith to split
        go :: [String] -> (String, String)
        go [] = (str, "")
        go (s:ss)
            | startsWith delimiter s = (take (length str - length s) str, drop (length delimiter) s)
            | otherwise = go ss
        -- helper function: generate all suffixes of a string
        tails :: String -> [String]
        tails [] = [[]]
        tails s@(_:xs) = s : tails xs
        
    











