import random
randomize()

const
  dp* = "• •"
  sp* = " • "

type
  Figure* = array[4,string]
  figSet* = array[4,Figure]

proc getFigure(): Figure =
  for n in 0..3:
    case [true,false].sample
    of true:  result[n] = dp
    of false: result[n] = sp

proc getMothers(): figSet =
  for n in 0..3:
    result[n] = getFigure()

proc getDaughters(mothers: figSet): figSet =
  for d in 0..3:
    result[d] = [mothers[0][d],mothers[1][d],mothers[2][d],mothers[3][d]]

proc sumFigures(fig1,fig2: Figure):Figure =
  for n in 0..3:
    if fig1[n] == fig2[n]:
      result[n] = dp
    else:
      result[n] = sp

proc getCousins(mothers,daughters:figSet): figSet = 
  result[0] = sumFigures(mothers[0],mothers[1])
  result[1] = sumFigures(mothers[2],mothers[3])
  result[2] = sumFigures(daughters[0],daughters[1])
  result[3] = sumFigures(daughters[2],daughters[3])

proc geomancy*():tuple[ms,ds,cs:figSet, rw,lw,ju:Figure] =
  let
    ms = getMothers()
    ds = getDaughters ms
    cs = getCousins(ms,ds)
    rw = sumFigures(cs[0],cs[1])
    lw = sumFigures(cs[2],cs[3])
    ju = sumFigures(rw,lw)
  return (ms,ds,cs,rw,lw,ju)

when isMainModule:
  import strformat

  let
    reading = geomancy()
    ms = reading.ms
    ds = reading.ds
    cs = reading.cs
    lw = reading.lw
    rw = reading.rw
    ju = reading.ju
    shield = &"""
Shield Chart
+---Daughters---+----Mothers----+
|{ds[3][0]}|{ds[2][0]}|{ds[1][0]}|{ds[0][0]}|{ms[3][0]}|{ms[2][0]}|{ms[1][0]}|{ms[0][0]}|
|{ds[3][1]}|{ds[2][1]}|{ds[1][1]}|{ds[0][1]}|{ms[3][1]}|{ms[2][1]}|{ms[1][1]}|{ms[0][1]}|
|{ds[3][2]}|{ds[2][2]}|{ds[1][2]}|{ds[0][2]}|{ms[3][2]}|{ms[2][2]}|{ms[1][2]}|{ms[0][2]}|
|{ds[3][3]}|{ds[2][3]}|{ds[1][3]}|{ds[0][3]}|{ms[3][3]}|{ms[2][3]}|{ms[1][3]}|{ms[0][3]}|
+---+---+---+---+---+---+---+---+
|  {cs[3][0]}  |  {cs[2][0]}  |  {cs[1][0]}  |  {cs[0][0]}  |
|  {cs[3][1]}  |  {cs[2][1]}  |  {cs[1][1]}  |  {cs[0][1]}  |
|  {cs[3][2]}  |  {cs[2][2]}  |  {cs[1][2]}  |  {cs[0][2]}  |
|  {cs[3][3]}  |  {cs[2][3]}  |  {cs[1][3]}  |  {cs[0][3]}  |
+-------+-------+-------+-------+
|      {lw[0]}      |      {rw[0]}      |
|      {lw[1]}      |      {rw[1]}      |
|      {lw[2]}      |      {rw[2]}      |
|      {lw[3]}      |      {rw[3]}      |
+---------------+---------------+
|              {ju[0]}              |
|              {ju[1]}              |
|              {ju[2]}              |
|              {ju[3]}              |
+-------------------------------+"""
  quit(shield, 0)
