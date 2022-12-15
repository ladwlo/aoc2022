package main

import (
  "fmt"
  "os"
  "bufio"
  "sort"
  "time"
)

func addDigit(number int, char byte) int {
  if number < 0 {
    return int(char)
  }
  return 10 * number + int(char)
}

func parse(line string) []any {
  stack := make([][]any, 64)
  stackTop := -1
  var list []any
  var number int = -1
  for i := 0; i < len(line); i++ {
    c := line[i]
    if c == '[' {
      if list != nil {
        stackTop += 1
        stack[stackTop] = list
      }
      list = make([]any, 0)
    } else if c == ']' || c == ',' {
      if number >= 0 {
        list = append(list, number)
        number = -1
      }
      if c == ']' {
        if stackTop < 0 {
          return list
        }
        list = append(stack[stackTop], list)
        stackTop -= 1
      }
    } else {
      number = addDigit(number, c)
    }
  }
  return nil // should never reach this line
}

func isNum(e any) bool {
  switch e.(type) {
    case int:
      return true
  }
  return false
}

func wrap(e any) []any {
  if isNum(e) {
    return []any{e}
  }
  return e.([]any)
}

func cmp(l1, l2 []any) int {
  n := len(l1)
  if len(l2) < n {
    n = len(l2)
  }
  for i := 0; i < n; i++ {
    e1 := l1[i]
    e2 := l2[i]
    var c int
    if isNum(e1) && isNum(e2) {
      c = e1.(int) - e2.(int)
    } else {
      c = cmp(wrap(e1), wrap(e2))
    }
    if c != 0 {
      return c
    }
  }  
  return len(l1) - len(l2)
}

func main() {
  start := time.Now()
  overallStart := start

  f, _ := os.Open("../aoc2022/input/day13.txt")
  sc := bufio.NewScanner(f)
  sc.Split(bufio.ScanLines)
  var lists [][]any
  for sc.Scan() {
    line := sc.Text()
    if line != "" {
      lists = append(lists, parse(line))
    }
  }
  f.Close()

//   f, _ := os.Open("../aoc2022/input/day13.txt")
//   sc := bufio.NewScanner(f)
//   sc.Split(bufio.ScanLines)
//   var lists [][]any
//   for sc.Scan() {
//     var list []any
//     line := sc.Text()
//     if line != "" {
//       json.Unmarshal([]byte(line), &list)
//       lists = append(lists, list)
//     }
//   }
//   f.Close()

  parseTime := time.Since(start)
  start = time.Now()

  n := len(lists) / 2
  sum := 0
  for i := 0; i < n; i++ {
    if cmp(lists[2 * i], lists[2 * i + 1]) <= 0 {
      sum += (i + 1)
    }
  }
  fmt.Println(sum)

  part1Time := time.Since(start)
  start = time.Now()

  m2 := parse("[[2]]")
  m6 := parse("[[6]]")
  lists = append(lists, m2, m6)
  sort.Slice(lists, func(i, j int) bool {
    return cmp(lists[i], lists[j]) < 0
  })
  i2 := 0
  i6 := 0
  for i, v := range lists {
    if cmp(v, m2) == 0 {
      i2 = i + 1
    }
    if cmp(v, m6) == 0 {
      i6 = i + 1
    }
  }
  fmt.Println(i2 * i6)

  part2Time := time.Since(start)

  fmt.Println("Parsing: ", parseTime)
  fmt.Println("Part 1: ", part1Time)
  fmt.Println("Part 2: ", part2Time)
  fmt.Println("Overall time: ", time.Since(overallStart))
}
