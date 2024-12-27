      ! f77 aoc8.f -o aoc8 && ./aoc8

      ! main function
      PROGRAM TEST
         ! Define shit
         INTEGER, PARAMETER :: MAX_LINE = 100
         INTEGER, PARAMETER :: CHAR_COUNT = 62
         INTEGER, PARAMETER :: MAX_COUNT = 1000
         CHARACTER*(MAX_LINE) :: LINE
         INTEGER :: POS_X(CHAR_COUNT * MAX_COUNT)
         INTEGER :: POS_Y(CHAR_COUNT * MAX_COUNT)
         INTEGER :: NEW_POS_X_I(MAX_LINE * MAX_LINE)
         INTEGER :: NEW_POS_Y_I(MAX_LINE * MAX_LINE)
         INTEGER :: NEW_POS_X(MAX_LINE * MAX_LINE)
         INTEGER :: NEW_POS_Y(MAX_LINE * MAX_LINE)
         INTEGER :: NEW_COUNTER, NEW_COUNTER_I
         INTEGER :: COUNTER(CHAR_COUNT)
         INTEGER :: ROWS, COLS, LEN_LINE, CHAR_IDX
         INTEGER :: CHAR_TO_IDX
         INTEGER :: I, J, X, Y
         CHARACTER :: C
         LOGICAL :: IS_NEW

         ! Day 8 of AOC 2024
         PRINT *, 'DAY 8 OF AOC 2024'
         ! Part 1
         PRINT *, 'PART 1'

         ! set up parameters
         ROWS = 0
         COLS = 0
         DO I = 1, CHAR_COUNT
            COUNTER(I) = 0
         END DO

         ! read file
         OPEN(UNIT=69, FILE='input.txt',
     &        STATUS='OLD', ACTION='READ')

         DO WHILE (.TRUE.)
            READ(69, '(A)', END=666) LINE
            ROWS = ROWS + 1
            LEN_LINE = LEN_TRIM(LINE)
            IF (LEN_LINE > COLS) COLS = LEN_LINE

            DO I = 1, LEN_LINE
               C = LINE(I:I)
               CHAR_IDX = CHAR_TO_IDX(C)
               IF (CHAR_IDX > 0) THEN
                  COUNTER(CHAR_IDX) = COUNTER(CHAR_IDX)+1
                  POS_X((CHAR_IDX-1)*MAX_COUNT+COUNTER(CHAR_IDX))=ROWS
                  POS_Y((CHAR_IDX-1)*MAX_COUNT+COUNTER(CHAR_IDX))=I
               END IF
            END DO
         END DO
