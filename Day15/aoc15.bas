01   REM fbc64.exe -lang qb aoc15.bas && aoc15.exe
02   CLS
10   PRINT "Day 15 of AOC 2024"
20   PRINT "Part 1"

30   DECLARE FUNCTION CheckMoveUp%(rc%, cc%)
35   DECLARE FUNCTION CheckMoveDown%(rc%, cc%)
40   DECLARE FUNCTION MoveUp%(d%, rc%, cc%)
45   DECLARE FUNCTION MoveDown%(d%, rc%, cc%)
50   REM Define variables
60   DIM SHARED grid%(1 TO 100, 1 TO 100)
70   DIM SHARED gridMove%(1 TO 100, 1 TO 100)
80   DIM commands%(1 TO 20000)
90   DIM text$
100   DIM row%
110  DIM col%
120  DIM SHARED gridRows%
130  DIM gridCols%
140  DIM playerRow%
150  DIM playerCol%
160  DIM idx%
170  DIM cmdIdx%
180  DIM i%
190  DIM coordCount&
200  DIM filename$
210  DIM colg%
220  DIM firstZero%

250  filename$ = "input.txt"

300  REM Fill grid and movement commands
310  GOSUB 8500

350  REM Calculate movements
360  GOSUB 3200
370  REM GOSUB 9000

400  REM Calculate score
410  GOSUB 3000
420  PRINT "Coordinate Score: "; coordCount&

450  PRINT "Part 2"

500  REM Fill bigger grid and movement commands
510  GOSUB 8900

550  REM Calculate movements
560  GOSUB 6000
570  REM GOSUB 9000
580  REM GOSUB 9300

600  REM Calculate score
610  GOSUB 3000
620  PRINT "Coordinate Score (big): "; coordCount&

999  END




1000 REM Move character up subroutine
1010   REM Check for first wall -> row index: idx%
1020   FOR row% = playerRow% TO 1 STEP -1
1030     IF grid%(row%, playerCol%) = 1 THEN
1040       idx% = row%
1050       GOTO 1075
1060     END IF
1070   NEXT row%
1071   PRINT "Something went wrong in the MOVE UP subroutine!"
1075   REM PRINT idx%
1079   REM Check for first empty space up until wall -> row index: idx%
1080   FOR row% = playerRow% TO idx% STEP -1
1090     IF grid%(row%, playerCol%) = 0 THEN
1100       idx% = row%
1110       GOTO 1150
1120     END IF
1130   NEXT row%
1131   REM No empty space found -> exit subroutine
1140   RETURN
1149   REM Space found -> row index: idx%
1150   FOR row% = idx% TO playerRow% - 1
1160     grid%(row%, playerCol%) = grid%(row% + 1, playerCol%)
1170   NEXT row%
1180   grid%(playerRow%, playerCol%) = 0
1190   playerRow% = playerRow% - 1
1200   RETURN

1500 REM Move character down subroutine
1510   REM Check for first wall -> row index: idx%
1520   FOR row% = playerRow% TO gridRows%
1530     IF grid%(row%, playerCol%) = 1 THEN
1540       idx% = row%
1550       GOTO 1575
1560     END IF
1570   NEXT row%
1571   PRINT "Something went wrong in the MOVE DOWN subroutine!"
1575   REM PRINT idx%
1579   REM Check for first empty space up until wall -> row index: idx%
1580   FOR row% = playerRow% TO idx%
1590     IF grid%(row%, playerCol%) = 0 THEN
1600       idx% = row%
1610       GOTO 1650
1620     END IF
1630   NEXT row%
1631   REM No empty space found -> exit subroutine
1640   RETURN
1649   REM Space found -> row index: idx%
1650   FOR row% = idx% - 1 TO playerRow% STEP -1
1660     grid%(row% + 1, playerCol%) = grid%(row%, playerCol%)
1670   NEXT row%
1680   grid%(playerRow%, playerCol%) = 0
1690   playerRow% = playerRow% + 1
1700   RETURN

