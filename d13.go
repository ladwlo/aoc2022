package main

import (
  "fmt"
  "os"
  "bufio"
  "encoding/json"
  "sort"
)

func isNum(e interface{}) bool {
  switch e.(type) {
    case float64:
      return true
  }
  return false
}

func wrap(e interface{}) []interface{} {
  if isNum(e) {
    wrapped := make([]interface{}, 1)
    wrapped[0] = e
    return wrapped
  }
  return e.([]interface{})
}

func cmp(l1, l2 []interface{}) int {
  n := len(l1)
  if len(l2) < n {
    n = len(l2)
  }
  for i := 0; i < n; i++ {
    e1 := l1[i]
    e2 := l2[i]
    var c int
    if isNum(e1) && isNum(e2) {
      c = int(e1.(float64)) - int(e2.(float64))
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
  f, _ := os.Open("../aoc2022/input/day13.txt")
  sc := bufio.NewScanner(f)
  sc.Split(bufio.ScanLines)
  var lists [][]interface{}
  for sc.Scan() {
    var list []interface{}
    line := sc.Text()
    if line != "" {
      json.Unmarshal([]byte(line), &list)
      lists = append(lists, list)
    }
  }
  f.Close()

  n := len(lists) / 2
  sum := 0
  for i := 0; i < n; i++ {
    if cmp(lists[2 * i], lists[2 * i + 1]) <= 0 {
      sum += (i + 1)
    }
  }
  fmt.Println(sum)

  var m2 []interface{}
  json.Unmarshal([]byte("[[2]]"), &m2)
  var m6 []interface{}
  json.Unmarshal([]byte("[[6]]"), &m6)
  markers := [][]interface{}{m2, m6}
  lists = append(lists, markers...)
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
}

