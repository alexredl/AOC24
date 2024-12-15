' cscript aoc12.vbs

' Day 12 of AOC 2024
WScript.Echo "Day 12 of AOC 2024"
' Part 1
WScript.Echo "Part 1"

' read file
Dim filepath, grid
filepath = "input.txt"
grid = readFile(filepath)
'Call printGrid(grid)

' make empty grid
Dim eGrid
eGrid = emptyGrid(grid)
'Call printGrid(eGrid)

' Find element in unvisited region
Dim fence_sum
fence_sum = 0
Dim uIdx, stats
Do While True
  uIdx = findFirstZero(eGrid)
  If uIdx(0) = -1 Or uIdx(1) = -1 Then
    Exit Do
  End If
  stats = calcAreaCirc(grid, eGrid, uIdx, grid(uIdx(0), uIdx(1)))
  'WScript.Echo grid(uIdx(0), uIdx(1)) & "(" & uIdx(0) & ", " & uIdx(1) & "): border=" & stats(0) & ", area=" & stats(1)
  'Call printGrid(grid)
  'Call printGrid(eGrid)
  fence_sum = fence_sum + stats(0) * stats(1)
Loop

WScript.Echo "Sum of fence is: " & fence_sum


' Part 2
WScript.Echo "Part 2"

' make empty grid
eGrid = emptyGrid(grid)
'Call printGrid(eGrid)

' Find element in unvisited region
Dim corner_sum
corner_sum = 0
Do While True
  uIdx = findFirstZero(eGrid)
  If uIdx(0) = -1 Or uIdx(1) = -1 Then
    Exit Do
  End If
  stats = calcCorners(grid, eGrid, uIdx, grid(uIdx(0), uIdx(1)))
  'WScript.Echo grid(uIdx(0), uIdx(1)) & "(" & uIdx(0) & ", " & uIdx(1) & "): corner=" & stats(0) & ", area=" & stats(1)
  'Call printGrid(grid)
  'Call printGrid(eGrid)
  corner_sum = corner_sum + stats(0) * stats(1)
Loop

WScript.Echo "Sum of corners is: " & corner_sum 







' function to read file into 2D array
Function readFile(filename)
  Dim fso, file
  Dim line, lines, maxCols, row, col, i
  Dim arr()

  Set fso = CreateObject("Scripting.FileSystemObject")
  Set file = fso.OpenTextFile(filename)
  lines = Array()

  Do Until file.AtEndOfStream
    line = file.Readline
    ReDim Preserve lines(UBound(lines) + 1)
    lines(UBound(lines)) = line
  Loop
  file.Close

  maxCols = Len(lines(0))
  ReDim arr(UBound(lines), maxCols - 1)

  For row = 0 To UBound(lines)
    For col = 0 To maxCols - 1
        arr(row, col) = Mid(lines(row), col + 1, 1)
    Next
  Next

  readFile = arr
End Function

' function for printing a grid
Function printGrid(grid)
  Dim r, c
  Dim line
  For r = LBound(grid, 1) To UBound(grid, 1)
    line = ""
    For c = LBound(grid, 2) To UBound(grid, 2)
      line = line & grid(r, c)
      'WScript.Echo "Row: " & r & ", Col: " & c & ": " & grid(r, c)
    Next
  WScript.Echo line
  Next
End Function

' function to produce empty (=0) grid with same dimensions as other grid
Function emptyGrid(grid)
  Dim arr()
  Dim rowMin, rowMax, colMin, colMax
  Dim r, c

  rowMin = LBound(grid, 1)
  rowMax = UBound(grid, 1)
  colMin = LBound(grid, 2)
  colMax = UBound(grid, 2)

  ReDim arr(rowMax - rowMin, colMax - colMin)

  For r = rowMin To rowMax
    For c = colMin To colMax
      arr(r, c) = 0
    Next
  Next

  emptyGrid = arr
End Function