2000 REM Move character right subroutine
2010   REM Check for first wall -> col index: idx%
2020   FOR col% = playerCol% TO gridCols%
2030     IF grid%(playerRow%, col%) = 1 THEN
2040       idx% = col%
2050       GOTO 2075
2060     END IF
2070   NEXT col%
2071   PRINT "Something went wrong in the MOVE RIGHT subroutine!"
2075   REM PRINT idx%
2079   REM Check for first empty space up until wall -> col index: idx%
2080   FOR col% = playerCol% TO idx%
2090     IF grid%(playerRow%, col%) = 0 THEN
2100       idx% = col%
2110       GOTO 2150
2120     END IF
2130   NEXT col%
2131   REM No empty space found -> exit subroutine
2140   RETURN
2149   REM Space found -> col index: idx%
2150   FOR col% = idx% - 1 TO playerCol% STEP -1
2160     grid%(playerRow%, col% + 1) = grid%(playerRow%, col%)
2170   NEXT col%
2180   grid%(playerRow%, playerCol%) = 0
2190   playerCol% = playerCol% + 1
2200   RETURN

2500 REM Move character left subroutine
2510   REM Check for first wall -> col index: idx%
2520   FOR col% = playerCol% TO 1 STEP -1
2530     IF grid%(playerRow%, col%) = 1 THEN
2540       idx% = col%
2550       GOTO 2575
2560     END IF
2570   NEXT col%
2571   PRINT "Something went wrong in the MOVE LEFT subroutine!"
2575   REM PRINT idx%
2579   REM Check for first empty space up until wall -> col index: idx%
2580   FOR col% = playerCol% TO idx% STEP -1
2590     IF grid%(playerRow%, col%) = 0 THEN
2600       idx% = col%
2610       GOTO 2650
2620     END IF
2630   NEXT col%
2631   REM No empty space found -> exit subroutine
2640   RETURN
2649   REM Space found -> col index: idx%
2650   FOR col% = idx% TO playerCol% - 1
2660     grid%(playerRow%, col%) = grid%(playerRow%, col% + 1)
2670   NEXT col%
2680   grid%(playerRow%, playerCol%) = 0
2690   playerCol% = playerCol% - 1
2700   RETURN

3000 REM Calculate Coordinates
3010   coordCount& = 0
3020   FOR row% = 1 TO gridRows%
3030     FOR col% = 1 TO gridCols%
3040       IF grid%(row%, col%) = 2 THEN
3050         coordCount& = coordCount& + 100 * (row% - 1) + (col% - 1)
3055         REM PRINT coordCount&
3060       END IF
3070     NEXT col%
3080   NEXT row%
3090   RETURN

3200 REM Do movements
3210   FOR i% = 1 TO cmdIdx%
3215     REM PRINT "Command: "; commands%(i%)
3220     REM GOSUB 9000
3230     SELECT CASE commands%(i%)
           CASE 1
             GOSUB 1000
           CASE 2
             GOSUB 1500
           CASE 3
             GOSUB 2000
           CASE 4
             GOSUB 2500
         END SELECT
3240   NEXT i%
3250   REM GOSUB 9000
3270   RETURN

3500 REM Check if move up is possible
3510 FUNCTION CheckMoveUp%(rc%, cc%)
3520   DIM ri%
3530   DIM res%
3540   res% = 0
3550   FOR ri% = rc% TO 1 STEP -1
3560     IF res% = 1 THEN
3570       GOTO 3660
3580     END IF
3590     SELECT CASE grid%(ri%, cc%)
           CASE 1
             res% = 1
           CASE 0
             GOTO 3660
           CASE 2
             gridMove%(ri%, cc%) = 1
             gridMove%(ri%, cc% + 1) = 1
             res% = CheckMoveUp%(ri% - 1, cc% + 1)
           CASE 3
             gridMove%(ri%, cc%) = 1
             gridMove%(ri%, cc% - 1) = 1
             res% = CheckMoveUp%(ri% - 1, cc% - 1)
           CASE 4
             gridMove%(ri%, cc%) = 1
         END SELECT 
