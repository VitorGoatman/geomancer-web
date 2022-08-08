import geomancerpkg/[geomancy, figures], dom
from sugar import `=>`
include karax / prelude

var
  reading = geomancy()
  selected, lastselected = "m0"
  details: FigData

proc readingCstring(): tuple[
  ms,ds,ns:array[4,array[4,cstring]],
  rw,lw,ju:array[4,cstring]] =
  for fs in 0..3:
    for f in 0..3:
      result.ms[fs][f] = reading.ms[fs][f].cstring
      result.ds[fs][f] = reading.ds[fs][f].cstring
      result.ns[fs][f] = reading.ns[fs][f].cstring
  for f in 0..3:
    result.rw[f] = reading.rw[f].cstring
    result.lw[f] = reading.lw[f].cstring
    result.ju[f] = reading.ju[f].cstring

var cReading = readingCstring()

proc bgChange(id,color: string) =
  document.getElementById(id).style.background = color

proc getFigData(fig:Figure) =
  for fd in Figures:
    if fig == fd.fig:
      details = fd

getFigData reading.ms[0]

proc selectFig(fig:Figure, id:string) = 
  lastselected = selected
  bgChange(lastselected, "white")
  selected = id
  bgChange(selected, "#f6e259")
  getFigData fig

proc genTable():VNode =
  result = buildHtml(table(class="w3-table w3-centered w3-border w3-bordered w3-card")):
    tr:
      td(id="d3", onclick = () => selectFig(reading.ds[3],"d3")):
        for l in reading.ds[3]:
          pre: text l
      td(id="d2", onclick = () => selectFig(reading.ds[2],"d2")):
        for l in reading.ds[2]:
          pre: text l
      td(id="d1", onclick = () => selectFig(reading.ds[1],"d1")):
        for l in reading.ds[1]:
          pre: text l
      td(id="d0", onclick = () => selectFig(reading.ds[0],"d0")):
        for l in reading.ds[0]:
          pre: text l
          
      td(id="m3", onclick = () => selectFig(reading.ms[3],"m3")):
        for l in reading.ms[3]:
          pre: text l
      td(id="m2", onclick = () => selectFig(reading.ms[2],"m2")):
        for l in reading.ms[2]:
          pre: text l
      td(id="m1", onclick = () => selectFig(reading.ms[1],"m1")):
        for l in reading.ms[1]:
          pre: text l
      td(id="m0", onclick = () => selectFig(reading.ms[0],"m0")):
        for l in reading.ms[0]:
          pre: text l
    tr:
      td(colspan="2",id="n3", onclick = () => selectFig(reading.ns[3],"n3")):
        for l in reading.ns[3]:
          pre: text l
      td(colspan="2",id="n2", onclick = () => selectFig(reading.ns[2],"n2")):
        for l in reading.ns[2]:
          pre: text l
      td(colspan="2",id="n1", onclick = () => selectFig(reading.ns[1],"n1")):
        for l in reading.ns[1]:
          pre: text l
      td(colspan="2",id="n0", onclick = () => selectFig(reading.ns[0],"n0")):
        for l in reading.ns[0]:
          pre: text l
    tr:
      td(colspan="4",id="lw", onclick = () => selectFig(reading.lw,"lw")):
        for l in reading.lw:
          pre: text l
      td(colspan="4",id="rw", onclick = () => selectFig(reading.rw,"rw")):
        for l in reading.rw:
          pre: text l
    tr:
      td(colspan="8",id="ju", onclick = () => selectFig(reading.ju,"ju")):
        for l in reading.ju:
          pre: text l

proc genInfobox(data: FigData): VNode =
  result = buildHtml(tdiv):
    h3: text data.name
    table(class="w3-table", id="tabelements"):
      for l in 0..3:
        tr:
          td:
            pre: text data.fig[l]
          td:
            if data.fig[l] == sp: text "Active"
            else: text "Passive"
          td(id="elements"):
            case l
            of 0: text "🜂 Fire"
            of 1: text "🜁 Air"
            of 2: text "🜄 Water"
            of 3: text "🜃 Earth"
            else: discard
          case l
          of 0:
            td(id="elements"):
              bold: text "Outer Element: "
              text data.outElement
          of 1:
            td(id="elements"):
              bold: text "Inner Element: "
              text data.inElement
          else: discard

    tdiv(class="w3-row-padding"):
      tdiv(class="w3-col s12 m6"):
        dl:
          dt: bold: text "Keyword: "
          dd: text data.keyword
          dt: bold: text "Images: "
          dd: text data.img
          dt: bold: text "Colors: "
          dd: text data.color
          dt: bold: text "Quality: "
          dd: text data.quality
      tdiv(class="w3-col s12 m6"):
        dl:
          dt: bold: text "Planet: "
          dd: text data.planet
          dt: bold: text "Sign: "
          dd: text data.sign
          dt: bold: text "Houses: "
          dd: text data.house
    p:
      bold: text "Divinatory meaning: "
      text data.divination
    p:
      bold: text "Commentary: "
      text data.commentary


proc newReading() =
  reading = geomancy()
  cReading = readingCstring()
  selectFig(reading.ms[0], "m0")
  
proc drawImg(reading:tuple[ms,ds,ns:array[4,array[4,cstring]], rw,lw,ju:array[4,cstring]]):cstring {.importc.}

proc download() =
  let img = drawImg(cReading)
  var element = document.createElement("a")
  element.setAttribute("href",img)
  element.setAttribute("download", "geomancer.png")
  element.style.display = "none"
  document.body.appendChild(element)
  element.click()
  document.body.removeChild(element)

proc genPage(): VNode =
  result = buildHtml(tdiv):
    h1: text "Geomancer"
    tdiv(class="w3-row-padding"):
      tdiv(class="w3-col l5 s12"):
        genTable()
        tdiv(class="w3-row"):
          button(class="w3-button w3-ripple w3-col s6 m6 l6 w3-blue",
            onclick=() => newReading()):
            text "🛡️ Get a new reading"
          button(class="w3-button w3-ripple w3-col s6 m6 l6 w3-green",
            onclick=() => download()):
            text "💾 Download Chart"
        p(class="w3-panel w3-pale-yellow w3-border w3-border-yellow"): small: em:
          text "This website uses the information contained in John Micheal Greer's book "
          a(href="https://www.amazon.com/Art-Practice-Geomancy-Divination-Renaissance/dp/1578634318"):
            text "The Art and Practice of Geomancy"
          text " as it's source. Consider buying it to support the author's work and learn more about geomancy."

      tdiv(class="w3-container w3-col l7 s12 w3-small"):
        genInfobox(details)
    canvas(id="canvas",width="400px",height="300px")

setRenderer genPage
