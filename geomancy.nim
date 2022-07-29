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

proc getNieces(mothers,daughters:figSet): figSet = 
  result[0] = sumFigures(mothers[0],mothers[1])
  result[1] = sumFigures(mothers[2],mothers[3])
  result[2] = sumFigures(daughters[0],daughters[1])
  result[3] = sumFigures(daughters[2],daughters[3])

proc geomancy*():tuple[ms,ds,ns:figSet, rw,lw,ju:Figure] =
  let
    ms = getMothers()
    ds = getDaughters ms
    ns = getNieces(ms,ds)
    rw = sumFigures(ns[0],ns[1])
    lw = sumFigures(ns[2],ns[3])
    ju = sumFigures(rw,lw)
  return (ms,ds,ns,rw,lw,ju)

when isMainModule:
  import strformat

  let
    reading = geomancy()
    ms = reading.ms
    ds = reading.ds
    ns = reading.ns
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
|  {ns[3][0]}  |  {ns[2][0]}  |  {ns[1][0]}  |  {ns[0][0]}  |
|  {ns[3][1]}  |  {ns[2][1]}  |  {ns[1][1]}  |  {ns[0][1]}  |
|  {ns[3][2]}  |  {ns[2][2]}  |  {ns[1][2]}  |  {ns[0][2]}  |
|  {ns[3][3]}  |  {ns[2][3]}  |  {ns[1][3]}  |  {ns[0][3]}  |
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
