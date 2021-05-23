        echo €ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€
        echo €                                   €
        echo €   Linking Spectrum AYX32-CONFIG   €
        echo €         By TSL and Rob F.         €
        echo €                                   €
        echo €‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€


CD GFX
 CD LOADING
  loading.exe
 CD ..
CD ..
asam.exe loados.az8 z80.cmd
asam.exe loader.az8 z80.cmd
asam.exe loaexe.az8 z80.cmd
asam.exe boot.az8 z80.cmd

CD LINKER
 link.exe
CD ..


exit /B
