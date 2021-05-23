{$DEFINE TMT}

{$IFDEF __WIN32__}
  {$DEFINE WIN32}
{$ENDIF}

{$IFDEF __VER4__}
  {$DEFINE TMT4}
  {$DEFINE TMT4_UP}
  {$DEFINE TMT3_UP}
{$ENDIF}

{$IFDEF __VER3__}
  {$DEFINE TMT3}
  {$DEFINE TMT3_UP}
{$ENDIF}

{$IFDEF TMT4_UP}
  {$DEFINE SUPPORTS_INTERFACE}
{$ENDIF}

       // Additional settings
{$A+}  // Word alignment data
{$OA+} // Objects and structures align
{$Z4}  // Set minimum size of enumerated type to 4