3650   NEXT ri%
3660   CheckMoveUp% = res%
3670 END FUNCTION

3700 REM Check if move down is possible
3710 FUNCTION CheckMoveDown%(rc%, cc%)
3720   DIM ri%
3730   DIM res%
3740   res% = 0
3750   FOR ri% = rc% TO gridRows%
3760     IF res% = 1 THEN
3770       GOTO 3860
3780     END IF
3790     SELECT CASE grid%(ri%, cc%)
           CASE 1
             res% = 1
           CASE 0
             GOTO 3860
           CASE 2
             gridMove%(ri%, cc%) = 1
             gridMove%(ri%, cc% + 1) = 1
             res% = CheckMoveDown%(ri% + 1, cc% + 1)
           CASE 3
             gridMove%(ri%, cc%) = 1
             gridMove%(ri%, cc% - 1) = 1
             res% = CheckMoveDown%(ri% + 1, cc% - 1)
           CASE 4
             gridMove%(ri%, cc%) = 1
         END SELECT 
3850   NEXT ri%
3860   CheckMoveDown% = res%
3870 END FUNCTION

5000 REM Move character up subroutine (big grid)
5010   REM reset gridMove
5020   GOSUB 6200
5030   REM Check if move up is possible and set gridMove
5040   IF CheckMoveUp%(playerRow%, playerCol%) = 1 THEN
5050     RETURN
5060   END IF
5065   REM GOSUB 9300
5070   REM loop over gridMove and move places
5080   FOR col% = 1 TO gridCols%
5090     firstZero% = 0
5100     FOR row% = 1 TO gridRows%
5110       IF gridMove%(row%, col%) = 1 THEN
5120         firstZero% = 1
5130         grid%(row% - 1, col%) = grid%(row%, col%)
5140       ELSEIF firstZero% = 1 THEN
5150         firstZero% = 0
5160         grid%(row% - 1, col%) = 0
5170       END IF
5180     NEXT row%
5190   NEXT col%
5200   playerRow% = playerRow% - 1
5210   RETURN

5500 REM Move character down subroutine (big grid)
5510   REM reset gridMove
5520   GOSUB 6200
5530   REM Check if move down is possible and set gridMove
5540   IF CheckMoveDown%(playerRow%, playerCol%) = 1 THEN
5550     RETURN
5560   END IF
5565   REM GOSUB 9300
5570   REM loop over gridMove and move places
5580   FOR col% = 1 TO gridCols%
5590     firstZero% = 0
5600     FOR row% = gridRows% TO 1 STEP -1
5610       IF gridMove%(row%, col%) = 1 THEN
5620         firstZero% = 1
5630         grid%(row% + 1, col%) = grid%(row%, col%)
5640       ELSEIF firstZero% = 1 THEN
5650         firstZero% = 0
5660         grid%(row% + 1, col%) = 0
5670       END IF
5680     NEXT row%
5690   NEXT col%
5700   playerRow% = playerRow% + 1
5710   RETURN

6000 REM Do movements (big grid)
6030   FOR i% = 1 TO cmdIdx%
6040     REM PRINT "Command: "; commands%(i%)
6050     REM GOSUB 9000
6060     SELECT CASE commands%(i%)
           CASE 1
             GOSUB 5000
           CASE 2
             GOSUB 5500
           CASE 3
             GOSUB 2000
           CASE 4
             GOSUB 2500
         END SELECT
6110   NEXT i%
6120   REM GOSUB 9000
6130   RETURN

6200 REM Initialize gridMove with zeros
6210   FOR row% = 1 TO gridRows%
6220     FOR col% = 1 TO gridCols%
6230       gridMove%(row%, col%) = 0
6240     NEXT col%
6250   NEXT row%
6260   RETURN

