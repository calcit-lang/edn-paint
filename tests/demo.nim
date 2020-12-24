
# import asyncdispatch
import tables
import os

import cirru_edn

import edn_paint
import edn_paint/edn_util

# probably just a demo for using
proc startRenderLoop() =
  renderCanvas(genCrEdnMap(
    kwd("type"), genCrEdnKeyword("arc"),
    kwd("position"), genCrEdnVector(genCrEdn(20), genCrEdn(20)),
    kwd("radius"), genCrEdn(40),
    kwd("line-color"), genCrEdnVector(genCrEdn(200), genCrEdn(80), genCrEdn(71),genCrEdn( 0.4)),
    kwd("fill-color"), genCrEdnVector(genCrEdn(200), genCrEdn(80), genCrEdn(72),genCrEdn( 0.4)),
  ))

  while true:
    echo "loop"
    sleep(400)
    takeCanvasEvents(proc(event: CirruEdnValue) =
      echo "event: ", event
    )

proc renderSomething() =
  renderCanvas(genCrEdnMap(
    kwd("type"), genCrEdnKeyword("group"),
    kwd("position"), genCrEdnVector(genCrEdn(100), genCrEdn(30)),
    kwd("children"), genCrEdnVector(
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("arc"),
        kwd("position"), numbersVec([20, 20]),
        kwd("radius"), genCrEdn(40),
        kwd("stroke-color"), numbersVec([20, 80, 73]),
        kwd("fill-color"), numbersVec([60, 80, 74]),
      ),
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("polyline"),
        kwd("position"), numbersVec([10, 10]),
        kwd("skip-first?"), genCrEdn(true),
        kwd("stops"), genCrEdnVector(
          numbersVec([40, 40]), numbersVec([40, 80]), numbersVec([70, 90]), numbersVec([200, 200])
        ),
        kwd("line-width"), genCrEdn(2),
        kwd("stroke-color"), numbersVec([100, 80, 75]),
      ),
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("text"),
        kwd("text"), genCrEdn("this is a demo"),
        kwd("align"), genCrEdn("center"),
        # kwd("font-face"), genCrEdn(), # nil
        kwd("font-face"), genCrEdn("Menlo"),
        kwd("font-weight"), genCrEdn("normal"),
        kwd("position"), numbersVec([40, 40]),
        kwd("color"), numbersVec([140, 80, 76]),
      ),
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("ops"),
        kwd("position"), numbersVec([0, 0]),
        kwd("ops"), genCrEdnVector(
          genCrEdnVector(kwd("move-to"), numbersVec([100, 100])),
          genCrEdnVector(kwd("move-to"), numbersVec([300, 200])),
          genCrEdnVector(kwd("source-rgb"), numbersVec([180, 80, 77])),
          genCrEdnVector(kwd("stroke")),
          genCrEdnVector(kwd("rectangle"), numbersVec([200, 200]), numbersVec([40, 40])),
          genCrEdnVector(kwd("stroke")),
        )
      ),
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("touch-area"),
        kwd("position"), numbersVec([200, 80]),
        kwd("path"), genCrEdnVector(genCrEdnKeyword("a"), genCrEdn(1)),
        kwd("radius"), genCrEdn(6),
        kwd("action"), genCrEdnKeyword("demo"),
        kwd("fill-color"), numbersVec([200, 80, 30]),
        kwd("stroke-color"), numbersVec([200, 60, 90]),
        kwd("line-width"), genCrEdn(2),
      ),
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("touch-area"),
        kwd("position"), numbersVec([300, 120]),
        kwd("rect?"), genCrEdn(true),
        kwd("path"), genCrEdnVector(genCrEdnKeyword("a"), genCrEdn(2)),
        kwd("action"), genCrEdnKeyword("demo-rect"),
        kwd("dx"), genCrEdn(80),
        kwd("dy"), genCrEdn(40),
        kwd("fill-color"), numbersVec([0, 80, 70]),
        kwd("stroke-color"), numbersVec([200, 60, 90]),
        kwd("line-width"), genCrEdn(2),
      ),
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("ops"),
        kwd("ops"), genCrEdnVector(
          genCrEdnVector(kwd("arc"), numbersVec([100, 100]), genCrEdn(10), numbersVec([0, 6]), genCrEdn(false)),
          genCrEdnVector(kwd("source-rgb"), numbersVec([0, 80, 80])),
          genCrEdnVector(kwd("fill")),
        )
      ),
      genCrEdn(),
      genCrEdnMap(
        kwd("type"), genCrEdnKeyword("key-listener"),
        kwd("key"), genCrEdn("a"),
        kwd("path"), genCrEdnVector(genCrEdnKeyword("a"), genCrEdn(1)),
        kwd("action"), genCrEdnKeyword("hit-key"),
        kwd("data"), genCrEdn("demo data")
      ),
    )
  ))

proc ap1() =
  let bg = hslToRgb(0,0,10,1)
  initCanvas("This is a title", 600, 300, bg)
  renderSomething()

  while true:
    sleep(160)
    takeCanvasEvents(proc(event: CirruEdnValue) =
      if event.kind == crEdnMap:
        let t = event.mapVal[genCrEdnKeyword("type")]
        if t.kind != crEdnKeyword:
          raise newException(ValueError, "expects event type described in keyword")
        case t.keywordVal
        of "quit":
          quit 0
        of "window-resized":
          renderSomething()
        else:
          echo event
    )

ap1()

echo "doing"