666      CONTINUE
         CLOSE(69)

         ! print all information
         !CALL PRINT_GRID_INFO(ROWS, COLS, CHAR_COUNT, COUNTER,
     &   !                     POS_X, POS_Y, MAX_COUNT)

         ! get new positions for all characters and add them to list
         NEW_COUNTER = 0
         DO CHAR_IDX = 1, CHAR_COUNT
            CALL GEN_NEW_POSITIONS(CHAR_IDX, POS_X, POS_Y, COUNTER,
     &                             ROWS, COLS, MAX_COUNT,
     &                             NEW_POS_X_I, NEW_POS_Y_I,
     &                             NEW_COUNTER_I)

            ! DEBUG: print positions
            !PRINT *, 'NEW POSITIONS FOR CHARACTER:'
            !CALL PRINT_CHAR(CHAR_IDX)
            !DO I = 1, NEW_COUNTER_I
            !   PRINT *, '(', NEW_POS_X_I(I), ',', NEW_POS_Y_I(I), ')'
            !END DO
            ! END DEBUG: print positions

            ! loop over all new positions
            DO I = 1, NEW_COUNTER_I
               IS_NEW = .TRUE.
               X = NEW_POS_X_I(I)
               Y = NEW_POS_Y_I(I)

               ! check if new position was seen before
               DO J = 1, NEW_COUNTER
                  IF (X == NEW_POS_X(J) .AND. Y == NEW_POS_Y(J)) THEN
                     IS_NEW = .FALSE.
                     EXIT
                  END IF
               END DO

               ! add to list if was not seen before
               IF (IS_NEW) THEN
                  NEW_COUNTER = NEW_COUNTER + 1
                  NEW_POS_X(NEW_COUNTER) = X
                  NEW_POS_Y(NEW_COUNTER) = Y
               END IF
            END DO
         END DO
         
         ! print total number of new positions
         PRINT *, 'NUMBER OF NEW POSITIONS: ', NEW_COUNTER

         ! Part 2
         PRINT *, 'PART 2'

         ! get new positions for all characters and add them to list
         NEW_COUNTER = 0
         DO CHAR_IDX = 1, CHAR_COUNT
            CALL GEN_NEW_POSITIONS_E(CHAR_IDX, POS_X, POS_Y, COUNTER,
     &                               ROWS, COLS, MAX_COUNT,
     &                               NEW_POS_X_I, NEW_POS_Y_I,
     &                               NEW_COUNTER_I)

            ! DEBUG: print positions
            !PRINT *, 'NEW POSITIONS (END) FOR CHARACTER:'
            !CALL PRINT_CHAR(CHAR_IDX)
            !DO I = 1, NEW_COUNTER_I
            !   PRINT *, '(', NEW_POS_X_I(I), ',', NEW_POS_Y_I(I), ')'
            !END DO
            ! END DEBUG: print positions

            ! loop over all new positions
            DO I = 1, NEW_COUNTER_I
               IS_NEW = .TRUE.
               X = NEW_POS_X_I(I)
               Y = NEW_POS_Y_I(I)

               ! check if new position was seen before
               DO J = 1, NEW_COUNTER
                  IF (X == NEW_POS_X(J) .AND. Y == NEW_POS_Y(J)) THEN
                     IS_NEW = .FALSE.
                     EXIT
                  END IF
               END DO

               ! add to list if was not seen before
               IF (IS_NEW) THEN
                  NEW_COUNTER = NEW_COUNTER + 1
                  NEW_POS_X(NEW_COUNTER) = X
                  NEW_POS_Y(NEW_COUNTER) = Y
               END IF
            END DO
         END DO
         
         ! print total number of new positions
         PRINT *, 'NUMBER OF NEW POSITIONS (END): ', NEW_COUNTER

      END PROGRAM TEST

      ! function to convert character to an index into arrays
      INTEGER FUNCTION CHAR_TO_IDX(C)
         CHARACTER :: C
         INTEGER :: IDX

         IF (C .GE. 'a' .AND. C .LE. 'z') THEN
            IDX = ICHAR(C) - ICHAR('a') + 1
         ELSE IF (C .GE. 'A' .AND. C .LE. 'Z') THEN
            IDX = ICHAR(C) - ICHAR('A') + 27
         ELSE IF (C .GE. '0' .AND. C .LE. '9') THEN
            IDX = ICHAR(C) - ICHAR('0') + 53
         ELSE
            IDX = 0
         END IF

         CHAR_TO_IDX = IDX

      RETURN
      END FUNCTION CHAR_TO_IDX

      ! subroutine to print grid information
      SUBROUTINE PRINT_GRID_INFO(ROWS, COLS, CHAR_COUNT, COUNTER,
     &                           POS_X, POS_Y, MAX_COUNT)
         INTEGER :: ROWS, COLS, CHAR_COUNT, MAX_COUNT
         INTEGER :: COUNTER(*), POS_X(*), POS_Y(*)
         CHARACTER :: C
         INTEGER :: CHAR_IDX

         PRINT *, 'GRID SIZE: ', ROWS, ' x ', COLS
         PRINT *, 'POSITIONS OF CHARACTERS:'
         DO CHAR_IDX = 1, CHAR_COUNT
            CALL PRINT_CHAR(CHAR_IDX)
            DO I = 1, COUNTER(CHAR_IDX)
               PRINT *, ': (', POS_X((CHAR_IDX-1)*MAX_COUNT+I),
     &                  ',', POS_Y((CHAR_IDX-1)*MAX_COUNT+I), ')'
            END DO
         END DO

      RETURN
      END SUBROUTINE PRINT_GRID_INFO

      ! subroutine to print a character with given char_idx
      SUBROUTINE PRINT_CHAR(CHAR_IDX)
         INTEGER :: CHAR_IDX
         CHARACTER :: C

         IF (CHAR_IDX .LE. 26) THEN
            C = CHAR(ICHAR('a') + CHAR_IDX - 1)
         ELSE IF(CHAR_IDX .LE. 52) THEN
            C = CHAR(ICHAR('A') + CHAR_IDX - 27)
         ELSE
            C = CHAR(ICHAR('0') + CHAR_IDX - 53)
         END IF

         PRINT *, C

      RETURN
      END SUBROUTINE PRINT_CHAR

      ! subroutine to generate new positions
      SUBROUTINE GEN_NEW_POSITIONS(CHAR_IDX, POS_X, POS_Y, COUNTER,
     &                             ROWS, COLS, MAX_COUNT,
     &                             NEW_POS_X, NEW_POS_Y, NEW_COUNTER)
         INTEGER :: CHAR_IDX, ROWS, COLS, MAX_COUNT, NEW_COUNTER
         INTEGER :: COUNTER(*), POS_X(*), POS_Y(*)
         INTEGER :: NEW_POS_X(*), NEW_POS_Y(*)
         INTEGER :: I, J, X1, Y1, X2, Y2, NEW_X, NEW_Y

         ! loop over all indices from given character (index)
         NEW_COUNTER = 0
         DO I = 1, COUNTER(CHAR_IDX)
            ! get position pos1
            X1 = POS_X((CHAR_IDX-1)*MAX_COUNT+I)
            Y1 = POS_Y((CHAR_IDX-1)*MAX_COUNT+I)

            ! loop over all other indices
            DO J = I + 1, COUNTER(CHAR_IDX)
               ! get position pos2
               X2 = POS_X((CHAR_IDX-1)*MAX_COUNT+J)
               Y2 = POS_Y((CHAR_IDX-1)*MAX_COUNT+J)

               ! get new = pos2 + (pos2 - pos1)
               NEW_X = X2 + (X2 - X1)
               NEW_Y = Y2 + (Y2 - Y1)

               ! check if is in grid and add to list
               IF (NEW_X > 0 .AND. NEW_X <= ROWS .AND.
     &             NEW_Y > 0 .AND. NEW_y <= COLS) THEN
                  NEW_COUNTER = NEW_COUNTER + 1
                  NEW_POS_X(NEW_COUNTER) = NEW_X
                  NEW_POS_Y(NEW_COUNTER) = NEW_Y
               END IF

               ! get new = pos1 + (pos1 - pos2)
               NEW_X = X1 + (X1 - X2)
               NEW_Y = Y1 + (Y1 - Y2)

               ! check if is in grid and add to list
               IF (NEW_X > 0 .AND. NEW_X <= ROWS .AND.
     &             NEW_Y > 0 .AND. NEW_y <= COLS) THEN
                  NEW_COUNTER = NEW_COUNTER + 1
                  NEW_POS_X(NEW_COUNTER) = NEW_X
                  NEW_POS_Y(NEW_COUNTER) = NEW_Y
               END IF
            END DO
         END DO

      RETURN
      END SUBROUTINE GEN_NEW_POSITIONS

      ! subroutine to generate new positions until end of grid
      SUBROUTINE GEN_NEW_POSITIONS_E(CHAR_IDX, POS_X, POS_Y, COUNTER,
     &                               ROWS, COLS, MAX_COUNT,
     &                               NEW_POS_X, NEW_POS_Y, NEW_COUNTER)
         INTEGER :: CHAR_IDX, ROWS, COLS, MAX_COUNT, NEW_COUNTER
         INTEGER :: COUNTER(*), POS_X(*), POS_Y(*)
         INTEGER :: NEW_POS_X(*), NEW_POS_Y(*)
         INTEGER :: I, J, X1, Y1, X2, Y2, NEW_X, NEW_Y, VX, VY

         ! loop over all indices from given character (index)
         NEW_COUNTER = 0
         DO I = 1, COUNTER(CHAR_IDX)
            ! get position pos1
            X1 = POS_X((CHAR_IDX-1)*MAX_COUNT+I)
            Y1 = POS_Y((CHAR_IDX-1)*MAX_COUNT+I)

            ! loop over all other indices
            DO J = I + 1, COUNTER(CHAR_IDX)
               ! get position pos2
               X2 = POS_X((CHAR_IDX-1)*MAX_COUNT+J)
               Y2 = POS_Y((CHAR_IDX-1)*MAX_COUNT+J)

               ! get v = (pos2 - pos1), new = pos2
               NEW_X = X2
               VX = X2 - X1
               NEW_Y = Y2
               VY = Y2 - Y1

               ! do until we reach end of grid
               DO WHILE (.TRUE.)
                  ! check if is in grid and add to list
                  IF (NEW_X > 0 .AND. NEW_X <= ROWS .AND.
     &                NEW_Y > 0 .AND. NEW_y <= COLS) THEN
                     NEW_COUNTER = NEW_COUNTER + 1
                     NEW_POS_X(NEW_COUNTER) = NEW_X
                     NEW_POS_Y(NEW_COUNTER) = NEW_Y
                  ELSE
                     EXIT
                  END IF
               
                  ! get next new
                  NEW_X = NEW_X + VX
                  NEW_Y = NEW_Y + VY
               END DO

               ! get v = (pos1 - pos2), new = pos1
               NEW_X = X1
               VX = X1 - X2
               NEW_Y = Y1
               VY = Y1 - Y2

               ! do until we reach end of grid
               DO WHILE (.TRUE.)
                  ! check if is in grid and add to list
                  IF (NEW_X > 0 .AND. NEW_X <= ROWS .AND.
     &                NEW_Y > 0 .AND. NEW_y <= COLS) THEN
                     NEW_COUNTER = NEW_COUNTER + 1
                     NEW_POS_X(NEW_COUNTER) = NEW_X
                     NEW_POS_Y(NEW_COUNTER) = NEW_Y
                  ELSE
                     EXIT
                  END IF
               
                  ! get next new
                  NEW_X = NEW_X + VX
                  NEW_Y = NEW_Y + VY
               END DO
            END DO
         END DO

      RETURN
      END SUBROUTINE GEN_NEW_POSITIONS_E