' function to find first index for non-done area
Function findFirstZero(eGrid)
  Dim r, c
  For r = LBound(eGrid, 1) To UBound(eGrid, 1)
    For c = LBound(eGrid, 2) To UBound(eGrid, 2)
      If eGrid(r, c) = 0 Then
        findFirstZero = Array(r, c)
        Exit Function
      End If
    Next
  Next
  findFirstZero = Array(-1, -1)
End Function

' function to find region area and circumfence from given start index
Function calcAreaCirc(grid, eGrid, pos, plant)
  Dim border, area
  Dim rowMin, rowMax, colMin, colMax

  rowMin = LBound(grid, 1)
  rowMax = UBound(grid, 1)
  colMin = LBound(grid, 2)
  colMax = UBound(grid, 2)

  'WScript.Echo "rowMin: " & rowMin & ", rowMax: " & rowMax & ", colMin: " & colMin & ", colMax: " & colMax

  'WScript.Echo "(" & pos(0) & ", " & pos(1) & ")"
  ' outside grid
  If pos(0) < rowMin Or pos(0) > rowMax Or pos(1) < colMin Or pos(1) > colMax Then
    'WScript.Echo "break on first"
    calcAreaCirc = Array(0, 0)
    Exit Function
  End If

  ' not a valid position
  If grid(pos(0), pos(1)) <> plant Or eGrid(pos(0), pos(1)) <> 0 Then
    'WScript.Echo "break on second"
    calcAreaCirc = Array(0, 0)
    Exit Function
  End If

  ' calculate border
  border = 0
  If pos(0) = rowMin Then
    border = border + 1
  ElseIf grid(pos(0) - 1, pos(1)) <> plant Then
    border = border + 1
  End If
  If pos(0) = rowMax Then
    border = border + 1
  ElseIf grid(pos(0) + 1, pos(1)) <> plant Then
    border = border + 1
  End If
  If pos(1) = colMin Then
    border = border + 1
  ElseIf grid(pos(0), pos(1) - 1) <> plant Then
    border = border + 1
  End If
  If pos(1) = colMax Then
    border = border + 1
  ElseIf grid(pos(0), pos(1) + 1) <> plant Then
    border = border + 1
  End If

  ' Set area
  area = 1
  eGrid(pos(0), pos(1)) = 1

  Dim neighbor
  neighbor = calcAreaCirc(grid, eGrid, Array(pos(0) + 1, pos(1)), plant)
  border = border + neighbor(0)
  area = area + neighbor(1)
  neighbor = calcAreaCirc(grid, eGrid, Array(pos(0) - 1, pos(1)), plant)
  border = border + neighbor(0)
  area = area + neighbor(1)
  neighbor = calcAreaCirc(grid, eGrid, Array(pos(0), pos(1) + 1), plant)
  border = border + neighbor(0)
  area = area + neighbor(1)
  neighbor = calcAreaCirc(grid, eGrid, Array(pos(0), pos(1) - 1), plant)
  border = border + neighbor(0)
  area = area + neighbor(1)

  calcAreaCirc = Array(border, area)
End Function


