window.Gricer =
  getFlashVersion: ->
    if navigator?.plugins?.length > 0
      for r in navigator.plugins
        if r.name.indexOf("Shockwave Flash") > -1
          return r.description.split("Shockwave Flash ")[1]
    else 
      if window.ActiveXObject
        for q in [12..2]
          try 
            g = new ActiveXObject "ShockwaveFlash.ShockwaveFlash." + q
            if g
              return q + ".0"        
          catch p
            # nop
    return false
    
  hasJava: ->
    if !self.screen && self.java
      return java.awt.Toolkit.getDefaultToolkit() ? 1 : 0
    else 
      if navigator?.javaEnabled()
        return navigator.javaEnabled() ? 1 : 0
    return undefined
    
  getSilverlightVersion: ->
    version = false;
    if plugin = navigator?.plugins?["Silverlight Plug-In"]
      version = plugin.description
      if version == "1.0.30226.2" 
        version = "2.0.30226.2";
    else 
      if window.ActiveXObject
        try 
          control = new ActiveXObject('AgControl.AgControl')
          q = 1;
          while control.IsVersionSupported(q + '.0')
            q++;
          
          version = q-1
          q = 0;
          
          while control.IsVersionSupported(version +'.' + q)
              q++
              
          version += '.' + (q-1) + '.'

          i = 10000
          while i >= 1 
            q=1;
            while control.IsVersionSupported(version + (q*i))
              q++
            version += (q-1)
            
            i = i / 10
          control = null
        catch p
          version = false
        
    return version
    
  getWindowSize: ->
    if typeof( window.innerWidth ) == 'number' 
      # Non-IE
      return {width: window.innerWidth, height: window.innerHeight}
    else if _ref = document.documentElement and ( _ref.clientWidth or _ref.clientHeight )
      # IE 6+ in 'standards compliant mode'
      return {width: document.documentElement.clientWidth, height: document.documentElement.clientHeight}
    else if _ref = document.body and ( _ref.clientWidth or _ref.clientHeight )
      # IE 4 compatible
      return {width: document.body.clientWidth, height: document.body.clientHeight}
  prepareValues: ->
    windowsize = Gricer.getWindowSize()
    
    {
      f: Gricer.getFlashVersion(),
      j: Gricer.hasJava(),
      sl: Gricer.getSilverlightVersion(),
      sx: screen.width,
      sy: screen.height,
      sd: screen.colorDepth,
      wx: windowsize.width,
      wy: windowsize.height
    }