8000 REM Fill Grid
8010   gridRows% = 0
8020   gridCols% = 0
8030   REM Read grid from file
8040   OPEN filename$ FOR INPUT AS #69
8050   DO
8060     LINE INPUT #69, text$
8070     IF text$ = "" THEN EXIT DO
8080     gridRows% = gridRows% + 1
8090     gridCols% = LEN(text$)
8100     FOR col% = 1 TO LEN(text$)
8200       SELECT CASE MID$(text$, col%, 1)
             CASE "."
               grid%(gridRows%, col%) = 0
             CASE "#"
               grid%(gridRows%, col%) = 1
             CASE "O"
               grid%(gridRows%, col%) = 2
             CASE "@"
               grid%(gridRows%, col%) = 4
               playerRow% = gridRows%
               playerCol% = col%
           END SELECT
8250     NEXT col%
8260   LOOP
8270   RETURN

8300 REM Fill Movement Commands
8310   cmdIdx% = 0
8320   DO
8330     LINE INPUT #69, text$
8340     FOR col% = 1 TO LEN(text$)
8350       SELECT CASE MID$(text$, col%, 1)
             CASE "^"
               cmdIdx% = cmdIdx% + 1
               commands%(cmdIdx%) = 1
             CASE "v"
               cmdIdx% = cmdIdx% + 1
               commands%(cmdIdx%) = 2
             CASE ">"
               cmdIdx% = cmdIdx% + 1
               commands%(cmdIdx%) = 3
             CASE "<"
               cmdIdx% = cmdIdx% + 1
               commands%(cmdIdx%) = 4
8400       END SELECT
8410     NEXT col%
8420   LOOP UNTIL EOF(69)
8430   CLOSE #69
8440   RETURN

8500 REM Fill grid and read movement commands
8510   GOSUB 8000
8520   GOSUB 8300
8530   RETURN

8600 REM Fill Grid (broader)
8610   gridRows% = 0
8620   gridCols% = 0
8630   REM Read grid from file
8640   OPEN filename$ FOR INPUT AS #69
8650   DO
8660     LINE INPUT #69, text$
8670     IF text$ = "" THEN EXIT DO
8680     gridRows% = gridRows% + 1
8690     gridCols% = LEN(text$) * 2
8700     FOR col% = 1 TO LEN(text$)
8710       colg% = (col% - 1) * 2 + 1
8720       SELECT CASE MID$(text$, col%, 1)
             CASE "."
               grid%(gridRows%, colg%) = 0
               grid%(gridRows%, colg% + 1) = 0
             CASE "#"
               grid%(gridRows%, colg%) = 1
               grid%(gridRows%, colg% + 1) = 1
             CASE "O"
               grid%(gridRows%, colg%) = 2
               grid%(gridRows%, colg% + 1) = 3
             CASE "@"
               grid%(gridRows%, colg%) = 4
               grid%(gridRows%, colg% + 1) = 0
               playerRow% = gridRows%
               playerCol% = colg%
           END SELECT
8770     NEXT col%
8780   LOOP
8790   RETURN

8900 REM Fill grid and read movement commands
8910   GOSUB 8600
8920   GOSUB 8300
8930   RETURN

9000 REM Output Grid
9020   PRINT "Grid:   ("; gridRows%; "x"; gridCols%; ")"
9030   PRINT "Player: "; playerRow%; ","; playerCol%
9040   FOR row% = 1 TO gridRows%
9050     FOR col% = 1 TO gridCols%
9060       PRINT grid%(row%, col%);
9070     NEXT col%
9080     PRINT
9090   NEXT row%
9100   RETURN

9200 REM Output commands
9220   PRINT "Commands: "
9230   FOR col% = 1 TO cmdIdx%
9240     PRINT commands%(col%)
9250   NEXT col%
9260   RETURN

9300 REM Output GridMove
9310   PRINT "GridMove:"
9340   FOR row% = 1 TO gridRows%
9350     FOR col% = 1 TO gridCols%
9360       PRINT gridMove%(row%, col%);
9370     NEXT col%
9380     PRINT
9390   NEXT row%
9400   RETURN