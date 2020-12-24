## EDN Paint

> Cirru EDN based painter based on SDL2 and Cario.

### Usage

```nim
requires "https://github.com/calcit-runner/edn-paint.nim#v0.2.3"
```

```nim
import edn_paint

initCanvas("title", 400, 400)
# it also takes an optional RgbaColor as background

renderCanvas({
  "type": "group",
  "children": [] # see specs for currently supported shapes
})

takeCanvasEvents(proc(event: CirruEdnValue) =
  if event.kind == crEdnKeyword:
    if event["type"].getStr == "quit":
      quit 0
  echo "event: ", event
)

hslToRgb(0,0,10,1)
```

Try in dev:

```bash
nimble t
```

Find example in [`tests/demo.nim`](tests/demo.nim).

### Specs

EDN described in [Cirru EDN](https://github.com/Cirru/cirru-edn.nim).

This library uses HSL/HSLA colors:

```cirru
[] 360 100 100

[] 360 100 100 1
```

- Group

```cirru
{}
  :type :group
  :position $ [] 1 1
  :children $ []
```

- Text

```cirru
{}
  :type :text
  :text |DEMO
  :position $ [] 1 1
  :font-size 14
  :font-face |Arial
  :font-weight :normal
  :color Color
  :align :center" ; :left | :center | :right
```

- Arc

```cirru
{}
  :type :arc
  :position $ [] 1 1
  :radius 1
  :from-angle 0
  :to-angle $ * 2 PI ; 0 ~ 2*PI
  :negative? false
  :stroke-color Color
  :line-width 1
  :fill-color Color
```

- Operations

```cirru
{}
  :type :ops
  :position $ [] 1 1
  :ops $ []
    [] :stroke
    [] :fill
    [] :stroke-preserve
    [] :fill-preserve
    [] :line-width 1
    [] :source-rgb Color ; which is actually using HSL colors
    [] :hsl Color        ; alias for 'source-rgb'
    [] :move-to $ [] 1 1
    [] :line-to $ [] 1 1
    [] :relative-line-to $ [] 1 1
    [] :curve-to $ []
      [] 1 2
      [] 3 4
      [] 5 6
    [] :relative-curve-to $ []
      [] 1 2
      [] 3 4
      [] 5 6
    [] :arc ([] 1 2) 1 ([] 0 6.28) false
    [] :new-path
    [] :close-path
```

- Polyline

```cirru
{}
  :type :polyline
  :position $ [] 1 1
  :stops $ []
    [] 2 2
    [] 3 3
    [] 4 4
  :stroke-color Color
  :line-width 1
  :line-join :round ; 'round' | 'milter' | 'bevel'
  :fill-color Color
  :skip-first? false
```

- Touch Area

```cirru
{}
  :type :touch-area
  :path $ [] :a 1 ; EDN
  :action Action ; EDN
  :data Data ; EDN
  :position $ [] 1 1
  :radius 20
  :fill-color Color
  :stroke-color Color
  :line-width 1

  :rect? true ; enabled rect mode
  :dx 24 ; half of rect width
  :dy 8  ; half of rect height
```

- Key Listener

```cirru
{}
  :type :key-listener
  :path $ [] :a 2 ; EDN
  :action Action ; EDN
  :data Data ; EDN
  :key |a
```

### Events

```cirru
{}
  :type :mouse-move
  :x 1
  :y 1
  :path $ [] :a 1 ; data, defined in "touch-area"
  :action Action ; data, defined in "touch-area"
  :data Data ; data, defined in "touch-area"
```

```cirru
{}
  :type :key-down
  :sym 97
  :repeat false
  :scancode |SDL_SCANCODE_D
  :name |a
```

```cirru
{}
  :type :key-up
  :sym 97
  :repeat false
  :scancode |SDL_SCANCODE_D
  :name |a
```

```cirru
{}
  :type :text-input
  :text |a
```

```cirru
:type :quit
```

```cirru
{}
  :type :mouse-down
  :clicks 1
  :path $ [] ; data, defined in "touch-area"
  :action Action ; data, defined in "touch-area"
  :data Data ; data, defined in "touch-area"
  :x 100
  :y 100
```

```cirru
{}
  :type :mouse-up
  :clicks 1
  :path $ [] :a 1 ; data, defined in "touch-area"
  :action Action ; data, defined in "touch-area"
  :data Data ; data, defined in "touch-area"
  :x 100
  :y 100
```

```cirru
{}
  :type :window
  :event |WindowEvent_FocusGained
```

```cirru
{}
  :type :window-resized
  :x 100
  :y 100
```

Example logs:

```clojure
; normal moves
{:x 491.0, :type :mouse-move, :y 36.0}
{:x 468.0, :type :mouse-move, :y 42.0}

; a normal click
{:x 87.0, :clicks 1.0, :type :mouse-down, :y 163.0}
{:x 87.0, :clicks 1.0, :type :mouse-up, :y 163.0}
{:x 86.0, :type :mouse-move, :y 163.0}

; a normal drag
{:x 156.0, :clicks 1.0, :type :mouse-down, :y 46.0}
{:x 172.0, :type :mouse-move, :y 46.0}
{:x 189.0, :type :mouse-move, :y 44.0}
{:x 190.0, :type :mouse-move, :y 44.0}
{:x 192.0, :type :mouse-move, :y 45.0}
{:x 192.0, :clicks 0.0, :type :mouse-up, :y 45.0}
{"type":"mouse-move","x":291,"y":102}

; move from touch-area
{:x 374.0, :clicks 1.0, :type :mouse-down, :data nil, :action :demo-rect, :path [1.0 2.0], :y 131.0}
{:x 369.0, :dx -5.0, :type :mouse-move, :data nil, :action :demo-rect, :path [1.0 2.0], :dy -1.0, :y 130.0}
{:x 360.0, :dx -14.0, :type :mouse-move, :data nil, :action :demo-rect, :path [1.0 2.0], :dy -1.0, :y 130.0}
{:x 359.0, :dx -15.0, :type :mouse-move, :data nil, :action :demo-rect, :path [1.0 2.0], :dy -1.0, :y 130.0}
{:x 357.0, :dx -17.0, :type :mouse-move, :data nil, :action :demo-rect, :path [1.0 2.0], :dy 1.0, :y 132.0}
{:x 357.0, :clicks 0.0, :dx -17.0, :type :mouse-up, :data nil, :action :demo-rect, :path [1.0 2.0], :dy 1.0, :y 132.0}

; click in touch-area
{:x 371.0, :clicks 1.0, :type :mouse-down, :data nil, :action :demo-rect, :path [1.0 2.0], :y 182.0}
{:x 371.0, :clicks 1.0, :dx 0.0, :type :mouse-up, :data nil, :action :demo-rect, :path [1.0 2.0], :dy 0.0, :y 182.0}

; keyboard events
{:repeat false, :scancode "SDL_SCANCODE_DOWN", :name "down", :type :key-down, :sym 1073741905.0}
{:repeat false, :scancode "SDL_SCANCODE_DOWN", :name "down", :type :key-up, :sym 1073741905.0}
{:repeat false, :scancode "SDL_SCANCODE_D", :name "d", :type :key-down, :sym 100.0}
{:type :text-input, :text "d"}
{:repeat false, :scancode "SDL_SCANCODE_D", :name "d", :type :key-up, :sym 100.0}
{:repeat false, :scancode "SDL_SCANCODE_UP", :name "up", :type :key-down, :sym 1073741906.0}
{:repeat false, :scancode "SDL_SCANCODE_UP", :name "up", :type :key-up, :sym 1073741906.0}
```

### License

MIT
