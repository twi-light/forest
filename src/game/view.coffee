Symbols = ['🐶','🐱','🐭','🐹','🐰','🐻','🐼','🐨','🐯','🦁','🐮','🐷','🐽','🐸','🐵','🙊','🙉','🙊','🐒','🐔','🐧','🐦','🐤','🐣','🐥','🐺','🐗','🐴','🦄','🐝','🐛','🐌','🐚','🐞','🐜','🕷','🕸','🐢','🐍','🦂','🦀','🐙','🐠','🐟','🐡','🐬','🐳','🐋','🐊','🐆','🐅','🐃','🐂','🐄','🐪','🐫','🐘','🐎','🐖','🐐','🐏','🐑','🐕','🐩','🐈','🐓','🦃','🐇','🐁','🐀','🐿','🐾','🐉','🐲']

createSymbol = (id) ->
  {
    id
    x: window.innerWidth/2
    y: window.innerHeight/2
    font: "#{((Math.random() * 25) + 25)|0}px serif"
    text: Symbols[(Symbols.length*Math.random())|0]
  }

createCanvas = (element) ->
  canvas = document.createElement 'canvas'
  canvas.style.position = 'absolute'
  canvas.style.top = '0px'
  canvas.style.left = '0px'
  canvas.style.margin = '0'
  canvas.style.width = canvas.style.height = '100%'
  canvas.resize = ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
  window.addEventListener 'resize', canvas.resize
  canvas.resize()
  element.appendChild canvas
  canvas

export GameView = (element) ->
  overlayCanvas = createCanvas element
  overlay = overlayCanvas.getContext '2d'
  overlay.fillStyle = 'white'

  symbols = []#(createSymbol id for id in [0..1000])

  drawSymbol = (symbol) ->
    symbol.x += (Math.random() - 0.5) * 25
    if symbol.x < 0 then symbol.x = 0
    if symbol.x > window.innerWidth then symbol.x = window.innerWidth
    symbol.y += (Math.random() - 0.5) * 25
    if symbol.y < 0 then symbol.y = 0
    if symbol.y > window.innerHeight then symbol.y = window.innerHeight
    # symbol.scale += (Math.random() - 0.5) * symbol.scale
    overlay.fillText symbol.text, symbol.x, symbol.y

  drawFps = do ->
    last = Date.now()
    ->
      now = Date.now()
      fps = (1000/(now - last))|0
      overlay.fillText "#{symbols.length} animals #{fps} fps", 0, 45
      last = now
      fps
  draw = ->
    start = Date.now()
    overlay.clearRect 0, 0, overlayCanvas.width, overlayCanvas.height
    overlay.font = "50px serif"
    symbols.forEach drawSymbol
    if (do drawFps) > 30
      # for _ in [0..100]
      symbols.push do createSymbol
    else
      symbols.unshift()
    requestAnimationFrame draw

  requestAnimationFrame draw