' function to count corners
Function calcCorners(grid, eGrid, pos, plant)
  Dim corner, area
  Dim rowMin, rowMax, colMin, colMax

  rowMin = LBound(grid, 1)
  rowMax = UBound(grid, 1)
  colMin = LBound(grid, 2)
  colMax = UBound(grid, 2)

  'WScript.Echo "rowMin: " & rowMin & ", rowMax: " & rowMax & ", colMin: " & colMin & ", colMax: " & colMax

  'WScript.Echo "(" & pos(0) & ", " & pos(1) & ")"
  ' outside grid
  If pos(0) < rowMin Or pos(0) > rowMax Or pos(1) < colMin Or pos(1) > colMax Then
    'WScript.Echo "break on first"
    calcCorners= Array(0, 0)
    Exit Function
  End If

  ' not a valid position
  If grid(pos(0), pos(1)) <> plant Or eGrid(pos(0), pos(1)) <> 0 Then
    'WScript.Echo "break on second"
    calcCorners = Array(0, 0)
    Exit Function
  End If

  ' calculate corner
  corner = 0

  ' upper left corner
  'WScript.Echo "check upper left corner"
  If pos(0) = rowMin And pos(1) = colMin Then
    corner = corner + 1
  ElseIf pos(0) = rowMin And pos(1) <> colMin Then
    If grid(pos(0), pos(1) - 1) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(1) = colMin And pos(0) <> rowMin Then
    If grid(pos(0) - 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(0) <> rowMin And pos(1) <> colMin Then
    If grid(pos(0), pos(1) - 1) = plant And grid(pos(0) - 1, pos(1) - 1) <> plant And grid(pos(0) - 1, pos(1)) = plant Then
      corner = corner + 1
    ElseIf grid(pos(0), pos(1) - 1) <> plant And grid(pos(0) - 1, pos(1) - 1) = plant And grid(pos(0) - 1, pos(1)) = plant Then
      corner = corner + 1
    ElseIf grid(pos(0), pos(1) - 1) <> plant And grid(pos(0) - 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  End If

  ' upper right corner
  'WScript.Echo "check upper right corner"
  If pos(0) = rowMin And pos(1) = colMax Then
    corner = corner + 1
  ElseIf pos(0) = rowMin Then
    If grid(pos(0), pos(1) + 1) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(1) = colMax Then
    If grid(pos(0) - 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(0) <> rowMin And pos(1) <> colMax Then
    If grid(pos(0), pos(1) + 1) = plant And grid(pos(0) - 1, pos(1) + 1) <> plant And grid(pos(0) - 1, pos(1)) = plant Then
      corner = corner + 1
    ElseIf grid(pos(0), pos(1) + 1) <> plant And grid(pos(0) - 1, pos(1) + 1) = plant And grid(pos(0) - 1, pos(1)) = plant Then
      corner = corner + 1
    ElseIf grid(pos(0), pos(1) + 1) <> plant And grid(pos(0) - 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  End If

  ' lower left corner
  'WScript.Echo "check lower left corner"
  If pos(0) = rowMax And pos(1) = colMin Then
    corner = corner + 1
  ElseIf pos(0) = rowMax And pos(1) <> colMin Then
    If grid(pos(0), pos(1) - 1) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(1) = colMin And pos(0) <> rowMax Then
    If grid(pos(0) + 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(0) <> rowMax And pos(1) <> colMin Then
    If grid(pos(0), pos(1) - 1) <> plant And grid(pos(0) + 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  End If

  ' lower right corner
  'WScript.Echo "check lower right corner"
  If pos(0) = rowMax and pos(1) = colMax Then
    corner = corner + 1
  ElseIf pos(0) = rowMax And pos(1) <> colMax Then
    If grid(pos(0), pos(1) + 1) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(1) = colMax And pos(0) <> rowMax Then
    If grid(pos(0) + 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  ElseIf pos(0) <> rowMax And pos(1) <> colMax Then
    If grid(pos(0), pos(1) + 1) <> plant And grid(pos(0) + 1, pos(1)) <> plant Then
      corner = corner + 1
    End If
  End If

  ' Set area
  area = 1
  eGrid(pos(0), pos(1)) = 1

  ' get neighbors
  Dim neighbor
  neighbor = calcCorners(grid, eGrid, Array(pos(0) + 1, pos(1)), plant)
  corner = corner + neighbor(0)
  area = area + neighbor(1)
  neighbor = calcCorners(grid, eGrid, Array(pos(0) - 1, pos(1)), plant)
  corner = corner + neighbor(0)
  area = area + neighbor(1)
  neighbor = calcCorners(grid, eGrid, Array(pos(0), pos(1) + 1), plant)
  corner = corner + neighbor(0)
  area = area + neighbor(1)
  neighbor = calcCorners(grid, eGrid, Array(pos(0), pos(1) - 1), plant)
  corner = corner + neighbor(0)
  area = area + neighbor(1)

  calcCorners = Array(corner, area)
End Function

